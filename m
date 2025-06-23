Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0D9219E0;
	Mon, 23 Jun 2025 21:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713751; cv=none; b=Ml9nhBXrablPlnKGSeo1fbrTvDxoawBKbLdVFPMt+qdOkuSXW2yHEv2UY5onxufyMzEBvexbb1g3MUpW970dBD+LBgGkKi4ICwIzm4/aKsqjQypzq02ho8eXgQjh6l706E9+yzxxz5c0RPc0uk9cXZLJ4gdvrC1I3nCmL6MPr90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713751; c=relaxed/simple;
	bh=DBN2uk9PZuQYR26Dhm4YDhvyINgOl4VGPAhi1hKPAJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWFr3O3ILV1ZS+naea7RqBJ7P/wWPsm5UgJOdjWJ2+Nv9B8fs4Gi5BSC1BtKZY2n9xQyyU2veS9osWF0ZTRGr8OrK4rQsy/MwiFx51VyHQENhdiJKCRrJ5dxXDlsU+yae5nrfErRcFDf5xnB4OAQkUBRkmc4IRk6u7s1u4i3ttM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yk2+EfeJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yk2+EfeJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FD37C4CEEA;
	Mon, 23 Jun 2025 21:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713751;
	bh=DBN2uk9PZuQYR26Dhm4YDhvyINgOl4VGPAhi1hKPAJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yk2+EfeJw2mn32kF4l+Qu3hP96JLur/AcCHZckdqtdAJa+s0BGfdvcr7hAN6pls3O
	 LMS8cohiykKE0C1GasPEWz9iXOCalEOMMe2bAMZ817j4m0kchfQPQ6Q3rAx9ozGrbP
	 6P9ertpcJQ7Dp/Fhesm0B+3QS1+QiplvO0X801OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 061/414] media: venus: Fix probe error handling
Date: Mon, 23 Jun 2025 15:03:18 +0200
Message-ID: <20250623130643.598984403@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

commit 523cea3a19f0b3b020a4745344c136a636e6ffd7 upstream.

Video device registering has been moved earlier in the probe function,
but the new order has not been propagated to error handling. This means
we can end with unreleased resources on error (e.g dangling video device
on missing firmware probe aborting).

Fixes: 08b1cf474b7f7 ("media: venus: core, venc, vdec: Fix probe dependency error")
Cc: stable@vger.kernel.org
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Reviewed-by: Dikshita Agarwal <quic_dikshita@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/venus/core.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -354,7 +354,7 @@ static int venus_probe(struct platform_d
 
 	ret = v4l2_device_register(dev, &core->v4l2_dev);
 	if (ret)
-		goto err_core_deinit;
+		goto err_hfi_destroy;
 
 	platform_set_drvdata(pdev, core);
 
@@ -386,24 +386,24 @@ static int venus_probe(struct platform_d
 
 	ret = venus_enumerate_codecs(core, VIDC_SESSION_TYPE_DEC);
 	if (ret)
-		goto err_venus_shutdown;
+		goto err_core_deinit;
 
 	ret = venus_enumerate_codecs(core, VIDC_SESSION_TYPE_ENC);
 	if (ret)
-		goto err_venus_shutdown;
+		goto err_core_deinit;
 
 	ret = pm_runtime_put_sync(dev);
 	if (ret) {
 		pm_runtime_get_noresume(dev);
-		goto err_dev_unregister;
+		goto err_core_deinit;
 	}
 
 	venus_dbgfs_init(core);
 
 	return 0;
 
-err_dev_unregister:
-	v4l2_device_unregister(&core->v4l2_dev);
+err_core_deinit:
+	hfi_core_deinit(core, false);
 err_venus_shutdown:
 	venus_shutdown(core);
 err_firmware_deinit:
@@ -414,9 +414,9 @@ err_runtime_disable:
 	pm_runtime_put_noidle(dev);
 	pm_runtime_disable(dev);
 	pm_runtime_set_suspended(dev);
+	v4l2_device_unregister(&core->v4l2_dev);
+err_hfi_destroy:
 	hfi_destroy(core);
-err_core_deinit:
-	hfi_core_deinit(core, false);
 err_core_put:
 	if (core->pm_ops->core_put)
 		core->pm_ops->core_put(core);


