Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA5315D1;
	Sat,  7 Jun 2025 10:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291100; cv=none; b=tI9iyYpS5DS6QoRDCS/YYGDbMfAglVohI9sD1pekU/gmBEjTTDYfRqp9AtkMUB89MdVVaZspGkbYwc64etI1lYl1eC242w270KBHjRb+lfXgZTC81nV1YrOFeKCrhoJSpWAyNh3gEWxQzI9poAxP/JNGZUyo0XnfEK4FJgGDneo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291100; c=relaxed/simple;
	bh=ib+yxfMEioxsFMIigbcM5zQI0/r9GAasMuT8UYZzwb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5pSmKbA9oLxtzOt3Ibloa9rczSgN7N5nxa4CqWOyGo6/yilrSfuq3YjzuxGXMkz1rBTBwk37eL0Nn1rGeHw1jAzheCTDdGAe+R09+uWNAJW+2VCI3/NYS6Ir0Fzm7RN34h9tR4wUp/uMxerO9M/aT/c+GrKsrJ5JGVCDeGbp4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQuiPyKb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQuiPyKb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF8EC4CEED;
	Sat,  7 Jun 2025 10:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291100;
	bh=ib+yxfMEioxsFMIigbcM5zQI0/r9GAasMuT8UYZzwb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XQuiPyKbrpGKdixdGQshPblqX6xibG3hH+GbaoPgf1wXAVF86CcgGzTREsvmzV9HZ
	 26yRjS3s5aWv5TgH99Vga8Cr1ZlZb7nnB50mZN3r9klSffyGA63hbyiRG9HVpq6fhi
	 ktuZpLSGYSxaU5bdDOQVs+Gtio3qY2TpTTronX6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Hsin-chen Chuang <chharry@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.15 23/34] Bluetooth: hci_qca: move the SoC type check to the right place
Date: Sat,  7 Jun 2025 12:08:04 +0200
Message-ID: <20250607100720.624429665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

commit 0fb410c914eb03c7e9d821e26d03bac0a239e5db upstream.

Commit 3d05fc82237a ("Bluetooth: qca: set power_ctrl_enabled on NULL
returned by gpiod_get_optional()") accidentally changed the prevous
behavior where power control would be disabled without the BT_EN GPIO
only on QCA_WCN6750 and QCA_WCN6855 while also getting the error check
wrong. We should treat every IS_ERR() return value from
devm_gpiod_get_optional() as a reason to bail-out while we should only
set power_ctrl_enabled to false on the two models mentioned above. While
at it: use dev_err_probe() to save a LOC.

Cc: stable@vger.kernel.org
Fixes: 3d05fc82237a ("Bluetooth: qca: set power_ctrl_enabled on NULL returned by gpiod_get_optional()")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Tested-by: Hsin-chen Chuang <chharry@chromium.org>
Reviewed-by: Hsin-chen Chuang <chharry@chromium.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/hci_qca.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2415,14 +2415,14 @@ static int qca_serdev_probe(struct serde
 
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
-		if (IS_ERR(qcadev->bt_en) &&
-		    (data->soc_type == QCA_WCN6750 ||
-		     data->soc_type == QCA_WCN6855)) {
-			dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
-			return PTR_ERR(qcadev->bt_en);
-		}
+		if (IS_ERR(qcadev->bt_en))
+			return dev_err_probe(&serdev->dev,
+					     PTR_ERR(qcadev->bt_en),
+					     "failed to acquire BT_EN gpio\n");
 
-		if (!qcadev->bt_en)
+		if (!qcadev->bt_en &&
+		    (data->soc_type == QCA_WCN6750 ||
+		     data->soc_type == QCA_WCN6855))
 			power_ctrl_enabled = false;
 
 		qcadev->sw_ctrl = devm_gpiod_get_optional(&serdev->dev, "swctrl",


