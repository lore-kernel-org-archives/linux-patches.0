Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05BF230BC8;
	Mon, 10 Mar 2025 17:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627549; cv=none; b=i5UG3pwzjIfrDf3adm//Ve+3atsbwMtF1RXQb1p4RLjOGaakqXZbZBBE+GArZ0+O7VSl9SWVl7niORrer7W2i2HBfGlrle4sYL3Pk8fiTjnLpfNsBW6EnezQiap+CdtrI15Vu9N16V4lv30F7l9e6cKqs7X3war9omltuYY6G5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627549; c=relaxed/simple;
	bh=63dMqJLdCKQejNRXclrFCmV+VTAc4Yt85et9tjK1fAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMfdhAWb5hd4fgx9JrJa0CtbsCnGCVdm7Mam/MJVV9H+6FI9jgPc89B568WLbkCrgGNjSET/MULuNPxeSJPb+MY6/Wntv7M1v4kQHdTH9JiuldkEl9Xln8PbB2EHDAF108A+5xoOFIqBW7MKnA6fE0f4v/Q9oZ9qukNZUmHY7Dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uBhnIBjs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uBhnIBjs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2596CC4CEE5;
	Mon, 10 Mar 2025 17:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627549;
	bh=63dMqJLdCKQejNRXclrFCmV+VTAc4Yt85et9tjK1fAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uBhnIBjsuc7P4EO/nsf4iAlVfLVX0L8Tyh/aX6pAHiYovJyZHMenr1k2ES0wk2oZ0
	 UJ0uOfaCgNFUS+uZDm6YT7Mhjg9BiaVNBeWs4IpXd2IQCS7jstnnBBX8azso/1BTcp
	 sKE3CAFzzJZqqzjwp7CTfV8g3lIJ6nVzzZ8CmvIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 167/269] net: gso: fix ownership in __udp_gso_segment
Date: Mon, 10 Mar 2025 18:05:20 +0100
Message-ID: <20250310170504.372102523@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit ee01b2f2d7d0010787c2343463965bbc283a497f ]

In __udp_gso_segment the skb destructor is removed before segmenting the
skb but the socket reference is kept as-is. This is an issue if the
original skb is later orphaned as we can hit the following bug:

  kernel BUG at ./include/linux/skbuff.h:3312!  (skb_orphan)
  RIP: 0010:ip_rcv_core+0x8b2/0xca0
  Call Trace:
   ip_rcv+0xab/0x6e0
   __netif_receive_skb_one_core+0x168/0x1b0
   process_backlog+0x384/0x1100
   __napi_poll.constprop.0+0xa1/0x370
   net_rx_action+0x925/0xe50

The above can happen following a sequence of events when using
OpenVSwitch, when an OVS_ACTION_ATTR_USERSPACE action precedes an
OVS_ACTION_ATTR_OUTPUT action:

1. OVS_ACTION_ATTR_USERSPACE is handled (in do_execute_actions): the skb
   goes through queue_gso_packets and then __udp_gso_segment, where its
   destructor is removed.
2. The segments' data are copied and sent to userspace.
3. OVS_ACTION_ATTR_OUTPUT is handled (in do_execute_actions) and the
   same original skb is sent to its path.
4. If it later hits skb_orphan, we hit the bug.

Fix this by also removing the reference to the socket in
__udp_gso_segment.

Fixes: ad405857b174 ("udp: better wmem accounting on gso")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20250226171352.258045-1-atenart@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index a5be6e4ed326f..ecfca59f31f13 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -321,13 +321,17 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 
 	/* clear destructor to avoid skb_segment assigning it to tail */
 	copy_dtor = gso_skb->destructor == sock_wfree;
-	if (copy_dtor)
+	if (copy_dtor) {
 		gso_skb->destructor = NULL;
+		gso_skb->sk = NULL;
+	}
 
 	segs = skb_segment(gso_skb, features);
 	if (IS_ERR_OR_NULL(segs)) {
-		if (copy_dtor)
+		if (copy_dtor) {
 			gso_skb->destructor = sock_wfree;
+			gso_skb->sk = sk;
+		}
 		return segs;
 	}
 
-- 
2.39.5



