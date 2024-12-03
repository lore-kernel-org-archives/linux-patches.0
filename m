Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EF21EE00B;
	Tue,  3 Dec 2024 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242634; cv=none; b=YwB+ZWJ1kMGm1t095ktoPqOcVwzLIDzB181zQ5GwtvImlFC1PGDCMPB5Mon5yTVNx/03aYw5hjaU6Xcs8Xz7V2T9c5vmZUiSnusCp4O9VYnLn7VGbw769k70P5ihnFC+m4aCBUnmxbGTUVQ3vX9MTH7RbTlAPjIUDsyAjTP33Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242634; c=relaxed/simple;
	bh=jYFdMuF1mn/6BHDTSfBZtUTbMd6HusHtcLyeA2p5iws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfeZGU4NkXw6bJb/qlU9QZfmGk9wZ+6B6uZSjC5/ZSUlRcjmOoNSVAhwigA43x0R4J4I5Dc/+MlTLf1i6+5lGvv2VPaoqvWidRTJqhZg/gec37dG6XvWSqgpicjYupK8+pct6G/p2MLu7L8dZCgHO/G6HfNomEB3oQygXAsT4UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6p5hqNZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6p5hqNZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 370CEC4CECF;
	Tue,  3 Dec 2024 16:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242634;
	bh=jYFdMuF1mn/6BHDTSfBZtUTbMd6HusHtcLyeA2p5iws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6p5hqNZr7JR/6fmdv+Dq39c7bdDetp504gFI+0hZzDhN5JwFyIAjQv67/cOgOmvU
	 +gcyFw5tHRBPIoPLogyUulNVDI2lt+0o6nR5/raN3ahqgZNhrUsn8/kGh5sS9KrvYL
	 8jCovKyx6UQnHLwuFK1KtVDcjq1AsU9fM6SfMraY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Umang Jain <umang.jain@ideasonboard.com>
Subject: [PATCH 6.12 763/826] staging: vchiq_arm: Fix missing refcount decrement in error path for fw_node
Date: Tue,  3 Dec 2024 15:48:10 +0100
Message-ID: <20241203144813.528779302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 22a3703af127e897dc7df89372b85bb9dc331c5f upstream.

An error path was introduced without including the required call to
of_node_put() to decrement the node's refcount and avoid leaking memory.
If the call to kzalloc() for 'mgmt' fails, the probe returns without
decrementing the refcount.

Use the automatic cleanup facility to fix the bug and protect the code
against new error paths where the call to of_node_put() might be missing
again.

Cc: stable@vger.kernel.org
Fixes: 1c9e16b73166 ("staging: vc04_services: vchiq_arm: Split driver static and runtime data")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Umang Jain <umang.jain@ideasonboard.com>
Link: https://lore.kernel.org/r/20241014-vchiq_arm-of_node_put-v2-2-cafe0a4c2666@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1715,7 +1715,6 @@ MODULE_DEVICE_TABLE(of, vchiq_of_match);
 
 static int vchiq_probe(struct platform_device *pdev)
 {
-	struct device_node *fw_node;
 	const struct vchiq_platform_info *info;
 	struct vchiq_drv_mgmt *mgmt;
 	int ret;
@@ -1724,8 +1723,8 @@ static int vchiq_probe(struct platform_d
 	if (!info)
 		return -EINVAL;
 
-	fw_node = of_find_compatible_node(NULL, NULL,
-					  "raspberrypi,bcm2835-firmware");
+	struct device_node *fw_node __free(device_node) =
+		of_find_compatible_node(NULL, NULL, "raspberrypi,bcm2835-firmware");
 	if (!fw_node) {
 		dev_err(&pdev->dev, "Missing firmware node\n");
 		return -ENOENT;
@@ -1736,7 +1735,6 @@ static int vchiq_probe(struct platform_d
 		return -ENOMEM;
 
 	mgmt->fw = devm_rpi_firmware_get(&pdev->dev, fw_node);
-	of_node_put(fw_node);
 	if (!mgmt->fw)
 		return -EPROBE_DEFER;
 


