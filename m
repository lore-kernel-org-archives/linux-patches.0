Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209347;
	b=zdUrI4Sv93VkwhgyOg1GEpasfDH08rPywk7C05MYN41x1hFpKfZ344zittcWu9ci867o
	 AMLvlVHxnNHDLK8Wyh5xFkAcAFe0B2KDm05/AnnbTA5mQfxIAxocwsyG185KXexR0c/m0
	 5swnBb342Ya324E5CvmOoYGlWec9Z4zXZnK90QswyeN/eplRClj/8ZgBEepJxG8vogY3y
	 zJg4vJLsu7XFNJLAzk06NRPjx9ClHPsEpj40aPhfI/mLUt6vDborSLsepCZcXNzKwIKXn
	 S1iooMtMlHv/Y6+jjbO+af1jCZxRM908msCahkGYR44INVht0hpKGsNikTCf8k5q2ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z+MfapXXVDsr8JkCghPsDO8r8XyJyZSTIc48HQa0JOg=;
	b=3VAfMQoDLlRFuqARu7YP0XT7pTp/JvhJ3cbmgt/6epKC58/DfRRDCOW1CqP+8llM1NxK
	 eH9Zk4Lx/k9IBOFc1+xB/ZvRZSgjMXMwF3Rlq3m+J0pItwPW4DWJriaKuw0jk2wXCsG+T
	 Gyf7bf5k5iyHqjcX+dmhHsHZOH8WBhQvtXL2H4fLhaeDSJ5ojM6GubVNecMz2ce9Qqulr
	 LLEvx+p3mA/k/degkgR5MZ+k1B3gl0dzuPyTxb7/YY5cOlTC+SSFaPZJfEa2yUGrcOMpH
	 PfrA0JIwdP+3xrEbqgNTlZGCMXM2jJgeqZ4J3/Xa3eLtq1bLtDKEnlOS4F6IH+b2XGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0zjbtDWA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEFC606A31A;
	Wed, 28 Oct 2026 17:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0zjbtDWA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC6C1F01825;
	Wed, 28 Oct 2026 17:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209346;
	bh=z+MfapXXVDsr8JkCghPsDO8r8XyJyZSTIc48HQa0JOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zjbtDWAsq3JFXKkIjcHRU4R3YZhb2bUnuNQOcmKmIViD1gA0A0qS199Xcnvdz712
	 h3LYOM6UGSPz6pox5NzMTBeNkHKxkliWopHQtm0245OIH2jKZb4zfYVvAmhMvOixgQ
	 gx8+RA6e6tbRGYWqSytZcD0n9rhpwhk/jhjwiHRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Keith Busch <kbusch@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 439/516] nios2: fix __wsum type degradation in csum_fold()
Date: Wed, 28 Oct 2026 17:59:51 +0100
Message-ID: <20261028170013.883577158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit b963f2345fa20417401c51a69dedb6a58eea33a9 ]

csum_fold() shifts a bitwise __wsum type, which sparse reports as
"restricted __wsum degrades to integer". Sparse only checks the body of
a static inline once something instantiates it, so this went unnoticed
until a recent block layer change added the first csum_fold() caller to
a file built on this architecture.

Force cast to a __u32 for the shift, as the other architectures do.

Fixes: eea9507a69d6 ("nios2: Library functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609222053.5gjiJjtb-lkp@intel.com/
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/nios2/include/asm/checksum.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/nios2/include/asm/checksum.h b/arch/nios2/include/asm/checksum.h
index 69004e07a1ba3..b6b415ae17a08 100644
--- a/arch/nios2/include/asm/checksum.h
+++ b/arch/nios2/include/asm/checksum.h
@@ -27,7 +27,7 @@ static inline __sum16 csum_fold(__wsum sum)
 		"add	%0, %0, r8\n"
 		"nor	%0, %0, %0\n"
 		: "=r" (sum)
-		: "r" (sum << 16), "0" (sum)
+		: "r" ((__force u32)sum << 16), "0" (sum)
 		: "r8");
 	return (__force __sum16) sum;
 }
-- 
2.53.0



