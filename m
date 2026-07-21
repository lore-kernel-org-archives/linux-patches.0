Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC96443AAC;
	Tue, 21 Jul 2026 22:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672358; cv=none; b=OewIgKDIj2WAXWifNZhyfAL4od3Rfpq9ZuzrTuhC8eCZNi1ZPOgWAfX9g4KG+2EbfWQFDcj45k1wn6b1oyOHPEBRNSs3aMU72wwvarxiVl0CJ0ynBuMdwMYox99nUQjo0Xo9lcmsARJCaAyZPUUkcKjpXLkobdroNRVaSeqGxBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672358; c=relaxed/simple;
	bh=sggvqGS+hxt/4reEyyCOschp1SUQ4/uZnTq6LVEu8p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO5xYLJJOaqgqIwpdZMPW8uYRE58fjE8CBagMAhhRtLEnPifFLCed3R5J9vLZ1nQPj7EB/xVeVg4CrZtYmeKq38kxRlyIVCxKXyrM06VshuMfkIWgng1DEBXrqCdt9fysy/+L/XdeCgmlBfOTCLXHp/cYVm7DJBWX+l89yIf58w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuImmY9X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuImmY9X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A52FA1F000E9;
	Tue, 21 Jul 2026 22:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672357;
	bh=vpxY+KjkFUW1Subr3hwtN7ge0shG+SlLSFQHjGtuGOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AuImmY9XfMelSlotO8huX/5wL5ZvzckKMZYpQpMtGia4PT8ZJ7g0hKU2JepWNWS/N
	 cu7hk+/1a8MEvFgY5D9j3xxRNrbMvRPuSvNgked6gYUlcBFYXJLhtYbZwSShRTdcVF
	 lN3b7/X11KN9EZM2shIg7ZX4bLgFABuC3cFp0k/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 595/843] batman-adv: frag: free unfragmentable packet
Date: Tue, 21 Jul 2026 17:23:50 +0200
Message-ID: <20260721152419.433006044@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 6b628425aed49a1c7a4ffc997583840fc582d32b upstream.

The caller of batadv_frag_send_packet() assume that the skb provided to the
function are always consumed. But the pre-check for an empty payload or the
zero fragment size returned an error without any further actions.

A failed pre-check must use the same error handling code as the rest of the
function.

Cc: stable@vger.kernel.org
Fixes: ee75ed88879a ("batman-adv: Fragment and send skbs larger than mtu")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/fragmentation.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -522,8 +522,10 @@ int batadv_frag_send_packet(struct sk_bu
 	mtu = min_t(unsigned int, mtu, BATADV_FRAG_MAX_FRAG_SIZE);
 	max_fragment_size = mtu - header_size;
 
-	if (skb->len == 0 || max_fragment_size == 0)
-		return -EINVAL;
+	if (skb->len == 0 || max_fragment_size == 0) {
+		ret = -EINVAL;
+		goto free_skb;
+	}
 
 	num_fragments = (skb->len - 1) / max_fragment_size + 1;
 	max_fragment_size = (skb->len - 1) / num_fragments + 1;


