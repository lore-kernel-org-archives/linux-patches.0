Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403B4352949;
	Wed,  3 Dec 2025 16:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778497; cv=none; b=QCD80qkqM8rYIoCpAM71529umC0u6SzUnSbNJ+iHNw+p0D6caRnO8r2cbUtH+usvedjW1ZjdXQx1KuVtobJQd0eaSZn7GxXZ89BiY8zshquZKK9XWWVX4qlCnVy5HAvNj2gF8N3Laz6SLi6KRwzEZyHbBf9XVBFVTDk5Icvx2OA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778497; c=relaxed/simple;
	bh=yvF8y3THs+KCWaHriOcKJtAfe44Bmfqgh//zpT5z+Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUIssWlLu1gcxUFobkmfmAiP8JRuKb/cNYY7ssqjGz8CGvXsELiA4gKo/yzKYUgrGir9VXpxK+Tu7DoUWVhhOWvxETeVQts7CUtTm3NGU608r43viEhm4GZRFcTkCxHferwx8PxfXIgZKXcJaystOHKxVoy4cabmXgaUUWJLZOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNM+dJ6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNM+dJ6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641EDC4CEF5;
	Wed,  3 Dec 2025 16:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778496;
	bh=yvF8y3THs+KCWaHriOcKJtAfe44Bmfqgh//zpT5z+Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zNM+dJ6Fc4HGt6varsWeyXKAeTza1VbqVPZV6A/wzv8aa7P2ag8nY1H60SwmWs0k4
	 PRj//3/56Cd2dkFlw67HGhb/ACHBzCo1eekS0zKFG0tqfEfnqsjv9SacHzROF2YLhl
	 J4cYYmWNMT5stpcg3BOxJU2uF8dqBZB3flDIKkMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiefeng Zhang <jiefeng.z.zhang@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 346/392] net: atlantic: fix fragment overflow handling in RX path
Date: Wed,  3 Dec 2025 16:28:16 +0100
Message-ID: <20251203152426.900024667@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiefeng Zhang <jiefeng.z.zhang@gmail.com>

[ Upstream commit 5ffcb7b890f61541201461580bb6622ace405aec ]

The atlantic driver can receive packets with more than MAX_SKB_FRAGS (17)
fragments when handling large multi-descriptor packets. This causes an
out-of-bounds write in skb_add_rx_frag_netmem() leading to kernel panic.

The issue occurs because the driver doesn't check the total number of
fragments before calling skb_add_rx_frag(). When a packet requires more
than MAX_SKB_FRAGS fragments, the fragment index exceeds the array bounds.

Fix by assuming there will be an extra frag if buff->len > AQ_CFG_RX_HDR_SIZE,
then all fragments are accounted for. And reusing the existing check to
prevent the overflow earlier in the code path.

This crash occurred in production with an Aquantia AQC113 10G NIC.

Stack trace from production environment:
```
RIP: 0010:skb_add_rx_frag_netmem+0x29/0xd0
Code: 90 f3 0f 1e fa 0f 1f 44 00 00 48 89 f8 41 89
ca 48 89 d7 48 63 ce 8b 90 c0 00 00 00 48 c1 e1 04 48 01 ca 48 03 90
c8 00 00 00 <48> 89 7a 30 44 89 52 3c 44 89 42 38 40 f6 c7 01 75 74 48
89 fa 83
RSP: 0018:ffffa9bec02a8d50 EFLAGS: 00010287
RAX: ffff925b22e80a00 RBX: ffff925ad38d2700 RCX:
fffffffe0a0c8000
RDX: ffff9258ea95bac0 RSI: ffff925ae0a0c800 RDI:
0000000000037a40
RBP: 0000000000000024 R08: 0000000000000000 R09:
0000000000000021
R10: 0000000000000848 R11: 0000000000000000 R12:
ffffa9bec02a8e24
R13: ffff925ad8615570 R14: 0000000000000000 R15:
ffff925b22e80a00
FS: 0000000000000000(0000)
GS:ffff925e47880000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff9258ea95baf0 CR3: 0000000166022004 CR4:
0000000000f72ef0
PKRU: 55555554
Call Trace:
<IRQ>
aq_ring_rx_clean+0x175/0xe60 [atlantic]
? aq_ring_rx_clean+0x14d/0xe60 [atlantic]
? aq_ring_tx_clean+0xdf/0x190 [atlantic]
? kmem_cache_free+0x348/0x450
? aq_vec_poll+0x81/0x1d0 [atlantic]
? __napi_poll+0x28/0x1c0
? net_rx_action+0x337/0x420
```

Fixes: 6aecbba12b5c ("net: atlantic: add check for MAX_SKB_FRAGS")
Changes in v4:
- Add Fixes: tag to satisfy patch validation requirements.

Changes in v3:
- Fix by assuming there will be an extra frag if buff->len > AQ_CFG_RX_HDR_SIZE,
  then all fragments are accounted for.

Signed-off-by: Jiefeng Zhang <jiefeng.z.zhang@gmail.com>
Link: https://patch.msgid.link/20251126032249.69358-1-jiefeng.z.zhang@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
index 98e8997f80366..5a85999987b51 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c
@@ -363,6 +363,11 @@ int aq_ring_rx_clean(struct aq_ring_s *self,
 
 		if (!buff->is_eop) {
 			unsigned int frag_cnt = 0U;
+
+			/* There will be an extra fragment */
+			if (buff->len > AQ_CFG_RX_HDR_SIZE)
+				frag_cnt++;
+
 			buff_ = buff;
 			do {
 				bool is_rsc_completed = true;
-- 
2.51.0



