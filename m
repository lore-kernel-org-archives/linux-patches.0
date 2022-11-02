Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CB47E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C92BC433D7;
	Wed,  2 Nov 2022 02:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356811;
	bh=N6H/qRSL3YgHoDhTK7tcCe9i/SF5iY6Y7TS0MjoL63o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NPt1qa7fzxUge02SM+JCn96M7ppS8a4poSxncRavCswy4RuJN+hs+bLPJpM4XGaHk
	 P7t75Fr8tjkjqpvu/NLS5weGX2+oxk8rckYe9OeIHXlEFrMqkqoMti4q3uE/65D/j0
	 MH5cbOFenqNxHm3sV7P9NScPLgvQrPZCuYdBSX7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qilong <zhangqilong3@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.0 035/240] mtd: rawnand: tegra: Fix PM disable depth imbalance in probe
Date: Wed,  2 Nov 2022 03:30:10 +0100
Message-Id: <20221102022112.198049006@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Qilong <zhangqilong3@huawei.com>

commit 3ada71310d2c68eebb57772df6bb1f5f033ae802 upstream.

The pm_runtime_enable will increase power disable depth. Thus
a pairing decrement is needed on the error handling path to
keep it balanced according to context.

Cc: stable@vger.kernel.org
Fixes: d7d9f8ec77fe9 ("mtd: rawnand: add NVIDIA Tegra NAND Flash controller driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220926084456.98160-1-zhangqilong3@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/tegra_nand.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/tegra_nand.c
+++ b/drivers/mtd/nand/raw/tegra_nand.c
@@ -1181,7 +1181,7 @@ static int tegra_nand_probe(struct platf
 	pm_runtime_enable(&pdev->dev);
 	err = pm_runtime_resume_and_get(&pdev->dev);
 	if (err)
-		return err;
+		goto err_dis_pm;
 
 	err = reset_control_reset(rst);
 	if (err) {
@@ -1215,6 +1215,8 @@ static int tegra_nand_probe(struct platf
 err_put_pm:
 	pm_runtime_put_sync_suspend(ctrl->dev);
 	pm_runtime_force_suspend(ctrl->dev);
+err_dis_pm:
+	pm_runtime_disable(&pdev->dev);
 	return err;
 }
 


