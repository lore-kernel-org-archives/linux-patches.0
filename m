Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7ADE32276C;
	Tue,  2 Sep 2025 13:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819823; cv=none; b=BtYPSAdexYuaAOfi0faubFjlfGPBA97oG6xRw0jw1KkhenEnpTqQQsWX449mwM62juSkvHSP4T9vh4F5F7PbFVnADT3oeb190ZKvWfKzOeX3tQ14Rm1h1WyiCuTTwBUCoa9BtycP5UPpmTk1ZY3MN0Ao9RcNiENYAc4rkiqpB64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819823; c=relaxed/simple;
	bh=H0ENwSOyo+8y7TDRITS+o75zpFSxha5i8fhAezaIVFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzHiyjVdZhB2XFViNWX7FraIBRB24nsMhCfSvvxrgWoky8ZJm0PujVjjnRN0Y0ahzLWjiNH6+eW6M6j9zolnoPSXTERBm9UocPFvGQdrZYORwGWmjdg3SXFmeGHsnbMtWZc1d8xBy4xaHHofoHGYfSo28/Keu2T1zsx2t3Ho3OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=At5DQXk8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="At5DQXk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13976C4CEF7;
	Tue,  2 Sep 2025 13:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819821;
	bh=H0ENwSOyo+8y7TDRITS+o75zpFSxha5i8fhAezaIVFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=At5DQXk8gxBX2QDUmPS+q00x/QtDy3LX/0/eXyD4L/1bqbNoh1bPnrcS5RVi/CZ2b
	 wqpOzeV51XjbWPRwLKc03Qo2X4dfZx20tnIJl0xQdWPyYS5t8cWWybRv7eq7p3uuRR
	 gnhb5OSSw9NtvUH9oEnVHGRa2byvOXsNTHFjYP4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.16 138/142] firmware: qcom: scm: request the waitqueue irq *after* initializing SCM
Date: Tue,  2 Sep 2025 15:20:40 +0200
Message-ID: <20250902131953.566568302@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 7ab36b51c6bee56e1a1939063dd10d602fe49d13 upstream.

There's a subtle race in the SCM driver: we assign the __scm pointer
before requesting the waitqueue interrupt. Assigning __scm marks the SCM
API as ready to accept calls. It's possible that a user makes a call
right after we set __scm and the firmware raises an interrupt before the
driver's ready to service it. Move the __scm assignment after we request
the interrupt.

This has the added benefit of allowing us to drop the goto label.

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20250630-qcom-scm-race-v2-4-fa3851c98611@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qcom/qcom_scm.c |   36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -2276,29 +2276,27 @@ static int qcom_scm_probe(struct platfor
 		return dev_err_probe(scm->dev, PTR_ERR(scm->mempool),
 				     "Failed to create the SCM memory pool\n");
 
+	irq = platform_get_irq_optional(pdev, 0);
+	if (irq < 0) {
+		if (irq != -ENXIO)
+			return irq;
+	} else {
+		ret = devm_request_threaded_irq(scm->dev, irq, NULL, qcom_scm_irq_handler,
+						IRQF_ONESHOT, "qcom-scm", scm);
+		if (ret < 0)
+			return dev_err_probe(scm->dev, ret,
+					     "Failed to request qcom-scm irq\n");
+	}
+
 	/*
 	 * Paired with smp_load_acquire() in qcom_scm_is_available().
 	 *
 	 * This marks the SCM API as ready to accept user calls and can only
-	 * be called after the TrustZone memory pool is initialized.
+	 * be called after the TrustZone memory pool is initialized and the
+	 * waitqueue interrupt requested.
 	 */
 	smp_store_release(&__scm, scm);
 
-	irq = platform_get_irq_optional(pdev, 0);
-	if (irq < 0) {
-		if (irq != -ENXIO) {
-			ret = irq;
-			goto err;
-		}
-	} else {
-		ret = devm_request_threaded_irq(__scm->dev, irq, NULL, qcom_scm_irq_handler,
-						IRQF_ONESHOT, "qcom-scm", __scm);
-		if (ret < 0) {
-			dev_err_probe(scm->dev, ret, "Failed to request qcom-scm irq\n");
-			goto err;
-		}
-	}
-
 	__get_convention();
 
 	/*
@@ -2328,12 +2326,6 @@ static int qcom_scm_probe(struct platfor
 	WARN(ret < 0, "failed to initialize qseecom: %d\n", ret);
 
 	return 0;
-
-err:
-	/* Paired with smp_load_acquire() in qcom_scm_is_available(). */
-	smp_store_release(&__scm, NULL);
-
-	return ret;
 }
 
 static void qcom_scm_shutdown(struct platform_device *pdev)


