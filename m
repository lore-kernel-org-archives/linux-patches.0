Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6AA266EEA;
	Tue,  8 Apr 2025 11:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112759; cv=none; b=SdU5KpdulAr7QttiEi/8IW2t9WfcAgplcVBEgUjPQTW2OiPZZfxUQmGdbxRtdTSmwiq7kdl/zVZ/9lh2H0z+Q1vmYK1+DOPt3UdDyjuDmQn7tAZzGnXPRRjzg9dMtaZ0VlRGDSfbRIZy5L9CbW9O/DsPVAtH6IPx4YeRba013xY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112759; c=relaxed/simple;
	bh=24mHujU6Xdz0flljewBdRnnoBjd5Qjc0q/EqJtVxDhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKvg0/XrhbvN/7vVNyYi0QhwQV/2aGmY24ZPdVZpSdcupG15i+giv+Shp9IAHR/dBX06dqMcQLAkGlwdEHhJfSQXcu8lSvG897srmwjSBzIUPHNOrXW+8WX/AM04oLlusZkvLOPQRccFD+0YMhsrWuZZ6pLzLt1vNL4j2ZBLkvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YP07sou; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YP07sou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929F7C4CEE5;
	Tue,  8 Apr 2025 11:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112758;
	bh=24mHujU6Xdz0flljewBdRnnoBjd5Qjc0q/EqJtVxDhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1YP07souy1+AzcLHgxHd1pvflaE8kzl4Px+X/U5kFgObx3Imm4j9eQTCOLquNNc1n
	 3b/vrSbaL+ymDsLG8WSERM9KvRrG3B2gMWvpdZboY+5NjDeHQjTY0JQpFECs6yNInS
	 FaavkwkLm7OkG/das9qtjx+Z06bf6kkGI26MMgQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/279] power: supply: max77693: Fix wrong conversion of charge input threshold value
Date: Tue,  8 Apr 2025 12:49:30 +0200
Message-ID: <20250408104831.383363711@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a2c5c9858639f..ef3482fa4023e 100644
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



