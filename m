Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C8F1662E7;
	Tue, 26 Aug 2025 14:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217094; cv=none; b=tmQZfIT2Z9zgrrzjD6uhuXNFUl9X6EXlPKBL0CkILA4l0eb7csK12+gxhH0DKJZr2Xz86vqGfsdY2hRevO1j836P7lTpAGYiay331RHzIa4zKf9ej95ZD8wbsD9RxXiyXcHoEMH/Ggm2qM3h4iwAorMLe+f4Oi//dr8yCY3fAPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217094; c=relaxed/simple;
	bh=v//Oalllj3ZHqTQhYDSzU7s+r4ncKgbnz2z7lgDe1JU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MMUkJc7JEBvcDQZup9rcD5AzZ/Tosh2vY/I9Nb00j7wNTL3mfFf5FAgg6etSCuRTVihMtHVNTI4iuiprGBUTZwhqodbGMdhxjM8U1OZum2S8qj37e6MmEESfL0NCA0vov5FLLH5D79EyYgwu+wQFVHlFUSW494V9kc2NhQvz8L4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDldSMrM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDldSMrM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B8DC4CEF1;
	Tue, 26 Aug 2025 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217094;
	bh=v//Oalllj3ZHqTQhYDSzU7s+r4ncKgbnz2z7lgDe1JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDldSMrMs7xXoP0aNB8Qyh7Hibo7YA0CdVIkypKjZTNY1/QNK/nylPJDDy2IE2Yfz
	 JoGZrnorahanPrYrfaaAC6677902Poi+OSP4cfeT2GVDEcys4uJiYdchJua5kJXsJj
	 fsLUNnE+4uJVHd/cW3vHMR7d9h+kIpoML4crK6AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Eric Dumazet <edumazet@google.com>,
	Yun Lu <luyun@kylinos.cn>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 014/523] af_packet: fix the SO_SNDTIMEO constraint not effective on tpacked_snd()
Date: Tue, 26 Aug 2025 13:03:44 +0200
Message-ID: <20250826110924.935822297@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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
@@ -2739,7 +2739,7 @@ static int tpacket_snd(struct packet_soc
 	int len_sum = 0;
 	int status = TP_STATUS_AVAILABLE;
 	int hlen, tlen, copylen = 0;
-	long timeo = 0;
+	long timeo;
 
 	mutex_lock(&po->pg_vec_lock);
 
@@ -2793,6 +2793,7 @@ static int tpacket_snd(struct packet_soc
 	if ((size_max > dev->mtu + reserve + VLAN_HLEN) && !po->has_vnet_hdr)
 		size_max = dev->mtu + reserve + VLAN_HLEN;
 
+	timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
 	reinit_completion(&po->skb_completion);
 
 	do {
@@ -2800,7 +2801,6 @@ static int tpacket_snd(struct packet_soc
 					  TP_STATUS_SEND_REQUEST);
 		if (unlikely(ph == NULL)) {
 			if (need_wait && skb) {
-				timeo = sock_sndtimeo(&po->sk, msg->msg_flags & MSG_DONTWAIT);
 				timeo = wait_for_completion_interruptible_timeout(&po->skb_completion, timeo);
 				if (timeo <= 0) {
 					err = !timeo ? -ETIMEDOUT : -ERESTARTSYS;


