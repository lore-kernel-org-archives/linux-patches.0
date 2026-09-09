Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F04D576EC0;
	Wed,  9 Sep 2026 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963272; cv=none; b=qGcFvK9Yn1TUTaiPlZPIEw8U29RaFzL49Q6SoW6ApUc9L4BIVmqMKgX17apavbhqk8t1p16ZyQuJOAfP+H1Cf8sSAMHf5SjOQq34CsmdfRry3rkSKk2VI3rs0p/YJaCx02sTWvou21WbrsMfWeW1r57FrDQXmd/4bVgWyBOxvsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963272; c=relaxed/simple;
	bh=1FfYxyaXfGTMN3p04H6KAeOmaeJYEG/sd6TfQTtqREs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZLAvVQqx+mKy8xhRqwrvHja9Uf97PhOUEg40e6NQx6wIMcV4ilJxwB8hc4k9mLZLXT4nnsiG8hAklCLjzsm8b/s3+Ah+eNJWn5apEbiTkhYDq/Td8kKKzU41TlttuSYnZhN5D8d9AkzR20HEhNL7kGH16pf+nRBZ5h5IBAxwbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUE+fldN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUE+fldN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7C711F00A3A;
	Wed,  9 Sep 2026 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963270;
	bh=+6kAZo5dVshA+Gbq5axeVIQcFOV8VXdTFhABE0fzVAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JUE+fldNBfohW+w4lr+Rz2pOByINe73ITdcKWgtyjyVxt6FXeNQvGO1mgGT9rGMll
	 Wp/zGCyhpeRWNOcpj4gPuYxo2Eb2qvee3DPwKeVA+hoskG8qhD0tXYri0ozyft8vTB
	 kkNuYePIpFFr4y9jX611yduoIRS7InZuGj1JkFwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 021/583] usb: typec: qcom-pmic-typec: disable cc_debounce_dwork on stop
Date: Wed,  9 Sep 2026 15:35:06 +0200
Message-ID: <20260909134238.555878275@linuxfoundation.org>
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


