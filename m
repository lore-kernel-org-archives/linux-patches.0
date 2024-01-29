Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD28615705F;
	Mon, 29 Jan 2024 17:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548115; cv=none; b=IjTcXXnmK0ah6ASqbsVzvFcoRMG1UZY8TbcdWEtrX03GBrvL3FIIgfajOeWzS6NsR8ISTyXfrF1cmtkGwaEXaBra+XMBg3TszCh4jC9WwsBAexYjTNq3BAOs/NsW4H3wOOCqc7Bx4+hYlTAZs62DHuCvNylDbgKscW4If116RAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548115; c=relaxed/simple;
	bh=gP2RTNUMNQfqtnptNOen7KX8URKhB9Q0tRDguy0VZ9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpT9R7eeY9JQ0Juu0nBKWT3YmJrwjbW9fw0q8/FUvlQgz7EksJSr9fm3HdjU/e0JQyPUi8UsxtL+X2KVRMhLqk8gxr44xYp+h31tMKLnaCOMlKHzSLUcorAkdT2OhrCBc7nHyQsCfLSvFXXkXlMN3FsBDm50u75E8Kz8yex9n5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DB1TWtaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DB1TWtaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9229DC43390;
	Mon, 29 Jan 2024 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548115;
	bh=gP2RTNUMNQfqtnptNOen7KX8URKhB9Q0tRDguy0VZ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DB1TWtaCHQhdRwIUQRcdNmWWw6uaWAJhxGUtCdaCZZR1G1x3GPATKZhVr4VyenB8P
	 yLuuYrSlV5OjtDdMK9b3cuBzmkGRKtDXefGLwQimpaUTGN+cy8UHTTajc/cZb3xzTf
	 E9bHm+S+cY+1i6NN/kTGkeZKts4DsFkmDeaah03w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.7 115/346] nouveau/gsp: handle engines in runl without nonstall interrupts.
Date: Mon, 29 Jan 2024 09:02:26 -0800
Message-ID: <20240129170019.774382896@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

From: Dave Airlie <airlied@redhat.com>

commit 205e18c13545ab43cc4fe4930732b4feef551198 upstream.

It appears on TU106 GPUs (2070), that some of the nvdec engines
are in the runlist but have no valid nonstall interrupt, nouveau
didn't handle that too well.

This should let nouveau/gsp work on those.

Cc: stable@vger.kernel.org # v6.7+
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://lore.kernel.org/all/20240110011826.3996289-1-airlied@gmail.com/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga100.c |    4 ++++
 drivers/gpu/drm/nouveau/nvkm/engine/fifo/r535.c  |    2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/base.c   |    8 ++------
 3 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/ga100.c
@@ -550,6 +550,10 @@ ga100_fifo_nonstall_ctor(struct nvkm_fif
 		struct nvkm_engn *engn = list_first_entry(&runl->engns, typeof(*engn), head);
 
 		runl->nonstall.vector = engn->func->nonstall(engn);
+
+		/* if no nonstall vector just keep going */
+		if (runl->nonstall.vector == -1)
+			continue;
 		if (runl->nonstall.vector < 0) {
 			RUNL_ERROR(runl, "nonstall %d", runl->nonstall.vector);
 			return runl->nonstall.vector;
--- a/drivers/gpu/drm/nouveau/nvkm/engine/fifo/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/fifo/r535.c
@@ -351,7 +351,7 @@ r535_engn_nonstall(struct nvkm_engn *eng
 	int ret;
 
 	ret = nvkm_gsp_intr_nonstall(subdev->device->gsp, subdev->type, subdev->inst);
-	WARN_ON(ret < 0);
+	WARN_ON(ret == -ENOENT);
 	return ret;
 }
 
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/base.c
@@ -25,12 +25,8 @@ int
 nvkm_gsp_intr_nonstall(struct nvkm_gsp *gsp, enum nvkm_subdev_type type, int inst)
 {
 	for (int i = 0; i < gsp->intr_nr; i++) {
-		if (gsp->intr[i].type == type && gsp->intr[i].inst == inst) {
-			if (gsp->intr[i].nonstall != ~0)
-				return gsp->intr[i].nonstall;
-
-			return -EINVAL;
-		}
+		if (gsp->intr[i].type == type && gsp->intr[i].inst == inst)
+			return gsp->intr[i].nonstall;
 	}
 
 	return -ENOENT;


