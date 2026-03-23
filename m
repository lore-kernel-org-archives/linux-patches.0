Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F54242D7B;
	Mon, 23 Mar 2026 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774279425; cv=none; b=lbnYAX+kGx7rj141TXV/4+/TYDcLm+aR0D5DmW9yEPw3kuUNJmlJ0/UeK90Fq2tZ0TH08Jk43eA+x8LuL3gD359Akoo9eccNSF/rVumR88tJIrruWKcxoQNPM/H4LNY031gYkf19CeoyiIrOC6pPe4W4TwTOPmhwruhLG/4YEVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774279425; c=relaxed/simple;
	bh=AWJcvE5eQv7pSQEdgpl8uXe+AXTpHCSDrzfSr9O/zIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miAeJsmBt+h9jmeqUWuEyIJlRC62BaYF4OdNTiQalkh/vHky6V4SZ8EGd2ubuwUaxmhDGHhWg70dLgcL08RD5aasup+u/mA5N2Zh5bqpC/PLZV8jx0328QDyT2D6+xQ47sJqVqrFFU6nnUvNbsLwgDfMyNousk4HPBaECSkALKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YZvAXnDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YZvAXnDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32502C4CEF7;
	Mon, 23 Mar 2026 15:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774279425;
	bh=AWJcvE5eQv7pSQEdgpl8uXe+AXTpHCSDrzfSr9O/zIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YZvAXnDnABviKRkDZLOKoyO5Du78TraEDOfgNKsd5rq8F9+sR+CIwYNp2EcDf/bQF
	 M3nZmXR4+Zw7b2y6Tufqh8KW5tNQB6Og1jVFVgMmM05w97zH+/d/mCGZBobsColX/i
	 DHauLW29JP0iqu9VxDXsVedBIMCS6W7PLdSaOy2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Ak <alperyasinak1@gmail.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/481] media: qcom: camss: vfe: Fix out-of-bounds access in vfe_isr_reg_update()
Date: Mon, 23 Mar 2026 14:40:15 +0100
Message-ID: <20260323134526.045502264@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 0063e36a30e05..fa818517ab0da 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe-480.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe-480.c
@@ -223,11 +223,13 @@ static irqreturn_t vfe_isr(int irq, void *dev)
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
 				vfe_isr_wm_done(vfe, i);
 		}
-- 
2.51.0



