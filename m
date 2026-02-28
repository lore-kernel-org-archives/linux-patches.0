Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5BC4B8DE6;
	Sat, 28 Feb 2026 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301335; cv=none; b=s6RR/To1IEJQ+4O931905fxZfeNk5S8wDqjQqop6pd6Q/9jEFxRNIdz0GgsdeHwLzsKNBQ2cokcCPscw9rucit3YSKPeugTGRd/Mr+/EQlPo4F3kRfiJ87Ky+E7lI6+Xj5aqyKugPrecbmEU9qAIjhzFovoXX17q4NMEuCPsXmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301335; c=relaxed/simple;
	bh=hk7Vevhy52GiAlAeBIvAyEeQV9/hNyiHwDwMTJV5wwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dqoU2q3QC89ZPT0nqlXsOc7pBSQxijCz1ssnDtlwAHJpeD/m9uv482kz+57BFw+6kdzpg4YyPmdEw7u9BS2yFfp937MYZrgh9bNE8Tvwzp0AfjulmZu6b9cKUyXnk/exeW9Y3zVB8G5ecqsNsTpDZKjoWjEtb5LeDOtpqQ0m004=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SUB4mOb4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SUB4mOb4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C9D6C116D0;
	Sat, 28 Feb 2026 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301335;
	bh=hk7Vevhy52GiAlAeBIvAyEeQV9/hNyiHwDwMTJV5wwg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUB4mOb4udNjkBWIuTE62JvyTmg+6DBRfHMjOmg4fpXEtsBNDL+zTwge6MCRpqUfC
	 v7+AzqTjnHO1P4vHIbfaD56Ji7SALfCXeZ9sXyYvVJQrl41pq1shwy0hvHmeM9bDog
	 movIU8kBa85kU5Syny+FvqXeGlaz7z5ODTcmbWqvJe8jafFZ2+0AnoTo7vA8dZVqZw
	 fgWZP+FOzryx7LUMrVDU4NLhTgjFAzdk9xDqAoY0+plEuUvtJjLREIlYJdKX1/W7jR
	 zckKTl3JkbGd2d9dhOs5skQDN603xMclOCVIX/7/lnVceunADOhojd8LTmTfucaCcD
	 kfAM47ITR/v3w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	stable@vger.kernel.org,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
	Bryan O'Donoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 522/752] media: qcom: camss: vfe: Fix out-of-bounds access in vfe_isr_reg_update()
Date: Sat, 28 Feb 2026 12:43:53 -0500
Message-ID: <20260228174750.1542406-522-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alper Ak <alperyasinak1@gmail.com>

[ Upstream commit d965919af524e68cb2ab1a685872050ad2ee933d ]

vfe_isr() iterates using MSM_VFE_IMAGE_MASTERS_NUM(7) as the loop
bound and passes the index to vfe_isr_reg_update(). However,
vfe->line[] array is defined with VFE_LINE_NUM_MAX(4):

    struct vfe_line line[VFE_LINE_NUM_MAX];

When index is 4, 5, 6, the access to vfe->line[line_id] exceeds
the array bounds and resulting in out-of-bounds memory access.

Fix this by using separate loops for output lines and write masters.

Fixes: 4edc8eae715c ("media: camss: Add initial support for VFE hardware version Titan 480")
Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
Cc: stable@vger.kernel.org
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss-vfe-480.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe-480.c b/drivers/media/platform/qcom/camss/camss-vfe-480.c
index 4feea590a47bc..d73f733fde045 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-480.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-480.c
@@ -202,11 +202,13 @@ static irqreturn_t vfe_isr(int irq, void *dev)
 		writel_relaxed(status, vfe->base + VFE_BUS_IRQ_CLEAR(0));
 		writel_relaxed(1, vfe->base + VFE_BUS_IRQ_CLEAR_GLOBAL);
 
-		/* Loop through all WMs IRQs */
-		for (i = 0; i < MSM_VFE_IMAGE_MASTERS_NUM; i++) {
+		for (i = 0; i < MAX_VFE_OUTPUT_LINES; i++) {
 			if (status & BUS_IRQ_MASK_0_RDI_RUP(vfe, i))
 				vfe_isr_reg_update(vfe, i);
+		}
 
+		/* Loop through all WMs IRQs */
+		for (i = 0; i < MSM_VFE_IMAGE_MASTERS_NUM; i++) {
 			if (status & BUS_IRQ_MASK_0_COMP_DONE(vfe, RDI_COMP_GROUP(i)))
 				vfe_buf_done(vfe, i);
 		}
-- 
2.51.0

