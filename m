Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C90A446839;
	Tue, 21 Jul 2026 17:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655047; cv=none; b=abdLd5FyNGq2w4qRerPeLvjtOV2fwf9WCTqiS/7nZfh5a0VbV8UYuTjMPlkmie2e3G7tnKy3FJHFbPhv9XjWysfq0owGttJStBFMYzgxk/lzCnzbTxDuJX5lge5njOPDCHcr55xS8Vyk9aKPm5/MlHSgJABT4+m/T4IoBVQTMgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655047; c=relaxed/simple;
	bh=JayFqPzcPuye7gANaUjroOsyo8Tkrzsl+SuLlRG58sQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n1gJqu3XQZwXMQFQsXRafgX4MKnu9M33zIijKHawZHq/UL00BaOpgudqtmBxdRK5S1w1fHGv87ynh40H1s3pRz9FgZIIUNEdAAvVN66AGJKGJrafx2Iz3xnqDtw1cuq2Bbh4Uzb766HXKlCM4KEjLpSqCJ2Deo43i/EYpVITLxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyUvX8wx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyUvX8wx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F7B1F000E9;
	Tue, 21 Jul 2026 17:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655045;
	bh=B76+BcM1XQ9Bz+69c2um8Qaq/dJ38Wj+nF2Uv82lsC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zyUvX8wxUXuErwPNAqm1Oc30ja3t4WpzzUKoMcY6NUpxzmbksTkPyrEulykHbY5cj
	 p0eAdtWSKEjNunTveleNVYWcYn6RTRwGHVQFCrcrGUEt8MzcbFoFL8bknx6sdGVrRQ
	 aHyu6kzPGEgzXzwc2d9DVBwCh8BB/happEHu43/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Shuicheng Lin <shuicheng.lin@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Subject: [PATCH 7.1 1933/2077] drm/xe/userptr: Stub notifier_lock helpers when DRM_GPUSVM=n
Date: Tue, 21 Jul 2026 17:26:46 +0200
Message-ID: <20260721152638.302621814@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1407,6 +1407,7 @@ static int xe_pt_pre_commit(struct xe_mi
 				     pt_update_ops, rftree);
 }
 
+#if IS_ENABLED(CONFIG_DRM_GPUSVM)
 /*
  * Acquire/release the svm notifier_lock around xe_pt_svm_userptr_pre_commit()
  * and the matching late release in xe_pt_update_ops_run(). Read mode by
@@ -1433,6 +1434,10 @@ static void xe_pt_svm_userptr_notifier_u
 	xe_svm_notifier_unlock(vm);
 #endif
 }
+#else
+static inline void xe_pt_svm_userptr_notifier_lock(struct xe_vm *vm) { }
+static inline void xe_pt_svm_userptr_notifier_unlock(struct xe_vm *vm) { }
+#endif
 
 #if IS_ENABLED(CONFIG_DRM_GPUSVM)
 #ifdef CONFIG_DRM_XE_USERPTR_INVAL_INJECT


