Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6C8332EAE;
	Sat, 12 Sep 2026 14:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224902; cv=none; b=XxzgSNNRCluDfUgtpBkXlqWnjcnG8OSzvDI7N9omxx/91mNGNb000qhguWrTvBqmYO/py0aF3uRhS21Vrcy09RTsebShTZIBUzhpwBaNeCyUCVbIJmqzD89wHb5gwEqd8/WfC/gbuGb+Agkd/AHs0wGqHOfkzr7cQ3my/wQfGKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224902; c=relaxed/simple;
	bh=g8AJGHBZ7NQY2g6Qf2u9FuDIvdbG2W0XsLoqLOYiPPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFn76PS7VqB+flXBHE9f+GTC84pJRnKjjy5pTvldSlioWqdRslI04eX6Z0cnyWVPA15xYt0IGHwldkkaBLB/EQVKUQ0o+jzd3mhr2cHUWoYkvNeHcFmaqs8Mnk6XYv8yc4aGonVwu7X7jNZPUd1DDA7lc/lQIpDgCub3gNJamBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcubT67n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcubT67n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684F11F000FF;
	Sat, 12 Sep 2026 14:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224901;
	bh=P/VQsiEGCCeU7C3kVuE3TVKs+hb95u3SycfqyT4n0TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KcubT67nC6dCAwzZOqiMwdi2KmjVvTnFe9EaCW0R2CZ7I1vZOavzwVLyMRzL5NRtF
	 Q7AkqQRmNwdaSJ157E+NPPdwmb2kesjRkIF35GUyIMEuUIsLi8RFbFANl6oQKZvehi
	 fh12CEjbPGDvY4uIFckUMefN5WQgWvlBZB60kOLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1086/1424] arm64: hibernate: mask DAIF before restoring hibernated kernel
Date: Sat, 12 Sep 2026 08:58:38 +0200
Message-ID: <20260912065631.626876879@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 17c436387f1b6..165f61b07da13 100644
--- a/arch/arm64/kernel/hibernate.c
+++ b/arch/arm64/kernel/hibernate.c
@@ -459,9 +459,21 @@ int __nocfi swsusp_arch_resume(void)
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



