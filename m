Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743C7359F8A;
	Tue, 16 Dec 2025 12:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887286; cv=none; b=Ql7vyjtHKSz7yRz3GZhLdjJ80X36g35Ldz0FYZCae5TRfeaxeU6Ha5bA/rPfe1OOuNAHPq1u0P/4BXyQxYCFSNrH+03i/1qOa0kcQXbiR1Pv5//HPf8rSkOnIfVNb9u10IQ6eiHXH1fq77stIKKkPKgw3Gy0+hwlB5AOR+WLTgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887286; c=relaxed/simple;
	bh=nzSOeoV3E2mszxyQHSCXOHHALdGnCU/MEKZ4OdDiq/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoOvzh9Y8NMDV2D7ERAAzo+wAio7Sks78UmDfSIryQCMX1Oj/GOMXPOEq/bdU7jcOtYOivdG/Xus7mVs8SpZGIJbFe2Zhp9m547zxCztSc4IZOctzFAoeHP6emOGiI1jAqW89xYx4xjJ5FhjEcrjL7wIxvXJbXrullGzwvWu3+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hulpSMA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hulpSMA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8881C4CEF1;
	Tue, 16 Dec 2025 12:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887285;
	bh=nzSOeoV3E2mszxyQHSCXOHHALdGnCU/MEKZ4OdDiq/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hulpSMA4Epa6x/mp8ZOmSbI0hUF1hZSauMZoEjegA91NE1egVFgmYX5iOcduCLMj6
	 bq7cn3B/i0n1CNJGVCR/EHe5M/yB17QMOS3Hjv/SHlwRPUhZnNTi5mJNeZzq8TLARy
	 4BRFEBLBHBY/7YNNovdjHITgFWBgf+yYLntQcoMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 184/614] power: supply: qcom_battmgr: clamp charge control thresholds
Date: Tue, 16 Dec 2025 12:09:11 +0100
Message-ID: <20251216111408.039911311@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Val Packett <val@packett.cool>

[ Upstream commit 8809980fdc8a86070667032fa4005ee83f1c62f3 ]

The sysfs API documentation says that drivers "round written values to
the nearest supported value" for charge_control_end_threshold.

Let's do this for both thresholds, as userspace (e.g. upower) generally
does not expect these writes to fail at all.

Fixes: cc3e883a0625 ("power: supply: qcom_battmgr: Add charge control support")
Signed-off-by: Val Packett <val@packett.cool>
Link: https://patch.msgid.link/20251012233333.19144-3-val@packett.cool
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/qcom_battmgr.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/power/supply/qcom_battmgr.c b/drivers/power/supply/qcom_battmgr.c
index 3c2837ef34617..c8028606bba00 100644
--- a/drivers/power/supply/qcom_battmgr.c
+++ b/drivers/power/supply/qcom_battmgr.c
@@ -678,12 +678,7 @@ static int qcom_battmgr_set_charge_start_threshold(struct qcom_battmgr *battmgr,
 	u32 target_soc, delta_soc;
 	int ret;
 
-	if (start_soc < CHARGE_CTRL_START_THR_MIN ||
-	    start_soc > CHARGE_CTRL_START_THR_MAX) {
-		dev_err(battmgr->dev, "charge control start threshold exceed range: [%u - %u]\n",
-			CHARGE_CTRL_START_THR_MIN, CHARGE_CTRL_START_THR_MAX);
-		return -EINVAL;
-	}
+	start_soc = clamp(start_soc, CHARGE_CTRL_START_THR_MIN, CHARGE_CTRL_START_THR_MAX);
 
 	/*
 	 * If the new start threshold is larger than the old end threshold,
@@ -716,12 +711,7 @@ static int qcom_battmgr_set_charge_end_threshold(struct qcom_battmgr *battmgr, i
 	u32 delta_soc = CHARGE_CTRL_DELTA_SOC;
 	int ret;
 
-	if (end_soc < CHARGE_CTRL_END_THR_MIN ||
-	    end_soc > CHARGE_CTRL_END_THR_MAX) {
-		dev_err(battmgr->dev, "charge control end threshold exceed range: [%u - %u]\n",
-			CHARGE_CTRL_END_THR_MIN, CHARGE_CTRL_END_THR_MAX);
-		return -EINVAL;
-	}
+	end_soc = clamp(end_soc, CHARGE_CTRL_END_THR_MIN, CHARGE_CTRL_END_THR_MAX);
 
 	if (battmgr->info.charge_ctrl_start && end_soc > battmgr->info.charge_ctrl_start)
 		delta_soc = end_soc - battmgr->info.charge_ctrl_start;
-- 
2.51.0



