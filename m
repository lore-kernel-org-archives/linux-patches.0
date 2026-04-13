Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28A641DDC37;
	Mon, 13 Apr 2026 16:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096952; cv=none; b=i0hlrpiN9tGIAJyuJJ5w6u6MVLlKSfJQshGv2LwVs2JS7vyBI+AH1KgxnwveY3jU6sM593e/VvmBmocaORUD7LlEqeC8YPXiDVmguIhz6Q9ZhknQ3O/yJWuZjo93ABdF7VAcZMLRdFCfseJ+Q8QChePvqBA/TYuiJ9UAUlKJw2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096952; c=relaxed/simple;
	bh=tLn0TIz1Hqppa0qu+IwvI86laZtacGczwQPWr+KVSZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mtbyt2EQ6rE76LiCWih6/Rq00cwHy5UFyplQG8qtyW77wjiS8g6qazeOfNZw1/k5/jXP+sL5+7tSkskXEHNm9oVkY8lg2sg/7tUtlLe/ytQd56puKf8wLVqM9M+gLSBObH4mt5OAPKJ5tZ+EVXw1bXbGB8cjjB57mL5vGW0Rbv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AL9V4DrF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AL9V4DrF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19CAC2BCAF;
	Mon, 13 Apr 2026 16:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096952;
	bh=tLn0TIz1Hqppa0qu+IwvI86laZtacGczwQPWr+KVSZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AL9V4DrFoctFMnsbYR7MH12iAuGf4ZYEeLm9s8QMhCnd14ShpEHvPOFJ+HfXgxDUE
	 PS2MDE81kENWeELC2XVU3gcobBNiCER1cERdtOodqbeBrDOh4VdjbH5UYKRXe1yRrw
	 Bi8Hm11fWU6zwygdEUWXun8LW80MhK1CTZjTNqaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacky Bai <ping.bai@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.6 37/50] pmdomain: imx8mp-blk-ctrl: Keep the NOC_HDCP clock enabled
Date: Mon, 13 Apr 2026 18:01:04 +0200
Message-ID: <20260413155725.897871260@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155724.497323914@linuxfoundation.org>
References: <20260413155724.497323914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacky Bai <ping.bai@nxp.com>

commit e91d5f94acf68618ea3ad9c92ac28614e791ae7d upstream.

Keep the NOC_HDCP clock always enabled to fix the potential hang
caused by the NoC ADB400 port power down handshake.

Fixes: 77b0ddb42add ("soc: imx: add i.MX8MP HDMI blk ctrl HDCP/HRV_MWR")
Signed-off-by: Jacky Bai <ping.bai@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx8mp-blk-ctrl.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8mp-blk-ctrl.c
@@ -352,9 +352,6 @@ static void imx8mp_hdmi_blk_ctrl_power_o
 		regmap_set_bits(bc->regmap, HDMI_RTX_RESET_CTL0, BIT(12));
 		regmap_clear_bits(bc->regmap, HDMI_TX_CONTROL0, BIT(3));
 		break;
-	case IMX8MP_HDMIBLK_PD_HDCP:
-		regmap_set_bits(bc->regmap, HDMI_RTX_CLK_CTL0, BIT(11));
-		break;
 	case IMX8MP_HDMIBLK_PD_HRV:
 		regmap_set_bits(bc->regmap, HDMI_RTX_CLK_CTL1, BIT(3) | BIT(4) | BIT(5));
 		regmap_set_bits(bc->regmap, HDMI_RTX_RESET_CTL0, BIT(15));
@@ -408,9 +405,6 @@ static void imx8mp_hdmi_blk_ctrl_power_o
 		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL0, BIT(7));
 		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL1, BIT(22) | BIT(24));
 		break;
-	case IMX8MP_HDMIBLK_PD_HDCP:
-		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL0, BIT(11));
-		break;
 	case IMX8MP_HDMIBLK_PD_HRV:
 		regmap_clear_bits(bc->regmap, HDMI_RTX_RESET_CTL0, BIT(15));
 		regmap_clear_bits(bc->regmap, HDMI_RTX_CLK_CTL1, BIT(3) | BIT(4) | BIT(5));
@@ -439,7 +433,7 @@ static int imx8mp_hdmi_power_notifier(st
 	regmap_write(bc->regmap, HDMI_RTX_CLK_CTL0, 0x0);
 	regmap_write(bc->regmap, HDMI_RTX_CLK_CTL1, 0x0);
 	regmap_set_bits(bc->regmap, HDMI_RTX_CLK_CTL0,
-			BIT(0) | BIT(1) | BIT(10));
+			BIT(0) | BIT(1) | BIT(10) | BIT(11));
 	regmap_set_bits(bc->regmap, HDMI_RTX_RESET_CTL0, BIT(0));
 
 	/*


