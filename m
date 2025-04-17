Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 780C81DB148;
	Thu, 17 Apr 2025 18:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915655; cv=none; b=rv0eQbb9ibknzprMknE+jCQfHtk4Wip7fsJ0gpVJSmz1K7HMZaKKK89atBeNgBT7rnmvu6UT84F/vPMiZrKfqWUCoEXcMGEkyyEj2VOuqi2Ffh9i2TXqdY5kQ4qAis9qqWK5tFdoFbUlocHdgJ1bbkytdudxglXhnvczKqLLR9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915655; c=relaxed/simple;
	bh=9AM7jSlHk8hfkJK0iPcsxhKzX99xmI/QgbVEhcPTkeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9/Yk2d4jj2ncJBh9xgyr2FDCH94GHpvfJYgZsflKaKdSC1YuQxSRqRI4S0BeBJk2IeF7UekyvFfYUQ1BSEV1jBBZsjwSWKoDiPB6Z6nNSyr4zS/kSjdps1pZfV2CI6PxVs0mGbytX0lanqKCHqOPNyv4qebB5/sXUaKJfkZclo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mzgF9PvO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mzgF9PvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017CDC4CEE4;
	Thu, 17 Apr 2025 18:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915655;
	bh=9AM7jSlHk8hfkJK0iPcsxhKzX99xmI/QgbVEhcPTkeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mzgF9PvOU0hSL+8qn132ZA+FpHWuyqN5carFBm3zUM8BEXVCEHQILaOk6SXl23f69
	 bhVHqtQ42Vi1rb0wGpoPaw37EgCy7doYNB/H48hYODTzhb8VvgYDxIvZIRO2RPi1l9
	 f4qJGIxjfbWZuhvzp7jJgwZBuIfa/YwXPo3npvro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Majewski <mattwmajewski@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 198/393] media: vim2m: print device name after registering device
Date: Thu, 17 Apr 2025 19:50:07 +0200
Message-ID: <20250417175115.551531650@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


