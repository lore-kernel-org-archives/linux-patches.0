Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0E743302F;
	Tue, 21 Jul 2026 19:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663619; cv=none; b=FA8Sy7KUbiD7AbEUZjVMOP/osYpGGF4OiMOh7bWIrVAbgYYdOk+eRzSv4RjB5PMlIUihD0rDPRwsfIxzHFyzhfEbSYmAZLnlYapeIZP8fHb54dqVMQKPhhSfdWR12fVCKTjViMW2L3DB+Kvv+vnj/8rfMcY248ZYm3oOFCdSJI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663619; c=relaxed/simple;
	bh=wRGatFzf+43jRbDqugz8KBfpEpLR+QHsr2bEOgktBT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pcj5FsykHpQN4umLrhe88mDf9XF3i8kFgBm2JkfLHR8doeC63P8l9ySr0aM7k0VcqA6ul4Jjh7DSahn+BVr8Packwpa9fmpyh6VNKXwz/xv/NPmu+/ptGqhs8TdUHVn4/vr9gn4IxuUh4g3V4jUtDAI1VHfAFDZomaS5+JG4Ziw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTMZNZtt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTMZNZtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07BE41F000E9;
	Tue, 21 Jul 2026 19:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663618;
	bh=K/gAupelcNKiUmZ+nT87L7wJJ2o7zU+e/xwYFIuqPnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTMZNZttdjqKkZ2SIIuXToCr94tyoZXrXEhT3fs0fQCxFArJbW1o6/NFcYBMA7/OY
	 6FvGvXaxl3HuG0MZKANMZc7CHCw3vqPbB7Bo5DCOnO8CZndgJfyHruu24LQTF9sPbZ
	 +zMmycR+iK65nU5HN6QWAbg5rWLam95wNEFGgNdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0892/1276] batman-adv: mcast: avoid OOB read of num_dests header
Date: Tue, 21 Jul 2026 17:22:15 +0200
Message-ID: <20260721152506.006937873@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


