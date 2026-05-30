Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B7F32B11D;
	Sat, 30 May 2026 17:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160661; cv=none; b=YRusSSnBvbHJAO7ilM/AnjpwyS5DkbfL7o6OM1wFMJiCAtzIIJep7rt3cdrJVM4H4WB4QhQVUSc5Doq2Xe7QZuSZmlRLSESh+9c4xBSXXIZBjvk6M8DCz85Gql6kloAPIe6RBhJ6JSRspIYa9Y4SBzuoRzhtpMoipIXS4iVitDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160661; c=relaxed/simple;
	bh=pFxI0Yj6i1JglaoY07Zodp9qTfcLqWYMPW8o8qy103E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuKVNfyoT7626KplweY4HymNZj+vUao14B2l2r5Ml0OR574FTvZZ6q1gO0liFOw6iu8uSPy+qXlKmmoy7TYA2uOiUj2qM4ZAgV1IHW2FiKoRROlZx4n+vIpxIXQNmbwd7u2He4pNiiUL7oA/I7e2Ypszt+2Q3eNyO2b7rD66w1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1fdkCv2u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1fdkCv2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACBA1F00893;
	Sat, 30 May 2026 17:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160660;
	bh=PU7BTLBQSbmfxlvn9HqqY34WLFxAsZ0Gm35ULwDdYa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1fdkCv2umafWoO2JAR72hllIdDM6u2Jul7S/ZmtfawiZyab8ODdU9xQ9OlU0tnxEe
	 Cx23nAJSkyJ8BDgq/8f98Ld9JohlBSPXF3abcC9zdVJTy6tJiw7Ij74e/OAhrGANqh
	 2rvnDETTpsft3PIvjbl6IBfNq7NNEkpyiAq2Y7Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 398/969] media: omap3isp: drop the use count of v4l2 pipeline
Date: Sat, 30 May 2026 17:58:42 +0200
Message-ID: <20260530160311.282816602@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1328,6 +1328,7 @@ static int isp_video_open(struct file *f
 
 	ret = vb2_queue_init(&handle->queue);
 	if (ret < 0) {
+		v4l2_pipeline_pm_put(&video->video.entity);
 		omap3isp_put(video->isp);
 		goto done;
 	}


