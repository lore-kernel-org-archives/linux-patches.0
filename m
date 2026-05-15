Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7831E3E714A;
	Fri, 15 May 2026 16:28:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862500; cv=none; b=CRgNziWZiLvlmUv1S04+nDQk5aIV6d2vUZUPS1ylKEKfQ4KOgLCKJk/tyO/OjA35Ml2H/ryZeQn93Xo2+JymkgiLJqQd8pC2T0nN26zyYuYfju7pa+ttnHUb6Z/OpG4Ukh5qQ1uQXRpzoevG+bTq5ZnOc4KMfI5Tp0fBtT2oW+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862500; c=relaxed/simple;
	bh=GOXzpz1EMtQVi4wREn6uiZgtypvBeqz30jEgyo0E7a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KA9ap5zpqs97UR6YI+J+B2WnBJ7YcsmYRRfLO7kDQMZS91fIuuhYF004ecMsRUi9Z+nX5syoAntS/o7Zz50sdK1fuzB21SxWRXymbUWZaiSN6Ycgy/6Wx3HojL2A/tN8Sy+7SiJONqa/TEC3KW+nmNEWztUW4b5Jc0bVGoUrlUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRcIPUpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRcIPUpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D286C2BCB0;
	Fri, 15 May 2026 16:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862500;
	bh=GOXzpz1EMtQVi4wREn6uiZgtypvBeqz30jEgyo0E7a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRcIPUpU1ZCDjFINp5Rt/FSsJYyMDnWxR9y+DDI0nsM41hUlr/l7rWQRQxFZKiQBZ
	 DCniuDCjTU3wDu+4UIWQULVGH0OJ8Brw52FhDiyxiIz8zvZ4O7xf+zEuwPhPEOe3lu
	 CbfmoGAwt/Okcww3H6KvYTmxg2AeLWh2bqZHf3Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 7.0 071/201] media: omap3isp: drop the use count of v4l2 pipeline
Date: Fri, 15 May 2026 17:48:09 +0200
Message-ID: <20260515154700.071078914@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1403,6 +1403,7 @@ static int isp_video_open(struct file *f
 
 	ret = vb2_queue_init(&handle->queue);
 	if (ret < 0) {
+		v4l2_pipeline_pm_put(&video->video.entity);
 		omap3isp_put(video->isp);
 		goto done;
 	}


