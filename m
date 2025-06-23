Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF581E51FA;
	Mon, 23 Jun 2025 21:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713942; cv=none; b=ABqPxjZd8zuM85mDvkwlPTAapckaqh5RiwsdUfvRfc6QmZJZaSvY+34F4IBSAFW6qKwca2WplQnhZn1utiMZOQrE9eAILtKmfpDirWf6xHs95QxvSkxAkQ8l8tlFNKmfmunAl79Skhr+iXiuY2gEHSlaBkgeCLzNoIWpc6bPCIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713942; c=relaxed/simple;
	bh=komZGg09fUwX/2aUW+GmCMfb7cQc1Yv6YifHTQcWlSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJ7+dfHQFshfCS71Oz92p0h8TlFLza1DRsCiRNMwpjYKvOeSDiEFdWKvU7aWBp+5hMVwtH9jh8h0+WC6hUyMBt9OITsYOFTPv4diGhEt9OHwTIlQ38oH8TgvKKVYoZuUjHp8teXoiJ12sk5BXSnUuuOT+TO2mB/IGqF4a6IX7sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVIzeBFB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVIzeBFB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17387C4CEEA;
	Mon, 23 Jun 2025 21:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713942;
	bh=komZGg09fUwX/2aUW+GmCMfb7cQc1Yv6YifHTQcWlSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xVIzeBFBhO6HylLLickJyyUhW6BYWQIZu9K4/tIbI0Ek0d1AjzOU7bxjbjRoq7pis
	 NLOt+A5v42PU9xPPu4VxoUsYUPat0EHHR+mWBb92eHa6VhEJ3qoa6Bp/sQqk7WqwfR
	 8W4o6RF4eRqAJsk+3yQnM4NPx4F1u0u1fks0FY30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Dikshita Agarwal <quic_dikshita@quicinc.com>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.10 175/355] media: venus: Fix probe error handling
Date: Mon, 23 Jun 2025 15:06:16 +0200
Message-ID: <20250623130631.967691956@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -290,7 +290,7 @@ static int venus_probe(struct platform_d
 
 	ret = v4l2_device_register(dev, &core->v4l2_dev);
 	if (ret)
-		goto err_core_deinit;
+		goto err_hfi_destroy;
 
 	platform_set_drvdata(pdev, core);
 
@@ -322,24 +322,24 @@ static int venus_probe(struct platform_d
 
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
@@ -350,9 +350,9 @@ err_runtime_disable:
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


