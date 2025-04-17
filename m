Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AD652580F2;
	Thu, 17 Apr 2025 18:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913126; cv=none; b=pdNlCnZluIv5MQ4Xfk66rKhrdtsBzlZ2zwdakgMuBmR9yIzy85qxkMBI4Vt923l4Dw8KvofyyHs4HYc6yQll/AGHy1H1KMt6sxDe+iRQCiA4pxeaPvISa6drMM//09asl8U5hdIDm+tX6JYTPCLlKcij3VJtQPePpWkLOyf+KQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913126; c=relaxed/simple;
	bh=r2M8wVlPr+1Z3sBVq88o21cfEbqlen8xylXr9t3n8mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u/cbnLNlMXc6PoHolDi3LXGP0TJgbvXgVGHx9mgCIgTZPaaCE3GVxPZi4FJL7v4xI+EeslTfCvvpTNNDkIfGJt1R5enAL/LZ8vTc+Q6c+xrSopzNEFIpRLSWMoGUcS2p/TCVYu/2ADLSA2qdm8XDJ3q7oaM1wT8f6bnLlyjxExU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qpQW8Lbp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qpQW8Lbp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A045C4CEE4;
	Thu, 17 Apr 2025 18:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913126;
	bh=r2M8wVlPr+1Z3sBVq88o21cfEbqlen8xylXr9t3n8mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qpQW8Lbpg1QBvYAgQBjT9xM9Ow7FceBu7UHa57CIt1/jk+8ugQpViDfoPiYHb2uTa
	 bYKtufQIS7iI25Ml/7Sbmxx9TLilEj2lJa8puA0L5ZpMcukGPaty/A7/lQXaPoVTb5
	 2ccomJqX9zlFnY+odnLpixi0Yd4TXmJYIYVAV5W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Majewski <mattwmajewski@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 228/449] media: vim2m: print device name after registering device
Date: Thu, 17 Apr 2025 19:48:36 +0200
Message-ID: <20250417175127.172679743@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1314,9 +1314,6 @@ static int vim2m_probe(struct platform_d
 	vfd->v4l2_dev = &dev->v4l2_dev;
 
 	video_set_drvdata(vfd, dev);
-	v4l2_info(&dev->v4l2_dev,
-		  "Device registered as /dev/video%d\n", vfd->num);
-
 	platform_set_drvdata(pdev, dev);
 
 	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
@@ -1343,6 +1340,9 @@ static int vim2m_probe(struct platform_d
 		goto error_m2m;
 	}
 
+	v4l2_info(&dev->v4l2_dev,
+		  "Device registered as /dev/video%d\n", vfd->num);
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_m2m_register_media_controller(dev->m2m_dev, vfd,
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);


