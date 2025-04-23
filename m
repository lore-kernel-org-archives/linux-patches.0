Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D196175BF;
	Wed, 23 Apr 2025 14:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420092; cv=none; b=tdPHsaM19KxCLTGmO00pJLFovkBlComeEE8hOs1PoZTVs1v4wHesjGip4sYQ/MWXOYQpKlvaHSOcKH+IwP8qfyoCoZrN/kQOPoRltduD4bmdYR5ExDpRps6d+/7fi6tsM8f/zcTa4oKkJBRW+9H3bENoehL9+Gm7/p+rG1CPSZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420092; c=relaxed/simple;
	bh=m6IQi1jidH0qivW3cJGPapwrYm1BZ4Zo2gnF1W00iiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mwIKK0SGhAoyF30L3fz2HFZYg1IkmtzcKGORbMeJ0voziGw2ssaKW1M2bR6E1N9AicpF9ykz/a5pefsmlqU+/zM5W2aTM7tNETdlSF/lwyaQW2h84aeXw/dfI8uhxP3bPNzQZZCSMIItizjQJdeMZ/1Uv3AyL5UW6eUAfX/4sOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RtCF6RZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RtCF6RZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B504DC4CEE2;
	Wed, 23 Apr 2025 14:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420092;
	bh=m6IQi1jidH0qivW3cJGPapwrYm1BZ4Zo2gnF1W00iiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RtCF6RZzLDyqKhr+gHY1zuTDbyymIazxDjE1yqQI0vTvTIBWXRy2cn0yCXx+1qa04
	 gsg6WSdENpgOUn7tuUykM/tHmp2OOADGFkFsym7evfJF3Ka3F6tEbW9oyv3BzEqm4I
	 6voD8oaTLf/5QoIqDurQ+KX/N6EhT0XRxbtVDY6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+29fc8991b0ecb186cf40@syzkaller.appspotmail.com,
	Arnaud Lecomte <contact@arnaud-lcm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/291] net: ppp: Add bound checking for skb data on ppp_sync_txmung
Date: Wed, 23 Apr 2025 16:40:05 +0200
Message-ID: <20250423142625.069033314@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaud Lecomte <contact@arnaud-lcm.com>

[ Upstream commit aabc6596ffb377c4c9c8f335124b92ea282c9821 ]

Ensure we have enough data in linear buffer from skb before accessing
initial bytes. This prevents potential out-of-bounds accesses
when processing short packets.

When ppp_sync_txmung receives an incoming package with an empty
payload:
(remote) gef➤  p *(struct pppoe_hdr *) (skb->head + skb->network_header)
$18 = {
	type = 0x1,
	ver = 0x1,
	code = 0x0,
	sid = 0x2,
        length = 0x0,
	tag = 0xffff8880371cdb96
}

from the skb struct (trimmed)
      tail = 0x16,
      end = 0x140,
      head = 0xffff88803346f400 "4",
      data = 0xffff88803346f416 ":\377",
      truesize = 0x380,
      len = 0x0,
      data_len = 0x0,
      mac_len = 0xe,
      hdr_len = 0x0,

it is not safe to access data[2].

Reported-by: syzbot+29fc8991b0ecb186cf40@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=29fc8991b0ecb186cf40
Tested-by: syzbot+29fc8991b0ecb186cf40@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Arnaud Lecomte <contact@arnaud-lcm.com>
Link: https://patch.msgid.link/20250408-bound-checking-ppp_txmung-v2-1-94bb6e1b92d0@arnaud-lcm.com
[pabeni@redhat.com: fixed subj typo]
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/ppp_synctty.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 94ef6f9ca5103..fb533c43deeea 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -515,6 +515,11 @@ ppp_sync_txmunge(struct syncppp *ap, struct sk_buff *skb)
 	unsigned char *data;
 	int islcp;
 
+	/* Ensure we can safely access protocol field and LCP code */
+	if (!pskb_may_pull(skb, 3)) {
+		kfree_skb(skb);
+		return NULL;
+	}
 	data  = skb->data;
 	proto = get_unaligned_be16(data);
 
-- 
2.39.5



