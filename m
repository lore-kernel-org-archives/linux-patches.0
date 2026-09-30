Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047863DBD48;
	Wed, 30 Sep 2026 19:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796993; cv=none; b=biWAGYcipLFYwKJii5Zadym2KeIdw/m5GF9/MiVuPLtiB4K5r3JVyoCKhWc/iNvCgga1OqfmNj5vDu2opDt7BKOik7cDs1T2NOK/614Tal95EVjWXw/wNjLpPUYiINPS0UBfgW6Xk4rwoDKQzWGZ+z5S47kJji7RYBL291D9uKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796993; c=relaxed/simple;
	bh=NlsY4+9ObDWJKQVv2+eDj3fNzajKUgN+pIu0Hioe0EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xn4ngKCq0KkTEEzW14UYsK1Nul3KsFigZwNHcTlGwQwtGA2VY8dQU9npndXtw+I11kwpvrZzcCv5zEp0htX3utZRdsKAX2x0Dqt6IBrrPayqA0rPeqjgHUDxxvuHHrX4dshVJewfVyd5jr+J0hgL+Q27xe/NqsIrXKbbkd++43g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LkIVD4hy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LkIVD4hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBC91F000FF;
	Wed, 30 Sep 2026 19:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796991;
	bh=HUeEgijCp0hq+sAPmLA+yRt+HhsrzvvlEPBLwGrCN4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LkIVD4hyqfpnUgUoYP0fubkDDe8m1j25P3tiGrHJgSBOcVYygqzClD/EvRTocCpuF
	 7dTHubZf5gyh7QRQQw+buUwxSqRMrRNf7laiLsoFrJAa0H/9GwYyGZBPpR3GrYjhS8
	 Q+eY6TOXlWX4g1rsJ59bP88Np//wlT/KI5b7qljM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 1110/1193] drm/amdgpu: Fix runtime PM leak in amdgpu_debugfs_test_ib_show()
Date: Wed, 30 Sep 2026 17:29:54 +0200
Message-ID: <20260930152458.893460786@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1664,8 +1664,10 @@ static int amdgpu_debugfs_test_ib_show(s
 
 	/* Avoid accidently unparking the sched thread during GPU reset */
 	r = down_write_killable(&adev->reset_domain->sem);
-	if (r)
+	if (r) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return r;
+	}
 
 	/* hold on the scheduler */
 	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {


