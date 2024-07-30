Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C7421A619A;
	Tue, 30 Jul 2024 16:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357040; cv=none; b=UzAtgEDmNWtL0bUM/U6uDrMCmLN1a1htr/3/Ht8PHoPFs/BynTUoDTGVoaPkX0kl9MnD3Jxdv4rwaHCjBYxev8G8iLMMxrwX5eidCELJFUCmiv+ye3cM/sldWVI9L2zrT82Fy2OiyK90dJfsRon+j8gvAa2nBdof3lhCe8H8KlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357040; c=relaxed/simple;
	bh=Eunncti6CP74i9Nnfg1clnoMKkBIL8nYKDHyE6NDBQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aD7cxstPpPPg+KIp3d8SBpvdh9TH9PxGGl0D4KKc3MOiuj82OGlhczii+8mWSNWLuo+d3IXKN/Pn9Rgc91+QR5v490F1TVJMUh+2CYy5vPSn97vMAXCG970QxVDCh4Ny4NxiRwrXg7MuTmKT+nKLbSrRToOtEfQLA/iYKQAKIgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X5IoiKiU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X5IoiKiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE3A3C32782;
	Tue, 30 Jul 2024 16:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357040;
	bh=Eunncti6CP74i9Nnfg1clnoMKkBIL8nYKDHyE6NDBQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X5IoiKiUNcUgDnMwlI6H+QhpSuY9WqVqpXcWbuv4UY2K8RtaMtDlx4ok5GNL5+npt
	 zpjDAXWQYcQXfev0IXRNKd4J9BEehOUcOIKfOC0ADkVQXHS4C8/sj5TcTRmkzuIp0O
	 mZGr1Ea7jTWMWsu62x+zkyQaNOp0l3o0qNGdP9ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Jacopo Mondi <jacopo.mondi+renesas@ideasonboard.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/568] media: renesas: vsp1: Store RPF partition configuration per RPF instance
Date: Tue, 30 Jul 2024 17:45:19 +0200
Message-ID: <20240730151648.159336103@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index ea12c3f12c92a..78b6cefc5a019 100644
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



