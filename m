Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD561803A
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9fpKpCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD8BCC433C8;
	Mon,  9 Oct 2023 13:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857416;
	bh=t1fA3ilmVtygiC1tpTrzCaF6ZXfCiN2Q8HShW+KaotI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S9fpKpCbO+UxktStlS/vvv7suWjAHzJxQRy4/YPlm35ao+uYVAMknNsxAloRL/TKw
	 l9SZGZdSsQv1HQXCOP8vzcCnHNm87xJv1d4WqALY13ohKwPe0HQ7h8xA5/4cxpwhaR
	 woaVIt8AkcuLmfHiD5osliujIic9gyLLDtiyqv9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/162] arm64: Avoid repeated AA64MMFR1_EL1 register read on pagefault path
Date: Mon,  9 Oct 2023 15:00:19 +0200
Message-ID: <20231009130123.991791042@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>
References: <20231009130122.946357448@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit a89c6bcdac22bec1bfbe6e64060b4cf5838d4f47 ]

Accessing AA64MMFR1_EL1 is expensive in KVM guests, since it is emulated
in the hypervisor.  In fact, ARM documentation mentions some feature
registers are not supposed to be accessed frequently by the OS, and
therefore should be emulated for guests [1].

Commit 0388f9c74330 ("arm64: mm: Implement
arch_wants_old_prefaulted_pte()") introduced a read of this register in
the page fault path.  But, even when the feature of setting faultaround
pages with the old flag is disabled for a given cpu, we are still paying
the cost of checking the register on every pagefault. This results in an
explosion of vmexit events in KVM guests, which directly impacts the
performance of virtualized workloads.  For instance, running kernbench
yields a 15% increase in system time solely due to the increased vmexit
cycles.

This patch avoids the extra cost by using the sanitized cached value.
It should be safe to do so, since this register mustn't change for a
given cpu.

[1] https://developer.arm.com/-/media/Arm%20Developer%20Community/PDF/Learn%20the%20Architecture/Armv8-A%20virtualization.pdf?revision=a765a7df-1a00-434d-b241-357bfda2dd31

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20230109151955.8292-1-krisman@suse.de
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index f73f11b550425..5bf0f9aa46267 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -863,7 +863,11 @@ static inline bool cpu_has_hw_af(void)
 	if (!IS_ENABLED(CONFIG_ARM64_HW_AFDBM))
 		return false;
 
-	mmfr1 = read_cpuid(ID_AA64MMFR1_EL1);
+	/*
+	 * Use cached version to avoid emulated msr operation on KVM
+	 * guests.
+	 */
+	mmfr1 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	return cpuid_feature_extract_unsigned_field(mmfr1,
 						ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
 }
-- 
2.40.1



