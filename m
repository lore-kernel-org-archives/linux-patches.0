Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB0392571AB;
	Tue, 25 Mar 2025 12:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906044; cv=none; b=YI7syC2BHnE+hmSgtSb6fqAFw/8ULfoiaEmvPIid8zQdhHkCvnUJEUX+vKJP9iBb9vlubEJT9EB2oFK7thQkXqee94pCHVfCMAXunYEedYpYHVhCJnh3CcRqMW50baP6yz7WqZCILmpmP9MI1Y/Fl6d7TZXrgVLWGtpJKmBjXmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906044; c=relaxed/simple;
	bh=EamRbubFk9gayX12DnkhozRzzbC8RaGru1MmiNAb/xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mj44c96QjVE8tD82JbVp2lwPQZ0OJNRgNYhBmItExPTTGsIJZcGGpqv7T9VNHP0yW0Xg7Obb/TyMGuE5DvoF1M5KY4kJ2T9jDOJcWEs0A1zDMlhAfjZ+Vmss9w21BjGHlOipgp5+8SF2rtYiBXB4H+gKAqVgWZIkXsfEFmT8o00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYSt8DMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYSt8DMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B4AFC4CEE4;
	Tue, 25 Mar 2025 12:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906044;
	bh=EamRbubFk9gayX12DnkhozRzzbC8RaGru1MmiNAb/xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYSt8DMh+mIhBtOTzCeDftI5G6z74iqvxo2MKeDWRxg5fhlByYv/5bdyv9xh/uxkK
	 KgkenQX0QVP4j2P7c4sqq3XNwStyngkFOko6NAfWleGzzsMWb4z29yopjru76ONSeW
	 +WW+USYy8P3k+j/DS8lN/V0Wy8Zfb9PmHl9OpXjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Maximilian Luz <luzmaximilian@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.13 087/119] firmware: qcom: uefisecapp: fix efivars registration race
Date: Tue, 25 Mar 2025 08:22:25 -0400
Message-ID: <20250325122151.282331510@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit da8d493a80993972c427002684d0742560f3be4a upstream.

Since the conversion to using the TZ allocator, the efivars service is
registered before the memory pool has been allocated, something which
can lead to a NULL-pointer dereference in case of a racing EFI variable
access.

Make sure that all resources have been set up before registering the
efivars.

Fixes: 6612103ec35a ("firmware: qcom: qseecom: convert to using the TZ allocator")
Cc: stable@vger.kernel.org	# 6.11
Cc: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Maximilian Luz <luzmaximilian@gmail.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20250120151000.13870-1-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/qcom/qcom_qseecom_uefisecapp.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/firmware/qcom/qcom_qseecom_uefisecapp.c
+++ b/drivers/firmware/qcom/qcom_qseecom_uefisecapp.c
@@ -814,15 +814,6 @@ static int qcom_uefisecapp_probe(struct
 
 	qcuefi->client = container_of(aux_dev, struct qseecom_client, aux_dev);
 
-	auxiliary_set_drvdata(aux_dev, qcuefi);
-	status = qcuefi_set_reference(qcuefi);
-	if (status)
-		return status;
-
-	status = efivars_register(&qcuefi->efivars, &qcom_efivar_ops);
-	if (status)
-		qcuefi_set_reference(NULL);
-
 	memset(&pool_config, 0, sizeof(pool_config));
 	pool_config.initial_size = SZ_4K;
 	pool_config.policy = QCOM_TZMEM_POLICY_MULTIPLIER;
@@ -833,6 +824,15 @@ static int qcom_uefisecapp_probe(struct
 	if (IS_ERR(qcuefi->mempool))
 		return PTR_ERR(qcuefi->mempool);
 
+	auxiliary_set_drvdata(aux_dev, qcuefi);
+	status = qcuefi_set_reference(qcuefi);
+	if (status)
+		return status;
+
+	status = efivars_register(&qcuefi->efivars, &qcom_efivar_ops);
+	if (status)
+		qcuefi_set_reference(NULL);
+
 	return status;
 }
 


