Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033163FE2D;
	Mon,  1 Apr 2024 15:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986583; cv=none; b=BwF1A0Lt5HGZXo9RPgKxG0iCvJfTcwMhD8fKv9NnutnbX08DoGpOug5ZFxYKPSO2DPFM9DBywLD2TBhM0ylh62N8zqqpRhIfyX9w6te+VSeIEXIjJ60Wq82IY77NOlnhkjlJJKoDf7hRF5JXLZOzcAYM5t2M0Iz/ZAF/fBMfaeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986583; c=relaxed/simple;
	bh=0Enh3qACiypt45F1iVL8gvC9WYYTDeXDA9htkuL9l0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I0t9XUxKKoqsN+lpP65RkFGkfQTubeoHUrQo4x2CVu0rW365GMCLkuvYfPo4tPFPiZ4ri4wNEOFVfD7MhL7Va+OZN8xZwRTnkQtEv93xYVwIEWblkSUujJqWVOMHrcxR5dkh7c9JyQq4DfO8Nog3ZZbWctP6yJq2nDNv2py5I0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0hHxeyHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0hHxeyHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4697CC433F1;
	Mon,  1 Apr 2024 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986582;
	bh=0Enh3qACiypt45F1iVL8gvC9WYYTDeXDA9htkuL9l0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0hHxeyHYhv4hjvxyyy3PugMgvstL9Fip1hXrO06ybTnZdMEK03oPAPorK9MvfUnCO
	 fcCyOPYATvgPMaXR3dSn5ZHBM0aYd5rha2Evx6szqm1ycOi81XLriAhAkay6+A7q8+
	 255r52omK3TSh+OdWDSA+9lkjn3CkIChcYz/acXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 020/399] media: mc: Add num_links flag to media_pad
Date: Mon,  1 Apr 2024 17:39:46 +0200
Message-ID: <20240401152549.764700573@linuxfoundation.org>
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
index 7839e3f68efa4..c2d8f59b62c12 100644
--- a/drivers/media/mc/mc-entity.c
+++ b/drivers/media/mc/mc-entity.c
@@ -1038,6 +1038,9 @@ static void __media_entity_remove_link(struct media_entity *entity,
 
 	/* Remove the reverse links for a data link. */
 	if ((link->flags & MEDIA_LNK_FL_LINK_TYPE) == MEDIA_LNK_FL_DATA_LINK) {
+		link->source->num_links--;
+		link->sink->num_links--;
+
 		if (link->source->entity == entity)
 			remote = link->sink->entity;
 		else
@@ -1143,6 +1146,9 @@ media_create_pad_link(struct media_entity *source, u16 source_pad,
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



