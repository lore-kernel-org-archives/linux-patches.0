Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB6025BEE5;
	Wed,  3 Dec 2025 15:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776492; cv=none; b=Gpe1laBD1cAPpAnGpBqhf5zXJfFz7xn1yc44SaJieiTfNoYzhTngX4WaEDbBHUS6lQARu5U/c679Rp/ixBa2MBThDtHOhzmHpS7Fj7N4kFsiS6ArTTlp1gplFROY+orq4Df83zGOGhJ+rEGjPky9j4xXCTW/LZGHwByN24VT8o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776492; c=relaxed/simple;
	bh=/azFzmgr4ZxnudEHjR36kE6frYb2AukRtX3yNeeQwRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qV/O6OOf8Q8jIsmwhIED7DFGylw3yCegnCanYnWoAAIfP+Hu6Q2XhtOI8EPyDWCUWBMpoc55xjaFTlwLdgBEKo1AMO4KgsQgx2vPjm8pgqEkVhKrjwoz+FrSNwS4ALeAr5PFZ6xE1C7BnqDeM5eqRP0PjeK6tzGI1TcTLlfT4WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9unPSrO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9unPSrO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D676C4CEF5;
	Wed,  3 Dec 2025 15:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776491;
	bh=/azFzmgr4ZxnudEHjR36kE6frYb2AukRtX3yNeeQwRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9unPSrOWGashod+D+sw8VvbvI3pTdjGtZ65MFMjfsiLIb9RYhXkZMgtESwCFnstv
	 263q9JA2+AftwISIKoNCp2IgbT6yRr/Pj/nK44NhGDlwBzPybp8TCAy2Vp/s+705pR
	 Nw9U0Wk0p/q/4zIytoP/jAj4ctzhEWF56QC7dc1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 171/300] lib/crypto: curve25519-hacl64: Fix older clang KASAN workaround for GCC
Date: Wed,  3 Dec 2025 16:26:15 +0100
Message-ID: <20251203152406.954660762@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -23,7 +23,7 @@ libcurve25519-generic-y				:= curve25519
 libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
 libcurve25519-generic-y				+= curve25519-generic.o
 # clang versions prior to 18 may blow out the stack with KASAN
-ifeq ($(call clang-min-version, 180000),)
+ifeq ($(CONFIG_CC_IS_CLANG)_$(call clang-min-version, 180000),y_)
 KASAN_SANITIZE_curve25519-hacl64.o := n
 endif
 


