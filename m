Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BC62F6923;
	Tue, 11 Nov 2025 01:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824945; cv=none; b=jtegrDD6vB7ayEk2QUMeJidpguv5n0amR57Nk4j7Cd3YkRKGb5xgHb23IGAbG3VbFqh7G+3PYiOgDpbklUkl6Nlf8LR2YVzSIVR6AMT/RLWK6EZ7NJK8Qav5SOyQBjyB1RyF+vYBODyYLrNXWcQiaNi1ftSsWeIMh0fiqLfp50Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824945; c=relaxed/simple;
	bh=jEToRx1Jesj/nzN+JfpgSmO9w/SdRzqd1AC2iOSxWOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjegQgfv7Q8B29JRgqySqnsVvsFKX9Q0yq9b5jl565/Nc8wM53oqqKPxvLOccLVZP8LgWKKnNtiHOcdo+DdhQ3fdNSnBmBLtI/FL5yCzMTqFPk1zfdemPxqvi3Xk1VJp1jfMNfOnnwhE4/fbE8JkrPdEDdn9qT8VIm7zuCFKz1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qcf+uLnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qcf+uLnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD20C16AAE;
	Tue, 11 Nov 2025 01:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824945;
	bh=jEToRx1Jesj/nzN+JfpgSmO9w/SdRzqd1AC2iOSxWOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qcf+uLnlcTr4eCHbVkL1FSNfRW0xJMi2+VOehHN1jW27EZOe4Htem/5cJfzFdGyHs
	 DzxmeFd5IN6VUJ1m2TxE1O8aQNsbewFG9ffD0AlGalSXSVxFLBWjQ8P8qtDcHt9H+w
	 xrSEat/64MMQLM5E4L0oOP/XbudlXz2/9WPyC0b8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 555/565] lib/crypto: curve25519-hacl64: Fix older clang KASAN workaround for GCC
Date: Tue, 11 Nov 2025 09:46:51 +0900
Message-ID: <20251111004539.488957385@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -34,7 +34,7 @@ libcurve25519-generic-y				:= curve25519
 libcurve25519-generic-$(CONFIG_ARCH_SUPPORTS_INT128)	:= curve25519-hacl64.o
 libcurve25519-generic-y				+= curve25519-generic.o
 # clang versions prior to 18 may blow out the stack with KASAN
-ifeq ($(call clang-min-version, 180000),)
+ifeq ($(CONFIG_CC_IS_CLANG)_$(call clang-min-version, 180000),y_)
 KASAN_SANITIZE_curve25519-hacl64.o := n
 endif
 


