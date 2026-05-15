Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0B23F44CE;
	Fri, 15 May 2026 16:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861957; cv=none; b=mOdxlRd6ah0RdBHe9fyy4a4Y0wH0hx/pVdAJOOiwWLUGw53v6kqEzpBGPGbu3fzvEDb1cH4jkWUU+RC0fy4xVZvC/kTQsXV4is16BPQbc5g1eklRtiFurZMNiQpY5NMHj+4hBZYeUFznXMz488e4IhPU7/GHC49cFKNThDCCVqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861957; c=relaxed/simple;
	bh=NUQav8ldPZrS1Pa5AHchXySaTmjU5vb+8wkQr26vPd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3Q3euacqjU7Np6umgCCd3xhrscL9RqXjklQtSWfhUmDVakQWkopvJKzfYG8DEoWGNZ1eY3wGX+YST366R4QCbNHa9jdNzC2sQXMwFb4ln1F9oImcAsVolksRmIag/eiITGPRAIDIBoF2dpDq7gqqC3g4YZk7V7j2MKdagWg/R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JnuJIHXp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JnuJIHXp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D36C2BCC7;
	Fri, 15 May 2026 16:19:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861957;
	bh=NUQav8ldPZrS1Pa5AHchXySaTmjU5vb+8wkQr26vPd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JnuJIHXpLOf6PzLlfiCnspyXlxWTYl7fEK+7I/jedayoo1UhsMoqmpkGpsyzDjAAA
	 3a2rB05sTuHP1elN+P0OiX2n6s5edzmUW7Hc343IATUHJ/skPXPLVDv85XsW8o+d6h
	 LbI9FfY71LK/K/640PIKlCiYzbVfIExF2TruSvdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Fend <matthias.fend@emfend.at>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 052/188] media: i2c: ov08d10: fix image vertical start setting
Date: Fri, 15 May 2026 17:47:49 +0200
Message-ID: <20260515154658.443910644@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


