Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB961A9B45;
	Wed, 20 Nov 2024 12:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107550; cv=none; b=tOB/pIlMFlvzAxZckKrKE62trsWNBHLD8CqmOmroi/iQZVZ6ea3cDbJLqRIDRQvDtEWxS/pbJu7lmkYdJrjCCYYFvH3u/KpNJGCJ3ftrE0Hu8k5WLlvLnqD+skEc1gaxm+AdmxP6QWGOvlGKsYyPfaLJEIhJNL2wU+CS5eWjxF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107550; c=relaxed/simple;
	bh=cgjXOeGU+i4TfkQ0mnmJbDmyR9yPCwBZgq6K+DlbZvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGH72Ykc35W3v152eFZHWhVI7fjUTklfTNZGEJo9g2+Yfrvb8dbHF6SWbHvDcnvFp/+wJNJbPd7otKky9k8EnzWUfg7gNr7T7yWOAg/hTIggjJaSjPpGQHaERa4p0hGNCIy80qWrAf0WgOCaD4sWSLPFv90PSew9HvdZHeB3WCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LzeuJP2L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LzeuJP2L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415F2C4CECD;
	Wed, 20 Nov 2024 12:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107550;
	bh=cgjXOeGU+i4TfkQ0mnmJbDmyR9yPCwBZgq6K+DlbZvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LzeuJP2LdvnphwWoyK+EbwhOafUJCPB6dqWtWklKcioqWRbWtjraCgvlXbb1gyoJl
	 WtzfirTQlr7KTQmTuPVi7bpSbzmpvM4mwdUGomd13pdF3Ps1RW1pMIPdobaSIihl5+
	 PAPnjG6bBQwFnZiqFbo8fi52ThN/EIayOji/6vU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lyude Paul <lyude@redhat.com>,
	Dave Airlie <airlied@redhat.com>
Subject: [PATCH 6.11 090/107] nouveau: handle EBUSY and EAGAIN for GSP aux errors.
Date: Wed, 20 Nov 2024 13:57:05 +0100
Message-ID: <20241120125631.741118322@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit b6ad7debf5ab3e581b5cb0f5c94e404ec968bd5b upstream.

The upper layer transfer functions expect EBUSY as a return
for when retries should be done.

Fix the AUX error translation, but also check for both errors
in a few places.

Fixes: eb284f4b3781 ("drm/nouveau/dp: Honor GSP link training retry timeouts")
Cc: stable@vger.kernel.org
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241111034126.2028401-1-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c |    2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c  |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/engine/disp/r535.c
@@ -992,7 +992,7 @@ r535_dp_train_target(struct nvkm_outp *o
 		ctrl->data = data;
 
 		ret = nvkm_gsp_rm_ctrl_push(&disp->rm.objcom, &ctrl, sizeof(*ctrl));
-		if (ret == -EAGAIN && ctrl->retryTimeMs) {
+		if ((ret == -EAGAIN || ret == -EBUSY) && ctrl->retryTimeMs) {
 			/*
 			 * Device (likely an eDP panel) isn't ready yet, wait for the time specified
 			 * by GSP before retrying again
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/r535.c
@@ -78,7 +78,7 @@ r535_rpc_status_to_errno(uint32_t rpc_st
 	switch (rpc_status) {
 	case 0x55: /* NV_ERR_NOT_READY */
 	case 0x66: /* NV_ERR_TIMEOUT_RETRY */
-		return -EAGAIN;
+		return -EBUSY;
 	case 0x51: /* NV_ERR_NO_MEMORY */
 		return -ENOMEM;
 	default:
@@ -601,7 +601,7 @@ r535_gsp_rpc_rm_alloc_push(struct nvkm_g
 
 	if (rpc->status) {
 		ret = ERR_PTR(r535_rpc_status_to_errno(rpc->status));
-		if (PTR_ERR(ret) != -EAGAIN)
+		if (PTR_ERR(ret) != -EAGAIN && PTR_ERR(ret) != -EBUSY)
 			nvkm_error(&gsp->subdev, "RM_ALLOC: 0x%x\n", rpc->status);
 	} else {
 		ret = repc ? rpc->params : NULL;
@@ -660,7 +660,7 @@ r535_gsp_rpc_rm_ctrl_push(struct nvkm_gs
 
 	if (rpc->status) {
 		ret = r535_rpc_status_to_errno(rpc->status);
-		if (ret != -EAGAIN)
+		if (ret != -EAGAIN && ret != -EBUSY)
 			nvkm_error(&gsp->subdev, "cli:0x%08x obj:0x%08x ctrl cmd:0x%08x failed: 0x%08x\n",
 				   object->client->object.handle, object->handle, rpc->cmd, rpc->status);
 	}


