Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648D3280012;
	Tue, 27 May 2025 16:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748364953; cv=none; b=G5nMLF/ra9WhW+v6thXHyXDiTqwKIyRzKKDRe2Ky9t7oBx0BZs+QQrN6q07IE69fSF74QWp+JFToHB9fQyvFV0dGZiZJl91ce7qWKKGPKHvx0x+huHVqqmUAN1ZR1Fae3ouS25BCuQmmh3zGJCkPvElSXBbqTZf+4YrroLP7UhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748364953; c=relaxed/simple;
	bh=fFQoLa5zDz8aCCKsO0nFlz/ZxHyQ3E9CE9aC84xAqDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWS9r2Wb8hfIqcvWXwJjwbB/QW8y9bcvPNedh11E/EZd/hivitbWJi4G/onpzwcwPAW0WzqOQK0OOt0Acy486sLMmvrrVByA4vluBFuQVhhth54uzp3ZBbyGVkuuvoDv7Kb3y69+KrUMLmtFjTtbKbveMImiuABSoikQKwZn8Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwR20lPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwR20lPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0751C4CEED;
	Tue, 27 May 2025 16:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748364953;
	bh=fFQoLa5zDz8aCCKsO0nFlz/ZxHyQ3E9CE9aC84xAqDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwR20lPpgXNPfMXj+5zafkF4IkncGZr12z7/6vM4PHMClGsTohrHNeQ70JNL2dr4w
	 3W77ESb3I6Uulex7yjsBiDuB+pXOANSyp4lLg8vChaCEXdLRIcxq0PwPBDb7F/CFTe
	 TOzlTpzuGwEJ7AZOeY2Hl87hp5NzMiy6ZtEQr5cQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/626] drm/xe: Retry BO allocation
Date: Tue, 27 May 2025 18:21:53 +0200
Message-ID: <20250527162453.957484355@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 1d724a2f1b2c3f0cba4975784a808482e0631adf ]

TTM doesn't support fair eviction via WW locking, this mitigated in by
using retry loops in exec and preempt rebind worker. Extend this retry
loop to BO allocation. Once TTM supports fair eviction this patch can be
reverted.

v4:
 - Keep line break (Stuart)

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250306012657.3505757-2-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 84e327b569252..35a8242a9f541 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1975,6 +1975,7 @@ int xe_gem_create_ioctl(struct drm_device *dev, void *data,
 	struct xe_file *xef = to_xe_file(file);
 	struct drm_xe_gem_create *args = data;
 	struct xe_vm *vm = NULL;
+	ktime_t end = 0;
 	struct xe_bo *bo;
 	unsigned int bo_flags;
 	u32 handle;
@@ -2047,6 +2048,10 @@ int xe_gem_create_ioctl(struct drm_device *dev, void *data,
 		vm = xe_vm_lookup(xef, args->vm_id);
 		if (XE_IOCTL_DBG(xe, !vm))
 			return -ENOENT;
+	}
+
+retry:
+	if (vm) {
 		err = xe_vm_lock(vm, true);
 		if (err)
 			goto out_vm;
@@ -2060,6 +2065,8 @@ int xe_gem_create_ioctl(struct drm_device *dev, void *data,
 
 	if (IS_ERR(bo)) {
 		err = PTR_ERR(bo);
+		if (xe_vm_validate_should_retry(NULL, err, &end))
+			goto retry;
 		goto out_vm;
 	}
 
-- 
2.39.5



