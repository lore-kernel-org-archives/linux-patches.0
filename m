Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA5E307AD9;
	Wed,  3 Dec 2025 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778183; cv=none; b=Ismd+D23K9bMDTx/Al5r9B7/CNnnXff4PvklBDLgBKS+Y+MMFGVZOGbIZVk1UMUn4vrk3FIDUZQx2jyWTqZr6lL9hDyD8XpFD3Y9QQa6pmQ9PmDkMkS7WS08CiyxRiizbkjhpcXZ9eR7AEUydeaaMSIgYhrx1/4Mr24UrpAfUMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778183; c=relaxed/simple;
	bh=wwgFZErVd+Eu++1MFmY8EQBiwGwYn04u6vg+ANPPKOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unR5ZJxVIePkzG530KQVUMl6WG54hpkT9DgILVr7/GQz7yr5EoFqwyYZef6SysLIbmeyAibp3EBcdSnQvJek4bY3Fa6BT1zpgA2QMNw5J3jHSSukjjjVKeFKuUNS7G5fhooHodtYezD7DI5wHzIAED9v8uKaK/4BWdrs8STlH9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jVSrpmtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jVSrpmtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03C86C4CEF5;
	Wed,  3 Dec 2025 16:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778182;
	bh=wwgFZErVd+Eu++1MFmY8EQBiwGwYn04u6vg+ANPPKOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jVSrpmtFAD+G0zF39HcRWwxcWtfccr2SU2GQeac0lk7ZDafU6olnLk4/uUH9eFzit
	 XDXCDrAQPbEOXvD/5Ie2WAtGnr6mi9tOxN3pNJCL8oIEffNGT6CGFLVIa6cDU8iwHT
	 ZhYdm4JPujIhKws8ydpqOSZEeY3GbbqPsWLYjpx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 267/392] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Wed,  3 Dec 2025 16:26:57 +0100
Message-ID: <20251203152423.990117746@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

commit 44e8241c51f762aafa50ed116da68fd6ecdcc954 upstream.

On big endian arm kernels, the arm optimized Curve25519 code produces
incorrect outputs and fails the Curve25519 test.  This has been true
ever since this code was added.

It seems that hardly anyone (or even no one?) actually uses big endian
arm kernels.  But as long as they're ostensibly supported, we should
disable this code on them so that it's not accidentally used.

Note: for future-proofing, use !CPU_BIG_ENDIAN instead of
CPU_LITTLE_ENDIAN.  Both of these are arch-specific options that could
get removed in the future if big endian support gets dropped.

Fixes: d8f1308a025f ("crypto: arm/curve25519 - wire up NEON implementation")
Cc: stable@vger.kernel.org
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20251104054906.716914-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/crypto/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 149a5bd6b88c1..d3d318df0e389 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -166,7 +166,7 @@ config CRYPTO_NHPOLY1305_NEON
 
 config CRYPTO_CURVE25519_NEON
 	tristate "NEON accelerated Curve25519 scalar multiplication library"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
 	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
 
-- 
2.51.0



