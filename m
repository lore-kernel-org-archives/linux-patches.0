Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27101F7540;
	Tue,  3 Dec 2024 15:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239849; cv=none; b=oIDOjYjadTuZS2ffEfH9xV+Ef5HTH4tscF3QKyKnOuIlrg/f7UfAKxQHwrFpVD9Gt/H6SdvYcz78NifreFEEIF66Vtu/cXqhE74pane1cX1d4JSVaSTWbgh+vczcX7jD7HxXz4UmsFafhsa3b/GWXwbSziq98Giee/7eEMqf+ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239849; c=relaxed/simple;
	bh=NLWlcCW1BcmkA9YjYd3PzgpGqmfHdykZZ4ViJLNVDHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMKXGwSXaaTq866MUEBOGXSBXiOUlqtNkpHSUmWD2BNj6cTU12X1D+tSYlc7lKpO+h9B/23rS/4HjkT2jGAv9mdeRG1WaYSI66m0biiWkBnAQ8F/wT5gDcPM31RJlEuKLcM7c9VVsN7QRpWHHH5tbM7dJ9B5TkiwCOZwu3JchvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vQxIZcwv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vQxIZcwv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC19C4CECF;
	Tue,  3 Dec 2024 15:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239849;
	bh=NLWlcCW1BcmkA9YjYd3PzgpGqmfHdykZZ4ViJLNVDHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vQxIZcwvsG1LV9xzOkCePQz6M4kF8jv7JPD08xBtAjuN8od8QLiIcbLtOyCjy2aNq
	 AmyQ574F+7cVVNDvUheDr0N/Unx7nQxQP8YEIV1nmEsEo8Urxy32scpJRKQvyvd6Tg
	 pVBUQIO7q6FyYq7yfAweI6FPbTImn3kCaCNghq8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Umang Jain <umang.jain@ideasonboard.com>
Subject: [PATCH 6.11 756/817] staging: vchiq_arm: Fix missing refcount decrement in error path for fw_node
Date: Tue,  3 Dec 2024 15:45:28 +0100
Message-ID: <20241203144025.506278859@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 


