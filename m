Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4574426A1A7;
	Tue,  8 Apr 2025 11:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113260; cv=none; b=TVuncUWBtkB5P4RzEsEoPSPi9JAnbwE0KpElYqZ6lslqhif7ZCl/Hpi7niEKpC3V2pQrHS98xC4yWxduz+fpYvaMBab11phaTNe6EIHf9wm8YDYW8LP+FsIM/B4E3W/d9BnsFjaX6qTAzd+/YztynjqKTXSjTtaFf6sIiqmNqA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113260; c=relaxed/simple;
	bh=y8j7m0CbHeQNospuvm8OP7Z4zCj42cvvwyIE+lzfyR0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fe4HAj6APUC1lURbfP2+8c2GXLNfqdAsJAB4khZFiHatF1hd91tJCeRp6Pu1h/OJvvyJVYlBKDJ3Mg38F5yrAOfaydjd587fvRfW5ZJel23vHS9Scr/KsD1H0XEpDF6H74l2ctCgqNnZu3hLygrOKQs8PiG1RLXi8FhLy/2WuO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SV0/+Htg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SV0/+Htg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9265C4CEEF;
	Tue,  8 Apr 2025 11:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113260;
	bh=y8j7m0CbHeQNospuvm8OP7Z4zCj42cvvwyIE+lzfyR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SV0/+Htg+h9mc1g/Gg6C7WRsZXr7hAg8oFJYykNz2QtHaxDPI1WUcEgK1lSTXTTja
	 kFIxF/KwkgbSezgpMSnR9uWNCtTBuANPVCL62cL9v3T6wm7/dS2CDU17VWovyyMrx+
	 7THnDAXbnlG1JgCg8v/R9uRrzbpmfMMXE1R93Iks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 093/268] power: supply: max77693: Fix wrong conversion of charge input threshold value
Date: Tue,  8 Apr 2025 12:48:24 +0200
Message-ID: <20250408104831.005426136@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artur Weber <aweber.kernel@gmail.com>

[ Upstream commit 30cc7b0d0e9341d419eb7da15fb5c22406dbe499 ]

The charge input threshold voltage register on the MAX77693 PMIC accepts
four values: 0x0 for 4.3v, 0x1 for 4.7v, 0x2 for 4.8v and 0x3 for 4.9v.
Due to an oversight, the driver calculated the values for 4.7v and above
starting from 0x0, rather than from 0x1 ([(4700000 - 4700000) / 100000]
gives 0).

Add 1 to the calculation to ensure that 4.7v is converted to a register
value of 0x1 and that the other two voltages are converted correctly as
well.

Fixes: 87c2d9067893 ("power: max77693: Add charger driver for Maxim 77693")
Signed-off-by: Artur Weber <aweber.kernel@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250316-max77693-charger-input-threshold-fix-v1-1-2b037d0ac722@gmail.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/max77693_charger.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/max77693_charger.c b/drivers/power/supply/max77693_charger.c
index 794c8c054450e..0e7b3277d481a 100644
--- a/drivers/power/supply/max77693_charger.c
+++ b/drivers/power/supply/max77693_charger.c
@@ -556,7 +556,7 @@ static int max77693_set_charge_input_threshold_volt(struct max77693_charger *chg
 	case 4700000:
 	case 4800000:
 	case 4900000:
-		data = (uvolt - 4700000) / 100000;
+		data = ((uvolt - 4700000) / 100000) + 1;
 		break;
 	default:
 		dev_err(chg->dev, "Wrong value for charge input voltage regulation threshold\n");
-- 
2.39.5



