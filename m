Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 565D526B747;
	Tue, 26 Aug 2025 13:36:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215388; cv=none; b=Z2Mc7D/mgkvibGi2xHvAZX3xGjPGUamgbF2YrAEGLpoJzY36Dkxs/+9zshWvl8lXhJ++X55K0UvNLn0AEgB/y72VOGOoNEZo5k7/a1PAJ1TjwTKrBJpt/i4TSG6podahTMmpIXZVNcmqIHsIKaT2WnqoIs6xkwi+BClTPbhegGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215388; c=relaxed/simple;
	bh=7QHPXPspcWHLKT7H/iP7wkyjXMH4/iLXur+eC3AW0T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZs6aGt0VYLKipPg1NpbcemAgjEzHVgquU3T3eI4/gsnWt4qmhJfOPI9qX2LU59G/2OccN36B2Ned1zmhHADtt0aKx5MAobCZOWJ6TnZ1QKLYclxrA4M1YjrLRcfw+ZmAq09XkBf4xpDRGWCMucMBW8Bj7ZEJfr7NL4KsK9cNFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORRZ3ZhT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORRZ3ZhT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF71CC4CEF1;
	Tue, 26 Aug 2025 13:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215388;
	bh=7QHPXPspcWHLKT7H/iP7wkyjXMH4/iLXur+eC3AW0T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ORRZ3ZhTxshVLBTO1NRcX1fNh1peovSKLd4mNtObGSh+7Jdo7nYSp1lFLlPBGRhvG
	 bE8Wi/WuhuP9yUkI46z6Mnb7nigoa/XFSvx/tBp0eBaZvo7ATAW9Gp+N9Pz5hF3ld0
	 ETaflqntG0/YprB5Zw9tq5M3BZRyEm2Eu4a8ewXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Yun Lu <luyun@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 015/644] af_packet: fix the SO_SNDTIMEO constraint not effective on tpacked_snd()
Date: Tue, 26 Aug 2025 13:01:46 +0200
Message-ID: <20250826110946.891378371@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Lu <luyun@kylinos.cn>

commit c1ba3c0cbdb5e53a8ec5d708e99cd4c497028a13 upstream.

Due to the changes in commit 581073f626e3 ("af_packet: do not call
packet_read_pending() from tpacket_destruct_skb()"), every time
tpacket_destruct_skb() is executed, the skb_completion is marked as
completed. When wait_for_completion_interruptible_timeout() returns
completed, the pending_refcnt has not yet been reduced to zero.
Therefore, when ph is NULL, the wait function may need to be called
multiple times until packet_read_pending() finally returns zero.

We should call sock_sndtimeo() only once, otherwise the SO_SNDTIMEO
constraint could be way off.

Fixes: 581073f626e3 ("af_packet: do not call packet_read_pending() from tpacket_destruct_skb()")
Cc: stable@kernel.org
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Yun Lu <luyun@kylinos.cn>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/packet/af_packet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2742,7 +2742,7 @@ static int tpacket_snd(struct packet_soc
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen, copylen = 0;
-	long timeo = 0;
+	long timeo;
 
 	mutex_lock(&po->pg_vec_lock);
 
@@ -2796,6 +2796,7 @@ static int tpacket_snd(struct packet_soc
 	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
+	timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
 	reinit_completion(&po->skb_completion);
 
 	do {
@@ -2803,7 +2804,6 @@ static int tpacket_snd(struct packet_soc
 					  TP_STATUS_SEND_REQUEST);
 		if (unlikely(ph == NULL)) {
 			if (need_wait && skb) {
-				timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
 				timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
 				if (timeo <= 0) {
 					err = !timeo ? -ETIMEDOUT : -ERESTARTSYS;


