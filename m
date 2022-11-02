Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26CF07E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A1BC433D6;
	Wed,  2 Nov 2022 02:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357342;
	bh=pKBUNdafFO6AO0Nw0ju2H23r0amSYiTIrkXn9hgiSMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxFfkpQGuZ28luMrPlz7OFuGZorhbvaUyV0mCrsHD98RE6vl9AK7nWnq1zuo0vKz9
	 Cu4a8tNIqHlI1XQ+edPVecwvPaKHHeOp+zSIzRM4lDyRkFLHEb4hcTN8nYH1vwtuyx
	 qknG/vUUDd63hiKrPCA9DTEUS86neJ0kjwEwNr9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 125/240] drm/msm/a6xx: Replace kcalloc() with kvzalloc()
Date: Wed,  2 Nov 2022 03:31:40 +0100
Message-Id: <20221102022114.209708418@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

[ Upstream commit ec8f1813bf8d0737898f99a8c1c69df0cde0d7dd ]

In order to reduce chance of allocation failure while capturing a6xx
gpu state, use kvzalloc() instead of kcalloc() in state_kcalloc().

Indirectly, this patch helps to fix leaking memory allocated for
gmu_debug object.

Fixes: b859f9b009b (drm/msm/gpu: Snapshot GMU debug buffer)
Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/505074/
Link: https://lore.kernel.org/r/20220928124830.1.I8ea24a8d586b4978823b848adde000f92f74d5c2@changeid
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 55f443328d8e..3c112a6cc8a2 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -91,7 +91,7 @@ struct a6xx_state_memobj {
 static void *state_kcalloc(struct a6xx_gpu_state *a6xx_state, int nr, size_t objsize)
 {
 	struct a6xx_state_memobj *obj =
-		kzalloc((nr * objsize) + sizeof(*obj), GFP_KERNEL);
+		kvzalloc((nr * objsize) + sizeof(*obj), GFP_KERNEL);
 
 	if (!obj)
 		return NULL;
@@ -819,7 +819,7 @@ static struct msm_gpu_state_bo *a6xx_snapshot_gmu_bo(
 
 	snapshot->iova = bo->iova;
 	snapshot->size = bo->size;
-	snapshot->data = kvzalloc(snapshot->size, GFP_KERNEL);
+	snapshot->data = state_kcalloc(a6xx_state, 1, snapshot->size);
 	if (!snapshot->data)
 		return NULL;
 
@@ -1034,14 +1034,8 @@ static void a6xx_gpu_state_destroy(struct kref *kref)
 	struct a6xx_gpu_state *a6xx_state = container_of(state,
 			struct a6xx_gpu_state, base);
 
-	if (a6xx_state->gmu_log)
-		kvfree(a6xx_state->gmu_log->data);
-
-	if (a6xx_state->gmu_hfi)
-		kvfree(a6xx_state->gmu_hfi->data);
-
 	list_for_each_entry_safe(obj, tmp, &a6xx_state->objs, node)
-		kfree(obj);
+		kvfree(obj);
 
 	adreno_gpu_state_destroy(state);
 	kfree(a6xx_state);
-- 
2.35.1



