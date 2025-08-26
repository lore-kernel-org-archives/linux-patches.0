Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF4E3568F4;
	Tue, 26 Aug 2025 14:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218577; cv=none; b=tO7idyazgoMxZt5iMrB4jmJp28LPp3JPtkLmn9dtem7GCuT5TKMqGpOc53v0cQA9Pxry3G/9gEJN9wrcfotQzGpOng4R0du0oSnCHIsQ3OprUAs3YFfjn7Bp6az1EWUgl4lSAQCoCRRc26dr8/CSN9i1/K1vIhMj+L6AeMnxadU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218577; c=relaxed/simple;
	bh=ArA7JRGcXQmzyzsQve1+1XZ0pSfk4s//rB4hFdOAltU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0FYqAjbH7KphdHr6l/O5auv2osnBbEcSnJ36FMIVcasqGNPSfo59iIeoAQtnAoWer1ndG3gUhHtL8cviAZzDWzoFdL5AkwKAUJa1jM8uL17tVf5kPNRdPi9Kj3cQdoDdH59+PtFsm3MoHD63uDzlcl7lAZd8tt5pq6vHuzCE64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkKTJtgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkKTJtgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A285C4CEF1;
	Tue, 26 Aug 2025 14:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218577;
	bh=ArA7JRGcXQmzyzsQve1+1XZ0pSfk4s//rB4hFdOAltU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkKTJtguXNb+nVXUjH+ZX7yIcyfNzc+779dAwZungKU4BjwTvKm28D1XZ9pBwnSHO
	 OapqAPKjCgJNFZvrgo+rYwZTHPwIsoKYOZZXF08rqA6acCBT7OVAQndpX0KHB63tpa
	 cIq9wUeCZJU2DJ/v1JaFGJ0w/Iu54JEmBOyzI7XE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Yun Lu <luyun@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 012/403] af_packet: fix the SO_SNDTIMEO constraint not effective on tpacked_snd()
Date: Tue, 26 Aug 2025 13:05:38 +0200
Message-ID: <20250826110906.077974480@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2713,7 +2713,7 @@ static int tpacket_snd(struct packet_soc
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen, copylen = 0;
-	long timeo = 0;
+	long timeo;
 
 	mutex_lock(&po->pg_vec_lock);
 
@@ -2767,6 +2767,7 @@ static int tpacket_snd(struct packet_soc
 	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
+	timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
 	reinit_completion(&po->skb_completion);
 
 	do {
@@ -2774,7 +2775,6 @@ static int tpacket_snd(struct packet_soc
 					  TP_STATUS_SEND_REQUEST);
 		if (unlikely(ph == NULL)) {
 			if (need_wait && skb) {
-				timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
 				timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
 				if (timeo <= 0) {
 					err = !timeo ? -ETIMEDOUT : -ERESTARTSYS;


