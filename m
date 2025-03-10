Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBA8F17CA12;
	Mon, 10 Mar 2025 17:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629000; cv=none; b=HzSWDRbl3+I9Ni3h1zzBAYe7D8Imy7+jEq7E6U210fEds5JagjznX5BMXQK4oO7eX8Fr4hhKXybgfz0tPZmlgf0HwrCdzcvFSdDLPiwWHoHG8eElr3htGis/2ODJquPjkIOEww++HZd5vl4UuqIiIpEeOUgfkmSrtIkbtXhQ9ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629000; c=relaxed/simple;
	bh=bj+mwH/pfCaGVVnROSTNqSaBe5Omdm5bZ4uCSATMXbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyBUrl/Z0OQGAStaHd+rCw63TOkDcmIJd6eIqsiTTwg1barJ/Wm/N93v6upTva5VoyRZcblxynqAbov9nMYXHhU2hQ9oCTPktr+AxbcbGlxw97ACeIwhQYPA7EYlGCsOAn/JC/9NudQF21siu8Xnfs5mcjvcIrsUMZ60So0NT5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LAUUWU+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAUUWU+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529E8C4CEE5;
	Mon, 10 Mar 2025 17:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629000;
	bh=bj+mwH/pfCaGVVnROSTNqSaBe5Omdm5bZ4uCSATMXbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAUUWU+N7L/iSEnn7ICgVvezYdhAlzdDvzvPymNsJ2knK//S48R41svGC5s74uYcZ
	 SyhWRm5i/5CAqx3nCiCeYP5JMaIgUyNeZaVyGPSAsx6nMOsaWhnYRyy6h0GsvaVZk5
	 S/eId2Acrz0QxHr7JRsHPmMw+JsLkrc4lymBjgIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Kieran Bingham <kieran.bingham@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/620] media: i2c: ov9282: Correct the exposure offset
Date: Mon, 10 Mar 2025 17:59:47 +0100
Message-ID: <20250310170551.164361943@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit feaf4154d69657af2bf96e6e66cca794f88b1a61 ]

The datasheet lists that "Maximum exposure time is frame
length -25 row periods, where frame length is set by
registers {0x380E, 0x380F}".
However this driver had OV9282_EXPOSURE_OFFSET set to 12
which allowed that restriction to be violated, and would
result in very under-exposed images.

Correct the offset.

Fixes: 14ea315bbeb7 ("media: i2c: Add ov9282 camera sensor driver")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov9282.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/ov9282.c b/drivers/media/i2c/ov9282.c
index 2e0b315801e56..5bc9fafa72a4b 100644
--- a/drivers/media/i2c/ov9282.c
+++ b/drivers/media/i2c/ov9282.c
@@ -31,7 +31,7 @@
 /* Exposure control */
 #define OV9282_REG_EXPOSURE	0x3500
 #define OV9282_EXPOSURE_MIN	1
-#define OV9282_EXPOSURE_OFFSET	12
+#define OV9282_EXPOSURE_OFFSET	25
 #define OV9282_EXPOSURE_STEP	1
 #define OV9282_EXPOSURE_DEFAULT	0x0282
 
-- 
2.39.5



