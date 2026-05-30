Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4A9137750;
	Sat, 30 May 2026 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166824; cv=none; b=EsTQGTKnrXJnh4uUKSJJEh80hxg+HXzmaA3L6FM9lINAd8ySjNZzVFtkYSgkBC+ThkydqyCOcQpDpmDhWKF6KZldaAa0/LcN/RSDjz9GITldKEHzFK3SVMpZYRtzrWPXXFrIPaIeZvnEQ0O/iit5P33LpiQcyhmMIkPHy+Jc2HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166824; c=relaxed/simple;
	bh=7VD71YztWoDk9mYqU+mZCFtS5wnfLYfKzsLXkiEvLU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tx8O0a69ibemhAHyHAf8dWuvawSu+ORLCrbVmWwwMb3Hu4BhFq2+kFtUxuraLBkLcy6GCCFf/8EYm/OCX0C7QV0cLkb19Q9CiWWsZRUMokPiNIPGcjVYevTBdQts6fdjB+qVeS+SnOrretKixH9maFyZhSuqPA0dmNYeavjySJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19QfvtHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19QfvtHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC0D1F00893;
	Sat, 30 May 2026 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166823;
	bh=Hats3IlYzWyjPSP4f/AlazXczSKbBWp/GMN5Fn2WlQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=19QfvtHNlTKPOtyaTKyuhNQNZU8tkL1HtYqjb67q7lb79YQXvuVOH4x9NjfpHLwGm
	 0j+3zDqyMNno1LgdxrSxzmvWotA5JbGQqnoaXJJiHxksnEbnzo/+S/mssdaXbvtc6k
	 b8pmx1g1lU1k2BnmWsDWTeDoahWPLT5BT70ejW9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Geurts <paul.geurts@prodrive-technologies.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Greer <mgreer@animalcreek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 483/589] NFC: trf7970a: Ignore antenna noise when checking for RF field
Date: Sat, 30 May 2026 18:06:04 +0200
Message-ID: <20260530160237.342245975@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Geurts <paul.geurts@prodrive-technologies.com>

[ Upstream commit a9bc28aa4e64320668131349436a650bf42591a5 ]

The main channel Received Signal Strength Indicator (RSSI) measurement
is used to determine whether an RF field is present or not. RSSI != 0
is interpreted as an RF Field is present. This does not take RF noise
and measurement inaccuracy into account, and results in false positives
in the field.

Define a noise level and make sure the RF field is only interpreted as
present when the RSSI is above the noise level.

Fixes: 851ee3cbf850 ("NFC: trf7970a: Don't turn on RF if there is already an RF field")
Signed-off-by: Paul Geurts <paul.geurts@prodrive-technologies.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Mark Greer <mgreer@animalcreek.com>
Link: https://patch.msgid.link/20260422100930.581237-1-paul.geurts@prodrive-technologies.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/trf7970a.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/trf7970a.c b/drivers/nfc/trf7970a.c
index 081ec1105572e..4d99d4dbf817e 100644
--- a/drivers/nfc/trf7970a.c
+++ b/drivers/nfc/trf7970a.c
@@ -311,6 +311,7 @@
 #define TRF7970A_RSSI_OSC_STATUS_RSSI_MASK	(BIT(2) | BIT(1) | BIT(0))
 #define TRF7970A_RSSI_OSC_STATUS_RSSI_X_MASK	(BIT(5) | BIT(4) | BIT(3))
 #define TRF7970A_RSSI_OSC_STATUS_RSSI_OSC_OK	BIT(6)
+#define TRF7970A_RSSI_OSC_STATUS_RSSI_NOISE_LEVEL	1
 
 #define TRF7970A_SPECIAL_FCN_REG1_COL_7_6		BIT(0)
 #define TRF7970A_SPECIAL_FCN_REG1_14_ANTICOLL		BIT(1)
@@ -1253,7 +1254,7 @@ static int trf7970a_is_rf_field(struct trf7970a *trf, bool *is_rf_field)
 	if (ret)
 		return ret;
 
-	if (rssi & TRF7970A_RSSI_OSC_STATUS_RSSI_MASK)
+	if ((rssi & TRF7970A_RSSI_OSC_STATUS_RSSI_MASK) > TRF7970A_RSSI_OSC_STATUS_RSSI_NOISE_LEVEL)
 		*is_rf_field = true;
 	else
 		*is_rf_field = false;
-- 
2.53.0



