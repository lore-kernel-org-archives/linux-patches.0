Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC7F24BC17;
	Wed,  5 Mar 2025 17:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197011; cv=none; b=Ys3EpQP2azR2y7FQJuNbl07QTbZjav58Zcycqa29zoiDS3yee8mQOSOaPUBSfG53nhDuwCZIvjbsQ9OIJYeRCCbzDDPPt7cTc4ZcJ3Fdcax+yPyOpzezTqccKHKUgZDPeBC9cJtB+h9ZzBcQl/UrFV+iq82EL0t4pbi60dbXsu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197011; c=relaxed/simple;
	bh=yXq+p4W1Bv5Sj+GvZABCZ8NmeJWUOaNNAY1AQHuNnjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKC/TSU+JrjJTR4j/G4Trkqp1E/9BwzUKF1FvktoB4qFR2JosWfy8X/W0uUxrf+H8UFrVDoGm//vLreCe68eBo0aa57HBZJpgsCUYfJHm4WD+6gqkajTqgQlLkAMVrEbwtbd3XViRkYtPPR6cs49qiBzPENxdRUtw2EVlqMKhnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHDJKMuM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHDJKMuM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAE9C4CED1;
	Wed,  5 Mar 2025 17:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197010;
	bh=yXq+p4W1Bv5Sj+GvZABCZ8NmeJWUOaNNAY1AQHuNnjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jHDJKMuMVRqF7TxSnJqVBRjbwR3znLtbQGKK4ilCOV1iLLS5Q+2j+wGF4C4bG/LVz
	 JL4UuDC/5RgmZk/dhwYj8hG1q/JGVfMs97nv4BbHy1fxhKzqgDdIg1Ib71gTkOhdIw
	 dulutpvfEMolBusqFppxDGWHeQtfcv81ka910BCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"yang@os.amperecomputing.com, Naresh Kamboju" <naresh.kamboju@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 6.1 001/176] arm64: mte: Do not allow PROT_MTE on MAP_HUGETLB user mappings
Date: Wed,  5 Mar 2025 18:46:10 +0100
Message-ID: <20250305174505.502440313@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


