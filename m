Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC1512D1F1;
	Mon, 23 Dec 2024 16:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969957; cv=none; b=bIb6VmXgBpo+pAv3Oyx0UKf84X0SeMl7DE6A/PCv/6CjjoOhjAtknlwH0/36OBAL3MMePaFG3dFmBsQ6K1rkZoiLvvI59o7cS5HO4bid4c4bnihbs1eNRu3u+YSFWWfOqCJms9u+IhEtqQBAWl7Ef/1prRuCyA4iJOTUOt4sTsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969957; c=relaxed/simple;
	bh=EndlIIbXvPA06XativTAo1qMnYrJa2HMhyYE1nXHmek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB16TCGGpTXtJtUhLb8ZOo3l6aMDF5/mvk+9WwCl77pH31Rmyty8RdRKeSkRv2SCqaFEhH/rO2aD/imbt/BtMpDq95vd5vdLJ7ehvvwYMflA/lgOYNkA5BhrTZjFyrsIylhpX+DPyU9YHUFZ/k64+5jIxfc86c0lKqreiYqqhc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TjdezxJ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TjdezxJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA03DC4CED6;
	Mon, 23 Dec 2024 16:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969957;
	bh=EndlIIbXvPA06XativTAo1qMnYrJa2HMhyYE1nXHmek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TjdezxJ75xUPMF1BOYupXoWUy2DwgPEhCidkWyjtWsuPPmgUssa9cWLbHSmqWp0na
	 hnVvcDaqud9y2whWsEKuj7YuLc/df4S2knUSNjnTGBi1yQg44srdS0xRTHxkve3sRD
	 o34rh0qQNVGC+f/BG5fI69Z/C6EclBRLbaYQvxG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/160] hwmon: (tmp513) Fix Current Register value interpretation
Date: Mon, 23 Dec 2024 16:58:33 +0100
Message-ID: <20241223155412.619843643@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@maxima.ru>

[ Upstream commit da1d0e6ba211baf6747db74c07700caddfd8a179 ]

The value returned by the driver after processing the contents of the
Current Register does not correspond to the TMP512/TMP513 specifications.
A raw register value is converted to a signed integer value by a sign
extension in accordance with the algorithm provided in the specification,
but due to the off-by-one error in the sign bit index, the result is
incorrect. Moreover, negative values will be reported as large positive
due to missing sign extension from u32 to long.

According to the TMP512 and TMP513 datasheets, the Current Register (07h)
is a 16-bit two's complement integer value. E.g., if regval = 1000 0011
0000 0000, then the value must be (-32000 * lsb), but the driver will
return (33536 * lsb).

Fix off-by-one bug, and also cast data->curr_lsb_ua (which is of type u32)
to long to prevent incorrect cast for negative values.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 59dfa75e5d82 ("hwmon: Add driver for Texas Instruments TMP512/513 sensor chips.")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Link: https://lore.kernel.org/r/20241216173648.526-3-m.masimov@maxima.ru
[groeck: Fixed description line length]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp513.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index d87fcea3ef24..2846b1cc515d 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -222,7 +222,7 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
 		break;
 	case TMP51X_BUS_CURRENT_RESULT:
 		// Current = (ShuntVoltage * CalibrationRegister) / 4096
-		*val = sign_extend32(regval, 16) * data->curr_lsb_ua;
+		*val = sign_extend32(regval, 15) * (long)data->curr_lsb_ua;
 		*val = DIV_ROUND_CLOSEST(*val, MILLI);
 		break;
 	case TMP51X_LOCAL_TEMP_RESULT:
-- 
2.39.5



