Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E014155CB3;
	Tue, 30 Jul 2024 16:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358090; cv=none; b=bVHaC4+nsy0xY1EOsRPN8aTiVSg1L2u+F1GjnqXu8c2WIxNN9tv0x1Ic7soVPDRne9E6039QrgUtcJyyGXVqxmDXHURd2cx5wVTHreBrbfL3VsTnlaIJxbVOBQBfa+iFEsNEgZkWrkTz2neFZlXegwgNF8To65S+YKEqDH/ktos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358090; c=relaxed/simple;
	bh=HlTAdkCozNnzI4QKcNotqhjqsDok/ELjtrGhSWyGOa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hnvSGoNochJFdN0gQPQPdd0pip8cq5pBkgXWKp0j/Xzes5IKgHzFMDrWvDy/ogiNHkrMltJ1E0mUcaXMtavg5muO+y36LtXlCkje4xEfDGeUo3+38eBiTUH1peiqOvwZH/NWzegCk+QzsmKi0g2loBSIClHiEE7Wqh1VFzs8xxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bwyhg1jJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bwyhg1jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B039C32782;
	Tue, 30 Jul 2024 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358090;
	bh=HlTAdkCozNnzI4QKcNotqhjqsDok/ELjtrGhSWyGOa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bwyhg1jJXiZJnoz7HECbfb+/eA5MLjjbrKT/jX07hTZtx18eVror+q2BezRbimLoz
	 L9h/UEpXaVeI2WxV2txLMkVtbM3aFjGldBUGEXo/6i7RIB3hSzN2hLS5/XZ+KiA5XG
	 12sCpuzz4rq0PYNCWUBGDRc9zHvr1TVOr3SnOWrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 322/809] media: renesas: vsp1: Store RPF partition configuration per RPF instance
Date: Tue, 30 Jul 2024 17:43:18 +0200
Message-ID: <20240730151737.324193323@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/media/platform/renesas/vsp1/vsp1_pipe.h | 2 +-
 drivers/media/platform/renesas/vsp1/vsp1_rpf.c  | 8 +++++---
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/media/platform/renesas/vsp1/vsp1_pipe.h b/drivers/media/platform/renesas/vsp1/vsp1_pipe.h
index 674b5748d929e..85ecd53cda495 100644
--- a/drivers/media/platform/renesas/vsp1/vsp1_pipe.h
+++ b/drivers/media/platform/renesas/vsp1/vsp1_pipe.h
@@ -73,7 +73,7 @@ struct vsp1_partition_window {
  * @wpf: The WPF partition window configuration
  */
 struct vsp1_partition {
-	struct vsp1_partition_window rpf;
+	struct vsp1_partition_window rpf[VSP1_MAX_RPF];
 	struct vsp1_partition_window uds_sink;
 	struct vsp1_partition_window uds_source;
 	struct vsp1_partition_window sru;
diff --git a/drivers/media/platform/renesas/vsp1/vsp1_rpf.c b/drivers/media/platform/renesas/vsp1/vsp1_rpf.c
index c47579efc65f6..6055554fb0714 100644
--- a/drivers/media/platform/renesas/vsp1/vsp1_rpf.c
+++ b/drivers/media/platform/renesas/vsp1/vsp1_rpf.c
@@ -315,8 +315,8 @@ static void rpf_configure_partition(struct vsp1_entity *entity,
 	 * 'width' need to be adjusted.
 	 */
 	if (pipe->partitions > 1) {
-		crop.width = pipe->partition->rpf.width;
-		crop.left += pipe->partition->rpf.left;
+		crop.width = pipe->partition->rpf[rpf->entity.index].width;
+		crop.left += pipe->partition->rpf[rpf->entity.index].left;
 	}
 
 	if (pipe->interlaced) {
@@ -371,7 +371,9 @@ static void rpf_partition(struct vsp1_entity *entity,
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



