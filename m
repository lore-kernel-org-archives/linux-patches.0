Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDAF3EFFD8;
	Fri, 15 May 2026 16:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862495; cv=none; b=Lx99yuwFgdbHe/aHcyyiYM22CZmQOFDn3xbGB/r4wFMR6PtolssOhCXIIoeX8jqmkdpDPiQzmYAVj4pE2LgF8of81sCfOgFH0/baRRldT/QWvJ0bKVWCWdBamY/IVE99uwsnG9mzSVY5Z8w07YBHLYkJuPBvVwlC9K34ZimM8dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862495; c=relaxed/simple;
	bh=IJFKZHG3a0yZWjtg4+2nhW8tykEHdDucB4q5FUiEZug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpxUS6ISv8ZeXYGF5uD1AdDf2H8lO2pSC+IpfKfAlw4eR4YSBqvyKdtNvXvA1BfwzXBrU0G5i22IaJGUvTAu/GaP4JgjaOk71p6CtNLtV0F0cgU+d/ea+nA2cBKLpyt0E44jKTqHatXkGir3/pTwL5Q5mvwV/oJm97Qs1jZ21Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gd45LgrC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gd45LgrC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEF61C2BCB0;
	Fri, 15 May 2026 16:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862495;
	bh=IJFKZHG3a0yZWjtg4+2nhW8tykEHdDucB4q5FUiEZug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gd45LgrCdlFOYmEg1jnwm51xMg7Ynf1IvdeGE/fB4OqttENCspgRFh+3xWv8f9f4G
	 GfAizwVubSNExnUokuIECw7UxDqtLuT5YWV5jBuiTodiDxtz44vlqGICeKixDfjJLC
	 Ki5B7b5H/94WTBThrCg6iNRk2CB9nDv56wVeFXRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Fend <matthias.fend@emfend.at>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 069/201] media: i2c: ov08d10: fix image vertical start setting
Date: Fri, 15 May 2026 17:48:07 +0200
Message-ID: <20260515154700.028703381@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Fend <matthias.fend@emfend.at>

commit 5d150fa0f16096d736bd24d13e04495da5116fab upstream.

The current settings for the "image vertical start" register appear to be
incorrect. While this only results in an incorrect start line for native
modes, this faulty setting causes actual problems in binning mode. At least
on an i.MX8MP test system, only corrupted frames could be received.
To correct this, the recommended settings from the reference register sets
are used for all modes. Since this shifts the start by one line, the Bayer
pattern also changes, which has also been corrected.

Fixes: 7be91e02ed57 ("media: i2c: Add ov08d10 camera sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Fend <matthias.fend@emfend.at>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov08d10.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/media/i2c/ov08d10.c
+++ b/drivers/media/i2c/ov08d10.c
@@ -217,7 +217,7 @@ static const struct ov08d10_reg lane_2_m
 	{0x9a, 0x30},
 	{0xa8, 0x02},
 	{0xfd, 0x02},
-	{0xa1, 0x01},
+	{0xa1, 0x00},
 	{0xa2, 0x09},
 	{0xa3, 0x9c},
 	{0xa5, 0x00},
@@ -335,7 +335,7 @@ static const struct ov08d10_reg lane_2_m
 	{0x9a, 0x30},
 	{0xa8, 0x02},
 	{0xfd, 0x02},
-	{0xa1, 0x09},
+	{0xa1, 0x08},
 	{0xa2, 0x09},
 	{0xa3, 0x90},
 	{0xa5, 0x08},
@@ -467,7 +467,7 @@ static const struct ov08d10_reg lane_2_m
 	{0xaa, 0xd0},
 	{0xab, 0x06},
 	{0xac, 0x68},
-	{0xa1, 0x09},
+	{0xa1, 0x04},
 	{0xa2, 0x04},
 	{0xa3, 0xc8},
 	{0xa5, 0x04},
@@ -613,8 +613,8 @@ static const struct ov08d10_lane_cfg lan
 static u32 ov08d10_get_format_code(struct ov08d10 *ov08d10)
 {
 	static const u32 codes[2][2] = {
-		{ MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SRGGB10_1X10},
-		{ MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SGBRG10_1X10},
+		{ MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SGBRG10_1X10 },
+		{ MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SRGGB10_1X10 },
 	};
 
 	return codes[ov08d10->vflip->val][ov08d10->hflip->val];


