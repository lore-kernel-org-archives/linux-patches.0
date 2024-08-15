Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F45A1DDF5;
	Thu, 15 Aug 2024 13:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728551; cv=none; b=g5QTzGoaZOffYxPXe6RnWBx9Xb9McxzeI6cnju6qpSuQ24j9MYyOiGvdNJg0YWUU9N7aqZecIIDoGL+LVAo56tYHoa9SPJz9QIYbmqEMwbu7F/uXmAcVIcOzWw9A76qGvW8G8E3KlJGQLUXrDZ/itLZiKSV+spOXk3+d12hGTko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728551; c=relaxed/simple;
	bh=b5R042+uLZfeEhj1tuGCQ/sV5ApKDgv75n4JSjTdgKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNelFTYSa+6lXrSk3CBI1TJZEnxrT7586sxi988omncUYz4DBIJNbN6/N7l65P9S4n3rTgVn4mIOnuu13Q2Rg7HumUINQJi8TvfwAKoHavxFItDkWDW0Ry9dXId1dM02yLKuCYb14IGW/wX3ehbn2TkEO/MVdySdneiZAEjLeZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xo22mrmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xo22mrmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA619C32786;
	Thu, 15 Aug 2024 13:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728551;
	bh=b5R042+uLZfeEhj1tuGCQ/sV5ApKDgv75n4JSjTdgKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xo22mrmjLJ6qY06r9XjCJZScUaQDRwfK5XQ7cp1Tmke7Ce/wtq7qp0g0e/v47Kc6T
	 pxkPwEYdoCdZF9L19AsjGIg60sGcNG9rym8defBood02nBlq4t6Hq1bDgi6qxUORN4
	 mOCHT16GmamidAg75ovojP5PN4BKpwqkzgHA+6F0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 035/196] media: renesas: vsp1: Store RPF partition configuration per RPF instance
Date: Thu, 15 Aug 2024 15:22:32 +0200
Message-ID: <20240815131853.432080923@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit a213bc09b1025c771ee722ee341af1d84375db8a ]

The vsp1_partition structure stores the RPF partition configuration in a
single field for all RPF instances, while each RPF can have its own
configuration. Fix it by storing the configuration separately for each
RPF instance.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Fixes: ab45e8585182 ("media: v4l: vsp1: Allow entities to participate in the partition algorithm")
Reviewed-by: Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vsp1/vsp1_pipe.h | 2 +-
 drivers/media/platform/vsp1/vsp1_rpf.c  | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/vsp1/vsp1_pipe.h b/drivers/media/platform/vsp1/vsp1_pipe.h
index ae646c9ef3373..15daf35bda216 100644
--- a/drivers/media/platform/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/vsp1/vsp1_pipe.h
@@ -73,7 +73,7 @@ struct vsp1_partition_window {
  * @wpf: The WPF partition window configuration
  */
 struct vsp1_partition {
-	struct vsp1_partition_window rpf;
+	struct vsp1_partition_window rpf[VSP1_MAX_RPF];
 	struct vsp1_partition_window uds_sink;
 	struct vsp1_partition_window uds_source;
 	struct vsp1_partition_window sru;
diff --git a/drivers/media/platform/vsp1/vsp1_rpf.c b/drivers/media/platform/vsp1/vsp1_rpf.c
index abaf4dde3802d..a61b86861c64d 100644
--- a/drivers/media/platform/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/vsp1/vsp1_rpf.c
@@ -270,8 +270,8 @@ static void rpf_configure_partition(struct vsp1_entity *entity,
 	 * 'width' need to be adjusted.
 	 */
 	if (pipe->partitions > 1) {
-		crop.width = pipe->partition->rpf.width;
-		crop.left += pipe->partition->rpf.left;
+		crop.width = pipe->partition->rpf[rpf->entity.index].width;
+		crop.left += pipe->partition->rpf[rpf->entity.index].left;
 	}
 
 	if (pipe->interlaced) {
@@ -326,7 +326,9 @@ static void rpf_partition(struct vsp1_entity *entity,
 			  unsigned int partition_idx,
 			  struct vsp1_partition_window *window)
 {
-	partition->rpf = *window;
+	struct vsp1_rwpf *rpf = to_rwpf(&entity->subdev);
+
+	partition->rpf[rpf->entity.index] = *window;
 }
 
 static const struct vsp1_entity_operations rpf_entity_ops = {
-- 
2.43.0



