Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C070C182D7;
	Tue, 27 May 2025 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366583; cv=none; b=LQVVGeRFvl/zXcwKYztrDZxE4N16QECIKp7rtMhHlQIoCEgDMdDk3L1lS0/yjW9Ce8I2QmkHzKxnITVAFBmTM/1p1yKLjqpJBdF0avQq7PbY+iyoHyRUcNOsGveeXBNiI3AUXys4xv+/7oXKPLeQRsTPx3/ecctxHSpJZUqPAzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366583; c=relaxed/simple;
	bh=aLa4RaqDzxXZ4NyPcTXdEdP81JyOxP4Y3kuYmXwHYNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+mDkDbKNJki9GUhxtBHOqWTuj1+q3MW29QQozwvfOzzf+JyI2HYtfonIePzoobIakCMcJnczSxQhkiwZqh5DCS/uTR5dXva8b6TP+nrjPHbjWHA2bHn9Wf6d8F9IGe3XtFpLJMw8zBv29NVbsFy8iAttmLyutrxD15MmrXeyBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wXIR73sP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wXIR73sP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED24C4CEE9;
	Tue, 27 May 2025 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366583;
	bh=aLa4RaqDzxXZ4NyPcTXdEdP81JyOxP4Y3kuYmXwHYNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wXIR73sPdddomAyLuW8Dkfa3Pa14UoGXLQ7NZBIkYJCfQ5uKQhi/9kpmM0FuFbwQq
	 Uazmxw3axkAiqNdyz1f3BX0Q8B/dTAe60rLBay/yP/hkoJC84AksoDvo1Pu5dzRCxK
	 43x2i6yJ2aU7jL5Ny0xzPHm006NBpJfvSQtLsgqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Guo <alice.guo@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 085/783] thermal/drivers/qoriq: Power down TMU on system suspend
Date: Tue, 27 May 2025 18:18:02 +0200
Message-ID: <20250527162516.599751545@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Guo <alice.guo@nxp.com>

[ Upstream commit 229f3feb4b0442835b27d519679168bea2de96c2 ]

Enable power-down of TMU (Thermal Management Unit) for TMU version 2 during
system suspend to save power. Save approximately 4.3mW on VDD_ANA_1P8 on
i.MX93 platforms.

Signed-off-by: Alice Guo <alice.guo@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20241209164859.3758906-2-Frank.Li@nxp.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/qoriq_thermal.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/thermal/qoriq_thermal.c b/drivers/thermal/qoriq_thermal.c
index 52e26be8c53df..aed2729f63d06 100644
--- a/drivers/thermal/qoriq_thermal.c
+++ b/drivers/thermal/qoriq_thermal.c
@@ -18,6 +18,7 @@
 #define SITES_MAX		16
 #define TMR_DISABLE		0x0
 #define TMR_ME			0x80000000
+#define TMR_CMD			BIT(29)
 #define TMR_ALPF		0x0c000000
 #define TMR_ALPF_V2		0x03000000
 #define TMTMIR_DEFAULT	0x0000000f
@@ -356,6 +357,12 @@ static int qoriq_tmu_suspend(struct device *dev)
 	if (ret)
 		return ret;
 
+	if (data->ver > TMU_VER1) {
+		ret = regmap_set_bits(data->regmap, REGS_TMR, TMR_CMD);
+		if (ret)
+			return ret;
+	}
+
 	clk_disable_unprepare(data->clk);
 
 	return 0;
@@ -370,6 +377,12 @@ static int qoriq_tmu_resume(struct device *dev)
 	if (ret)
 		return ret;
 
+	if (data->ver > TMU_VER1) {
+		ret = regmap_clear_bits(data->regmap, REGS_TMR, TMR_CMD);
+		if (ret)
+			return ret;
+	}
+
 	/* Enable monitoring */
 	return regmap_update_bits(data->regmap, REGS_TMR, TMR_ME, TMR_ME);
 }
-- 
2.39.5



