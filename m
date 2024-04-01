Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FAD31C0DE7;
	Mon,  1 Apr 2024 16:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989333; cv=none; b=JSDkwHSLxqkbH3VlEVU/BwXtlzGWFqzhHINjNcx5QbJ/r+pN6q4iNxbOoSERRpvVQClqHwnfxmBbn6D7ijOpXEAkrjm/Swrp5p+nsZLkkJyOlk3dYxnrl4wg/Oguz/yTz7JmcyvkST8C4A5XQuh390L70dg3S6xaiUp5Q7mwfKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989333; c=relaxed/simple;
	bh=c20IKd11Rj+mtVfZu1VbieGN49wG9EXrqREe5UIXMjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uHizk2BUeC5fzFz9M0z1JeHCz2M3hLebq3xfYz4+JgcctfaJmn5pIa+YNhJCqV/w0jqMeB1VYnbZ4JmTRUjzeAmGMDF07GydqFR3m3n4kTKlg4YBpPuS+2QVb7vhQv30lnSc4JOaJQRblAY4ggL+A6UhEapV437T/7kyCIpJNKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blJJxU5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blJJxU5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BB28C433C7;
	Mon,  1 Apr 2024 16:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989332;
	bh=c20IKd11Rj+mtVfZu1VbieGN49wG9EXrqREe5UIXMjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blJJxU5xbK1iCjJjfNEzlP8iBvp+8pFAW2xMdvu7yWXmya4N5ja5lbwrunf0+14Kd
	 UkXB4gC/R3dqdCsR/KEUuxUBYrFSVRn9Zaqt/I8S0I9gmDjRxElqPwdJnt4bgjRtqa
	 H/ljwYawmHPCJGAm0mDooJ+FXn1pCofsJgK99E6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/396] media: mc: Add local pad to pipeline regardless of the link state
Date: Mon,  1 Apr 2024 17:41:07 +0200
Message-ID: <20240401152548.437672472@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 83468d4a440b3..737fc14e92dd3 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -607,13 +607,6 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
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
@@ -635,13 +628,20 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
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



