Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA74F1F1522;
	Mon, 23 Jun 2025 13:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684445; cv=none; b=MRVy2Q9Dh71nqACmuZ9e/gy0g86qnq3t/ZPyGtAhqo2da4Tx+9XJuH1KxHnlWPK3pXT0CgUY66GNclIpezE+Ca7GsrLPCi++dKEVPIrtNMZgD4Z7i1flLCVI3Fltn41/++PIgreCCgjJ0STbNEi89e6zbJNiZ94Kqw66FSCCqjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684445; c=relaxed/simple;
	bh=Agv1rhOS86S3ZLQsHQvq7ELEF+zP/RtOCKLf37HbDgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXvcFj+SttSWCW3bhJkXH5agpQJVluTArWzPO01I1iiItVJSDzZ54Jzumc6rWmcT1lFrUbcp4LArwbqmk+EHNl3OT4YGfcuMZC+zH2ZVwkgoxYxHDVFeYROCpSMSQW7vndeAupjhfihYH52b6E/mjrKkmqNJgAmKiCoek9Q7Nq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=szTp9uYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="szTp9uYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B94C4CEEA;
	Mon, 23 Jun 2025 13:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684445;
	bh=Agv1rhOS86S3ZLQsHQvq7ELEF+zP/RtOCKLf37HbDgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szTp9uYZtKATunhts973J0JMaYUXMzdP44wtbRmCiLSzTrXrH+8AGxw2NLgKSO3Nu
	 +IeEoaasVnRgomHQ91y0FnIr7vRa5nyF6PW9S5RUbC+bjyY44SwX4QFWRfUKSuWyKL
	 2jdVzIR+4Iz37hMcn/skHym7sI3/mU81HfYMXszw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 070/592] media: imagination: fix a potential memory leak in e5010_probe()
Date: Mon, 23 Jun 2025 15:00:28 +0200
Message-ID: <20250623130701.928209971@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <haoxiang_li2024@163.com>

commit 609ba05b9484856b08869f827a6edee51d51b5f3 upstream.

Add video_device_release() to release the memory allocated by
video_device_alloc() if something goes wrong.

Fixes: a1e294045885 ("media: imagination: Add E5010 JPEG Encoder driver")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/imagination/e5010-jpeg-enc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/imagination/e5010-jpeg-enc.c
+++ b/drivers/media/platform/imagination/e5010-jpeg-enc.c
@@ -1057,8 +1057,11 @@ static int e5010_probe(struct platform_d
 	e5010->vdev->lock = &e5010->mutex;
 
 	ret = v4l2_device_register(dev, &e5010->v4l2_dev);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to register v4l2 device\n");
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to register v4l2 device\n");
+		goto fail_after_video_device_alloc;
+	}
+
 
 	e5010->m2m_dev = v4l2_m2m_init(&e5010_m2m_ops);
 	if (IS_ERR(e5010->m2m_dev)) {
@@ -1118,6 +1121,8 @@ fail_after_video_register_device:
 	v4l2_m2m_release(e5010->m2m_dev);
 fail_after_v4l2_register:
 	v4l2_device_unregister(&e5010->v4l2_dev);
+fail_after_video_device_alloc:
+	video_device_release(e5010->vdev);
 	return ret;
 }
 


