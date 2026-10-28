Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211368;
	b=PoPrtwZpAD8jSTCkmQdNvPOu7i4SQG6DtqbegS0bnl+dU/NaYhMyetUHNUK/xziqgG51
	 YBF9TD58LIWOXMzmZsA5Ioryz/+74XuUjT7sMSaHw/+CN1Bnp5wPBYg0pV199JJcnYTN8
	 tuvkQMPncr4h2EneIeDgs5IMCc8ob/hQIF32YYHz2EA25mEpAb8zijM8XrX6tzbdd124p
	 Dg7dA+rRm2qjbRZ7m8LJW63uRrt2JfbyvPZuOip6AWXhgnKyKReAAL4k1Q/MA2EstUtTW
	 9bZ+IZOcUAEYH3uCvRaI61vu1a9YfsxRygG18JkC1lZe7WnPWD8sEwX1hbuaRqUxWyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211368;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tKDbRgcbsKoKUWs1jfqmalgLXu2TA8wfsZLXPPc/8d8=;
	b=YrJvMIFRnBp2HMZ3YB0NoQR+y6bepIS8/75vLFQC7l6PLskpaZof8U5eAUhkSKnSbjny
	 YCb7EWoTyzbYmv7OFCA+kxUEZc+bTxYMgX+Pj/9d1Cs9zrapy9Ujc0WtKrqmEZSHoxNbJ
	 EQmHA84d3J7Ykljrb83aAbVrGRlLKW/rFpzxuSvaTWXVhiCFWLkw0kKbguKktE6VcVCS/
	 6N60LlQQdp/p4iHJ+lgWxPmOnfpFNZpteWV5s6r9+ljKxZCvfG/MZSC61J9OBXTZ4tAU5
	 5lUPdQaQEbk4JbsFxiOH8bLXljQbNgqmq47G0TZEDZZzsGFcgTZWQagPWfnxN1oXk1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+eauG8i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A89606A96E;
	Wed, 28 Oct 2026 18:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t+eauG8i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D39E1F01825;
	Wed, 28 Oct 2026 18:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211367;
	bh=tKDbRgcbsKoKUWs1jfqmalgLXu2TA8wfsZLXPPc/8d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t+eauG8iLl0xu/W1Q65RCVUAY6BwyJuokvpG4dMKOPFCJRBVll75kLAU0okbB3HIR
	 NguM/Ov4Ixz2DpQGVEcEXG2jQbgvvsIzyPvG/F5FLeP2Yg/kepqkndvcyOcw2uvshv
	 pXo0fPw+k3jY7pLTK9Fap0T1xZYfRoBnCvlKPZmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Juergen Gross <jgross@suse.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 352/571] xen/netfront: dont leak the skb when xennet_fill_frags() fails
Date: Wed, 28 Oct 2026 17:58:19 +0100
Message-ID: <20261028170016.368452944@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 93ccaf1c26e2133396173b76a071e59024daa622 upstream.

When a response chain has more slots than fit in the skb's frags,
xennet_fill_frags() returns an error and xennet_poll() jumps to its
error path.  That path moves what's left on tmpq to errq to be freed,
but the skb being filled was already dequeued from tmpq, so it's never
freed.  Each chain that overflows leaks the skb and the pages attached
to it as frags, and the backend decides how many slots it sends.

Put the skb back on tmpq before taking the error path, like the
xennet_set_skb_gso() failure just above it does.

Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20261007-b4-xen-netfront-fill-frags-leak-v1-1-a8a01ff9cd52@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1340,8 +1340,10 @@ err:
 		skb->data_len = rx->status;
 		skb->len += rx->status;
 
-		if (unlikely(xennet_fill_frags(queue, skb, &tmpq)))
+		if (unlikely(xennet_fill_frags(queue, skb, &tmpq))) {
+			__skb_queue_head(&tmpq, skb);
 			goto err;
+		}
 
 		if (rx->flags & XEN_NETRXF_csum_blank)
 			skb->ip_summed = CHECKSUM_PARTIAL;


