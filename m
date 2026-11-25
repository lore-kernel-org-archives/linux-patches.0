Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625661;
	b=tTW2Fh807qAfwV4rYIqLQAVqMig3Yek6p6Lv4TavIYc/JRjMJhT60wRikNNITo3enx/I
	 yxuxiYwgagnK4h0yELLaD8svZ17Kr5Wo2tMGDwSVdMZtOUeUFE0qgrfXgUl42RbTaBOla
	 bEOP/xYKzzKROmL4g03HTjf18ZgakaFp2PCkILNTHMt0pIWseDF377RlvI/C2MMlWbhuv
	 1CfjjlD/LGJQh+Y0dNRtwNosafBjoG5UuKDfP5c+OQPd5l7Br/gSvR50HKMg8lpRx34T2
	 bSmZ2ID72Shc3vZywtAk0cQjc7g0j+FTsW8ZNuZhxnmiDp/ZgcDNb4RGK0ekz8wdPEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q04DxeZK7qnXEVAVwWChOoG1jQQTb/jDhhis41eGMHQ=;
	b=VA8NsFt2yktUl1oZL7pwLZ4Nz77mNvGQoOc4p70Hq4mAmDLOclpBxO5Z6Dl5Ny6XzZGW
	 xIGqV0PXZcmp2AtTu2S1Is+LSwaB5T9bc9IlQf+Pl5yw/XxVRQelvpRiDIs07q3/frc09
	 SfgvtXXQSMRM1KmrOo/+/X/upU51gCXY8ago0yw2/67j48FFiScwn1o1uy8eeD9OGasJS
	 OWVMLlilT9+brLnSXcqGxpJpj6EoSNgr4WiFikT4FISCMVGONAISfGmdGqpIvCAfX92/9
	 LAz9O25o+9uOrxCqBbxlLVMOM01sKzQb73vXmwl3FPH6/uF/7PULaM0P83Eq3i18+9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCRkg70i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1D4606A321;
	Wed, 25 Nov 2026 16:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kCRkg70i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B691F000D0;
	Wed, 25 Nov 2026 16:54:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625660;
	bh=q04DxeZK7qnXEVAVwWChOoG1jQQTb/jDhhis41eGMHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kCRkg70iFEYGWDXBU9vnSlHFvG3p68qn0U4D2OT57qsIXRtEAI+Gf0hLHxTp3sLBm
	 Lzq9AEQR1K1daCjelk2hAF/x3DSe583oKIvvLToKs4SkX6VnXPObg+WCgawKQWkuab
	 O+4J7KmRqystEFpyUqIwTyX/66JuwE6yYrrHyCSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 589/816] mptcp: reject DATA_ACKs against a reversed send interval
Date: Wed, 25 Nov 2026 15:35:37 +0100
Message-ID: <20261125143902.811772097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

commit d75e5cd72995ec2fa77ec77a593cea28e2490ff1 upstream.

ack_update_msk() samples snd_nxt before taking the data lock, but reads
snd_una after taking it. Concurrent transmission and ACK processing can
therefore leave the sampled upper bound behind snd_una. Active-open
completion also exposes a reversed interval when it initializes snd_una
to IDSN + 1 while the socket-owned state synchronization is deferred.

A peer-supplied 64-bit Data ACK half a sequence space away can pass both
wraparound comparisons against such an interval. The resulting snd_una
can make __mptcp_retrans() inflate a fragment's already_sent field. Later
ACKs can then underflow data_len and cause out-of-bounds page fragments
to be passed to TCP.

Read snd_nxt after acquiring the data lock and reject reversed intervals
before checking the received Data ACK. This keeps the interval shorter
than half the sequence space, so the existing upper-bound check cannot
accept an advance beyond snd_nxt. Preserve the existing handling of old
ACKs and keep the transmit fields under their existing socket locking.

Cc: stable@vger.kernel.org
Fixes: 7439d687b79c ("mptcp: avoid a few atomic ops in the rx path")
Fixes: 3f83d8a77eee ("mptcp: fix more tx path fields initialization")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20261104130747.1045741-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/options.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/net/mptcp/options.c
+++ b/net/mptcp/options.c
@@ -1139,9 +1139,9 @@ static void ack_update_msk(struct mptcp_
 			   struct sock *ssk,
 			   struct mptcp_options_received *mp_opt)
 {
-	u64 new_wnd_end, new_snd_una, snd_nxt = READ_ONCE(msk->snd_nxt);
+	u64 new_wnd_end, new_snd_una, old_snd_una;
 	struct sock *sk = (struct sock *)msk;
-	u64 old_snd_una;
+	u64 snd_nxt;
 
 	mptcp_data_lock(sk);
 
@@ -1150,10 +1150,14 @@ static void ack_update_msk(struct mptcp_
 	 * more dangerous than missing an ack
 	 */
 	old_snd_una = msk->snd_una;
+	snd_nxt = READ_ONCE(msk->snd_nxt);
 	new_snd_una = mptcp_expand_seq(old_snd_una, mp_opt->data_ack, mp_opt->ack64);
 
-	/* ACK for data not even sent yet? Ignore.*/
-	if (unlikely(after64(new_snd_una, snd_nxt)))
+	/* The active-open state sync can defer the snd_nxt update. Do not
+	 * accept an ACK against a reversed interval, or beyond snd_nxt.
+	 */
+	if (unlikely(before64(snd_nxt, old_snd_una) ||
+		     after64(new_snd_una, snd_nxt)))
 		new_snd_una = old_snd_una;
 
 	new_wnd_end = new_snd_una + tcp_sk(ssk)->snd_wnd;


