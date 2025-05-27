Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE56280023;
	Tue, 27 May 2025 17:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367058; cv=none; b=qQJop7/Srb1ablTSC3hiNPwe0HGg0eVHKBCvc82HAAFji5h+woDhc5FNsV/KMLLcFeqNHN2QUVX2z9sBOfo30nDGmo1NIzepVZoSo+Xo1UyuW2k8S4nCF9kTfTSYPD0efk0QCS9V/LnCMkuvkc7hPBhkV0QadtEm1XQkMftGjjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367058; c=relaxed/simple;
	bh=7cYdlIPusgu19xligAD/K4LQcQZcQREDc83Aq96qKEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KXd11j9FqIduGAf2E9rOay63Oq6fIW8mipGzOk+L/a6Wk6DlzT5L2U+869qCV9YJTtqWwmfzfsOH/rcMmpwzs7EL+1IiGziLMlDAv7oHWiLCQ3p/sexRtck5aSUrJtPAm5WczLFp4DOJhWOrWjxN+f4ne8qSVVram7ivxCKtnak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h3J3OWV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h3J3OWV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DABCC4CEEA;
	Tue, 27 May 2025 17:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367058;
	bh=7cYdlIPusgu19xligAD/K4LQcQZcQREDc83Aq96qKEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h3J3OWV43PcClowkw8dgsmLzYJ7LyDT0QjR+wu1pMLBYdEGOoosRTInZxtLqVBw/H
	 5dIA1BhI7L1b9HY+BJc4+JH2cMJyxXxvQbS6JhZGR9E6gQTLZrPTFC2xhaSrC9zPCx
	 csUBltIT1N3vLtfpX7/G4yl+TFPJ6n3Jj2Yin7H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 265/783] drm/xe: Retry BO allocation
Date: Tue, 27 May 2025 18:21:02 +0200
Message-ID: <20250527162523.887755594@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 3f5391d416d46..d1eb87cb178bd 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -2142,6 +2142,7 @@ int xe_gem_create_ioctl(struct drm_device *dev, void *data,
 	struct xe_file *xef = to_xe_file(file);
 	struct drm_xe_gem_create *args = data;
 	struct xe_vm *vm = NULL;
+	ktime_t end = 0;
 	struct xe_bo *bo;
 	unsigned int bo_flags;
 	u32 handle;
@@ -2214,6 +2215,10 @@ int xe_gem_create_ioctl(struct drm_device *dev, void *data,
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
@@ -2227,6 +2232,8 @@ int xe_gem_create_ioctl(struct drm_device *dev, void *data,
 
 	if (IS_ERR(bo)) {
 		err = PTR_ERR(bo);
+		if (xe_vm_validate_should_retry(NULL, err, &end))
+			goto retry;
 		goto out_vm;
 	}
 
-- 
2.39.5



