Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9C73264FF;
	Tue, 21 Jul 2026 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659169; cv=none; b=K2dwjr8P0dz+4b4WozC9ffCgvyBuceJw1DSB7VY3YtNMeMT10ettEh+EIkiLrczYjP8QVZFwbj3upk26NnFS8LF2EBvbdKrMLd2gCfnvOlsel/nfsMJbZ7R7ssl5VJQ/SPgyE+x/ncB0gAaX/gaZbq9RU4UPvMp2Jlh9roXIRss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659169; c=relaxed/simple;
	bh=8VaOIiHsqiVR32s+MoRliv474vlBGNGiDEU+x/Q5FSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Csiazz3/nNuffeVBQ7DFjeZNqcfXjeVYKSz1lKGUyOkYwzmyasZkT6mdDKIjJ22l+ZNzF2VlD9LfWdl1MKgnDDm1DIjcMrtE7f6ZSVVcvt0jGpBmCYAP6l3oqO83RRoel7MZFmCml8TeO8ZUUlvI5ha6v/+TANOEsqQOSnh8xoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uw38pFpn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uw38pFpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A861F000E9;
	Tue, 21 Jul 2026 18:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659168;
	bh=i/4LZ7BH2e6/zkITT2QOn13mSwhossgRzgQgfGNVfIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uw38pFpnppHk/z6C0GYgnrZIbcYeXBECJHmp9hMk1fuPIWwZTDG4hUahyMYosD4Qv
	 c6toapEGQHSOMX+wgQ9GDTNLQ+TU2kZq/J8X2PlTUPld4wy1rbgwo83bJiAVv1vyfE
	 i+wA0lpg0mLr2ThvM/LtWp8F6BZMezm2AKf/dQXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 6.18 1419/1611] drm/xe/userptr: Stub notifier_lock helpers when DRM_GPUSVM=n
Date: Tue, 21 Jul 2026 17:25:35 +0200
Message-ID: <20260721152547.355237367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuicheng Lin <shuicheng.lin@intel.com>

commit f5ef65adf81da3dbce4e692e48c1754c0bb95da0 upstream.

When CONFIG_DRM_GPUSVM=n (e.g. um-allyesconfig), the only caller of
xe_pt_svm_userptr_notifier_lock() is compiled out, triggering:

  drivers/gpu/drm/xe/xe_pt.c:1418:13: warning:
    'xe_pt_svm_userptr_notifier_lock' defined but not used
    [-Wunused-function]

The helpers cannot simply be removed in this case: the matching
xe_pt_svm_userptr_notifier_unlock() is also referenced from
xe_pt_update_ops_run(), which lives outside any DRM_GPUSVM ifdef and is
gated only at runtime by pt_update_ops->needs_svm_lock. The symbol must
exist in all builds.

Provide empty static inline stubs for !DRM_GPUSVM, matching the pattern
used by xe_svm_notifier_lock()/_unlock() in xe_svm.h.

Fixes: dca6e08c923a ("drm/xe/userptr: Hold notifier_lock for write on inject test path")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202606302210.QqcLbOEN-lkp@intel.com/
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20260630192221.2998168-1-shuicheng.lin@intel.com
Signed-off-by: Shuicheng Lin <shuicheng.lin@intel.com>
(cherry picked from commit 3359422bf0a1140e96d783a19a397686e580a3ca)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_pt.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -1388,6 +1388,7 @@ static int xe_pt_pre_commit(struct xe_mi
 				     pt_update_ops, rftree);
 }
 
+#if IS_ENABLED(CONFIG_DRM_GPUSVM)
 /*
  * Acquire/release the svm notifier_lock around xe_pt_svm_userptr_pre_commit()
  * and the matching late release in xe_pt_update_ops_run(). Read mode by
@@ -1414,6 +1415,10 @@ static void xe_pt_svm_userptr_notifier_u
 	xe_svm_notifier_unlock(vm);
 #endif
 }
+#else
+static inline void xe_pt_svm_userptr_notifier_lock(struct xe_vm *vm) { }
+static inline void xe_pt_svm_userptr_notifier_unlock(struct xe_vm *vm) { }
+#endif
 
 #if IS_ENABLED(CONFIG_DRM_GPUSVM)
 #ifdef CONFIG_DRM_XE_USERPTR_INVAL_INJECT


