Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEDAB4DF4DC;
	Wed,  9 Sep 2026 13:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961833; cv=none; b=o4il9bMzKPBv0k5cpI9ZTDm+o18UM6ZMdBH94fGexY9VlQtcqYeEYqngrcpG8oro5MGBvFgBlb3GJRYApjSe74qdsDUXspTjm85C6n4lGeq//BdOoqSIgDZ9PiHi5BmaAO/zBgVkse14ekNRMD1CDLwAnm9KFkROG5WIUgSWWv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961833; c=relaxed/simple;
	bh=OEwVJPSL8/T9Rp17bHnhnQGmCX1JpG+Hjh2k4bAbITc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCsf9oIrE4OLqAlXv8ORM2rLmTIbl99+0YHe4XYMUwII5rEtjSEvN7y5DUBADWuVV2qUjmocNQ1+dd6WgoziJb1s5rA1/4s3AFj71EVX0y7f0dI+tbHIE2BCQykl8ZMMVtRQq6LO/RpWbeglKd3dhnczSuCqJruT5K+gSg3SfPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Po2bg9Wv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Po2bg9Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F8271F00A3A;
	Wed,  9 Sep 2026 13:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961831;
	bh=T2QrfcsBgofvUCm/4NXoseG0NdwSIe6mop2FHZk4+L0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Po2bg9WvLtu5gOwItApZoe6s8sQjWyejHIkKOSXF+RxrvFp7uWkZLLpAhom0LbGQ5
	 03a1O82IWkK7M5JJl7oLABiQ84/kvY6RMtrrzqX71cYuvR0HqBZBEwxFgdG1/1IizH
	 Tw0zkIR0zyac78MuFoeqOKZwKAXeBnYrYrAQAqvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.2 040/556] usb: typec: qcom-pmic: cancel reset_work on stop
Date: Wed,  9 Sep 2026 15:35:20 +0200
Message-ID: <20260909134231.901470486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -543,6 +543,8 @@ static void qcom_pmic_typec_pdphy_stop(s
 	for (i = 0; i < pmic_typec_pdphy->nr_irqs; i++)
 		disable_irq(pmic_typec_pdphy->irq_data[i].irq);
 
+	cancel_work_sync(&pmic_typec_pdphy->reset_work);
+
 	qcom_pmic_typec_pdphy_reset_on(pmic_typec_pdphy);
 
 	regulator_disable(pmic_typec_pdphy->vdd_pdphy);


