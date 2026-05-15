Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6840317C220;
	Fri, 15 May 2026 15:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860304; cv=none; b=l6jGToadUmSdE7Ygjwk6itbIKSalxliE5e3vOoDez0eG4sRHF4TI/OuYHkOruvh6k9cMOFUdYud87oU23ArWiNt1A88HguM/2gJhZQXrp560QfVOUUU4M/ne9uj8ZzD5lxksvB08d38YkiGVXkMD8W3Cx0nubuy5mAy4pa+BQnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860304; c=relaxed/simple;
	bh=N98viDCqjiotAej6uIOePU758pATPrKdhRygqQ3AqBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtYv0yO1qMmHHi95L2ttKeS2LYoM38iEBmul9v9aDA5MBCn6uwvOCRzQ2o1HMqudIBdTwdlyJjGC8NOw7lCDjtWvPEN6rTUd/zeXLEvU1Q3GngEFUVbmqaGMzJM33LTww8H+B7b6BPUYaLzrMJWdc03CNEQVg1rha6gKRPnX+i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KMp351An; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KMp351An"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C67C2BCB0;
	Fri, 15 May 2026 15:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860304;
	bh=N98viDCqjiotAej6uIOePU758pATPrKdhRygqQ3AqBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMp351AnsXUoPP6CDF7f+kPWm3MhJPQYYeSysD9aqS1mnJF7I6hBCAfkzrT/d8Wrt
	 aYWYMDnGhLhDq3KVfv5KCjHf5QwY7bBvwXeLgyBxyqw8+rpXwhgyotqlr1y8QzkSbC
	 txNZW9B/vEmfoF/ealoA08rsc9Xs5ZDeO/oIsRgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 037/144] media: omap3isp: drop the use count of v4l2 pipeline
Date: Fri, 15 May 2026 17:47:43 +0200
Message-ID: <20260515154654.378348277@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


