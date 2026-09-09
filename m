Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D20F440626;
	Wed,  9 Sep 2026 13:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961830; cv=none; b=TAT+Syk3dD/CbITHRSU+CPJVK9yhcU9lhAD2A51A+k1/GS7a2oeRBXu189VDy3lapEw/s2cYCp0v0nB65VxIKe6Lowi1jjdoZVPFnJBeRFabY2hdsxEDga5a3FdTHVf5GBA9kUTBddCRexeXbs11xYx0YlK24XeNYB5dVBFfhDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961830; c=relaxed/simple;
	bh=K07kvxxqfnhyuk2SDfc2tNpbD0HlF4gZhB+rnjys6cA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VV6FTyDIjq1rwFbAW51Yz4DcXcRQ++4aH1wSmpdUE6Uumd/cRpsAeVSqetZRlE8WZfZNGq56jo70mOn9u2YdPWUectojt5/dcNMqPCbC6qZ4W4yfp19Qzk2C3b3e0r48hI3tMDcYyvQ2Xw3izSSxIjSgZHYGJ5fg2V4XUv25LUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rb70jZ1U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rb70jZ1U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 678CB1F00A3A;
	Wed,  9 Sep 2026 13:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961828;
	bh=MTYQKufm613NyNrkqOSia91+Nhams3c+DtAWdvp+4Oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rb70jZ1Un0GE/D+p0Ng1dOxz9EcU+A5oSsvFdeYLeGj8PjzyF8WC99pEBtRyrtAji
	 4/7mTuAivIuKRMMFHE/ZRaSi/DkAnvvLX5e3Zi6zx/nY/ROyRUc6dAW0/qfVxH2UcA
	 Ww/ELO62npzWYpdPjt4LLY5jYm1aNnHe70n8JX/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 7.2 039/556] usb: typec: qcom-pmic-typec: drain cc_debounce_dwork if port_start() fails
Date: Wed,  9 Sep 2026 15:35:19 +0200
Message-ID: <20260909134231.870726492@linuxfoundation.org>
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

commit c9273c83885835dbd1e8835d5665dfb8503d65e0 upstream.

cc_debounce_dwork can be queued before port_start() fails:
tcpm_register_port() runs first, and its state machine may invoke
set_cc() or start_toggling() from the TCPM worker.  The error path then
calls tcpm_unregister_port(), whose worker flush may queue the delayed
work before devres frees pmic_typec_port.

Disable and drain the delayed work directly at port_start()'s error
exit.  Do not use port_stop() for this path: its IRQs use IRQF_NO_AUTOEN
and are enabled only after a successful port_start().

This issue was found by an in-house static analysis tool.

Fixes: a4422ff22142 ("usb: typec: qcom: Add Qualcomm PMIC Type-C driver")
Cc: stable <stable@kernel.org>  # v6.10+
Suggested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260820135307.153773-3-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c
+++ b/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c
@@ -683,6 +683,9 @@ static int qcom_pmic_typec_port_start(st
 		enable_irq(pmic_typec_port->irq_data[i].irq);
 
 done:
+	if (ret)
+		disable_delayed_work_sync(&pmic_typec_port->cc_debounce_dwork);
+
 	return ret;
 }
 


