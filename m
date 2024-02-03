Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832B911198;
	Sat,  3 Feb 2024 04:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933866; cv=none; b=QW6v14jyiEBkDEOZcCBB6djP+dskq7XfOezG+6lJQ+u3rk3B+rRWDWho1M0gcA8NdstcQFUpq0Dkvc24RgRq7ai8lJTYDL6DySRVFysLGHoUlTSNwWOYZ9QkKc7TgvBOhPGJeXqnQQpGBaftZnUk9El2RJHCwW8yZvoTIXadJjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933866; c=relaxed/simple;
	bh=R6Ml8+ckbhiffBmoVRm/MSX/1bVjug9k4dIffdM+Ha8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a7HyXtWkIaF+oolyojN6Fq2oLH4ZJ/SB62Cq5deL8eRvNFKZvbbU7RNfRqyGVC4eLPcRKsFhPu2W2XubBeEqPLcusrcsN2kPSnKyKOlfmhQY0x4HirQGMY1UF2Q4+gQBh6qXRnFIdxL4Q7msSK/fglEmjDBNXApg2c6lLrfbkfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJZVwU6f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJZVwU6f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A453C43394;
	Sat,  3 Feb 2024 04:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933866;
	bh=R6Ml8+ckbhiffBmoVRm/MSX/1bVjug9k4dIffdM+Ha8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJZVwU6f9+FhVj6WWS0qhMsQsGrYHoXBFJ26yHtfAjTUQb4QLqC3jRFKwuV6b1aaU
	 4Cq4zHkv6yh8mhnx/YbtGQTOq4PUI9S+ncmh5hGmVeHZdT4GaqJlM8Sw//msCSIE40
	 aYU5VvdE2PM5Z7bqwG4eDfXeLKV4VSEgjwsFgl1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 202/353] media: ov2740: Fix hts value
Date: Fri,  2 Feb 2024 20:05:20 -0800
Message-ID: <20240203035410.076746217@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3735228bbe3511f844e03dfcc4003fadb59dde23 ]

HTS must be more then width, so the 1080 value clearly is wrong,
this is then corrected with some weird math dividing clocks in
to_pixels_per_line() which results in the hts getting multiplied by 2,
resulting in 2160.

Instead just directly set hts to the correct value of 2160 and
drop to_pixels_per_line().

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov2740.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/media/i2c/ov2740.c b/drivers/media/i2c/ov2740.c
index 24e468485fbf..6be22586c3d2 100644
--- a/drivers/media/i2c/ov2740.c
+++ b/drivers/media/i2c/ov2740.c
@@ -310,7 +310,7 @@ static const struct ov2740_mode supported_modes[] = {
 	{
 		.width = 1932,
 		.height = 1092,
-		.hts = 1080,
+		.hts = 2160,
 		.vts_def = OV2740_VTS_DEF,
 		.vts_min = OV2740_VTS_MIN,
 		.reg_list = {
@@ -357,15 +357,6 @@ static u64 to_pixel_rate(u32 f_index)
 	return pixel_rate;
 }
 
-static u64 to_pixels_per_line(u32 hts, u32 f_index)
-{
-	u64 ppl = hts * to_pixel_rate(f_index);
-
-	do_div(ppl, OV2740_SCLK);
-
-	return ppl;
-}
-
 static int ov2740_read_reg(struct ov2740 *ov2740, u16 reg, u16 len, u32 *val)
 {
 	struct i2c_client *client = v4l2_get_subdevdata(&ov2740->sd);
@@ -598,8 +589,7 @@ static int ov2740_init_controls(struct ov2740 *ov2740)
 					   V4L2_CID_VBLANK, vblank_min,
 					   vblank_max, 1, vblank_default);
 
-	h_blank = to_pixels_per_line(cur_mode->hts, cur_mode->link_freq_index);
-	h_blank -= cur_mode->width;
+	h_blank = cur_mode->hts - cur_mode->width;
 	ov2740->hblank = v4l2_ctrl_new_std(ctrl_hdlr, &ov2740_ctrl_ops,
 					   V4L2_CID_HBLANK, h_blank, h_blank, 1,
 					   h_blank);
@@ -842,8 +832,7 @@ static int ov2740_set_format(struct v4l2_subdev *sd,
 				 mode->vts_min - mode->height,
 				 OV2740_VTS_MAX - mode->height, 1, vblank_def);
 	__v4l2_ctrl_s_ctrl(ov2740->vblank, vblank_def);
-	h_blank = to_pixels_per_line(mode->hts, mode->link_freq_index) -
-		mode->width;
+	h_blank = mode->hts - mode->width;
 	__v4l2_ctrl_modify_range(ov2740->hblank, h_blank, h_blank, 1, h_blank);
 
 	return 0;
-- 
2.43.0



