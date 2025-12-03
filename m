Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4494932ED43;
	Wed,  3 Dec 2025 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779675; cv=none; b=fP9G9GdXAFUuryTj/ILl+SbDQypfVHj3GhCoVg4LgNdl/7eC8MOrSQHCuK+5uabYJaqzf3FUnPuxyQisU80LKcrYkESvhZhjp67gZoZs1IMmF1ZL2HtDSBKfNOXsA+UZRYh1UlJvNhd1BhO0LRd6i0eGnfX6GBa/fyfi2ngxu6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779675; c=relaxed/simple;
	bh=Rtwx67Hs+wNfgSPEXfisUpAd58FksXiabT70LiXZRKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZssnDGw8lmdCJgxk2NDycrN2ssMEfXYmDlQsAaMdt+rN0hDnL3S7nEN5HOC7N2yqP7RRHrriUQq2zrhFBckGyUKeikhC1Gzo79jmCkIAinBNfZPr1UWAMzRp6lcBJ8kIIu/dWZguXeTKLOsa2fenIV7EaGlsrsU+I6UvNQIWJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWb3MVoD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWb3MVoD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C43BC4CEF5;
	Wed,  3 Dec 2025 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779674;
	bh=Rtwx67Hs+wNfgSPEXfisUpAd58FksXiabT70LiXZRKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWb3MVoDVTuX7RSySLNFUsKYp7XqXF9GBxPTZClZAbhiWv3q5qfDgKL910umRZbHe
	 QuIkRYzP4Nq6E/Zr0Deph/nGKNDdQdNRL6YEtFgm8fdTwfRxLb5dIw8C2SM1ztui27
	 SDseGXrjwYBXHfhEHxA/piB6mv4fIFO6i6Uovuu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 328/568] lib/crypto: curve25519-hacl64: Fix older clang KASAN workaround for GCC
Date: Wed,  3 Dec 2025 16:25:30 +0100
Message-ID: <20251203152452.723037753@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 2b81082ad37cc3f28355fb73a6a69b91ff7dbf20 upstream.

Commit 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with
clang-17 and older") inadvertently disabled KASAN in curve25519-hacl64.o
for GCC unconditionally because clang-min-version will always evaluate
to nothing for GCC. Add a check for CONFIG_CC_IS_CLANG to avoid applying
the workaround for GCC, which is only needed for clang-17 and older.

Cc: stable@vger.kernel.org
Fixes: 2f13daee2a72 ("lib/crypto/curve25519-hacl64: Disable KASAN with clang-17 and older")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20251103-curve25519-hacl64-fix-kasan-workaround-v2-1-ab581cbd8035@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/crypto/Makefile
+++ b/lib/crypto/Makefile
@@ -26,7 +26,7 @@ libcurve25519-generic-y				:= curve25519
 libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
 libcurve25519-generic-y				+= curve25519-generic.o
 # clang versions prior to 18 may blow out the stack with KASAN
-ifeq ($(call clang-min-version, 180000),)
+ifeq ($(CONFIG_CC_IS_CLANG)_$(call clang-min-version, 180000),y_)
 KASAN_SANITIZE_curve25519-hacl64.o := n
 endif
 


