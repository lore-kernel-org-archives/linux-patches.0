Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A75332610;
	Sat, 12 Sep 2026 11:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212962; cv=none; b=R2U/sHoU7gAd5Z1KoXHhlQ6AQTEjfCKgzffFQClGuzgnEl+edBI6CQUOh6L2mSViY6OUfabjyQhBdy+59VgvYEtj6z4CEgO31mjkGOyvVEp5fDfDce0yaCYBafwxnsBM6MZGffxa7I2FKxYIEAB3vdXmW+IKum9vJ+BCBVL/y/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212962; c=relaxed/simple;
	bh=69Rl7ANBhe/Ae7LF7DTbdYhWR31lFf3hiIyVWmOPh2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sPvrww5y+eK4ZeyhMeztGV6dJxFIxo8ug7XV109I5aB85ed+RySFYnS5mgKhfx0z4zkMefa9JJ1cNMkJzsVBi53rz/LNOYJwEZiGa8lSKhn7652++T51h6cxcuRgG29eyfhSqhXBSPrnFjnK8dhdfqakA/UojmAs6s99muO7V3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aKEfaBY/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aKEfaBY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78CE21F000FF;
	Sat, 12 Sep 2026 11:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212960;
	bh=MiNSzwm2+TPVeTzWI/pl4by/xaRcAPSfz+0D6SSNn44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aKEfaBY/wmN+CScHumJQX590LkSKMI10vkPAXbbBOQ/Lhay4x7Md1QgCObOZRCtYP
	 LSPRp9mvFgkU44rdzFGfQVrlwQWhebl5GVGzVMeFr5psJjC6jvhi4UWW67u/MqZK34
	 L+v00Cst2wudjG5Wh/F2MiZgh6gf/O78GcUbfYxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 0024/1376] usb: typec: qcom-pmic-typec: drain cc_debounce_dwork if port_start() fails
Date: Sat, 12 Sep 2026 08:40:50 +0200
Message-ID: <20260912065608.087869500@linuxfoundation.org>
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
 


