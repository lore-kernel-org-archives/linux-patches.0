Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6B0B1FB2B
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A16BC433C8;
	Tue,  1 Aug 2023 09:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882371;
	bh=QH7KR7iqcVQTsLW/mJ5r5NQCFKcwNcxz0U+qY+XkdFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjt5ZpxElFg1WAWgcZxA0r1cdVeL5lIK1Ta6rcoewxOYUd2iLS36Shq+2KGyWj4T9
	 fboQyO26RgKi0e+DcWvVyz8R/8ipZ+V6yM0eUJ10VPA9acVsaJiWHi1qssFVQTtVNr
	 C49d8OEjyj+LMyXZeomkLiOlrSUWIp1tu6+Xwc/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/228] KVM: arm64: Condition HW AF updates on config option
Date: Tue,  1 Aug 2023 11:18:31 +0200
Message-ID: <20230801091924.810481541@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Oliver Upton <oliver.upton@linux.dev>

[ Upstream commit 1dfc3e905089a0bcada268fb5691a605655e0319 ]

As it currently stands, KVM makes use of FEAT_HAFDBS unconditionally.
Use of the feature in the rest of the kernel is guarded by an associated
Kconfig option.

Align KVM with the rest of the kernel and only enable VTCR_HA when
ARM64_HW_AFDBM is enabled. This can be helpful for testing changes to
the stage-2 access fault path on Armv8.1+ implementations.

Link: https://lore.kernel.org/r/20221202185156.696189-7-oliver.upton@linux.dev
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
Stable-dep-of: 6df696cd9bc1 ("arm64: errata: Mitigate Ampere1 erratum AC03_CPU_38 at stage-2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index cdf8e76b0be14..8f37e65c23eea 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -595,12 +595,14 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 		lvls = 2;
 	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
 
+#ifdef CONFIG_ARM64_HW_AFDBM
 	/*
 	 * Enable the Hardware Access Flag management, unconditionally
 	 * on all CPUs. The features is RES0 on CPUs without the support
 	 * and must be ignored by the CPUs.
 	 */
 	vtcr |= VTCR_EL2_HA;
+#endif /* CONFIG_ARM64_HW_AFDBM */
 
 	/* Set the vmid bits */
 	vtcr |= (get_vmid_bits(mmfr1) == 16) ?
-- 
2.39.2



