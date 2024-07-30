Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239251448FA;
	Tue, 30 Jul 2024 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357975; cv=none; b=aJSlsuKxIvo14qhe1iIHBMOF22cHkz6GHiO7muiVjHrGe2hfU4i181LK327R+aCC0EZkMW3kiUHRcdaxQhd7kZ20Ba0NeDl+MrWH5LaCoXDFQ1yhurp1anotrfB6KAuxTEefGGee4kHZ4Xo4pzIo2egpyNiJPyzHxAtcaJVGqA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357975; c=relaxed/simple;
	bh=x5BM1vmpqTYx8QdHs80E+yOUOJDI1XkskKTWQRR8nnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cigiFyNF09SHY0g2qvMs7AFO6YhVr7B0WMhQ7bOkTUt31ClOcvPZ00NSkJPfLxIv+IpiRdToO4lw+MtCVIt6+VtxFh2Hwe76uv90dgrqGj3RLag/WAliwKkGNpPq23wjJDedTAjdHmSsv+VJ7hRoaSKsoOIFB5C+hN3reRTasck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UecQh91i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UecQh91i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945E4C32782;
	Tue, 30 Jul 2024 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357975;
	bh=x5BM1vmpqTYx8QdHs80E+yOUOJDI1XkskKTWQRR8nnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UecQh91iWQW02yw0ywy7Uy23KGLmZhmbIcmCwec0Wu3e+n26kNk7gXpLsN1/uzs70
	 cGMe5pYsFNqVTrIegc5QudfWqAhgw2I4wakw9JLsdjJi74h1RVwlkGQlEzVzCqZhOT
	 PrXK4l7N7ljaO8Nx/MYc2c6/r0lVDlkdG6P43KwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>,
	Adam Ford <aford173@gmail.com>
Subject: [PATCH 6.10 311/809] media: i2c: imx219: fix msr access command sequence
Date: Tue, 30 Jul 2024 17:43:07 +0200
Message-ID: <20240730151736.880755814@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 3cdc776e0a5f1784c3ae5d3371b64215c228bf1f ]

It was reported to me that the imx219 didn't work on one of our
development kits partly because the access sequence is incorrect.
The datasheet I could find [1] for this camera has the access sequence:
Seq. No. Address (Hex) data
1        30EB          05
2        30EB          0C
3        300A          FF
4        300B          FF
5        30EB          05
6        30EB          09

but the driver swaps the first two elements. Laurent pointed out on IRC
that the original code used the correct sequence for 1920x1080 but the
current sequence for 3280x2464 and 1640x1232. During refactoring of the
init sequence the current order was used for all formats.

Switch to using the documented sequence.

Link: https://www.opensourceinstruments.com/Electronics/Data/IMX219PQ.pdf [1]
Fixes: 8508455961d5 ("media: i2c: imx219: Split common registers from mode tables")
Fixes: 1283b3b8f82b ("media: i2c: Add driver for Sony IMX219 sensor")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Tested-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Tested-by: Adam Ford <aford173@gmail.com>  #imx8mp-beacon-kit
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 51ebf5453fceb..e78a80b2bb2e4 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -162,8 +162,8 @@ static const struct cci_reg_sequence imx219_common_regs[] = {
 	{ IMX219_REG_MODE_SELECT, 0x00 },	/* Mode Select */
 
 	/* To Access Addresses 3000-5fff, send the following commands */
-	{ CCI_REG8(0x30eb), 0x0c },
 	{ CCI_REG8(0x30eb), 0x05 },
+	{ CCI_REG8(0x30eb), 0x0c },
 	{ CCI_REG8(0x300a), 0xff },
 	{ CCI_REG8(0x300b), 0xff },
 	{ CCI_REG8(0x30eb), 0x05 },
-- 
2.43.0



