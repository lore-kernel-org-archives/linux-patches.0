Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADF4207E14;
	Tue,  8 Apr 2025 11:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111395; cv=none; b=HwFqH3v1GmJ0rTaX/jy5qFjW9LY1jMug13yzAHjylEIRszyHt+DS2ShWZU0tp3Tt2JFQP3r0v48gH1hnYrahX9gBA807VWRoz7f6I46pCCjqLnagpoADY8pb1kcR179zVW2FD2/eQZ2bd8T4tCdiWNZHzDgkMRBvPtQuYgzD7IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111395; c=relaxed/simple;
	bh=LCoTR1l/mWjYVg06gZZWGC9Lrx2Z1ulNH4BsLNo1a04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2bAP7ZqSAQSFt7Gve7Smh2hx84iIqn0N1QTLKaG6jlzjufTTQXbrFhV0Woy6Sjy+sncnUqP7QPNbaaFuvbrqchNh3dE9czVoZtLQ2M1jkaUqfDUCoFBPPEihsjje5hnouncfcQrqcCsvJdsaaEhIiRoZ8hYt66ddoTpAmdhmZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnmWX23f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnmWX23f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6248C4CEE5;
	Tue,  8 Apr 2025 11:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111395;
	bh=LCoTR1l/mWjYVg06gZZWGC9Lrx2Z1ulNH4BsLNo1a04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnmWX23f13EjGvN2iJauZ6Oeqpn9xH1pj150vMNQPbBLHjtHHDxWbreSOsHXX0U1k
	 Vp+ZwWYAz8gYz90bWOhxGXxvANCbFgKV6WcS6EyIwd0SA3T1bg6oFFsXUXjRYcl4Sc
	 8gFlAOM+arY8iBQvL+9X6aPeRlJ1BDzKveSdQ84I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Artur Weber <aweber.kernel@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 416/731] power: supply: max77693: Fix wrong conversion of charge input threshold value
Date: Tue,  8 Apr 2025 12:45:13 +0200
Message-ID: <20250408104923.950679665@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index cdea35c0d1de1..027d6a539b65a 100644
--- a/drivers/power/supply/max77693_charger.c
+++ b/drivers/power/supply/max77693_charger.c
@@ -608,7 +608,7 @@ static int max77693_set_charge_input_threshold_volt(struct max77693_charger *chg
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



