Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDCC34D4DC;
	Fri, 21 Nov 2025 13:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733398; cv=none; b=f57C/TobdVAIIky+mNBPnQj4dUU/+6PU/zPjJ5Eje8wfeI+QnBlPDnDRCctcpRZnoTata1MNtDnO6ryFiJkoERp3Rdl5MgbXSN+pK0u4L/iGR+wSQ75ZSTHZOuABwqmtSSahpzbbLfClO4ZrqSGvVOc2HzCvxireJR6SCfpwm2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733398; c=relaxed/simple;
	bh=j03O68I7Sb/tLpMrZoVqoSR55gdeKN6HFcDJMn10g20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SAAVCQoMUngBJM6GQf5TOVFpSs8BJN6fF8ankp6m1gkOfMZh+CstkstRsnWVEJCDCgxHo3h+I6Z8i8HrTOfstu3Q6RfONITLjYyxIZj81mDhMt7c+sp6Z9ZY7T0DiGwXPoBUA8tTZrShJ34dDQ2Q8V+Gc+btaAFbODJT1C7syCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7cSK6G/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7cSK6G/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE05C4CEF1;
	Fri, 21 Nov 2025 13:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733397;
	bh=j03O68I7Sb/tLpMrZoVqoSR55gdeKN6HFcDJMn10g20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7cSK6G/gPvgXAn/7ohxE8gaxhgTNoB4gc2iyuXH2yEhjQS/q4ZlLLH0rxloQy7v/
	 JyY/3k+Ujf53BB41xJbK7KGdiBTA6xTbUz6aELg/5A2C8h7RQ6fqVtp95VlTel1mbL
	 9kUq4NFFC0QF1NU6Ic2/YjgUq77PXbqcH9EJUTZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 453/529] lib/crypto: arm/curve25519: Disable on CPU_BIG_ENDIAN
Date: Fri, 21 Nov 2025 14:12:32 +0100
Message-ID: <20251121130247.127272873@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
index 847b7a0033569..1f684e29cff2e 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -4,7 +4,7 @@ menu "Accelerated Cryptographic Algorithms for CPU (arm)"
 
 config CRYPTO_CURVE25519_NEON
 	tristate "Public key crypto: Curve25519 (NEON)"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && !CPU_BIG_ENDIAN
 	select CRYPTO_LIB_CURVE25519_GENERIC
 	select CRYPTO_ARCH_HAVE_LIB_CURVE25519
 	help
-- 
2.51.0



