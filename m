Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4D53BB12D;
	Fri, 15 May 2026 16:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861421; cv=none; b=Cl0fftx2lCkKbEkEtEEI1YpHUPF3WlUVGKYEYxUHl46h0XJJCJp84BApk66lIkUC0ftW/FqQF1CZnnIUgwU+lnNZL+baAp//ICU9EEhPiEs/tWS9SUzsviJ5BL7xUvrC2D2SB+jN2Z8ERVFZGCDYljvuzvgjtLXLByltqhOjV0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861421; c=relaxed/simple;
	bh=yNKwXe8fKNSx8rS0lSqMqqIpqr+8T9C/jIo7F23tvjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rYgqu0oPE4+bcPOEXb9MgOQ9c6IXAV0vSiihJcv06RWa3wHO1WLpaFyzwi3ck8JJHpSNXXbb4VOpxCAB5yEPK5GBWehcpyC82YEYjg34vkFzviT01sSg42Wz33Fyan4j0LZjEZTECvoOh4WP6I64AwGYEds8j6T2/VBIXS6epJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJ1ntM32; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJ1ntM32"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571E7C2BCB0;
	Fri, 15 May 2026 16:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861420;
	bh=yNKwXe8fKNSx8rS0lSqMqqIpqr+8T9C/jIo7F23tvjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJ1ntM32KXTcpzDZKyfHc5IDUPZEkYFJF8DZBTAfp5so93kCZ7vlpsCCS4YCbL8Vw
	 xxmO9uuE4AIwFvQLa/6FL6/DR6XSVl+W3YVBLPnemsGDWBx3wJRFSXKFD8tRMgd2lJ
	 cOs30f6oC/Hh6ElFtOhzCoCQEDtAg9XKSXrJSHiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.6 321/474] media: omap3isp: drop the use count of v4l2 pipeline
Date: Fri, 15 May 2026 17:47:10 +0200
Message-ID: <20260515154721.956679223@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>

commit 9da49bd9d4224035cff39b40d7395310abb10201 upstream.

In isp_video_open(), drop the use count of v4l2
pipeline if vb2_queue_init() fails.

Fixes: 8fd390b89cc8 ("media: Split v4l2_pipeline_pm_use into v4l2_pipeline_pm_{get, put}")
Cc: stable@vger.kernel.org
Signed-off-by: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/ti/omap3isp/ispvideo.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/platform/ti/omap3isp/ispvideo.c
+++ b/drivers/media/platform/ti/omap3isp/ispvideo.c
@@ -1324,6 +1324,7 @@ static int isp_video_open(struct file *f
 
 	ret = vb2_queue_init(&handle->queue);
 	if (ret < 0) {
+		v4l2_pipeline_pm_put(&video->video.entity);
 		omap3isp_put(video->isp);
 		goto done;
 	}


