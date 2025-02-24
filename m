Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525B418A6BA;
	Mon, 24 Feb 2025 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407786; cv=none; b=rmJ2zl9k4sUEHRSphd6uJ4EroJumoG+Hebhl+rNmxUfRM376vpqCRe7Fd6Ory9FA41reZrf7SiIAixVMwnUDvH5r9kzHHFrK0Kszwhntm/pmMzwfeWAl9g/UMca598DSYYc9zkXfuOOgIdj2USvuI9MdYH4jOb240pNQAE1/qn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407786; c=relaxed/simple;
	bh=PaiyGIV8LJHrjztEVL+mmmtKxB1CuNdVA9qGkui7RrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duR4jNltRItt2YJLetTFFTZwelWmGCR+aVidtMm9YoRcp2dZ1J7lM/w1ZcWFutVpRx7WbfKm3VQmFZcISS5cdUdoJnqIFFuY9MmCZi9weBR+Oa4IV7ZMtj/cjVA95X/VpXrPf7ZNufqZX46VY4RZtEg7twfWx4cc3IDDpuu1KVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGZ761uh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGZ761uh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC8FC4CED6;
	Mon, 24 Feb 2025 14:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407785;
	bh=PaiyGIV8LJHrjztEVL+mmmtKxB1CuNdVA9qGkui7RrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGZ761uhrhPRvN7dUrM5wmsyyNzP0Or0hjXN4Ny5Qh9lNfU29NEiAwfIlHzCOSe0x
	 IuHjTMJqCEMr8tQ1YG+pIe39w+3iedHlFnmfXFSZeCenHIqg0m+hN6ec3+J1PTe6eU
	 wj6gx4aGyY8ziKEBZl2cVrRGP5DgiClvGHZ3llV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yang@os.amperecomputing.com, Naresh Kamboju" <naresh.kamboju@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 6.6 001/140] arm64: mte: Do not allow PROT_MTE on MAP_HUGETLB user mappings
Date: Mon, 24 Feb 2025 15:33:20 +0100
Message-ID: <20250224142603.060607734@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


