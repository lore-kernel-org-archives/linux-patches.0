Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F1B286890;
	Wed,  4 Feb 2026 15:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219262; cv=none; b=MxFLOfivmQYVIJTbi1vMaawDbm9CWWwOplerbHdEA95s95Xsm/K4w3WoTirK/GYsXWOASMy2PELQGuClfyAO7n2spjiSya2tkQH8FDxeQXDoNuly6ZV2hkT1bPxVgD0o76kx59UPxfuEqaDEwY+YcDBca6Byqy7eFE5R0zvXdnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219262; c=relaxed/simple;
	bh=Jk5F99hdFj1AHGyCrjPvlUv+AB6gSLY/6Zasx67o43s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=APGXGSonGs46btutoF5AwCgV8qRUV6hNp1hnMLb1tTeYlZKFHKgrG6AfTAbRiIM98JvWTbyzo3lPS05bKte6N6Q80X9+CBazr5MkcGTgN1jz0aD4HDeJHT3kh0ZL+fv4mSbC4Njvh2sZAp7C7p9Gr34YMETl5O0+/1JQCt5+jD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vanqRl9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vanqRl9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3046BC4CEF7;
	Wed,  4 Feb 2026 15:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219262;
	bh=Jk5F99hdFj1AHGyCrjPvlUv+AB6gSLY/6Zasx67o43s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vanqRl9uMHTpLjUrVIty0whztduA3rA8/puz24WDKnS2PzbIxZCF86kXzGK/cGR0k
	 E4Fxp8tvIUrgEfIHn8O/jRoB9E6YtG20oToFczr9l3OF6bJVYBaz6RsOPyaUML/pmd
	 e2ocx8Abl4wzM8APpFPPwWMTsgmukLs9UNP5FQds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bao Nguyen <ncqb@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 6.18 115/122] iommu/tegra241-cmdqv: Reset VCMDQ in tegra241_vcmdq_hw_init_user()
Date: Wed,  4 Feb 2026 15:41:37 +0100
Message-ID: <20260204143855.990041224@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

commit 80f1a2c2332fee0edccd006fe87fc8a6db94bab3 upstream.

The Enable bits in CMDQV/VINTF/VCMDQ_CONFIG registers do not actually reset
the HW registers. So, the driver explicitly clears all the registers when a
VINTF or VCMDQ is being initialized calling its hw_deinit() function.

However, a userspace VCMDQ is not properly reset, unlike an in-kernel VCMDQ
getting reset in tegra241_vcmdq_hw_init().

Meanwhile, tegra241_vintf_hw_init() calling tegra241_vintf_hw_deinit() will
not deinit any VCMDQ, since there is no userspace VCMDQ mapped to the VINTF
at that stage.

Then, this may result in dirty VCMDQ registers, which can fail the VM.

Like tegra241_vcmdq_hw_init(), reset a VCMDQ in tegra241_vcmdq_hw_init() to
fix this bug. This is required by a host kernel.

Fixes: 6717f26ab1e7 ("iommu/tegra241-cmdqv: Add user-space use support")
Cc: stable@vger.kernel.org
Reported-by: Bao Nguyen <ncqb@google.com>
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index 378104cd395e..04cc7a9036e4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -1078,6 +1078,9 @@ static int tegra241_vcmdq_hw_init_user(struct tegra241_vcmdq *vcmdq)
 {
 	char header[64];
 
+	/* Reset VCMDQ */
+	tegra241_vcmdq_hw_deinit(vcmdq);
+
 	/* Configure the vcmdq only; User space does the enabling */
 	writeq_relaxed(vcmdq->cmdq.q.q_base, REG_VCMDQ_PAGE1(vcmdq, BASE));
 
-- 
2.53.0



