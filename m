Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA555BA3F;
	Mon,  1 Apr 2024 16:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990741; cv=none; b=k4rIpJarOA22AoHrmVQJ1PTKlM3RGJROtfvi4vxWMzEbu2eNLxF9udhXj3q4Bh1/emGllkPFt1FJCz7XaKCFahgT3NJcVtIubupQOjHXsFi2XfXrUwQKZzeNRbDL0jR12JnmxSHQ4HBf/gbSXjNrWRqIU3Njhn2rnYzluT0godY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990741; c=relaxed/simple;
	bh=C3RmaAHeVCjZiIaFgzOxtTqLiUHooWMmtYxAZamd6oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nhGfBatmfGeICKXIJL4N9OYngIp4RTA1I6+t0YZUyck4y3f1GGNrUp00PZOODYMEETU446SJBTrST3xg8xBnZQdXbjag9V58XMFZagYZOqKXadU32Ik925dPXplrghm9TRr0kNSymcLTCYU+yNNuZzp8nn5r+JD5Vy5OxYJJCvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CzyUm8UC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CzyUm8UC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17166C433F1;
	Mon,  1 Apr 2024 16:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990741;
	bh=C3RmaAHeVCjZiIaFgzOxtTqLiUHooWMmtYxAZamd6oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CzyUm8UCvzTmBZ41xKMy2wA6PNXvUVwxfvM2xDWqp2yNYs8RMPFv+G0LPUmW14Yrf
	 fBwchX0tVVwlC6EKAHq74vd68InSwU2hreYJESnsjR8DFfCzu8PuHSWED4I4sWlDyz
	 Hraw6yAgFTVZlK0b0ZC5H/Ikc2RHp2xdBv9RU2f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/272] media: mc: Add num_links flag to media_pad
Date: Mon,  1 Apr 2024 17:43:33 +0200
Message-ID: <20240401152531.077127040@linuxfoundation.org>
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

[ Upstream commit baeddf94aa61879b118f2faa37ed126d772670cc ]

Maintain a counter of the links connected to a pad in the media_pad
structure. This helps checking if a pad is connected to anything, which
will be used in the pipeline building code.

Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/mc/mc-entity.c | 6 ++++++
 include/media/media-entity.h | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/media/mc/mc-entity.c b/drivers/media/mc/mc-entity.c
index 688780c8734d4..c7cb49205b017 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -957,6 +957,9 @@ static void __media_entity_remove_link(struct media_entity *entity,
 
 	/* Remove the reverse links for a data link. */
 	if ((link->flags & MEDIA_LNK_FL_LINK_TYPE) == MEDIA_LNK_FL_DATA_LINK) {
+		link->source->num_links--;
+		link->sink->num_links--;
+
 		if (link->source->entity == entity)
 			remote = link->sink->entity;
 		else
@@ -1068,6 +1071,9 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	sink->num_links++;
 	source->num_links++;
 
+	link->source->num_links++;
+	link->sink->num_links++;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(media_create_pad_link);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 28c9de8a1f348..03bb0963942bd 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -205,6 +205,7 @@ enum media_pad_signal_type {
  * @graph_obj:	Embedded structure containing the media object common data
  * @entity:	Entity this pad belongs to
  * @index:	Pad index in the entity pads array, numbered from 0 to n
+ * @num_links:	Number of links connected to this pad
  * @sig_type:	Type of the signal inside a media pad
  * @flags:	Pad flags, as defined in
  *		:ref:`include/uapi/linux/media.h <media_header>`
@@ -216,6 +217,7 @@ struct media_pad {
 	struct media_gobj graph_obj;	/* must be first field in struct */
 	struct media_entity *entity;
 	u16 index;
+	u16 num_links;
 	enum media_pad_signal_type sig_type;
 	unsigned long flags;
 
-- 
2.43.0



