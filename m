Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FDA3CF21F;
	Wed, 30 Sep 2026 19:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795613; cv=none; b=bF8e90ThKELhJbKtX/6MFImwRGMdNlloh5VplJ4+Abt8BcjGk62sCMOl8Ddbdop5BnF2Bu/7AQHX6NQVi09QFpJbrpk8PC4x2mHheGxKJxewh6tYAl97F8r82hy5/1k5nBN0MYWdf6W3O8+ULzzsm4hotc4DzRAJMdzR6Tg3YQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795613; c=relaxed/simple;
	bh=MTfPSC0X3YXNTWu2BrcvA7t7FpVaeAlt82b6zKStLG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OT0mRshSUDF70adONWxc8QWBJ8mfKL+4kAUWsZYVVN/PvZoYciEBtOqAtVwHeftO7tbpNEWSJ7D6s4docMeiiuB+8G6vJGwdRmVgSg2pVr/aDDGAK5SOvnEIPkhgWJqE63K2mYVTZKCfjCJkDmEDAudOZ1EKtpsMDieEPpIp81k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJSH1Rsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJSH1Rsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E6151F000FF;
	Wed, 30 Sep 2026 19:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795612;
	bh=P2PO++tpxIxzr49kG6qHrVDfPU/ZW1TpBXZHeKgZAAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJSH1RsfY2QO627dPUTJyS+dAaylrv4fmKj8eEvp1TgmOkWuAC+twppBUKjGftfYb
	 nN8KHWhBdhtRfdZl1Cmu9Z/UJUsD20cfFYkmgUcEiG+hX4vOhyEm9nIbO9F5U+gXTX
	 sm35ua+D4xjGqXkDcoO8etvu/BMDbbBjoIZWm2ZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Subject: [PATCH 6.6 0623/1193] drm/drm_exec: fix up contended obj when num_objects is 0
Date: Wed, 30 Sep 2026 17:21:47 +0200
Message-ID: <20260930152448.083696769@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

commit 159720704d9d652b64390c11fb971e15b0a78d23 upstream.

drm_exec_prepare_array() silently returns success without calling
drm_exec_lock_contended() when num_objects is zero. This breaks the
invariant upheld by drm_exec_lock_obj(), where every entry point into
the locking sequence must first attempt to lock any previously
contended object before proceeding.

Drivers that chain multiple drm_exec_prepare_array() calls per
drm_exec_until_all_locked() iteration (e.g. amdgpu's userq signal/wait
ioctls, which prepare separate read and write BO arrays) can pass an
empty array for one of the two calls. If contention is hit while
preparing the non-empty array, exec->contended is set and the loop
retries; on retry, the empty-array call preceding it is a no-op that
never clears exec->contended, so drm_exec_retry_on_contention()
immediately jumps back to the top of the loop without ever reaching
the call that would resolve the contention. This spins forever.

Fix it by having drm_exec_prepare_array() call drm_exec_lock_contended()
directly when num_objects is zero, so a pending contended object dont
loop infinitely.

Fixes: 09593216bff1 ("drm: execution context for GEM buffers v7")
CC: stable@vger.kernel.org # v6.6+
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Link: https://lore.kernel.org/r/20260908091729.2749399-1-sunil.khatri@amd.com
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_exec.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpu/drm/drm_exec.c
+++ b/drivers/gpu/drm/drm_exec.c
@@ -319,6 +319,19 @@ int drm_exec_prepare_array(struct drm_ex
 {
 	int ret;
 
+	/*
+	 * Make sure to lock a contended object even when no objects are
+	 * given, otherwise drm_exec_retry_on_contention() would loop
+	 * forever on patterns like:
+	 *
+	 *	ret = drm_exec_prepare_array(exec, objs, num_objects, ...);
+	 *	drm_exec_retry_on_contention(exec);
+	 *
+	 * with num_objects == 0.
+	 */
+	if (!num_objects)
+		return drm_exec_lock_contended(exec);
+
 	for (unsigned int i = 0; i < num_objects; ++i) {
 		ret = drm_exec_prepare_obj(exec, objects[i], num_fences);
 		if (unlikely(ret))


