Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 735353314D1;
	Mon, 29 Dec 2025 16:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025965; cv=none; b=PzHa7ostzdIr5IOXabETcFWzaDbuaHiOC4KSOM+6y3gtPXVRzNrNCBeIzyAIB+MwgaIBBPmHburvCvvnAaGecVuKAcTVdjI2/gQYWVbBr1uKBF7cx2vdgQyKedxCILCnfmIJZ2XnGt3ZGtKFNRRR2na2ZCck0PJHO/WIE3yJHzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025965; c=relaxed/simple;
	bh=WaJLGgW9RxovQ26VF0j9g8izdj5aB8V3+2PdnEYxljE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izGykBvJ1gkRuxq9YXjPeyhHv5Oa+ZrfU67L+kZQtaRuHWmog4TYwi6LTKmwUgqvUnFrI4X0q2yzsGjdcoysvR+3g9AE/c3YobkmkmgitgE8fnDcVSIFE/P3DNfEdFkyZ/tpfPfaWhVDf2qEJRAsU0Cy/T73OVKpirC232OvVuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llvHphmE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llvHphmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D37C4CEF7;
	Mon, 29 Dec 2025 16:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025965;
	bh=WaJLGgW9RxovQ26VF0j9g8izdj5aB8V3+2PdnEYxljE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llvHphmEiLZqx+l46K+pF98Wr5IlAgVaRfKdryP1qysf99dinHov01fAr6ZtY+xqZ
	 GdcP7sJhEl+ODd2wMT1BFup1w534KVzqRgMqTeHfevCyku8TleT23D/o8Xu+W8NHGO
	 Zg85L6xUXGboNRiWSwDQW8dRmvxv9fe7NjzaAMUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diederik de Haas <diederik@cknow-tech.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 399/430] crypto: arm64/ghash - Fix incorrect output from ghash-neon
Date: Mon, 29 Dec 2025 17:13:21 +0100
Message-ID: <20251229160738.998744586@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit f6a458746f905adb7d70e50e8b9383dc9e3fd75f upstream.

Commit 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block
handling") made ghash_finup() pass the wrong buffer to
ghash_do_simd_update().  As a result, ghash-neon now produces incorrect
outputs when the message length isn't divisible by 16 bytes.  Fix this.

(I didn't notice this earlier because this code is reached only on CPUs
that support NEON but not PMULL.  I haven't yet found a way to get
qemu-system-aarch64 to emulate that configuration.)

Fixes: 9a7c987fb92b ("crypto: arm64/ghash - Use API partial block handling")
Cc: stable@vger.kernel.org
Reported-by: Diederik de Haas <diederik@cknow-tech.com>
Closes: https://lore.kernel.org/linux-crypto/DETXT7QI62KE.F3CGH2VWX1SC@cknow-tech.com/
Tested-by: Diederik de Haas <diederik@cknow-tech.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Link: https://lore.kernel.org/r/20251209223417.112294-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/crypto/ghash-ce-glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/crypto/ghash-ce-glue.c
+++ b/arch/arm64/crypto/ghash-ce-glue.c
@@ -133,7 +133,7 @@ static int ghash_finup(struct shash_desc
 		u8 buf[GHASH_BLOCK_SIZE] = {};
 
 		memcpy(buf, src, len);
-		ghash_do_simd_update(1, ctx->digest, src, key, NULL,
+		ghash_do_simd_update(1, ctx->digest, buf, key, NULL,
 				     pmull_ghash_update_p8);
 		memzero_explicit(buf, sizeof(buf));
 	}


