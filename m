Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56CC19049B;
	Mon, 23 Jun 2025 21:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715655; cv=none; b=FzdbzY/O8Xs/qWRVzsGCYRSYtM0hS4E9UrP449mbfxv4w8coqucAeuSbT6w95vdjwgP62H0UmRBmRzYSnzeWBuFW5TY1rNXFUEgm6E2LSC/mS+U7zFFvMQwAZqsxkiH6ltn7PzrATGavqrByzZ8Sg6ypoE3FZxyXy5ldLRIoEko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715655; c=relaxed/simple;
	bh=cEtcxhBs7tFKjQ/WLBbKtx1BRpFo2LKGuYRmtwmNkZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X9AcYKsJ6KOZfj9zNytbDI/A2gFrO95BXRd63b2jMP6k6F/HCbtDDp/uCbVxWv2hba1twKoco/HE6dUSDd/jFKRWWtu/H5WQMP6c2HjmILh4P7uVZl/w02LvEECF/yYW4ESkeyW4/bpaYFKicnavbl+qf2DkdaeiYjHWpXXhQTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAV6Kzgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAV6Kzgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F37FC4CEEA;
	Mon, 23 Jun 2025 21:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715655;
	bh=cEtcxhBs7tFKjQ/WLBbKtx1BRpFo2LKGuYRmtwmNkZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAV6KzgonCchvdRyneuRRieMZT9kmS8u+KYPzKwxkn9SdqILyA47ft/aPQGnVc0ir
	 t5DqwG/5OGLKM5FQS0yqC5kn4A7zDg8y54Zg4fKZkv6XPOtAj3k+shBN7zlfP4gVVQ
	 9MpBsPyena3wkYP4L8nyxvePQ1sRM9CE54TC9KXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.15 472/592] x86/Kconfig: only enable ROX cache in execmem when STRICT_MODULE_RWX is set
Date: Mon, 23 Jun 2025 15:07:10 +0200
Message-ID: <20250623130711.660583732@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit 47410d839fcda6890cb82828f874f97710982f24 upstream.

Currently ROX cache in execmem is enabled regardless of
STRICT_MODULE_RWX setting. This breaks an assumption that module memory
is writable when STRICT_MODULE_RWX is disabled, for instance for kernel
debuggin.

Only enable ROX cache in execmem when STRICT_MODULE_RWX is set to
restore the original behaviour of module text permissions.

Fixes: 64f6a4e10c05 ("x86: re-enable EXECMEM_ROX support")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250603111446.2609381-3-rppt@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -88,7 +88,7 @@ config X86
 	select ARCH_HAS_DMA_OPS			if GART_IOMMU || XEN
 	select ARCH_HAS_EARLY_DEBUG		if KGDB
 	select ARCH_HAS_ELF_RANDOMIZE
-	select ARCH_HAS_EXECMEM_ROX		if X86_64
+	select ARCH_HAS_EXECMEM_ROX		if X86_64 && STRICT_MODULE_RWX
 	select ARCH_HAS_FAST_MULTIPLIER
 	select ARCH_HAS_FORTIFY_SOURCE
 	select ARCH_HAS_GCOV_PROFILE_ALL


