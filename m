Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC31733D4F0;
	Thu,  2 Jul 2026 16:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010806; cv=none; b=lH+QtIv6jrzYP7+a8X/bry9krIedr2P/NoxSjktomussatEauBDB7n6Wyb/xJVv0OD0LSiImG7tJrhBy0NWZGDVMdjWtA1M75mi/l9Q2g4sTlZXvymJcpKT/+tb9U3l4ds52GG6GtQg/ZwKxRmiWpQmWL+V45I2R3JXyMhNA4Es=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010806; c=relaxed/simple;
	bh=nzBUlNNmpkyr5yQmHE1hRor7P47pQIDvD3b/MUbvy6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU0GSQESCJK+zNiW3c30H2v+zaQ9DykM1I2ZYbl9EWLLDOGJgCgLZHXQ+rJKlQey+K4PwxLD0fqMWU5ZJxV7ZhpNgrEFdSk2ntFGqoDYPMctZ232VqDM9ziaBILzBw5Q9Jzx4V95tCF/Z/YRBRk165fJpV7NVKHcv8aHGCocz6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y5hAphkj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y5hAphkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB891F000E9;
	Thu,  2 Jul 2026 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010805;
	bh=FrF3xZXmDpo4kMc58r5YGePgpr0WbtVA/FUO28plo08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y5hAphkj5qrTI6ugdUn7tP+ZaEnq2Zs2S4MTPKYuLtIlTAQzEyK29A/xvqpXRhXwh
	 Iuhm4IKYcF/ZY6N50aFI/oaHPJ9T2RkrbPBoYFzJqKQ81fSotd+I3uje5Sud9muA9p
	 9CHzHM5/zvWeGhGVBAq/yGXtLYlmyF3GZSUHkMBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/175] slimbus: qcom-ngd-ctrl: Balance pm_runtime enablement for NGD
Date: Thu,  2 Jul 2026 18:19:03 +0200
Message-ID: <20260702155116.683925916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 6a003446b725c44b9e3ffa111b0effbaa2d43085 ]

The pm_runtime_enable() and pm_runtime_use_autosuspend() calls are
supposed to be balanced on exit, add these calls.

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204421.116824-8-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1585,6 +1585,8 @@ static int qcom_slim_ngd_probe(struct pl
 	ret = qcom_slim_ngd_qmi_svc_event_init(ctrl);
 	if (ret) {
 		dev_err(&pdev->dev, "QMI service registration failed:%d", ret);
+		pm_runtime_dont_use_autosuspend(dev);
+		pm_runtime_disable(dev);
 		return ret;
 	}
 
@@ -1694,6 +1696,7 @@ static int qcom_slim_ngd_remove(struct p
 {
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	pdr_handle_release(ctrl->pdr);
 	qcom_unregister_ssr_notifier(ctrl->notifier, &ctrl->nb);


