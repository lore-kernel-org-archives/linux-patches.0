Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F8547A6B;
	Mon,  1 Apr 2024 16:11:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987879; cv=none; b=aU2FYCZh0hLo/U7d1OfHiu7d/audu4TzURMiHSA+LlDWplOJ6/2L2OEhpDUJdLfzveyBcVCj/PmNjKNwuNnOcKWQrhsCStINBHzxOwIw8T6lkYcoqAOMTiF4asQ4who5qwUSnjTaAUSRjFuJYLD8MIEe9LKsFqMrV3yBv5dvHWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987879; c=relaxed/simple;
	bh=bHc4N2e3my83ykRWwAuAnq6AFt8Bog8VeCLbtCy7hR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rp1ATt+ZqKogL13mYRlqEgTUNDn6K1hIUKDQrGMLejUhEI2vbalVmZLYa2I0R6oIch+kYY9SMyDIN4K/nl9RQzQjjm7MbH0SFeTPG73J377VEvVvoooL2Rqhnz4VqKfilUz+/m7idTzMUNsYFsumRvzYcvrkQN5vm6+aKhQ09y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZAiMSM7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZAiMSM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A728EC433C7;
	Mon,  1 Apr 2024 16:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987879;
	bh=bHc4N2e3my83ykRWwAuAnq6AFt8Bog8VeCLbtCy7hR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZAiMSM7DxezOTUiRx9Gw8p7CXYddrQi/8szjUVQOwcnXHHHdQYMKlVYSeMlEwLX5
	 Yql2C7szLC7dWSDf0IHEWA1r+IHbtqh5/NQhO7UHUTz5qptxqoONRdnnRGI6mRa9A7
	 zKg4xAGr4ObrIS/AXp2ODyQkutupRZ98UT6Iv6gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 019/432] media: mc: Add local pad to pipeline regardless of the link state
Date: Mon,  1 Apr 2024 17:40:06 +0200
Message-ID: <20240401152553.701652013@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



