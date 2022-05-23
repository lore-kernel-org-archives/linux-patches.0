Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4444E3D79
	for <patches@lists.linux.dev>; Mon, 23 May 2022 22:47:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3A3C385A9;
	Mon, 23 May 2022 22:47:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1653346033;
	bh=dM9xjGcIELwAk7SXfwRMkmck1pzZU48ZxvNuSCmz8to=;
	h=From:To:Cc:Subject:Date:From;
	b=NNT3O4KskyBq7fc/YZH4aWnVJknHVxdhCxk8QLMu7cr109aCMGdNOPLSN6TTna3FY
	 0NHWg5sWrQDIyEMBQokGHB0Y6FVWnzzt14g5Ks9n7SrZVBHbBmV74DuRtAcrrZBFQa
	 WpeSuQ28M29oJlrJh6hu57EfqYCtkCLPnaUm/o0a6/aaeQ7ZE/GAWXtW2Iv2/J5jyF
	 NvSRBm7MLKFohnofWfFWk/5+N9b1kJ+4oUDlDpHll2kX2Hyq2zBF8x4b9sb5No2qmO
	 i0wIfuK8DroytBp3gTZzei6xPv+FSI6n/MLU1TXYKWk5An8KXzQOJ0IRjG1qnBT3G4
	 5r0zZq146hOEw==
From: Nathan Chancellor <nathan@kernel.org>
To: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jassi Brar <jassisinghbrar@gmail.com>
Cc: Sibi Sankar <quic_sibis@quicinc.com>,
	Prasad Sodagudi <quic_psodagud@quicinc.com>,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH] mailbox: qcom-ipcc: Fix -Wunused-function with CONFIG_PM_SLEEP=n
Date: Mon, 23 May 2022 15:47:02 -0700
Message-Id: <20220523224702.2002652-1-nathan@kernel.org>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When CONFIG_PM_SLEEP is not set, there is a warning that
qcom_ipcc_pm_resume() is unused:

  drivers/mailbox/qcom-ipcc.c:258:12: error: 'qcom_ipcc_pm_resume' defined but not used [-Werror=unused-function]
    258 | static int qcom_ipcc_pm_resume(struct device *dev)
        |            ^~~~~~~~~~~~~~~~~~~
  cc1: all warnings being treated as errors

Commit 1a3c7bb08826 ("PM: core: Add new *_PM_OPS macros, deprecate old
ones") reworked the PM_OPS macros to avoid this problem. Use
NOIRQ_SYSTEM_SLEEP_PM_OPS directly so that qcom_ipcc_pm_resume() always
appears to be used to the compiler, even though it will be dead code
eliminated in the !CONFIG_PM_SLEEP case.

Fixes: c25f77899753 ("mailbox: qcom-ipcc: Log the pending interrupt during resume")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/mailbox/qcom-ipcc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/qcom-ipcc.c b/drivers/mailbox/qcom-ipcc.c
index 2583b20cdeb7..31d58b7d55fe 100644
--- a/drivers/mailbox/qcom-ipcc.c
+++ b/drivers/mailbox/qcom-ipcc.c
@@ -344,7 +344,7 @@ static const struct of_device_id qcom_ipcc_of_match[] = {
 MODULE_DEVICE_TABLE(of, qcom_ipcc_of_match);
 
 static const struct dev_pm_ops qcom_ipcc_dev_pm_ops = {
-	SET_NOIRQ_SYSTEM_SLEEP_PM_OPS(NULL, qcom_ipcc_pm_resume)
+	NOIRQ_SYSTEM_SLEEP_PM_OPS(NULL, qcom_ipcc_pm_resume)
 };
 
 static struct platform_driver qcom_ipcc_driver = {

base-commit: bca1a1004615efe141fd78f360ecc48c60bc4ad5
-- 
2.36.1

