Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D692440626;
	Wed,  9 Sep 2026 13:50:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961828; cv=none; b=jDSjaJL8+910EZnzZ7J/5ztuGqYqlXF41bLmpFqFC+zKLWQ5xm7DcdwbGLz7vxSO4AgXYWiqD/NmI/usDxGrZcpbaosFI4srsKt8VqfM43Sy5q8LWbiE/E6sePy9uHqrNtaLNHxjYuQ3DvyZ3jdMA9MG7PHQRI/Yc2z4BdBhaq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961828; c=relaxed/simple;
	bh=eIyvwW6BDK/xAC5QchiSIPIKhSbhsx2c9bOXUo4bbAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T6COC4ncBQVw9Kt8iMXvKPSL7uxBNE+SvwlAtOYskyFbdwx5iwMJrX1LlBsU3Y4lJ3d7ZcYXn+i4BwVG0iw+CxeImSJY5SLTWX9wvw/uEY5zcspdouS0xm9+qS4yxcbDFOvl6bX+MXwdpyKNQ+dS76//u3ZX7atZRa7I2Diou6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H9dSOIUh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H9dSOIUh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C531F00A3A;
	Wed,  9 Sep 2026 13:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961826;
	bh=51tsDCxsfA59wOD3CaYeWWwAGACb6zbNFZSnAHyiaX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H9dSOIUhaUMJwXS574JjLDHNrmghlqAMo7I/KDGT38UMq2QJOz/sXw58k8ZdnHMEQ
	 +uT7q3bXtBldTce6zP2Y5bwYqGZQL4UgAJlnrI9ipXZZwOO1wwN8p4Z5u5xxzupPCx
	 BQQawq8GeGV1meDvx3zuaB+cLwB5cSr+Meu0V9dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 7.2 038/556] usb: typec: qcom-pmic-typec: disable cc_debounce_dwork on stop
Date: Wed,  9 Sep 2026 15:35:18 +0200
Message-ID: <20260909134231.833842960@linuxfoundation.org>
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

commit 263f7d61a4201cde16849b2d016251806e7418be upstream.

cc_debounce_dwork is queued from the set_cc() and start_toggling()
callbacks, which run from TCPM's kthread worker.  port_stop() returns
before tcpm_unregister_port() destroys that worker.  Flushing the worker
during unregister may therefore run a callback which queues the delayed
work after port_stop() has returned.

The delayed work can then run after devres has freed pmic_typec_port.

Use disable_delayed_work_sync() in port_stop() to cancel a pending
instance and prevent the TCPM callbacks from queueing another one.

This issue was found by an in-house static analysis tool.

Fixes: a4422ff22142 ("usb: typec: qcom: Add Qualcomm PMIC Type-C driver")
Cc: stable <stable@kernel.org>  # v6.10+
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260820135307.153773-2-fanwu01@zju.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c
+++ b/drivers/usb/typec/tcpm/qcom/qcom_pmic_typec_port.c
@@ -693,6 +693,8 @@ static void qcom_pmic_typec_port_stop(st
 
 	for (i = 0; i < pmic_typec_port->nr_irqs; i++)
 		disable_irq(pmic_typec_port->irq_data[i].irq);
+
+	disable_delayed_work_sync(&pmic_typec_port->cc_debounce_dwork);
 }
 
 int qcom_pmic_typec_port_probe(struct platform_device *pdev,


