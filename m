Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1716322576A;
	Mon, 10 Mar 2025 18:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630482; cv=none; b=pzwRWI28Hpx4+1uMWUB2mLRcGimjnGXqpv3ZSZg1OtnOIBX197K/nudutPaZD2AT4J8t+X7VL/cSW9PMMhz3afp43aoZ8ynMUxW1i6LVJv6e0xS8LEhUkoymZpFvxC2O/T07BCUhcYnfwGtN0ZtshC6umLHHELZDgXlND5ZJUi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630482; c=relaxed/simple;
	bh=bxyVf9YF8ex398v5pUrK/8c3dH+gwVGdOg55qjU6g3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ToeGZ7LFo16CoJJcgVmUbpaTALJ517RZHu0GvtrRf+srzYVTsSRwheuUcAg0s7CHdlQv5/k0acwWh0s9P1ULEgMRH6tUug3tyYKn2kiad/wX8KU+odGeSMAkb4SKEJnjPGuXz2HAN22GOIbaGxxpFWsU900Qgu9zCfWDRTbX0kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GvuBHJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GvuBHJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D55DC4CEEC;
	Mon, 10 Mar 2025 18:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630481;
	bh=bxyVf9YF8ex398v5pUrK/8c3dH+gwVGdOg55qjU6g3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GvuBHJ+QJim2RpveiOXl/J+Owi+N2bjsLx9ryoh/AoaNOVKCXAjlP7B94yKrQ79p
	 EC90UpXpgE2soqFobVNqKodxGjwxLx/ULt0XixGf20IWSpMxfJYeP51BEuBlSCWsFl
	 EE0VoNRZSWEhTzJDYPTMWZGqgrjbSAHfeeL3Fr1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yang@os.amperecomputing.com, Naresh Kamboju" <naresh.kamboju@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 5.15 430/620] arm64: mte: Do not allow PROT_MTE on MAP_HUGETLB user mappings
Date: Mon, 10 Mar 2025 18:04:36 +0100
Message-ID: <20250310170602.571340049@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Catalin Marinas <catalin.marinas@arm.com>

PROT_MTE (memory tagging extensions) is not supported on all user mmap()
types for various reasons (memory attributes, backing storage, CoW
handling). The arm64 arch_validate_flags() function checks whether the
VM_MTE_ALLOWED flag has been set for a vma during mmap(), usually by
arch_calc_vm_flag_bits().

Linux prior to 6.13 does not support PROT_MTE hugetlb mappings. This was
added by commit 25c17c4b55de ("hugetlb: arm64: add mte support").
However, earlier kernels inadvertently set VM_MTE_ALLOWED on
(MAP_ANONYMOUS | MAP_HUGETLB) mappings by only checking for
MAP_ANONYMOUS.

Explicitly check MAP_HUGETLB in arch_calc_vm_flag_bits() and avoid
setting VM_MTE_ALLOWED for such mappings.

Fixes: 9f3419315f3c ("arm64: mte: Add PROT_MTE support to mmap() and mprotect()")
Cc: <stable@vger.kernel.org> # 5.10.x-6.12.x
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/mman.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/arch/arm64/include/asm/mman.h
+++ b/arch/arm64/include/asm/mman.h
@@ -31,9 +31,12 @@ static inline unsigned long arch_calc_vm
 	 * backed by tags-capable memory. The vm_flags may be overridden by a
 	 * filesystem supporting MTE (RAM-based).
 	 */
-	if (system_supports_mte() &&
-	    ((flags & MAP_ANONYMOUS) || shmem_file(file)))
-		return VM_MTE_ALLOWED;
+	if (system_supports_mte()) {
+		if ((flags & MAP_ANONYMOUS) && !(flags & MAP_HUGETLB))
+			return VM_MTE_ALLOWED;
+		if (shmem_file(file))
+			return VM_MTE_ALLOWED;
+	}
 
 	return 0;
 }


