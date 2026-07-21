Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0DE404BF6;
	Tue, 21 Jul 2026 22:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673762; cv=none; b=CNVjNOyudJQ2au6CGaM0WTw9GSQZyyIcpLXYDd0FzuMhaI5K881Hw7gM221L5VevIEVcTpCQuFEPTJt891Eoszcmm6Rri50HzZy5tiUQ5MGmyGIkuNvQlTRdT4H569UKcb+CzdHzHMP4lji9WMPgDskjgE6nwNMmRdKy05v10+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673762; c=relaxed/simple;
	bh=MZae47QFM21FpDC/ZaLliq3xoG65OEbaiWe26tNMqKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNiCWHUENUf/sYXEE4ihgR81SNEOAeg8wimkzJQq8avJzFSlIWUhj/NEVNQ2JTEMTLvUuRTRD1OW0GmvpDQ1SqFsWR1KX0GVPLHAHP00qBRvpwnLeSy+8lRwXxYMOaolBMYaH3UgyUZGTr9W5WL06PiJ3DfXXFFG83uX4NcXAV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EnTwRJQK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EnTwRJQK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE2F1F00A3A;
	Tue, 21 Jul 2026 22:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673761;
	bh=qs1x3t0bpXV1jVvSYVuIup7EZ3uceq4ULDi8MHtiUmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EnTwRJQKr2MJE5IusitJkYM/CBovh6MFF4LvxbJCh0EWN1GrUhY5/mO1Dv06s/roV
	 Qg9WSWtSDHy4ftjsk5P0R9gTXbN6BUEY62zbYYBr1DrAQ6dDr6D156aMKQNO0E5BHb
	 Cj5KC+x7UM38fAmp5DePoBs6bZeVjsGYBadAk8QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 285/699] staging: most: video: avoid double free on video register failure
Date: Tue, 21 Jul 2026 17:20:44 +0200
Message-ID: <20260721152402.130540457@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 7cb1c5b32a2bfde961fff8d5204526b609bcb30a ]

comp_register_videodev() allocates a video_device with
video_device_alloc() and releases it if video_register_device() fails.

This can double free the video_device when __video_register_device()
reaches device_register() and that call fails:

  video_register_device()
    -> __video_register_device()
       -> device_register() fails
          -> put_device(&vdev->dev)
             -> v4l2_device_release()
                -> vdev->release(vdev)
                   -> video_device_release(vdev)

  comp_register_videodev()
    -> video_device_release(mdev->vdev)

Use video_device_release_empty() while registering the device so that
registration failure paths do not free mdev->vdev through vdev->release().
comp_register_videodev() then releases mdev->vdev exactly once on failure.
Restore video_device_release() after successful registration so the
registered device keeps its normal lifetime handling.

This issue was found by a static analysis tool I am developing.

Fixes: eab231c0398a ("staging: most: v4l2-aim: remove unnecessary label err_vbi_dev")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260517111218.945796-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/most/video/video.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/most/video/video.c b/drivers/staging/most/video/video.c
index 829df899b99303..f239c9a57d855a 100644
--- a/drivers/staging/most/video/video.c
+++ b/drivers/staging/most/video/video.c
@@ -416,6 +416,7 @@ static int comp_register_videodev(struct most_video_dev *mdev)
 
 	/* Fill the video capture device struct */
 	*mdev->vdev = comp_videodev_template;
+	mdev->vdev->release = video_device_release_empty;
 	mdev->vdev->v4l2_dev = &mdev->v4l2_dev;
 	mdev->vdev->lock = &mdev->lock;
 	snprintf(mdev->vdev->name, sizeof(mdev->vdev->name), "MOST: %s",
@@ -428,9 +429,13 @@ static int comp_register_videodev(struct most_video_dev *mdev)
 		v4l2_err(&mdev->v4l2_dev, "video_register_device failed (%d)\n",
 			 ret);
 		video_device_release(mdev->vdev);
+		return ret;
 	}
 
-	return ret;
+	mdev->vdev->release = video_device_release;
+
+	return 0;
+
 }
 
 static void comp_unregister_videodev(struct most_video_dev *mdev)
-- 
2.53.0



