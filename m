Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26C5A3FD968;
	Fri, 15 May 2026 16:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861963; cv=none; b=OjXcwsxj4MV/BdjAhOyuXPR0qNp4z/GtqC4KzXB5d1eSL2Mq8+i7BMUR5mF7PjqEO+riSlxJY946jjPKdIMR8HaRYsSBKuXrVPXlELliWKBWscxdlMiW3IsRpwpP1v/8Ncrn74zAFelG7RhKHGJCDio9yjcpEa37VBK2rJpiyXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861963; c=relaxed/simple;
	bh=19JEWahNg63/O0Imp/3M7yzSF0RXwJRhW3BnldonItI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KNCQylQkOyqPZ4B/C4psk4CiOkrMgEjsDaVeL+mpYKsRoiQ8IYmFA0pmKCAVqfgdMW1f0XOtvsbBMGDFCNipaf/8n4aI/6w6l61nt0XrsdIrk7P1/ph6UMPxIMYOjOKZ54YgmNLSDICk2kBcMkELqxWkzKDOjnggtnJKH6UIQHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJ5kpXHL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJ5kpXHL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F4EC2BCB0;
	Fri, 15 May 2026 16:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861963;
	bh=19JEWahNg63/O0Imp/3M7yzSF0RXwJRhW3BnldonItI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cJ5kpXHLzYPXoBfoZLA9yOGe3ROcnCudceDURx3hmS5EiaZ2hvS9kXhqcegnDHnVL
	 bONs1ya0UcZe8LTxlRK3i69vLdEbqQeMKP0r6iXzZbIF5pGeYJJzJeo/vyW0Y2jBw4
	 rpFE5HZjyu3+EJgXJ1htVkdOA84Rzi54uwI/yLbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.18 054/188] media: omap3isp: drop the use count of v4l2 pipeline
Date: Fri, 15 May 2026 17:47:51 +0200
Message-ID: <20260515154658.486729673@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1325,6 +1325,7 @@ static int isp_video_open(struct file *f
 
 	ret = vb2_queue_init(&handle->queue);
 	if (ret < 0) {
+		v4l2_pipeline_pm_put(&video->video.entity);
 		omap3isp_put(video->isp);
 		goto done;
 	}


