Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8D41E2834;
	Wed, 25 Feb 2026 01:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983630; cv=none; b=LAEquyqTIdsf6sH3Wh77t+8u+PvK/LWIimkorhQzHdNy/weP2F23iPVylS+abmPCbtr4zPhU6ZNK5R1nU8CMDclJ2jwmHVGnEmAk/BRjFrWon7WRG4XtB0aHrZQzqqgNOlpykc3yYYMj5rtKhbnrBFJCtSb2cUqy5OWcGNfJDag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983630; c=relaxed/simple;
	bh=xQWiE5JhMVvAzQm3MGe/n4kIid53IQSAFM4N71RhQSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=U6w4MIu8oLMnYGWqckXtb9sv6E9MXO2K+OxdqRaZX72AABEosw+bH/XuMeFVPj984DE+k0noHV8jFLbJNIHPQPTDg9FeScFd+jRwFc2XlrYHZ2Nqfr2FnzJzWzoMltwqnICJjnoCjqzAe4fzcJmLi+rB9w0S4FsRzpTAsfeYeYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kl656bNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kl656bNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C2F7C116D0;
	Wed, 25 Feb 2026 01:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983630;
	bh=xQWiE5JhMVvAzQm3MGe/n4kIid53IQSAFM4N71RhQSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kl656bNatgbiaU9yKRHInIpQB02qxg94Byiff92Wqd9rr6M2JxBXqdLY16QFSzDV9
	 dCOtCknitmg+CmhSOpIxr/25M5HRFe7qG30HArMpqV2T+qWAQZHCsn6DPKg4RUwC97
	 XS9ba31DZL0tLekkTfRkwBHoQgjtrLJYbiDCyi4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jonathan Kim <jonathan.kim@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 721/781] drm/amdkfd: Fix watch_id bounds checking in debug address watch v2
Date: Tue, 24 Feb 2026 17:23:50 -0800
Message-ID: <20260225012417.420189577@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 5a19302cab5cec7ae7f1a60c619951e6c17d8742 ]

The address watch clear code receives watch_id as an unsigned value
(u32), but some helper functions were using a signed int and checked
bits by shifting with watch_id.

If a very large watch_id is passed from userspace, it can be converted
to a negative value.  This can cause invalid shifts and may access
memory outside the watch_points array.

drm/amdkfd: Fix watch_id bounds checking in debug address watch v2

Fix this by checking that watch_id is within MAX_WATCH_ADDRESSES before
using it.  Also use BIT(watch_id) to test and clear bits safely.

This keeps the behavior unchanged for valid watch IDs and avoids
undefined behavior for invalid ones.

Fixes the below:
drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_debug.c:448
kfd_dbg_trap_clear_dev_address_watch() error: buffer overflow
'pdd->watch_points' 4 <= u32max user_rl='0-3,2147483648-u32max' uncapped

drivers/gpu/drm/amd/amdgpu/../amdkfd/kfd_debug.c
    433 int kfd_dbg_trap_clear_dev_address_watch(struct kfd_process_device *pdd,
    434                                         uint32_t watch_id)
    435 {
    436         int r;
    437
    438         if (!kfd_dbg_owns_dev_watch_id(pdd, watch_id))

kfd_dbg_owns_dev_watch_id() doesn't check for negative values so if
watch_id is larger than INT_MAX it leads to a buffer overflow.
(Negative shifts are undefined).

    439                 return -EINVAL;
    440
    441         if (!pdd->dev->kfd->shared_resources.enable_mes) {
    442                 r = debug_lock_and_unmap(pdd->dev->dqm);
    443                 if (r)
    444                         return r;
    445         }
    446
    447         amdgpu_gfx_off_ctrl(pdd->dev->adev, false);
--> 448         pdd->watch_points[watch_id] = pdd->dev->kfd2kgd->clear_address_watch(
    449                                                         pdd->dev->adev,
    450                                                         watch_id);

v2: (as per, Jonathan Kim)
 - Add early watch_id >= MAX_WATCH_ADDRESSES validation in the set path to
   match the clear path.
 - Drop the redundant bounds check in kfd_dbg_owns_dev_watch_id().

Fixes: e0f85f4690d0 ("drm/amdkfd: add debug set and clear address watch points operation")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Jonathan Kim <jonathan.kim@amd.com>
Cc: Felix Kuehling <felix.kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Jonathan Kim <jonathan.kim@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_debug.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
index ba99e0f258aee..986cb297de8f8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_debug.c
@@ -401,27 +401,25 @@ static int kfd_dbg_get_dev_watch_id(struct kfd_process_device *pdd, int *watch_i
 	return -ENOMEM;
 }
 
-static void kfd_dbg_clear_dev_watch_id(struct kfd_process_device *pdd, int watch_id)
+static void kfd_dbg_clear_dev_watch_id(struct kfd_process_device *pdd, u32 watch_id)
 {
 	spin_lock(&pdd->dev->watch_points_lock);
 
 	/* process owns device watch point so safe to clear */
-	if ((pdd->alloc_watch_ids >> watch_id) & 0x1) {
-		pdd->alloc_watch_ids &= ~(0x1 << watch_id);
-		pdd->dev->alloc_watch_ids &= ~(0x1 << watch_id);
+	if (pdd->alloc_watch_ids & BIT(watch_id)) {
+		pdd->alloc_watch_ids &= ~BIT(watch_id);
+		pdd->dev->alloc_watch_ids &= ~BIT(watch_id);
 	}
 
 	spin_unlock(&pdd->dev->watch_points_lock);
 }
 
-static bool kfd_dbg_owns_dev_watch_id(struct kfd_process_device *pdd, int watch_id)
+static bool kfd_dbg_owns_dev_watch_id(struct kfd_process_device *pdd, u32 watch_id)
 {
 	bool owns_watch_id = false;
 
 	spin_lock(&pdd->dev->watch_points_lock);
-	owns_watch_id = watch_id < MAX_WATCH_ADDRESSES &&
-			((pdd->alloc_watch_ids >> watch_id) & 0x1);
-
+	owns_watch_id = pdd->alloc_watch_ids & BIT(watch_id);
 	spin_unlock(&pdd->dev->watch_points_lock);
 
 	return owns_watch_id;
@@ -432,6 +430,9 @@ int kfd_dbg_trap_clear_dev_address_watch(struct kfd_process_device *pdd,
 {
 	int r;
 
+	if (watch_id >= MAX_WATCH_ADDRESSES)
+		return -EINVAL;
+
 	if (!kfd_dbg_owns_dev_watch_id(pdd, watch_id))
 		return -EINVAL;
 
@@ -469,6 +470,9 @@ int kfd_dbg_trap_set_dev_address_watch(struct kfd_process_device *pdd,
 	if (r)
 		return r;
 
+	if (*watch_id >= MAX_WATCH_ADDRESSES)
+		return -EINVAL;
+
 	if (!pdd->dev->kfd->shared_resources.enable_mes) {
 		r = debug_lock_and_unmap(pdd->dev->dqm);
 		if (r) {
-- 
2.51.0



