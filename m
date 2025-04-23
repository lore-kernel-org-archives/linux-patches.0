Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B559280A20;
	Wed, 23 Apr 2025 15:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420793; cv=none; b=lVtMzXi6MXbN5X03W+Fd+CeXXNtS05TVR92uQ21Z9oF+vr49WrhBsDgI8AP57FMMYwKCOosr9sUsW4LhYdtwDotTz0UBhT+YfxoImjQFpTPUVxC+YBPOGErw0CNlTHDdkWYjeGex/q3lANmlVrhQaKMTg+r6l8ECa3nrJQ5SgxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420793; c=relaxed/simple;
	bh=n+9opHuQ8R+DmVz8/M1eQ4tgSITNNdyjVcoU7HZYyKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h1NvGppT3jkuGur1hEqvaIY6oUjFLwawQzN+i44bVBD8wAU5e+nDa/Xr1/87BV27IUwcGJzefW90/eUrFs8eM/eW5Bb7sYpKDZJ2hqa3wwWZU4rFpYxHG+Sq3YkRD8oljjtZpPadSrNCCd/9WUkAziAXugihU2Mkh1rzSIm3V6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPPNqLGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPPNqLGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF86FC4CEE3;
	Wed, 23 Apr 2025 15:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420793;
	bh=n+9opHuQ8R+DmVz8/M1eQ4tgSITNNdyjVcoU7HZYyKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPPNqLGUzPYs1tH4+zQ0JJcFDlBzxXvNeE1Z/vknf0cocGWF+MlhY3MFRVqSdDHW2
	 xhoQhZWO+YjHYswUaxhNZ/lRjaBxyqGDT5EK0alD7mGKZCmx5CtoAb4sUJy8IITBiq
	 AwHVOZ9CnMfK4i4u8EzdVazUhO4K13j9//l4Gzmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Majewski <mattwmajewski@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 081/291] media: vim2m: print device name after registering device
Date: Wed, 23 Apr 2025 16:41:10 +0200
Message-ID: <20250423142627.677661518@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Majewski <mattwmajewski@gmail.com>

commit 143d75583f2427f3a97dba62413c4f0604867ebf upstream.

Move the v4l2_info() call displaying the video device name after the
device is actually registered.

This fixes a bug where the driver was always displaying "/dev/video0"
since it was reading from the vfd before it was registered.

Fixes: cf7f34777a5b ("media: vim2m: Register video device after setting up internals")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Majewski <mattwmajewski@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/test-drivers/vim2m.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/media/test-drivers/vim2m.c
+++ b/drivers/media/test-drivers/vim2m.c
@@ -1316,9 +1316,6 @@ static int vim2m_probe(struct platform_d
 	vfd->v4l2_dev = &dev->v4l2_dev;
 
 	video_set_drvdata(vfd, dev);
-	v4l2_info(&dev->v4l2_dev,
-		  "Device registered as /dev/video%d\n", vfd->num);
-
 	platform_set_drvdata(pdev, dev);
 
 	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
@@ -1345,6 +1342,9 @@ static int vim2m_probe(struct platform_d
 		goto error_m2m;
 	}
 
+	v4l2_info(&dev->v4l2_dev,
+		  "Device registered as /dev/video%d\n", vfd->num);
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_m2m_register_media_controller(dev->m2m_dev, vfd,
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);


