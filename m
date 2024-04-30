Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A91A17592;
	Tue, 30 Apr 2024 11:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476470; cv=none; b=RrIUgwrLnnmaEb/45LCbFBnYlgph0Dz/6ycOEoyIgVaI/ClIG8x61N2CLHpRfYm+c2v+wmLO4d9bxCdvOrXoyf8rUnKQzRTyOsletAPx/pekU4J6btCG6r8usSGVsK6xcrNh7U09JTdAVMnxqvD7/xqS+/qa3S00k4ZYsJvWp38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476470; c=relaxed/simple;
	bh=1WPd0mKOPfwvGmLg/nGHku2XPqh8SkSfFATKyXUflt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e0X4HpJKrmlUsV0OQUwAbZYPXal/sdh4EUkZFIDZH7cR9vzK9KiYxtNrgPrSah/X/v/8RrXTinbiYzKllpvklwplaN+UJO0hvO4bCem+z8JxOZ0HHK/1DWQM6XlKVqCI5okKgXsyTAzARBSLCdxeRonkVRon5abBKp9SX6TEDcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZNMCfq1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZNMCfq1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC33C2BBFC;
	Tue, 30 Apr 2024 11:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476470;
	bh=1WPd0mKOPfwvGmLg/nGHku2XPqh8SkSfFATKyXUflt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZNMCfq1m0M/BoIku9EA3S0YjwMyLz2WMdaUs/95WRVGtlmABOPqfx2wePUQO+VU4R
	 bJorIYuhCih6XlwbKY8OQu2uHGAvpJp98aV2mfxBzHSxIOIQUx0x9uVLWO0Kwvctc8
	 M/yHvM2poAwbU6TdQKXtRW2XDUsRTn1vL1daAvMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wren Turkal <wt@penguintechs.org>,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/110] Bluetooth: qca: set power_ctrl_enabled on NULL returned by gpiod_get_optional()
Date: Tue, 30 Apr 2024 12:40:10 +0200
Message-ID: <20240430103048.779915226@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit 3d05fc82237aa97162d0d7dc300b55bb34e91d02 ]

Any return value from gpiod_get_optional() other than a pointer to a
GPIO descriptor or a NULL-pointer is an error and the driver should
abort probing. That being said: commit 56d074d26c58 ("Bluetooth: hci_qca:
don't use IS_ERR_OR_NULL() with gpiod_get_optional()") no longer sets
power_ctrl_enabled on NULL-pointer returned by
devm_gpiod_get_optional(). Restore this behavior but bail-out on errors.
While at it: also bail-out on error returned when trying to get the
"swctrl" GPIO.

Reported-by: Wren Turkal <wt@penguintechs.org>
Reported-by: Zijun Hu <quic_zijuhu@quicinc.com>
Closes: https://lore.kernel.org/linux-bluetooth/1713449192-25926-2-git-send-email-quic_zijuhu@quicinc.com/
Fixes: 56d074d26c58 ("Bluetooth: hci_qca: don't use IS_ERR_OR_NULL() with gpiod_get_optional()")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Tested-by: Wren Turkal <wt@penguintechs.org>
Reported-by: Wren Turkal <wt@penguintechs.org>
Reported-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Krzysztof Kozlowski<krzysztof.kozlowski@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_qca.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index 33956ddec9337..ca6065297a7b2 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -2257,16 +2257,21 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 		    (data->soc_type == QCA_WCN6750 ||
 		     data->soc_type == QCA_WCN6855)) {
 			dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
-			power_ctrl_enabled = false;
+			return PTR_ERR(qcadev->bt_en);
 		}
 
+		if (!qcadev->bt_en)
+			power_ctrl_enabled = false;
+
 		qcadev->sw_ctrl = devm_gpiod_get_optional(&serdev->dev, "swctrl",
 					       GPIOD_IN);
 		if (IS_ERR(qcadev->sw_ctrl) &&
 		    (data->soc_type == QCA_WCN6750 ||
 		     data->soc_type == QCA_WCN6855 ||
-		     data->soc_type == QCA_WCN7850))
-			dev_warn(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
+		     data->soc_type == QCA_WCN7850)) {
+			dev_err(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
+			return PTR_ERR(qcadev->sw_ctrl);
+		}
 
 		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
 		if (IS_ERR(qcadev->susclk)) {
@@ -2285,10 +2290,13 @@ static int qca_serdev_probe(struct serdev_device *serdev)
 		qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
 					       GPIOD_OUT_LOW);
 		if (IS_ERR(qcadev->bt_en)) {
-			dev_warn(&serdev->dev, "failed to acquire enable gpio\n");
-			power_ctrl_enabled = false;
+			dev_err(&serdev->dev, "failed to acquire enable gpio\n");
+			return PTR_ERR(qcadev->bt_en);
 		}
 
+		if (!qcadev->bt_en)
+			power_ctrl_enabled = false;
+
 		qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
 		if (IS_ERR(qcadev->susclk)) {
 			dev_warn(&serdev->dev, "failed to acquire clk\n");
-- 
2.43.0



