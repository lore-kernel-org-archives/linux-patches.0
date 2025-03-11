Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A00321E98EC;
	Tue, 11 Mar 2025 15:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707502; cv=none; b=mbslYjD+SWNJoTWb1kicfgmXNL97jL/SifGQ+S8vLY2co3iOv8JsTDl+cxak9QZFIYiyyq/U3bGN/skENrBSBVcW5H0E0P5UGQvaMZj/i3Z5kPAdLOH844CtZmX42BUsWmjpyAIVJ0aVajJugUJ682lBwok4TwMHZ4xusI4g5Ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707502; c=relaxed/simple;
	bh=FYx1uvOP8wpkR/81ciX3f9qOfOUbTdsaESd/HpgL0bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ptp02dNLGv2I/iSxAf/teawaI2iMpAqIs60Wbgmm0Up68HGBGiytYYmyvAnwN5vYYgzdArVCdNJWeb7Qvn7fdN4ujyaUge6fpZfW1Kg18rSVi2NNc2nrAPre05wXZ4WsehmOGyp+EFbD6KExZXG/UMtcuF7j9FFhPSPJq2+46sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QqBNS0CU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QqBNS0CU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24812C4CEE9;
	Tue, 11 Mar 2025 15:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707502;
	bh=FYx1uvOP8wpkR/81ciX3f9qOfOUbTdsaESd/HpgL0bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QqBNS0CUjuRKsYhkB/GWMgqDE9RIKBuOoTh1fpiNSYL2Dw/iJOX1Z17svGa90rTAe
	 SJaulBP87TQ6nuzit0jdpLIiejwldX94i56i1WpcjVRJUTb2kBC8uLsFgBLoZ6vSDE
	 CUi0nJ1HQFbzJUC7OqD5FqfdPxu9Xyg3YWakRL/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 409/462] net: gso: fix ownership in __udp_gso_segment
Date: Tue, 11 Mar 2025 16:01:15 +0100
Message-ID: <20250311145814.488579061@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6e36eb1ba2763..b6952b88b5051 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -280,13 +280,17 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 
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



