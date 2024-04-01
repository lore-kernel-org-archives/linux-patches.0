Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CE4A1E86C;
	Mon,  1 Apr 2024 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990748; cv=none; b=qriLzfMYCSEoqiUilUnIxzFPAHHExK6Wu+Eq0j/9ulzYhlrVGsDNKmb1iM8PGvVTnr/ZzU8hWE99JMnvca6VKbcv5EYs6+/o8FpEMGqjNN9AXv0zm7qbZdrn+9XoAT/ldyzrwLC+T4LwKRXhw49zpk5VDx55n38jvGnAZRHiBLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990748; c=relaxed/simple;
	bh=VXo3lRpDELA2XyjxSJn7CNUQSa8oYi1uvYz0ePDe2jk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B889gUBqeBBQYR9IrYsA+T19WWU8W8lfPORfv9VxVs0jsiQB4fSQThMWETnfXgFDlxnx7j7movpa05ma/P9qd0gK6/ZAeLJYvivTR8ibAmYb0C7DCyLam47QSOvDUfmpz7OxdBSEpo+FxmdJdt8z11rqTyO334b/yZFY6MfNlgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z/bDDePK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z/bDDePK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BF9DC433F1;
	Mon,  1 Apr 2024 16:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990748;
	bh=VXo3lRpDELA2XyjxSJn7CNUQSa8oYi1uvYz0ePDe2jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/bDDePKFJJq8LQsY7JnJ/TbNn3Cp4f4zOn54DTO30HrS1pqUFS9puphe47yVO3Lq
	 OrTqFt0x9aNIgGgnHReoqwWf/clXBgPIMjtvaZlesGbL/rQpUWEgsSvoVBmcv5uNqE
	 3kk15sGCB34WbNhBf3/0Rnr+2nZqb0z93YR0HK9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/272] media: mc: Expand MUST_CONNECT flag to always require an enabled link
Date: Mon,  1 Apr 2024 17:43:35 +0200
Message-ID: <20240401152531.138812106@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit b3decc5ce7d778224d266423b542326ad469cb5f ]

The MEDIA_PAD_FL_MUST_CONNECT flag indicates that the pad requires an
enabled link to stream, but only if it has any link at all. This makes
little sense, as if a pad is part of a pipeline, there are very few use
cases for an active link to be mandatory only if links exist at all. A
review of in-tree drivers confirms they all need an enabled link for
pads marked with the MEDIA_PAD_FL_MUST_CONNECT flag.

Expand the scope of the flag by rejecting pads that have no links at
all. This requires modifying the pipeline build code to add those pads
to the pipeline.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/mediactl/media-types.rst            | 11 ++--
 drivers/media/mc/mc-entity.c                  | 53 +++++++++++++++----
 2 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/Documentation/userspace-api/media/mediactl/media-types.rst b/Documentation/userspace-api/media/mediactl/media-types.rst
index 0ffeece1e0c8e..6332e8395263b 100644
--- a/Documentation/userspace-api/media/mediactl/media-types.rst
+++ b/Documentation/userspace-api/media/mediactl/media-types.rst
@@ -375,12 +375,11 @@ Types and flags used to represent the media graph elements
 	  are origins of links.
 
     *  -  ``MEDIA_PAD_FL_MUST_CONNECT``
-       -  If this flag is set and the pad is linked to any other pad, then
-	  at least one of those links must be enabled for the entity to be
-	  able to stream. There could be temporary reasons (e.g. device
-	  configuration dependent) for the pad to need enabled links even
-	  when this flag isn't set; the absence of the flag doesn't imply
-	  there is none.
+       -  If this flag is set, then for this pad to be able to stream, it must
+	  be connected by at least one enabled link. There could be temporary
+	  reasons (e.g. device configuration dependent) for the pad to need
+	  enabled links even when this flag isn't set; the absence of the flag
+	  doesn't imply there is none.
 
 
 One and only one of ``MEDIA_PAD_FL_SINK`` and ``MEDIA_PAD_FL_SOURCE``
