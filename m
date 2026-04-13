Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFA824DCF6;
	Mon, 13 Apr 2026 16:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096831; cv=none; b=VpYsrCLDZVOWBA7zQ3wVfx5NKazuAc3KJy0NZaRruDqvmB3680311HYWePPoECrAFG6za1NGPccycRThpCjx4mHDxYwQtDx1bX1Jm0SegZu5Pb50g3o1a24Vo5JHfXdx1dwjg5bzsxBVuat0dnfPSUqb3mATYPxZID/pvDoPj98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096831; c=relaxed/simple;
	bh=bMmMH8MjwIhpBOra8PQJ52cYsRspTja1SiagqxUYiRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fWLOU07+lTeJHFOaHYXNpSa3MHg1w/GKWiwSKVSFYRvrORuRi5CDfFmpP2ZveW/uw0tMDZthxfUCAZ/z9WykyY75wy9drBZevCMxjVntH5GAbZTh2J8Vsq/LC8tuh5PPCtghHK/CEZIOoI6FXnqJGbKOHeK9G31fhgnImB0EDa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4kYnR5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4kYnR5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D2EC2BCAF;
	Mon, 13 Apr 2026 16:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096831;
	bh=bMmMH8MjwIhpBOra8PQJ52cYsRspTja1SiagqxUYiRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4kYnR5GR5FFGjWqSuDL0ANus4jSRb/Psf+EPYoM/B/G1UlbCwQDAn9sIle8R6eyv
	 QTu950cHx9leUuJpvZfs1mRklR65JdmxfOm3GhAI2X8KpYPITPpGbQcS/q43XgDZNh
	 behOSy/abf0EA8gx3HcRQLvuCsmf3QBvltzc3cyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.6 01/50] lib/crypto: chacha: Zeroize permuted_state before it leaves scope
Date: Mon, 13 Apr 2026 18:00:28 +0200
Message-ID: <20260413155724.553161089@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


