Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F214146A79;
	Mon, 16 Sep 2024 12:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488610; cv=none; b=KnVKUbFgNKVJZWnSZS8n0wkumqTa+eXd9LUAF+dvzx1dn5Fh6xOBvmDMcEf+mM85okUheDD4Tdu17UZ9X20ULrhUtL/Ufkw84ubE37kmn2oQq7Ak1L87mEa8ZiTOZqAnGD5yU4R8mUfK/TKfMqN3gvoWM3iKtBG82y8Gc/Sy40k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488610; c=relaxed/simple;
	bh=V+M7PUImC8lNzPMefXNH5EQU6BZeAw6L6EU1zXSpkmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8m3XbnGgn3D8goT6Lqau8yPrRFl5msflI1KBUaRE/nqKUgZlfatuhreZ5Uvjc6wFeRRr1H+F2nBjzXRWvy58RsWCo1SjVh2vgPloGiS23yJnCMRC+mpnAm1RPQzv9yvDB3EMWJGGDlyH8mYKoFEtW70CDsYRyUp2EpFvx/Q5RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuAhuATY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuAhuATY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B896C4CEC4;
	Mon, 16 Sep 2024 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488610;
	bh=V+M7PUImC8lNzPMefXNH5EQU6BZeAw6L6EU1zXSpkmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuAhuATYq/ATKZz9ElZQ3Zk0jLGqrDf/9zr1ya944MbQydaqGHz3H8D1PdnOv9Xvo
	 PIA+5KSCJNcrMs9F2ZoJerR/Faqqk319EqTkMWZI4Q5qF6rHhtMmLCPtgH2RKNCnOV
	 eZpxPBuDsDay6lYYqV2fHnhXm3g8JVWHtdlg9KzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 24/91] Input: ads7846 - ratelimit the spi_sync error message
Date: Mon, 16 Sep 2024 13:44:00 +0200
Message-ID: <20240916114225.309305564@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit ccbfea78adf75d3d9e87aa739dab83254f5333fa ]

In case the touch controller is not connected, this message keeps scrolling
on the console indefinitelly. Ratelimit it to avoid filling kernel logs.

"
ads7846 spi2.1: spi_sync --> -22
"

Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20240708211913.171243-1-marex@denx.de
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index a66375700a63..8b8c43b3c27f 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -808,7 +808,7 @@ static void ads7846_read_state(struct ads7846 *ts)
 		m = &ts->msg[msg_idx];
 		error = spi_sync(ts->spi, m);
 		if (error) {
-			dev_err(&ts->spi->dev, "spi_sync --> %d\n", error);
+			dev_err_ratelimited(&ts->spi->dev, "spi_sync --> %d\n", error);
 			packet->ignore = true;
 			return;
 		}
-- 
2.43.0



