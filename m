Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01669DF6B;
	Mon,  1 Apr 2024 16:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989347; cv=none; b=WQidfvuX5o4GCNRP1wQh4TRCdBFSCMszq+L73BYwQa0KBb/Navm5k+hqriZG2TFlgC6RlmiSmTru2T/ncoLDX8ZLd54clQee0F0Vedv1t/GYiJC32pi1yGi69lY3QbBUnwXJMBJuLO7/Hj4I5cI2YMJGQEpHzJte7tgtdWYwbZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989347; c=relaxed/simple;
	bh=kSr7w6GlmUhw8+x59ZfJSjMburL1/oHr24kmUvChsK8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=geU0NPlEuHWkru9lZ25+VW8nNHWjLB35qvUYlkWzhv16GXB4pfl3Vq/k74iARK4QAhZfCpZM3KBKp+Ed3tM7xbe86VVKNQrVwbOlduJHXjB93UcOcZBB9M58EbWF8iGckFwNAClFqHQC5xEtwYvE14evXvPQAlai3qAS4Oac/4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FmiCzCm1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FmiCzCm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 604A7C433C7;
	Mon,  1 Apr 2024 16:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989346;
	bh=kSr7w6GlmUhw8+x59ZfJSjMburL1/oHr24kmUvChsK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FmiCzCm16MljdA9QP+nsTVQMt/l2o0eLPWeFbEFDiRVmE+vkODGQbiLMbCCajyQnW
	 wjzVbHkV/abjgBstLZM+sovJNddLVNK4///QTauqESaLBUk1lqbqqKcO9jGWZiUDRO
	 Z2z7ltN6ycMiP1JdME3NelQwvNipf9sT6qgeBlu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 021/396] media: mc: Add num_links flag to media_pad
Date: Mon,  1 Apr 2024 17:41:10 +0200
Message-ID: <20240401152548.530418591@linuxfoundation.org>
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
index 330d876f41945..c5f44cbf9f877 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -1025,6 +1025,9 @@ static void __media_entity_remove_link(struct media_entity *entity,
 
 	/* Remove the reverse links for a data link. */
 	if ((link->flags & MEDIA_LNK_FL_LINK_TYPE) == MEDIA_LNK_FL_DATA_LINK) {
+		link->source->num_links--;
+		link->sink->num_links--;
+
 		if (link->source->entity == entity)
 			remote = link->sink->entity;
 		else
@@ -1130,6 +1133,9 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
 	sink->num_links++;
 	source->num_links++;
 
+	link->source->num_links++;
+	link->sink->num_links++;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(media_create_pad_link);
diff --git a/include/media/media-entity.h b/include/media/media-entity.h
index 2b6cd343ee9e0..4d95893c89846 100644
--- a/include/media/media-entity.h
+++ b/include/media/media-entity.h
@@ -225,6 +225,7 @@ enum media_pad_signal_type {
  * @graph_obj:	Embedded structure containing the media object common data
  * @entity:	Entity this pad belongs to
  * @index:	Pad index in the entity pads array, numbered from 0 to n
+ * @num_links:	Number of links connected to this pad
  * @sig_type:	Type of the signal inside a media pad
  * @flags:	Pad flags, as defined in
  *		:ref:`include/uapi/linux/media.h <media_header>`
@@ -236,6 +237,7 @@ struct media_pad {
 	struct media_gobj graph_obj;	/* must be first field in struct */
 	struct media_entity *entity;
 	u16 index;
+	u16 num_links;
 	enum media_pad_signal_type sig_type;
 	unsigned long flags;
 
-- 
2.43.0



