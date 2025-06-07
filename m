Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF063217F26;
	Sat,  7 Jun 2025 10:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290906; cv=none; b=Nk3KzApiGgkwuGPjUr9bQk41CkHasw0pweYJeSGcoxgi9FTvK7N4oEeUn3tzEV39SSMGArbKh9xRLvddEvtNryd2B6TpeEmZnqbi927iFG/8KkEwJHikSW6T32U1+N/99ss8Hq+nKP0drY3t2gjvlMRWrKhWpab3OmHxG4AAww4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290906; c=relaxed/simple;
	bh=Lbv0L0DOQ2zVdN1a3yZmIG9+s5l2wqVjqd51hWw87gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JWlaz4gIY7vD/DhekaLqpkn7eJs4wM69yMEfjM47z1MctIUTDEs/cQZ2NzteWclNheSkPndqRnFyV6sO8zT+qomJ6JsgVpUPeeZhLLpVfv+St4xDaltatQVkgNq2t3xUHwjFgCLOQe9+eU9OJNdO3hGPa9/NvZQRMeztgIIGf4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FemquDjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FemquDjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E56BC4CEE4;
	Sat,  7 Jun 2025 10:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290905;
	bh=Lbv0L0DOQ2zVdN1a3yZmIG9+s5l2wqVjqd51hWw87gQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FemquDjASyPWzr3sdqVTbkXerK85ut/9dfVguK+XoR6qEYAER6aRMgjQ7kq5gevdr
	 ovmMM3SOLVdbAlFaTXtwZMyxLbdtVtFUZbuaD8xYB2x/jE9MjStwOZIBM/rR1Vulxg
	 ZTvNzynR2nx1dMTscE3A0QpOJRL0AvsOzdA+bI8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Hsin-chen Chuang <chharry@chromium.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.12 18/24] Bluetooth: hci_qca: move the SoC type check to the right place
Date: Sat,  7 Jun 2025 12:07:49 +0200
Message-ID: <20250607100718.609142774@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.910797456@linuxfoundation.org>
References: <20250607100717.910797456@linuxfoundation.org>
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
@@ -2385,14 +2385,14 @@ static int qca_serdev_probe(struct serde
 
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


