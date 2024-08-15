Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 622241A00D1;
	Thu, 15 Aug 2024 13:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729065; cv=none; b=GXLljKfqqrZNaK2Uhx1u2JsLSvzxnuFTfIXPz7StXXF29qCsHAusAHaaN8yV1krP4CJnm4yudZDHsz73In22xgtroCUIqGXhKhHuNq2tsLHSyzIn+ubvDq76A/VgfMJ3zKtaCh94CxVYao94zjHy65qngp2BSs648ufPu5MTwoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729065; c=relaxed/simple;
	bh=NgDL4yWuA2IpMZ3g7SjxTRpRwN3wVmv4sG80/WdxWTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tovHLG8M5RaaLOhgvb8MjkalMsBRzV/fccmFoWCCeM2UKIGb72j9xS8DLBOapLTNqqmTrvFsmWE0ss2MKCcJggeHBwJCaQ0o/Mp9mJ4StOq30o+SZBhIKd8udjqZrVItUANLciMt/mfYXR3tG8hDEW5tB9LJFRdyj+unD/1NGg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P9wANOri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P9wANOri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC986C32786;
	Thu, 15 Aug 2024 13:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729065;
	bh=NgDL4yWuA2IpMZ3g7SjxTRpRwN3wVmv4sG80/WdxWTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P9wANOrihyUn0ooUqeRvau5yfkf3dxodM8WIEz3H8uUZW8+44kH1bhtRQibuTj3aZ
	 guIyEAE/KPFe2EnwT0uKDZ5OD+PBDL/qjJBdCXjdXUoTLV4UM3OvDgL5ZgIx1LtHiy
	 s4AhDVSVcp69JrLPEX8kadyGZIHM3Ux9vCBmRRlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.19 182/196] power: supply: axp288_charger: Fix constant_charge_voltage writes
Date: Thu, 15 Aug 2024 15:24:59 +0200
Message-ID: <20240815131859.033992533@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit b34ce4a59cfe9cd0d6f870e6408e8ec88a964585 upstream.

info->max_cv is in millivolts, divide the microvolt value being written
to constant_charge_voltage by 1000 *before* clamping it to info->max_cv.

Before this fix the code always tried to set constant_charge_voltage
to max_cv / 1000 = 4 millivolt, which ends up in setting it to 4.1V
which is the lowest supported value.

Fixes: 843735b788a4 ("power: axp288_charger: axp288 charger driver")
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240717200333.56669-1-hdegoede@redhat.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/axp288_charger.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -378,8 +378,8 @@ static int axp288_charger_usb_set_proper
 			dev_warn(&info->pdev->dev, "set charge current failed\n");
 		break;
 	case POWER_SUPPLY_PROP_CONSTANT_CHARGE_VOLTAGE:
-		scaled_val = min(val->intval, info->max_cv);
-		scaled_val = DIV_ROUND_CLOSEST(scaled_val, 1000);
+		scaled_val = DIV_ROUND_CLOSEST(val->intval, 1000);
+		scaled_val = min(scaled_val, info->max_cv);
 		ret = axp288_charger_set_cv(info, scaled_val);
 		if (ret < 0)
 			dev_warn(&info->pdev->dev, "set charge voltage failed\n");


