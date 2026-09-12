Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E2F306B3B;
	Sat, 12 Sep 2026 13:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221174; cv=none; b=C3arVwWjqIbFdZdqmfEFN/WaWyUXWQdVzHHT+WewKcgHPupXry0AAtpX9jquKI8q2Qvpjn6YdOJ/qo7kxkQFsCdY0hCmV/eZsq7oXYN/kpu+ZnKD9ITiVtBCs4TmCWkxa1wStudoWx7upsIJf5OpLbeEVDGEz1Z3rwZZED1x9N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221174; c=relaxed/simple;
	bh=ZEPhMPRVUx2/rG0tu1JO0FWnvM32jXf+vqq/Gck/PhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SseqJVw1aL/2GjdFGp8bN+abVLXrbaoigLOYdwbelhdQSSxNgmlRfSLM1GjQEHgJAhyg1kzr0IP+ZMTd9mY2gSu0PU55Jg2FC86ID9OF/nzeOkN8quQ5h57BP+bqZWMXgMv0v+QjYtDrjRO3ECXkRN5NYWvk0KCxkqRdXTCzvaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onU32ho6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onU32ho6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9E41F000FF;
	Sat, 12 Sep 2026 13:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221172;
	bh=8K/Bk/EJ2X2n5I43x8l4tycD/4GNdTE+nIo0ChXP6FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onU32ho6JPYAtGCtCvMC6CKgoiehMgdPxC78DgMB9it+sKQFGrHjPlM7b2sAR3UPs
	 KQ9pyUd1eaIEoNm82lAVXaXJvfh1I8f26GcOdPVLinh7ryEEBTNT7tv6d6gj0jMOSO
	 Ee7s8lCNxbDG3dqs1yNyk+JQI9qSgMpvXwXSWadk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 0328/1424] usb: typec: qcom-pmic: cancel reset_work on stop
Date: Sat, 12 Sep 2026 08:46:00 +0200
Message-ID: <20260912065614.631198759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -464,6 +464,8 @@ void qcom_pmic_typec_pdphy_stop(struct p
 	for (i = 0; i < pmic_typec_pdphy->nr_irqs; i++)
 		disable_irq(pmic_typec_pdphy->irq_data[i].irq);
 
+	cancel_work_sync(&pmic_typec_pdphy->reset_work);
+
 	qcom_pmic_typec_pdphy_reset_on(pmic_typec_pdphy);
 
 	regulator_disable(pmic_typec_pdphy->vdd_pdphy);


