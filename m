Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C8E8292B4B;
	Fri,  3 Oct 2025 16:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507608; cv=none; b=YAwzBqsD+p11iJD2w/M8XP8donVb1h80aZcaHE1R17TIXw9xh0Z3/P1N9pKuu1XwTr8/3yXmZ0H/kUsR6AqrovwiXDY5AK6H+ZN1PL28Z+Q16quuv+Uc0u9cdZAdO51J3jhoMUW5y0ewerlcaTQjMwWcHvqJy5v2xhUNVdCkHe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507608; c=relaxed/simple;
	bh=350Ru3kijzasbbHsB848GNw1DVNM81vzuKk/JMNAKjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VK8BaHAarB6DoDm8FpdjV4jDyz5vhsqimqqCGxPxfTjksBhVIlvy1YMXCjbet7jijSx9ktSjLlbCFp5Q6qNmUnaRb9FsJr0hsfy/Uf+Cc/tTOxAtUbSgFhwVEvffXwjbh/OPpf27FobmEo/P0rgWdPI3+taZ3HA/dRIusiZ90f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZB8HKHy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZB8HKHy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7940CC4CEF5;
	Fri,  3 Oct 2025 16:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507607;
	bh=350Ru3kijzasbbHsB848GNw1DVNM81vzuKk/JMNAKjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZB8HKHy58JcSBEFmudtz3kSpmvhd7UkvI2MZlRAixv2i/orMRLPD6MYBs/1vDDv0
	 l9g6dYCYnqmOCfMlbtoPBRoSOWWP8ZVgO9CdF0cCVXx9qmk5K7PVqdfuaUPhANG6ol
	 aSILD5xv/6gb2Ff0tFSd5fF9p8lnLOUpM7gxzQho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandra Mohan Sundar <chandramohan.explore@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.17 14/15] media: stm32-csi: Fix dereference before NULL check
Date: Fri,  3 Oct 2025 18:05:38 +0200
Message-ID: <20251003160400.402586601@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
References: <20251003160359.831046052@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandra Mohan Sundar <chandramohan.explore@gmail.com>

commit 80eaf32672871bd2623ce6ba13ffc1f018756580 upstream.

In 'stm32_csi_start', 'csidev->s_subdev' is dereferenced directly while
assigning a value to the 'src_pad'. However the same value is being
checked against NULL at a later point of time indicating that there
are chances that the value can be NULL.

Move the dereference after the NULL check.

Fixes: e7bad98c205d1 ("media: v4l: Convert the users of v4l2_get_link_freq to call it on a pad")
Cc: stable@vger.kernel.org
Signed-off-by: Chandra Mohan Sundar <chandramohan.explore@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/st/stm32/stm32-csi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/st/stm32/stm32-csi.c
+++ b/drivers/media/platform/st/stm32/stm32-csi.c
@@ -443,8 +443,7 @@ static void stm32_csi_phy_reg_write(stru
 static int stm32_csi_start(struct stm32_csi_dev *csidev,
 			   struct v4l2_subdev_state *state)
 {
-	struct media_pad *src_pad =
-		&csidev->s_subdev->entity.pads[csidev->s_subdev_pad_nb];
+	struct media_pad *src_pad;
 	const struct stm32_csi_mbps_phy_reg *phy_regs = NULL;
 	struct v4l2_mbus_framefmt *sink_fmt;
 	const struct stm32_csi_fmts *fmt;
@@ -466,6 +465,7 @@ static int stm32_csi_start(struct stm32_
 	if (!csidev->s_subdev)
 		return -EIO;
 
+	src_pad = &csidev->s_subdev->entity.pads[csidev->s_subdev_pad_nb];
 	link_freq = v4l2_get_link_freq(src_pad,
 				       fmt->bpp, 2 * csidev->num_lanes);
 	if (link_freq < 0)


