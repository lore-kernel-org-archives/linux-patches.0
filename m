Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63EF82AE8D;
	Tue, 11 Nov 2025 00:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822257; cv=none; b=H7FNsk6jCUQlL2pesND7CACUYEjxo2++GCzeq0FgrXNpzW0DGkFOUIDZyT9LmdTx9jHhYbvxdjma2QAANR/cgMZEIf9Et0tNs684v3DtiaVtkhqpKNipOxKFoXMGUr0xgdLdA+sKHb6KUCUP28WlD/HNmFt/IZPmcCl0hlquXrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822257; c=relaxed/simple;
	bh=UjGXIgY7A4TIf90yRijJQhr9V7+5mxSomI3a0/AvnHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lOTBtccwcYmqydHGYryUD2gCgDUS8JDq6bNnoA4vTOy5b9fo6vKZIDwoQ0s/SyrhDjbouh7iLB4+xzSjzJKeDjASAFhu0p6xfTLTdTyVoR9TFRJ5D3jdiddHoGrPEdsMSHzXfz2QeBpQgibVOTcQUofDGLRsxzTtCrx7yJLSJw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QDlCFJsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QDlCFJsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E861C19422;
	Tue, 11 Nov 2025 00:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822257;
	bh=UjGXIgY7A4TIf90yRijJQhr9V7+5mxSomI3a0/AvnHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QDlCFJsiY08EquMvfZAH5+Es/f3TSbs/Dzlb/VsQYWwrTy7UzHof0MWc7qQJYrzzH
	 yF5FRU9hlxMTqPNiAovauRXzZn4wxX5ALvmxCdGXfMmmgFcih3Sssu1KAOQWPAkRog
	 E5cr1lsNue+cZh/9Ud0iS9Wq5TJWSdYWfinfTKFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephan Gerhold <stephan.gerhold@linaro.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Sasha Levin <sashal@kernel.org>,
	Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Subject: [PATCH 6.17 033/849] drm/msm: Fix GEM free for imported dma-bufs
Date: Tue, 11 Nov 2025 09:33:23 +0900
Message-ID: <20251111004537.246227961@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit c34e08ba6c0037a72a7433741225b020c989e4ae ]

Imported dma-bufs also have obj->resv != &obj->_resv.  So we should
check both this condition in addition to flags for handling the
_NO_SHARE case.

Fixes this splat that was reported with IRIS video playback:

    ------------[ cut here ]------------
    WARNING: CPU: 3 PID: 2040 at drivers/gpu/drm/msm/msm_gem.c:1127 msm_gem_free_object+0x1f8/0x264 [msm]
    CPU: 3 UID: 1000 PID: 2040 Comm: .gnome-shell-wr Not tainted 6.17.0-rc7 #1 PREEMPT
    pstate: 81400005 (Nzcv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
    pc : msm_gem_free_object+0x1f8/0x264 [msm]
    lr : msm_gem_free_object+0x138/0x264 [msm]
    sp : ffff800092a1bb30
    x29: ffff800092a1bb80 x28: ffff800092a1bce8 x27: ffffbc702dbdbe08
    x26: 0000000000000008 x25: 0000000000000009 x24: 00000000000000a6
    x23: ffff00083c72f850 x22: ffff00083c72f868 x21: ffff00087e69f200
    x20: ffff00087e69f330 x19: ffff00084d157ae0 x18: 0000000000000000
    x17: 0000000000000000 x16: ffffbc704bd46b80 x15: 0000ffffd0959540
    x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
    x11: ffffbc702e6cdb48 x10: 0000000000000000 x9 : 000000000000003f
    x8 : ffff800092a1ba90 x7 : 0000000000000000 x6 : 0000000000000020
    x5 : ffffbc704bd46c40 x4 : fffffdffe102cf60 x3 : 0000000000400032
    x2 : 0000000000020000 x1 : ffff00087e6978e8 x0 : ffff00087e6977e8
    Call trace:
     msm_gem_free_object+0x1f8/0x264 [msm] (P)
     drm_gem_object_free+0x1c/0x30 [drm]
     drm_gem_object_handle_put_unlocked+0x138/0x150 [drm]
     drm_gem_object_release_handle+0x5c/0xcc [drm]
     drm_gem_handle_delete+0x68/0xbc [drm]
     drm_gem_close_ioctl+0x34/0x40 [drm]
     drm_ioctl_kernel+0xc0/0x130 [drm]
     drm_ioctl+0x360/0x4e0 [drm]
     __arm64_sys_ioctl+0xac/0x104
     invoke_syscall+0x48/0x104
     el0_svc_common.constprop.0+0x40/0xe0
     do_el0_svc+0x1c/0x28
     el0_svc+0x34/0xec
     el0t_64_sync_handler+0xa0/0xe4
     el0t_64_sync+0x198/0x19c
    ---[ end trace 0000000000000000 ]---
    ------------[ cut here ]------------

Reported-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Fixes: de651b6e040b ("drm/msm: Fix refcnt underflow in error path")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Tested-by: Stephan Gerhold <stephan.gerhold@linaro.org>
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Tested-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org> # qrb5165-rb5
Patchwork: https://patchwork.freedesktop.org/patch/676273/
Message-ID: <20250923140441.746081-1-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index e7631f4ef5309..0745d958f3987 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -1120,12 +1120,16 @@ static void msm_gem_free_object(struct drm_gem_object *obj)
 		put_pages(obj);
 	}
 
-	if (obj->resv != &obj->_resv) {
+	/*
+	 * In error paths, we could end up here before msm_gem_new_handle()
+	 * has changed obj->resv to point to the shared resv.  In this case,
+	 * we don't want to drop a ref to the shared r_obj that we haven't
+	 * taken yet.
+	 */
+	if ((msm_obj->flags & MSM_BO_NO_SHARE) && (obj->resv != &obj->_resv)) {
 		struct drm_gem_object *r_obj =
 			container_of(obj->resv, struct drm_gem_object, _resv);
 
-		WARN_ON(!(msm_obj->flags & MSM_BO_NO_SHARE));
-
 		/* Drop reference we hold to shared resv obj: */
 		drm_gem_object_put(r_obj);
 	}
-- 
2.51.0



