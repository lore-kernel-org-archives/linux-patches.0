Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05483FB1B;
	Mon, 23 Jun 2025 22:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716282; cv=none; b=cS0dDpsrNuaP7F7A0DXJ+nh0oRlU9ELrCwXN5kvuTFGf1RbuLNe3cAyGTZL2GezQem+CdSWwLjYfRzRGd1/c30ny9+vESGqtDDbX9xQ3pAhxpGFTP8oTA6ae5UeUFyEpGHddolTvrRoDydeWsORiw3ue6kYKmThkV5O1NLc+yiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716282; c=relaxed/simple;
	bh=1nEzqYq8o0pw0iBwdfeq3Hc0U4aqTE14vui8nK417V4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNAJQnPUIkrROXvFEp3dcp5u04dmpm0EudtZWtE1/QE/L1Ur2FO/zUI4xTFV3eUky8f/fVuGEBLGFfAb+DPOgWDTtLSbmwntgvOYQxIr+fZ3eFdE2ImQMoTQcBKw8sTfG1ZMUGSQEl2RxbfHPQ6PtnZlkDmCu92vF9VezGIkpkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woWcAXh9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woWcAXh9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3C2EC4CEEA;
	Mon, 23 Jun 2025 22:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716282;
	bh=1nEzqYq8o0pw0iBwdfeq3Hc0U4aqTE14vui8nK417V4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woWcAXh9VQVPPUfhvc8dPfbRPyb5F0gO3aKkfHA/dW5r3C+p82tOZ0K0LzmDyTanv
	 Ifm0AxNE10M1aPhRAyIoU++Az6osatS58LGJ6q19frBdDrKButqsll1bMH4p1aN/eC
	 KlFOy2Us/U+jbwXnPoPQt88q2kpLe8tt7f0BBvyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi Wang <zhiw@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 513/592] drm/nouveau: fix a use-after-free in r535_gsp_rpc_push()
Date: Mon, 23 Jun 2025 15:07:51 +0200
Message-ID: <20250623130712.639206735@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi Wang <zhiw@nvidia.com>

[ Upstream commit 9802f0a63b641f4cddb2139c814c2e95cb825099 ]

The RPC container is released after being passed to r535_gsp_rpc_send().

When sending the initial fragment of a large RPC and passing the
caller's RPC container, the container will be freed prematurely. Subsequent
attempts to send remaining fragments will therefore result in a
use-after-free.

Allocate a temporary RPC container for holding the initial fragment of a
large RPC when sending. Free the caller's container when all fragments
are successfully sent.

Fixes: 176fdcbddfd2 ("drm/nouveau/gsp/r535: add support for booting GSP-RM")
Signed-off-by: Zhi Wang <zhiw@nvidia.com>
Link: https://lore.kernel.org/r/20250527163712.3444-1-zhiw@nvidia.com
[ Rebase onto Blackwell changes. - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c   | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c
index ffb4104a7d8cd..d558b0f62b010 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/gsp/rm/r535/rpc.c
@@ -638,12 +638,18 @@ r535_gsp_rpc_push(struct nvkm_gsp *gsp, void *payload,
 	if (payload_size > max_payload_size) {
 		const u32 fn = rpc->function;
 		u32 remain_payload_size = payload_size;
+		void *next;
 
-		/* Adjust length, and send initial RPC. */
-		rpc->length = sizeof(*rpc) + max_payload_size;
-		msg->checksum = rpc->length;
+		/* Send initial RPC. */
+		next = r535_gsp_rpc_get(gsp, fn, max_payload_size);
+		if (IS_ERR(next)) {
+			repv = next;
+			goto done;
+		}
 
-		repv = r535_gsp_rpc_send(gsp, payload, NVKM_GSP_RPC_REPLY_NOWAIT, 0);
+		memcpy(next, payload, max_payload_size);
+
+		repv = r535_gsp_rpc_send(gsp, next, NVKM_GSP_RPC_REPLY_NOWAIT, 0);
 		if (IS_ERR(repv))
 			goto done;
 
@@ -654,7 +660,6 @@ r535_gsp_rpc_push(struct nvkm_gsp *gsp, void *payload,
 		while (remain_payload_size) {
 			u32 size = min(remain_payload_size,
 				       max_payload_size);
-			void *next;
 
 			next = r535_gsp_rpc_get(gsp, NV_VGPU_MSG_FUNCTION_CONTINUATION_RECORD, size);
 			if (IS_ERR(next)) {
@@ -675,6 +680,8 @@ r535_gsp_rpc_push(struct nvkm_gsp *gsp, void *payload,
 		/* Wait for reply. */
 		repv = r535_gsp_rpc_handle_reply(gsp, fn, policy, payload_size +
 						 sizeof(*rpc));
+		if (!IS_ERR(repv))
+			kvfree(msg);
 	} else {
 		repv = r535_gsp_rpc_send(gsp, payload, policy, gsp_rpc_len);
 	}
-- 
2.39.5



