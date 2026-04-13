Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B208F1D5AD4;
	Mon, 13 Apr 2026 16:39:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098390; cv=none; b=jBJPwOezVawbwz4bFGTT3VmlSbqtDL8tOGG5sO0mJOx8v7ajHbW1V4t0a1tnG8NyHQd8QvqJyMWTPG/RduRy0w9vbmD3XxorKExdpPnR85ysbv4dVP22cf/GczfMNAcQcKbzGTKDJRRZpzAz7WTOfhEUkEpL0Vzg0bq7HkE2yqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098390; c=relaxed/simple;
	bh=BbGEgRZ6kC8Ubbfg8CycqfkKa94QqtL5bLFZPM1L/JM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iAq3s0qUbOOx1mT1WoKQQs18cOut9YLZ5lVgsDby+snitghCTb1xNvrYfak8jWR51dqzqHHRMsHlvHNN4JgrxI7aA49hzmJwVT9fjaUfpyQ45RXYxJLdjyQpN40TWU3ZFzxCSyu+QX34ygRM49uGe/K11eZcXD+2CqjxcXNeD3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0QAFDmq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0QAFDmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4783DC2BCAF;
	Mon, 13 Apr 2026 16:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098390;
	bh=BbGEgRZ6kC8Ubbfg8CycqfkKa94QqtL5bLFZPM1L/JM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0QAFDmqXvIua/nsNsYM3QR0tv6x73dIPUxp/CKlPF3T40cL4jpJxCfft2PIfAWa4
	 FUUIOGQMhHpgxft5yl71KsOftKGtD3aiOeZhf3ptUGSBp6+/Rn1gwHc2+XObNQ58NU
	 rzixkJgIcM24LX7X0pF7tZpMeryjpAKXlP3UD4j8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.15 505/570] lib/crypto: chacha: Zeroize permuted_state before it leaves scope
Date: Mon, 13 Apr 2026 18:00:36 +0200
Message-ID: <20260413155849.370112155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit e5046823f8fa3677341b541a25af2fcb99a5b1e0 upstream.

Since the ChaCha permutation is invertible, the local variable
'permuted_state' is sufficient to compute the original 'state', and thus
the key, even after the permutation has been done.

While the kernel is quite inconsistent about zeroizing secrets on the
stack (and some prominent userspace crypto libraries don't bother at all
since it's not guaranteed to work anyway), the kernel does try to do it
as a best practice, especially in cases involving the RNG.

Thus, explicitly zeroize 'permuted_state' before it goes out of scope.

Fixes: c08d0e647305 ("crypto: chacha20 - Add a generic ChaCha20 stream cipher implementation")
Cc: stable@vger.kernel.org
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20260326032920.39408-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/chacha.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/lib/crypto/chacha.c
+++ b/lib/crypto/chacha.c
@@ -86,6 +86,8 @@ void chacha_block_generic(u32 *state, u8
 		put_unaligned_le32(x[i] + state[i], &stream[i * sizeof(u32)]);
 
 	state[12]++;
+
+	memzero_explicit(x, sizeof(x));
 }
 EXPORT_SYMBOL(chacha_block_generic);
 
@@ -110,5 +112,7 @@ void hchacha_block_generic(const u32 *st
 
 	memcpy(&stream[0], &x[0], 16);
 	memcpy(&stream[4], &x[12], 16);
+
+	memzero_explicit(x, sizeof(x));
 }
 EXPORT_SYMBOL(hchacha_block_generic);


