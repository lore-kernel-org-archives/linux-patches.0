Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 239CA3FE2D;
	Mon,  1 Apr 2024 15:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986570; cv=none; b=IMCfS4IkwhAwD/n00oR5Kk2RX7DKnbTbRuz8oaA+iJ89pYUnKnw0aGDi46cro6GK5NNB+/NhnLGLki16V1b4frBSSPEWIScgSCzyC8VluWTtayEn3mgypZDCcZSpTP9/JQlxsSt/I0MkhqEfi5AkTKxiFAEPGIIVxdhckqSsIYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986570; c=relaxed/simple;
	bh=fNb4vA6+gwnk+wS1asmqYRQWkmN5be0xH9Ml/9UqGFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1UyU7SGGp2vBkypUgB5mlDhmFD24Is5zhxTDt42S/EwTKvuP3QpWmoGv1j/v3ZNm9xFB1Cfptn2/3laIAm/sR6VIar/tQa3NIVBxrkekVoUIg3yIzhhspuxm7CsL6Lb+nB2EuUfeh9KNyKscdzyUEJzVPkLMtcam+lF8K/4xss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lblNM7zi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lblNM7zi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4ABC433C7;
	Mon,  1 Apr 2024 15:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986569;
	bh=fNb4vA6+gwnk+wS1asmqYRQWkmN5be0xH9Ml/9UqGFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lblNM7ziY66qaV7b5U0cvR+85MHXcho6M1gvOZspsRnU8i0XhRxs5ZTE6x9kHbYYv
	 XAnarbBHBMdauktDRYIHBcmIoF5byWjQ7Grtl2TmR4RZQdcgrY7oOqV/l6XOWJOQSh
	 yt8iYNuJaItUdJ3hew02C3rrUSlkO09cGjAKTIX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 017/399] media: mc: Add local pad to pipeline regardless of the link state
Date: Mon,  1 Apr 2024 17:39:43 +0200
Message-ID: <20240401152549.675234572@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 78f0daa026d4c5e192d31801d1be6caf88250220 ]

When building pipelines by following links, the
media_pipeline_explore_next_link() function only traverses enabled
links. The remote pad of a disabled link is not added to the pipeline,
and neither is the local pad. While the former is correct as disabled
links should not be followed, not adding the local pad breaks processing
of the MEDIA_PAD_FL_MUST_CONNECT flag.

The MEDIA_PAD_FL_MUST_CONNECT flag is checked in the
__media_pipeline_start() function that iterates over all pads after
populating the pipeline. If the pad is not present, the check gets
skipped, rendering it useless.

Fix this by adding the local pad of all links regardless of their state,
only skipping the remote pad for disabled links.

Cc: stable@vger.kernel.org # 6.1
Fixes: ae219872834a ("media: mc: entity: Rewrite media_pipeline_start()")
Reported-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Closes: https://lore.kernel.org/linux-media/7658a15a-80c5-219f-2477-2a94ba6c6ba1@kontron.de
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/mc/mc-entity.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/mc/mc-entity.c b/drivers/media/mc/mc-entity.c
index 543a392f86357..a6f28366106fb 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -620,13 +620,6 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
 		link->source->entity->name, link->source->index,
 		link->sink->entity->name, link->sink->index);
 
-	/* Skip links that are not enabled. */
-	if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
-		dev_dbg(walk->mdev->dev,
-			"media pipeline: skipping link (disabled)\n");
-		return 0;
-	}
-
 	/* Get the local pad and remote pad. */
 	if (link->source->entity == pad->entity) {
 		local = link->source;
@@ -648,13 +641,20 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
 	}
 
 	/*
-	 * Add the local and remote pads of the link to the pipeline and push
-	 * them to the stack, if they're not already present.
+	 * Add the local pad of the link to the pipeline and push it to the
+	 * stack, if not already present.
 	 */
 	ret = media_pipeline_add_pad(pipe, walk, local);
 	if (ret)
 		return ret;
 
+	/* Similarly, add the remote pad, but only if the link is enabled. */
+	if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
+		dev_dbg(walk->mdev->dev,
+			"media pipeline: skipping link (disabled)\n");
+		return 0;
+	}
+
 	ret = media_pipeline_add_pad(pipe, walk, remote);
 	if (ret)
 		return ret;
-- 
2.43.0



