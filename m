Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54DB917E90E;
	Mon, 27 May 2024 19:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837245; cv=none; b=nwrjn3Ey0DwNWR20RRY7PhayAK5eAvTKEcWyaH6Q66upgxX3tnC1vGz9/GXUUMRb3xIj1xVsa1Uw8Q9va1acL+m4ezDFwXFQqI15L+8cQ8MyKlReUg12DFm3Y+CUU7bgv2kvZPgPQ1f36wIH8jM3Ra8xmAM0toOy1azFzg30ZK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837245; c=relaxed/simple;
	bh=upUMbYVQywNyDBdZB3mNNtTKsSeDsNIiy80yRKSk0Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3mjfEoAslA4dIqud/Bu/eRZGJDe7l1GkRIbam9FFEvUGW4HOWo+rFIOwyi0ZPkJ0mvcvhrQ2NBwPtZz6L8jabJ6tzOfmAH1arLRHNSDXpWBklEPgSe6T3vMhhC3onxQANz+S9eoGhOGRHuNhtCI707isnrftmIpbNUUgmW5agc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edH+nf/n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edH+nf/n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD47C2BBFC;
	Mon, 27 May 2024 19:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837245;
	bh=upUMbYVQywNyDBdZB3mNNtTKsSeDsNIiy80yRKSk0Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edH+nf/nOxeea1Qjd8w7emQYKOzpSMQlW0mbE4qbnedDrz4S/4UmUCTrKYmoSO+6n
	 jFTwi4H3SoPoj7T125UDvN58RefdiLhMsaFe/cdPkg7fdShG3AeDqXva/4EIM4HDBI
	 i3L5MKLzl325ANTaxm7LfSUo7DPVlyB32TmH2nVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 324/427] media: v4l2-subdev: Fix stream handling for crop API
Date: Mon, 27 May 2024 20:56:11 +0200
Message-ID: <20240527185631.818815952@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 34d7bf1c8e59f5fbf438ee32c96389ebe41ca2e8 ]

When support for streams was added to the V4L2 subdev API, the
v4l2_subdev_crop structure was extended with a stream field, but the
field was not handled in the core code that translates the
VIDIOC_SUBDEV_[GS]_CROP ioctls to the selection API. Fix it.

Fixes: 2f91e10ee6fd ("media: subdev: add stream based configuration")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-subdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
index 4c6198c48dd61..45836f0a2b0a7 100644
--- a/drivers/media/v4l2-core/v4l2-subdev.c
+++ b/drivers/media/v4l2-core/v4l2-subdev.c
@@ -732,6 +732,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg,
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
+		sel.stream = crop->stream;
 		sel.target = V4L2_SEL_TGT_CROP;
 
 		rval = v4l2_subdev_call(
@@ -756,6 +757,7 @@ static long subdev_do_ioctl(struct file *file, unsigned int cmd, void *arg,
 		memset(&sel, 0, sizeof(sel));
 		sel.which = crop->which;
 		sel.pad = crop->pad;
+		sel.stream = crop->stream;
 		sel.target = V4L2_SEL_TGT_CROP;
 		sel.r = crop->rect;
 
-- 
2.43.0



