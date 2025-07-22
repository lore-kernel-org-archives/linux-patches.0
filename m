Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236682EA168;
	Tue, 22 Jul 2025 14:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193325; cv=none; b=b9Bg1UEzktTdeDDGZfguVscFHunfvFlyEjzFcr5+sBm1c0RQzISAjMOOGGzuDY2GpEHw3oSSUnvMnOte+8Dv8Uc4558bmXq8v9Ca6Zo0OxAVcsjsyd70iwT2FKCuFhHcKwMpdSVxzO4AC4jKMFVkeUIDPZt94WU3osWX/G3ogGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193325; c=relaxed/simple;
	bh=X4QW/hiKJOlERZJjujqw5H8A3M5QyflkFYsXoqvtvK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajjzfbtdzIi+NDBd135qF5aZXWxGWK6mdtRPeCKz2Ph1xFm4IHUtpTbBf/jpP50oTBniiE+cPfaSdjZrxgnRNBjG9mmA24NO1wUwoRrQzdUG1iWZov1pWt/8ujEcYLJ1c6bS2V3FlLMxxWd07w+QOQZk9WpODDotOjaw1rLf/ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tBv42hth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tBv42hth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51596C4CEEB;
	Tue, 22 Jul 2025 14:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193322;
	bh=X4QW/hiKJOlERZJjujqw5H8A3M5QyflkFYsXoqvtvK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tBv42hth3RkD8Yo6wyaP0TTjqq3taC5sr3J9Szb19tueXr7RvWI4w5nvzfdUUrHcN
	 9FxAaEfJXmbBxOH+T43LC252Bfvgl0gyYXuA8yiCLMYcNEl+HCFE3qq3cQb9OzNGvY
	 Jt/2DhKrFB7lxMCIyVkp9Z8LW02JOp2PubI27NCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Yun Lu <luyun@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.15 057/187] af_packet: fix the SO_SNDTIMEO constraint not effective on tpacked_snd()
Date: Tue, 22 Jul 2025 15:43:47 +0200
Message-ID: <20250722134347.888627896@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2785,7 +2785,7 @@ static int tpacket_snd(struct packet_soc
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen, copylen = 0;
-	long timeo = 0;
+	long timeo;
 
 	mutex_lock(&po->pg_vec_lock);
 
@@ -2839,6 +2839,7 @@ static int tpacket_snd(struct packet_soc
 	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !vnet_hdr_sz)
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
+	timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
 	reinit_completion(&po->skb_completion);
 
 	do {
@@ -2846,7 +2847,6 @@ static int tpacket_snd(struct packet_soc
 					  TP_STATUS_SEND_REQUEST);
 		if (unlikely(ph == NULL)) {
 			if (need_wait && skb) {
-				timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
 				timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
 				if (timeo <= 0) {
 					err = !timeo ? -ETIMEDOUT : -ERESTARTSYS;


