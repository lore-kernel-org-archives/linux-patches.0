Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C89513555;
	Wed, 30 Sep 2026 16:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786660; cv=none; b=DhGF3WPirJGdoSQUyeG1yUlnx3W4FLb1yaHs7DsxOyNnNo1mp78KTGI3akYOYymZSB8udAwU+cGLtlvU2zg7elbebS1LUxvCtqn+QFFbRptzpoPqx2EP0vH6j3QM2DYa2fMPTqKdZvERDyX8QJ11IkPPXPdsn5AioGkj1QXCIjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786660; c=relaxed/simple;
	bh=4kcVrTCugBFqkjrx1JzOqOvfLZ8j6vDGcnmaflwCZzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YDMRHZggTuUIXUDMaknfF/Fu+eohjJSII1GKyGzQAJlLVbUS9yBsTZWgSJbR00OdHtzs4h11vJh1JguXrjl7oxFZE+GIQKrCn9ZPYQgjX+fIrgpIebu/DbsuOqTBz7/5xRs8T2RVc1Sp7TVJy3S4+1hIlydFk6PKmfUh/OPX/YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXXMXvPx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXXMXvPx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A5F1F000FF;
	Wed, 30 Sep 2026 16:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786659;
	bh=jl6gGD+YNyn6ycayWQkwYuqhu5/T10Y2j7Pfy4D9jKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vXXMXvPxpfU1IlCLNZnqXtDEtddgRle8pukbgUPWT79Ave5fItXGFVq5KQP3oIzd8
	 L8IBwHZlNkMrNkECakj2yP67f7hazDFgmcNxuS6ophTrxL/N9YfyEpGEjkJZOW2S7x
	 V30dVB3VfCJXWOpnPK27lLg+QjkSV75ijrgfiw2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 941/982] drm/amdgpu: Fix runtime PM leak in amdgpu_debugfs_test_ib_show()
Date: Wed, 30 Sep 2026 17:27:57 +0200
Message-ID: <20260930152436.951975991@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1494,8 +1494,10 @@ static int amdgpu_debugfs_test_ib_show(s
 
 	/* Avoid accidently unparking the sched thread during GPU reset */
 	r = down_write_killable(&adev->reset_domain->sem);
-	if (r)
+	if (r) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return r;
+	}
 
 	/* hold on the scheduler */
 	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {


