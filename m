Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD4F2E736D;
	Tue, 21 Jul 2026 17:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654300; cv=none; b=CVjw2ew/UKxiPtRQx/be2V/HOjM0QlPXHGi6RPcBl9YoDrFMm7+U5QMe6+gr+Sr4/Udcpmef5EhEHdc27qIs2kv5jKW3+7WYLVpAsbnNm8/W7bkOcKptjkY+MVsGS2AdzKM8KnsKvULzBReCmlO7wPEjnXE0zyLbEoAEK7ksipw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654300; c=relaxed/simple;
	bh=g9BoBpAaCUbPs7ss5kDCzkjTd9iNZAeakDfDAEaS3fI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQX8MoILIAWRCC3XNaIKzw7N98X0NdpYiW83YvB1WZ2Csa7fCmxi4lb0mVEGXEhhNNs/jrEepgNj3LpJdETNx6mX1yUztuim3ukWCgmRK4dS8EOOgz70dsk04251yFWnGj0TY4U2LkHXZJ6sf5M4DxRgqT0OitrwW70Fsuvlz1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bUSrMsP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bUSrMsP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB661F000E9;
	Tue, 21 Jul 2026 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654298;
	bh=/oyNhXD7SDIWgupeWTY7kZ/yB8TYrOm+mxBtgsmQms0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2bUSrMsPZFI2EpKhStBJnOOvNg7QUQw/93JN6iV6gWMDn5nUVsbrIBA4x4GhcCNi/
	 Hl8c6fYrJPi4k/7hhaxfLBwOdvlSzBhJxz/FvRZlzJlCnFs/9/h5wxE3CsuWApxPiC
	 2LjKaoFAcOOoQE6fRFpW+HhOj5A5UG0Xb1Gb8+ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1651/2077] batman-adv: mcast: avoid OOB read of num_dests header
Date: Tue, 21 Jul 2026 17:22:04 +0200
Message-ID: <20260721152631.691250716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 38eaed28e250895d56f4b7989bd65479a511c5c3 upstream.

Before the access to struct batadv_tvlv_mcast_tracker's num_dests, it is
attempted to check whether enough space is actually in the network header.
But instead of using offsetofend() to check for the whole size (2) which
must be accessible, offsetof() of is called. The latter is always returning
0. The comparison with the network header length will always return that
enough data is available - even when only 1 or 0 bytes are accessible.

Instead of using offsetofend(), use the more common check for the whole
header.

Cc: stable@vger.kernel.org
Fixes: 07afe1ba288c ("batman-adv: mcast: implement multicast packet reception and forwarding")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/multicast_forw.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/batman-adv/multicast_forw.c
+++ b/net/batman-adv/multicast_forw.c
@@ -927,11 +927,11 @@ static int batadv_mcast_forw_packet(stru
 {
 	struct batadv_tvlv_mcast_tracker *mcast_tracker;
 	struct batadv_neigh_node *neigh_node;
-	unsigned long offset, num_dests_off;
 	struct sk_buff *nexthop_skb;
 	unsigned char *skb_net_hdr;
 	bool local_recv = false;
 	unsigned int tvlv_len;
+	unsigned long offset;
 	bool xmitted = false;
 	u8 *dest, *next_dest;
 	u16 num_dests;
@@ -940,9 +940,8 @@ static int batadv_mcast_forw_packet(stru
 	/* (at least) TVLV part needs to be linearized */
 	SKB_LINEAR_ASSERT(skb);
 
-	/* check if num_dests is within skb length */
-	num_dests_off = offsetof(struct batadv_tvlv_mcast_tracker, num_dests);
-	if (num_dests_off > skb_network_header_len(skb))
+	/* check if batadv_tvlv_mcast_tracker header is within skb length */
+	if (sizeof(*mcast_tracker) > skb_network_header_len(skb))
 		return -EINVAL;
 
 	skb_net_hdr = skb_network_header(skb);


