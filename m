Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 191DA3FF1A0;
	Fri, 15 May 2026 15:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860302; cv=none; b=O2XTKgUyZFAnJWhnnFvb+i0mZx0kIqgnZz3qOawglmYmiXqteKNPNqS8Dz4KrttsIw3tP5lMcnpBRYKRyeUJC6MsIAGQrQinmuSgde4RsWwdZXqN2mNFe707ubcqLy45ieQrDlVh6hQEzMDEOrJFwyrPZJutYW49V6XtiWqdU14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860302; c=relaxed/simple;
	bh=7JROdUpy+Z/7NTDkafBdqKsa4aWeLEAYX8YM8rYF8NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8oolkHhhUJI0rJImyNtV1TPHbYVEfm6RuedO3/K9XZNSiJ+Emr+brWOI5CeftYi+SAR9UiCje/Kbnhry3PAI2YrN03aYinxkSbSUkTs61vouoN+2u4eRpA0hzsbIaywmSgbnVR4a7blnGZW1XJNJ7QXnTtvfVgrbUEfM38YySg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t0FQfIuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t0FQfIuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68BB4C2BCB0;
	Fri, 15 May 2026 15:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860301;
	bh=7JROdUpy+Z/7NTDkafBdqKsa4aWeLEAYX8YM8rYF8NQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t0FQfIuAhbZ7ZoDD00xqNHw12UmAJEIEvLOPtxXNrkZA5QMOwqBLS753KREGkXBxM
	 7XJwlWCI0KLwYPcEHGIGdiIiN081HgUFvYwqJjUPd3w7K5ZWsXtmn+VHvUPW3LrGkT
	 Wxfto203S2kk2BnH1NrR+9T2IgK1PVG3rukPSbV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Fend <matthias.fend@emfend.at>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 036/144] media: i2c: ov08d10: fix image vertical start setting
Date: Fri, 15 May 2026 17:47:42 +0200
Message-ID: <20260515154654.355597659@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -612,8 +612,8 @@ static const struct ov08d10_lane_cfg lan
 static u32 ov08d10_get_format_code(struct ov08d10 *ov08d10)
 {
 	static const u32 codes[2][2] = {
-		{ MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SRGGB10_1X10},
-		{ MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SGBRG10_1X10},
+		{ MEDIA_BUS_FMT_SBGGR10_1X10, MEDIA_BUS_FMT_SGBRG10_1X10 },
+		{ MEDIA_BUS_FMT_SGRBG10_1X10, MEDIA_BUS_FMT_SRGGB10_1X10 },
 	};
 
 	return codes[ov08d10->vflip->val][ov08d10->hflip->val];


