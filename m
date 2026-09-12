Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262DB38B7D2;
	Sat, 12 Sep 2026 11:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212958; cv=none; b=pzXHasxntgE/1ktV/jTNeiYaFvxUmTc70LO5yhe2YuDVgEPJ8PNhc/n5gE/P1ksHLcTCQcNrgdmhI8Ifpng0oSiIKCTSlY+yZ+yUwiTIRExjeHdUJFCFF8tvYiJOuhP1JQmR68VvHJxYtp2l7YwGe3y4t0Mg3hbOwHYq64oRbOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212958; c=relaxed/simple;
	bh=6Ipf3uV+joHDbJlzcyV+NiU+t1mtv3VnNhdG9868uPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SR1NRhfMqZHbreiVDb9lu3MavUbFGpuADLji3vips0pihiPsvuCNeLQK1xrocmTUnEwNhGoOF+/pBRQ9VLXZw9D5yG91f9I4wMLdzIr1AAJgCXtfJFYvvCP487xLIzxOBBh2bRdmG9INQ5WP2w8+dHQEmszrZug1tSdXB2A3g2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hs8qiO7U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hs8qiO7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4521F000FF;
	Sat, 12 Sep 2026 11:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212955;
	bh=Wplu9mGqW8x5FVIQX63zVlttzZqDdY3goalyzmDzR9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hs8qiO7UlBHknS6Z92P/U3SYuUrEIw3S62+Xh+uzDFjwyQehqIGDpnn/FlnCwKVIV
	 b73Jv15LUeZPmxUlmgvd0RKmhMlN4vJbaiUMQYb2rQ3sns20JtvnUF7J1gYbDFqf3X
	 jhZ+9QA8SCT1RypFHcuV8ktYWIrcrCVTsJy92VuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 0023/1376] usb: typec: qcom-pmic-typec: disable cc_debounce_dwork on stop
Date: Sat, 12 Sep 2026 08:40:49 +0200
Message-ID: <20260912065608.065222136@linuxfoundation.org>
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