diff --git a/drivers/media/mc/mc-entity.c b/drivers/media/mc/mc-entity.c
index 50b68b4dde5d0..8919df09e3e8d 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -509,14 +509,15 @@ static int media_pipeline_walk_push(struct media_pipeline_walk *walk,
 
 /*
  * Move the top entry link cursor to the next link. If all links of the entry
- * have been visited, pop the entry itself.
+ * have been visited, pop the entry itself. Return true if the entry has been
+ * popped.
  */
-static void media_pipeline_walk_pop(struct media_pipeline_walk *walk)
+static bool media_pipeline_walk_pop(struct media_pipeline_walk *walk)
 {
 	struct media_pipeline_walk_entry *entry;
 
 	if (WARN_ON(walk->stack.top < 0))
-		return;
+		return false;
 
 	entry = media_pipeline_walk_top(walk);
 
@@ -526,7 +527,7 @@ static void media_pipeline_walk_pop(struct media_pipeline_walk *walk)
 			walk->stack.top);
 
 		walk->stack.top--;
-		return;
+		return true;
 	}
 
 	entry->links = entry->links->next;
@@ -534,6 +535,8 @@ static void media_pipeline_walk_pop(struct media_pipeline_walk *walk)
 	dev_dbg(walk->mdev->dev,
 		"media pipeline: moved entry %u to next link\n",
 		walk->stack.top);
+
+	return false;
 }
 
 /* Free all memory allocated while walking the pipeline. */
@@ -583,11 +586,12 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
 	struct media_link *link;
 	struct media_pad *local;
 	struct media_pad *remote;
+	bool last_link;
 	int ret;
 
 	origin = entry->pad;
 	link = list_entry(entry->links, typeof(*link), list);
-	media_pipeline_walk_pop(walk);
+	last_link = media_pipeline_walk_pop(walk);
 
 	dev_dbg(walk->mdev->dev,
 		"media pipeline: exploring link '%s':%u -> '%s':%u\n",
@@ -612,7 +616,7 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
 					   local->index)) {
 		dev_dbg(walk->mdev->dev,
 			"media pipeline: skipping link (no route)\n");
-		return 0;
+		goto done;
 	}
 
 	/*
@@ -627,13 +631,44 @@ static int media_pipeline_explore_next_link(struct media_pipeline *pipe,
 	if (!(link->flags & MEDIA_LNK_FL_ENABLED)) {
 		dev_dbg(walk->mdev->dev,
 			"media pipeline: skipping link (disabled)\n");
-		return 0;
+		goto done;
 	}
 
 	ret = media_pipeline_add_pad(pipe, walk, remote);
 	if (ret)
 		return ret;
 
+done:
+	/*
+	 * If we're done iterating over links, iterate over pads of the entity.
+	 * This is necessary to discover pads that are not connected with any
+	 * link. Those are dead ends from a pipeline exploration point of view,
+	 * but are still part of the pipeline and need to be added to enable
+	 * proper validation.
+	 */
+	if (!last_link)
+		return 0;
+
+	dev_dbg(walk->mdev->dev,
+		"media pipeline: adding unconnected pads of '%s'\n",
+		local->entity->name);
+
+	media_entity_for_each_pad(origin->entity, local) {
+		/*
+		 * Skip the origin pad (already handled), pad that have links
+		 * (already discovered through iterating over links) and pads
+		 * not internally connected.
+		 */
+		if (origin == local || !local->num_links ||
+		    !media_entity_has_pad_interdep(origin->entity, origin->index,
+						   local->index))
+			continue;
+
+		ret = media_pipeline_add_pad(pipe, walk, local);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
@@ -745,7 +780,6 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
 		struct media_pad *pad = ppad->pad;
 		struct media_entity *entity = pad->entity;
 		bool has_enabled_link = false;
-		bool has_link = false;
 		struct media_link *link;
 
 		dev_dbg(mdev->dev, "Validating pad '%s':%u\n", pad->entity->name,
@@ -775,7 +809,6 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
 			/* Record if the pad has links and enabled links. */
 			if (link->flags & MEDIA_LNK_FL_ENABLED)
 				has_enabled_link = true;
-			has_link = true;
 
 			/*
 			 * Validate the link if it's enabled and has the
@@ -813,7 +846,7 @@ __must_check int __media_pipeline_start(struct media_pad *pad,
 		 * 3. If the pad has the MEDIA_PAD_FL_MUST_CONNECT flag set,
 		 * ensure that it has either no link or an enabled link.
 		 */
-		if ((pad->flags & MEDIA_PAD_FL_MUST_CONNECT) && has_link &&
+		if ((pad->flags & MEDIA_PAD_FL_MUST_CONNECT) &&
 		    !has_enabled_link) {
 			dev_dbg(mdev->dev,
 				"Pad '%s':%u must be connected by an enabled link\n",
-- 
2.43.0



