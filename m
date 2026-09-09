Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4887456E075;
	Wed,  9 Sep 2026 14:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963274; cv=none; b=tkr21imOX7XCoO7GA/5pR1Hh5QarBCcncOhClnlnFQ9ycNajdwvDmJGOVUoTl1cx6SiP4vswzS9OeNvaxLirNet0wBy1g5e2ZXEULbkTQyvjbbjkzWS/DFs9ynUx32nRxgLT/2mr5z1FggRyQF1G7ygRzCc7MIJ0G0Bo0qRoerM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963274; c=relaxed/simple;
	bh=NpyU+kVEmgq1guDhqlifp2Mid+7ia6wt84yALfMULG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PZicm1k2ppbK6Ud5WjFuCsmyjim2c3N8En0NmfyB8/cQToY5o0etkm0vvx9o6CvIzuBeoJK4UUjKmwaCJzidfpEgToEUHOcQmaIjluM1WRfN9xHMvY7jQrrvxJjbBNj4RuD+28pLvtFPzrJUW1GFf7XSbthMSrmMv3v95kQ0pkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdFi8AYt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdFi8AYt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CEA91F00A3D;
	Wed,  9 Sep 2026 14:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963273;
	bh=1WtQJdDGNEfGTS76I2ws/Is9kFlO4LEVxgGzxu/oFAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdFi8AYtoxJrwMjGrpwsQC0tFIQ/WDho5B78iX2pf3NtWC6hkG31lmqkNFVeS3Ijz
	 p6ZojV7XVwSuN5DuYyNTI+mcGhZfoVZp7v5N/I7ksG+fqzpiHdU6DLXMb9CLP2gAQZ
	 Ynwq7Rua4H27VNPafRIGD9fpe868WOMQy0hmxCH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 022/583] usb: typec: qcom-pmic-typec: drain cc_debounce_dwork if port_start() fails
Date: Wed,  9 Sep 2026 15:35:07 +0200
Message-ID: <20260909134238.590289845@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
 


