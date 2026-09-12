Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3293437AA92;
	Sat, 12 Sep 2026 10:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209975; cv=none; b=kxUi0LAKvQxIG0vYYrUh1xriSLLI8cLInj3dfmYEbnpTHSkqNaK/fY5R4MeDg/xvECpoQu7Gd5rmebBXvFXW2mt2yyIcx/6NG3ezuvxdVW+9Mfo8aNO160VWfs5rYRmBZGyreaFIdLsabrPxfvnS8TYAxKULS6/5rUucHFycF1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209975; c=relaxed/simple;
	bh=htrVoJAzI0yqihQXY8WP/1xWpXLnAmGhI5cJ2YlMLEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lO5cCR//OM93ro1Sbqn252uvb8ZUxbW6wzn2hmJnCoopU0ujJO59U7+3iLffNFoUpRSt2RIg+SJrxLk+STzGVw1nj+qp9LWVOBRr9mbrg9hB1hyVsle7oZxTrqxzpft/MUGqQMCqd/oyBXvHEwdl01J+u8RD5aggZA8rQRNDvqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/erit5z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/erit5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED601F000FF;
	Sat, 12 Sep 2026 10:46:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209974;
	bh=1F90Ql0ysTCwX2V7hOMcPw3TA2ZmeMdPILlbljG2TSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/erit5zW/N5ITyMBBZBqa9J5YgipcGh39bl65KiCRsf6+jCxPu+ei1ryHV9xHsUl
	 sqsml04Inv4zNf82yxanZRwHS6Ve9/rzwsDplKERvg6NySojHosI2oE30UNyWLf6hF
	 rVy/VzI2gGOYWUwqAKIYoaROUMMkDIyy4qiV8mYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0932/1518] arm64: hibernate: mask DAIF before restoring hibernated kernel
Date: Sat, 12 Sep 2026 08:51:41 +0200
Message-ID: <20260912065644.534266878@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ada Couprie Diaz <ada.coupriediaz@arm.com>

[ Upstream commit 684bde100117931f4c51c644a95f42f2dab041bc ]

The arm64 hibernate code manages the exception masking in an unsound
way, leading to potential crashes and/or warnings during resume.

When a hibernation image is saved in `swsusp_arch_suspend()`, all DAIF
exceptions are masked (by virtue of `local_daif_save()`), and the
suspended image is saved assuming that all DAIF exceptions will remain
masked when the image is restored.

When a hibernation image is resumed by `swsusp_arch_resume()`, only
interrupts are masked (by virtue of `local_irq_disable()` in
`resume_target_kernel()`). When pseudo-NMI is enabled the DAIF.IF bits
will be clear, and regardless of pseudo-NMI the DAIF.DA bits will be
clear.

This means that there are two problems:

(1) It is possible to take Debug, SError, or pseudo-NMI exceptions
    during the resume process. This is unsafe, as during the resume
    process both the old ane new kernels will tranisently be in an
    inconsistent state, and swsusp_arch_suspend_exit() won't retain
    an executable mapping of any exception vectors.

    Any exception taken here will be fatal and silent.

(2) When re-entering the resumed kernel, some DAIF bits will be clear
    unexpectedly. This permits Debug, SError, or pseudo-NMI exceptions
    to be taken for a short period while the resumed kernel is not yet
    in a consistent state.

    This is detected by CONFIG_ARM64_DEBUG_PRIORITY_MASKING.

Avoid these issues by masking all DAIF exceptions during resume.

Fixes: 82869ac57b5d ("arm64: kernel: Add support for hibernate/suspend-to-disk")
Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/hibernate.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/kernel/hibernate.c b/arch/arm64/kernel/hibernate.c
index 9717568518ba7..1eb1c1074c5b0 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -465,9 +465,21 @@ int __nocfi swsusp_arch_resume(void)
 	if (el2_reset_needed())
 		__hyp_set_vectors(el2_vectors);
 
+	/*
+	 * It is necessary to mask all DAIF exceptions here as:
+	 *
+	 * - The copy of swsusp_arch_suspend_exit() in the hibernation
+	 *   text cannot handle taking any exceptions.
+	 *
+	 * - The suspended kernel masked all DAIF exceptions in
+	 *   swsusp_arch_resume(), and expects to be re-entered in the
+	 *   same state : with all DAIF exceptions masked.
+	 */
+	local_daif_save();
 	hibernate_exit(virt_to_phys(tmp_pg_dir), resume_hdr.ttbr1_el1,
 		       resume_hdr.reenter_kernel, restore_pblist,
 		       resume_hdr.__hyp_stub_vectors, virt_to_phys(zero_page));
+	unreachable();
 
 	return 0;
 }
-- 
2.53.0



