Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABC7250BFE;
	Tue, 29 Apr 2025 16:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945497; cv=none; b=V/dVu0j5bRBQ4iM6noNJxUsn2C10wkXqA03Q1jVoffr4iqRL948MrwIpm/Q7kY/GOO+BITUhzdqD/BlUpBtW5IQaQ7MCEMAVUsGHU4C/nCZUeg8PPzakHMM9Lwg8E2QEEbotrcazxUYuG05RsvaBj48qi73wGAvfLJVReg6MqIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945497; c=relaxed/simple;
	bh=ka/UBEC2E2g0VdOanmUzmWL4CGW209I9SCS2A13GOW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kU1tA/88+HCDd3JTCt6unbe/vZwFa8foxIRVSwCO4GD4qXeHmnC71rdhCs6NKyEZFaifI66Yy2J5TTUydK5sgUN3OAomHaC0QWsltrYaAiMOCvm8yIn5R0SOEeMFgARvEGCyFDGIL1tD1nATZO8w6mZURLpC/evqtSLqkhlIJ0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tq2PKN2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tq2PKN2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993C5C4CEE9;
	Tue, 29 Apr 2025 16:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945497;
	bh=ka/UBEC2E2g0VdOanmUzmWL4CGW209I9SCS2A13GOW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tq2PKN2IAnYaZHf5GAkzDMJHz4LPqNz4EZxxNdtlrTRyRB/qDNxPNBglPxrBoZKIg
	 8/A9kUZR+XZuEfsL9U9PYKOhJsOtsXbMT23bWDh7B6Yg9MT2MMDH9ppoDoA54GTFaQ
	 vEt7ijLU9TBw7Kjtr4iqODGmDTX3lckZA0IhinUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Majewski <mattwmajewski@gmail.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/179] media: vim2m: print device name after registering device
Date: Tue, 29 Apr 2025 18:41:14 +0200
Message-ID: <20250429161054.776090847@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Majewski <mattwmajewski@gmail.com>

[ Upstream commit 143d75583f2427f3a97dba62413c4f0604867ebf ]

Move the v4l2_info() call displaying the video device name after the
device is actually registered.

This fixes a bug where the driver was always displaying "/dev/video0"
since it was reading from the vfd before it was registered.

Fixes: cf7f34777a5b ("media: vim2m: Register video device after setting up internals")
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Majewski <mattwmajewski@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vim2m.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/platform/vim2m.c b/drivers/media/platform/vim2m.c
index 6fba00e03c67b..10c9e8026d981 100644
--- a/drivers/media/platform/vim2m.c
+++ b/drivers/media/platform/vim2m.c
@@ -1334,9 +1334,6 @@ static int vim2m_probe(struct platform_device *pdev)
 	vfd->v4l2_dev = &dev->v4l2_dev;
 
 	video_set_drvdata(vfd, dev);
-	v4l2_info(&dev->v4l2_dev,
-		  "Device registered as /dev/video%d\n", vfd->num);
-
 	platform_set_drvdata(pdev, dev);
 
 	dev->m2m_dev = v4l2_m2m_init(&m2m_ops);
@@ -1363,6 +1360,9 @@ static int vim2m_probe(struct platform_device *pdev)
 		goto error_m2m;
 	}
 
+	v4l2_info(&dev->v4l2_dev,
+		  "Device registered as /dev/video%d\n", vfd->num);
+
 #ifdef CONFIG_MEDIA_CONTROLLER
 	ret = v4l2_m2m_register_media_controller(dev->m2m_dev, vfd,
 						 MEDIA_ENT_F_PROC_VIDEO_SCALER);
-- 
2.39.5



