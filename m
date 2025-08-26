Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064DB2BE653;
	Tue, 26 Aug 2025 11:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207334; cv=none; b=URoQHQDCyZYj6QDPodkwvGDZW7GZdlQetzV2NTDVQdjIyZzSFWSTCqQHoortPwZIseLnaQM6TcsJXW49ZnP/HB0euhPud69JTzMQuwV4pLOVnJsUvbsuR+SjodE7ULzHKPM6ydWfQyAhbwmc6T0UbpgDuztmO18u+sGMJn5MFUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207334; c=relaxed/simple;
	bh=BH/QX/eaU2DoyOfllgy2QxivmR1bCgV23Ey0r5iQOTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+li9ECtyLJZJFYetGwl4IMADtGfxQjaG62Xzm80YGMkCyt7lRxtK7kpxl1PekyQptXLl2dQNwymmCujiw8elvYqaiKW7seNkQlk2oImprT0mqE7PhI1ZLRouufJpBc3/hHMSvUQaLe090pTOj7pQzWq2s1TK8KZEq3q0XOO0wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SrOHZIyJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SrOHZIyJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9696FC4CEF1;
	Tue, 26 Aug 2025 11:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207333;
	bh=BH/QX/eaU2DoyOfllgy2QxivmR1bCgV23Ey0r5iQOTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrOHZIyJY5E17uOB23hvofsOklSTrAtantuZiHC1zKoubpdCU+L4SPEkod9EVniKo
	 G2moT6LBn2GgDlKVLfcaV+jvMuOCzgYzU6I2fBT3CiRUvaYiqOtZ7q1ZSrHZiC1yd0
	 pFZXxg9fTQ3phiGxgx59p58PrxGGR5pziQRc7DGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathis Foerst <mathis.foerst@mt.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.16 141/457] media: mt9m114: Fix deadlock in get_frame_interval/set_frame_interval
Date: Tue, 26 Aug 2025 13:07:05 +0200
Message-ID: <20250826110940.859971088@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathis Foerst <mathis.foerst@mt.com>

commit 298d1471cf83d5a2a05970e41822a2403f451086 upstream.

Getting / Setting the frame interval using the V4L2 subdev pad ops
get_frame_interval/set_frame_interval causes a deadlock, as the
subdev state is locked in the [1] but also in the driver itself.

In [2] it's described that the caller is responsible to acquire and
release the lock in this case. Therefore, acquiring the lock in the
driver is wrong.

Remove the lock acquisitions/releases from mt9m114_ifp_get_frame_interval()
and mt9m114_ifp_set_frame_interval().

[1] drivers/media/v4l2-core/v4l2-subdev.c - line 1129
[2] Documentation/driver-api/media/v4l2-subdev.rst

Fixes: 24d756e914fc ("media: i2c: Add driver for onsemi MT9M114 camera sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Mathis Foerst <mathis.foerst@mt.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/mt9m114.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/media/i2c/mt9m114.c
+++ b/drivers/media/i2c/mt9m114.c
@@ -1599,13 +1599,9 @@ static int mt9m114_ifp_get_frame_interva
 	if (interval->which != V4L2_SUBDEV_FORMAT_ACTIVE)
 		return -EINVAL;
 
-	mutex_lock(sensor->ifp.hdl.lock);
-
 	ival->numerator = 1;
 	ival->denominator = sensor->ifp.frame_rate;
 
-	mutex_unlock(sensor->ifp.hdl.lock);
-
 	return 0;
 }
 
@@ -1624,8 +1620,6 @@ static int mt9m114_ifp_set_frame_interva
 	if (interval->which != V4L2_SUBDEV_FORMAT_ACTIVE)
 		return -EINVAL;
 
-	mutex_lock(sensor->ifp.hdl.lock);
-
 	if (ival->numerator != 0 && ival->denominator != 0)
 		sensor->ifp.frame_rate = min_t(unsigned int,
 					       ival->denominator / ival->numerator,
@@ -1639,8 +1633,6 @@ static int mt9m114_ifp_set_frame_interva
 	if (sensor->streaming)
 		ret = mt9m114_set_frame_rate(sensor);
 
-	mutex_unlock(sensor->ifp.hdl.lock);
-
 	return ret;
 }
 


