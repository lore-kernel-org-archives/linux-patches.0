Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4444444CAF7;
	Tue, 16 Jun 2026 16:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626194; cv=none; b=hvDqZ+hpPSbi7c8yV+1cFCgpjPjFCkpJZ9aQprKCVPdL7Js3nKmAz1AHr3vOklV3RNgwsoiBfS5FSWgiToKmKgEiTCaHdUTWh+REQHns4sWAOX3tQXdLXcXreexTkYx4VQvlFjHIiDvra/vNZvSf44ccoC8yh6kSTj5YK/ydftE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626194; c=relaxed/simple;
	bh=wHOuQsCgu4cv+cGeRhy22wqyjPGYVxgzuWK07YDEyiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FMZkLbNT3cnKUlvmY++cUhfrKrjz+w9ehmhUtzj3Ashx6lM3Ixe6LqbGnxWoNscJzXqJZeGHGYH5aPyXUX5yEmNakMKZB3J9qmp5peknpRTFgC2LB9GVu8warfKgOA8egSzcKfaz06jVXiKh3Gcee7zC6AjBs6byVIIgABplhKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Hs8A5y5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Hs8A5y5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 063F11F000E9;
	Tue, 16 Jun 2026 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626192;
	bh=seJSoM+hmPT9pDFLai358oKffAF7cOFLXYF10Rvkoak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0Hs8A5y5fbtGFYaYTiz0avfBvBlovhQohG8LHpeJ80V4UG35Akysha/7kQ99Qlssc
	 9rJT5hfK0u8klF4FpUA8GF29LHxI5K2vNmfn15zHL45MU53UZX5qtPyrSlcKgYN+A+
	 ZhrPAAoJXiiV5UGIrXentqsCd4f8m9lZxXlldw6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.18 280/325] slimbus: qcom-ngd-ctrl: Balance pm_runtime enablement for NGD
Date: Tue, 16 Jun 2026 20:31:16 +0530
Message-ID: <20260616145112.677413386@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

commit 6a003446b725c44b9e3ffa111b0effbaa2d43085 upstream.

The pm_runtime_enable() and pm_runtime_use_autosuspend() calls are
supposed to be balanced on exit, add these calls.

Fixes: 917809e2280b ("slimbus: ngd: Add qcom SLIMBus NGD driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204421.116824-8-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/qcom-ngd-ctrl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/slimbus/qcom-ngd-ctrl.c
+++ b/drivers/slimbus/qcom-ngd-ctrl.c
@@ -1588,8 +1588,11 @@ static int qcom_slim_ngd_probe(struct pl
 	pm_runtime_enable(dev);
 	pm_runtime_get_noresume(dev);
 	ret = qcom_slim_ngd_qmi_svc_event_init(ctrl);
-	if (ret)
+	if (ret) {
 		dev_err(&pdev->dev, "QMI service registration failed:%d", ret);
+		pm_runtime_dont_use_autosuspend(dev);
+		pm_runtime_disable(dev);
+	}
 
 	return ret;
 }
@@ -1702,6 +1705,7 @@ static void qcom_slim_ngd_remove(struct
 {
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	qcom_slim_ngd_enable(ctrl, false);
 	qcom_slim_ngd_exit_dma(ctrl);


