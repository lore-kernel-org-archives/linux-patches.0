Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A53B5172E7;
	Wed, 30 Sep 2026 17:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787615; cv=none; b=f3X7/GVK3TeuRCLibgcTsCiKifAHXgKHCDVq8DcO+aDC17zDx3eaklctxgDa/JFO9+PT8m4qz+rh8b0wLFgFyFrPXrH3uTpERR9xI34xpzsIDUtt7phph7jtOne6uBjQpS71Z6wqfWkyLftP9jP1KBA1OF3cxaxjuXvYI4gi3kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787615; c=relaxed/simple;
	bh=sHHX5RQsI9ySvrbaOF8l1eY+OhaoBYaJBv/F02Kkunc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fcM4PIPCka8jc7b6tGl9VHaEg5U2H699QWkGTW4WDUiAD+2NKih9SjRFG+sEsRBp30TeRY9jsUlGGgENvms4C4mKeE/ix5XuzkvdHlT4c4XCSjkPbQMg5BiEbR4WK3F3psIRISCP2EoQNs514RB5StH47w36KcDnIKmJ8+W2zM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=weqM0taP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="weqM0taP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA5F1F000FF;
	Wed, 30 Sep 2026 17:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787613;
	bh=qZplOYKMeHSIXKTiIfMeS+QVQhMDwC5lk/aZEyZe7ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=weqM0taP18L2J7YRzCuU6QnhVG0Kh1ey3YOkwtu21aTrxTEW4TVp47aZB/lYeXDna
	 L+WeZr/Fu77wrCzAQDgQuHRaqBVSsg3/iZgF09ys2EuWeH42d681Io3/F1aHB0w0I4
	 zhx2pdqWEtyBl8BdbUlHfd8hrKfLL063gg94BIcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 290/457] drm/amdgpu: Fix runtime PM leak in amdgpu_debugfs_test_ib_show()
Date: Wed, 30 Sep 2026 17:26:35 +0200
Message-ID: <20260930152352.294228984@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 2b86ab1bd6673c525adda88819d7658ba9e784ec upstream.

amdgpu_debugfs_test_ib_show() resumes the device with
pm_runtime_get_sync() before taking the reset domain semaphore with
down_write_killable().  If the write lock acquisition is interrupted,
the function returns without calling pm_runtime_put_autosuspend(),
leaking the runtime PM reference acquired for the device and keeping
the GPU awake.

Drop the runtime PM reference on the interrupted down_write_killable()
error path before returning.

Fixes: 6049db43d6dd ("drm/amdgpu: change reset lock from mutex to rw_semaphore")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ec30a576c2d4c0364549e6c04218f50704ef56c8)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1773,8 +1773,10 @@ static int amdgpu_debugfs_test_ib_show(s
 
 	/* Avoid accidently unparking the sched thread during GPU reset */
 	r = down_write_killable(&adev->reset_domain->sem);
-	if (r)
+	if (r) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return r;
+	}
 
 	/* hold on the scheduler */
 	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {


