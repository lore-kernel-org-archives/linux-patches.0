Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 786311F5439;
	Tue, 21 Jan 2025 17:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482087; cv=none; b=D6JJW5LesPe4dybG9CFRawIHfhqGDr0dgykY0muBRk42z3ULodnuCJI6brrXb2B6Boen7nGa8YAGb/BCspoKtk/cTKEn3BhZ56SNia2UFrgCWQ0PNJ8VyEoT8MB0nmd4B4KpTIXTnTzVrLEtywsew/1IWbAvdIL6e1pqcnWZtSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482087; c=relaxed/simple;
	bh=PJf7nNvcuXdYuZc3P3lmqsDOe6Iv4X3bkRpWu+3+t2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meu8pgaJqRde8r5UsMMwiqCGW5eaL5IuG681v6rDiUubqqJAOXORUTfm/2zdzTvt7EFGRQI38qrWTQn/SDBgSuymdKchKeIf5ayKqtc4K0t+BKpRWF0Bs9RpWNsD1Rq/VYmB08H2kL8JLnlc2Mr5rfz826wqZzFu7dSpHEC3Hj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqxizEzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqxizEzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3348C4CEDF;
	Tue, 21 Jan 2025 17:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482087;
	bh=PJf7nNvcuXdYuZc3P3lmqsDOe6Iv4X3bkRpWu+3+t2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqxizEzQg17LvJjKkgptJYhUkyhC0l3zQ7fUikv8kpEuwplM0dEXhz3Av/pWmxj1n
	 6e3KbNUkDE0JWOeHBalTtWRm8dCVhi94uToixV8ry2Lqu7uf3YJQ2lr58UgTHxdwfz
	 QQYqshWqwumdQ4dziN8+i+U8InIaS704PSDNjJsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 30/72] scsi: ufs: core: Honor runtime/system PM levels if set by host controller drivers
Date: Tue, 21 Jan 2025 18:51:56 +0100
Message-ID: <20250121174524.584881111@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit bb9850704c043e48c86cc9df90ee102e8a338229 ]

Otherwise, the default levels will override the levels set by the host
controller drivers.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241219-ufs-qcom-suspend-fix-v3-2-63c4b95a70b9@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 02696c7f9beff..0ac0b6aaf9c62 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10483,14 +10483,17 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	}
 
 	/*
-	 * Set the default power management level for runtime and system PM.
+	 * Set the default power management level for runtime and system PM if
+	 * not set by the host controller drivers.
 	 * Default power saving mode is to keep UFS link in Hibern8 state
 	 * and UFS device in sleep state.
 	 */
-	hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+	if (!hba->rpm_lvl)
+		hba->rpm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
-	hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
+	if (!hba->spm_lvl)
+		hba->spm_lvl = ufs_get_desired_pm_lvl_for_dev_link_state(
 						UFS_SLEEP_PWR_MODE,
 						UIC_LINK_HIBERN8_STATE);
 
-- 
2.39.5



