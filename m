Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28697449EAB;
	Tue, 16 Jun 2026 15:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624418; cv=none; b=A8KuUz6RlYB4aldNW17hBYXdH2t/WIIidGQ/wXcq5QP/+wNCOv4jed3wAcD+pvpTCmSYL7SyIX8m549pTws1VOi814Uk/pDquwT4Fk7FLLwGQj3qvpaK4ZVNaEbtPl01eF6DwQVuwQH97iX1LPVK8T+jLBZ93pGYrUJmYELqBKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624418; c=relaxed/simple;
	bh=K2UDrgNed6RHqg/75vOR0D/0Q7eY+o7UPgNrk67Toow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ByjP7GLrfs2VJEVxHjtSuEFNIETqCGw00QihHwwjWB3AA4xgf1dHpQQBpFMR0ojComSqikUH7dAhmYm6MKttNoyXtkbDoHq6ruTlK4XmdAEtQsQB9ZqPISqgwjqb8OKkYbPs/RKcDp4IrH2Bie0neRoYNGI0Aj84VMVt/SQebAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mPw+GXA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mPw+GXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8411F000E9;
	Tue, 16 Jun 2026 15:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624417;
	bh=lSXgaPybHoFgHm3xJJ37byb8iPOodzSsq5L3CKIkSm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mPw+GXAyHxPgibCKpFYZQZM9T2rPD60WU3r7D7hEfQm66M57Jg6puZ1FZaQ6gHI3
	 DYWsvl+VmQXTa+g6R/AWm1PBBGJTlFemMZGYKQJgVEzcgJdPF4TcTQ3FOznH72PUWv
	 t912OQ3OtgRjmRmael4M3xU7cy5SetgOvm91cdK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 7.0 331/378] slimbus: qcom-ngd-ctrl: Balance pm_runtime enablement for NGD
Date: Tue, 16 Jun 2026 20:29:22 +0530
Message-ID: <20260616145127.653293070@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1582,8 +1582,11 @@ static int qcom_slim_ngd_probe(struct pl
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
@@ -1696,6 +1699,7 @@ static void qcom_slim_ngd_remove(struct
 {
 	struct qcom_slim_ngd_ctrl *ctrl = platform_get_drvdata(pdev);
 
+	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	qcom_slim_ngd_enable(ctrl, false);
 	qcom_slim_ngd_exit_dma(ctrl);


