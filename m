Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C022D0C75;
	Sat, 12 Sep 2026 11:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212967; cv=none; b=Vhp4vYa37Wy0iOaK4PovJGy9dhJGE9ITuIevA/Lu5Tpd61OdBq33eElwYsKmLQStPZTTx41IccWAH/kp0JI3FQkZh0V02G05dvHecp7CmaY8nRwOf4jxpsM2kpARbEFauNNyaC9MDv262JJLAUYEva1beKc/me1KwLVGYnmhqsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212967; c=relaxed/simple;
	bh=fh2gx18fhNdnIm3jLcnKi6fS/ryGJU2lpjl/xM11Heo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdWV9E9cn7GhjF9OJjgGlz4Tkz94MFdue2+PLkGcwAs/lncdSTmxQtdp+MYd7E/3NphVmznacLHv/eBzA/LGCnWnW8qeYnmFZglQGanjiPjJAVC8mFsVzhYqh93McORfHD9sZxo7DYw3Xbpp2jykKApTVDz4kJpkgkogeItuNSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EgQlYKxK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EgQlYKxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 644D41F000FF;
	Sat, 12 Sep 2026 11:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212965;
	bh=JiZN784eHvbm6ymkoziEV9cCJDSc3db3UCzoubbFIZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EgQlYKxKOAPPSN25yrp73sayQLmFrtmhfi7Ygs+cja5w9aRvjASW+I/CPH5b8XQa3
	 lptE+OpZ2uzGklJPiRh2XXWDIEj5Y1/0hAPNnw45EgEBoVMTL7uTbp+TlM3pIYi3o0
	 zJnB53OpzBq0DXbbTZd1gOeMzC7dEVfclyfv24w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 0025/1376] usb: typec: qcom-pmic: cancel reset_work on stop
Date: Sat, 12 Sep 2026 08:40:51 +0200
Message-ID: <20260912065608.109943663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

commit 7b0df6efd143f8085bdb68778a013a46f1349913 upstream.

pdphy_stop() disables IRQs but leaves reset_work pending.  If the IRQ
handler schedules it just before disable_irq(), the work runs after
remove() frees the struct via devm.

Call cancel_work_sync() after disabling IRQs to close the window.

This issue was found by an in-house static analysis tool.

Fixes: a4422ff22142 ("usb: typec: qcom: Add Qualcomm PMIC Type-C driver")
Cc: stable <stable@kernel.org>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260819161448.76597-1-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c
+++ b/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_pdphy.c
@@ -544,6 +544,8 @@ static void qcom_pmic_typec_pdphy_stop(s
 	for (i = 0; i < pmic_typec_pdphy->nr_irqs; i++)
 		disable_irq(pmic_typec_pdphy->irq_data[i].irq);
 
+	cancel_work_sync(&pmic_typec_pdphy->reset_work);
+
 	qcom_pmic_typec_pdphy_reset_on(pmic_typec_pdphy);
 
 	regulator_disable(pmic_typec_pdphy->vdd_pdphy);


