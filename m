Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210669;
	b=EupxQTzPiY2h8+CnMuoUUpM3yKPMsU0+GQgAwNXl+qWD2GeTOt2ftzHj7tqIukscIG7R
	 /0Yr9tSN32Qz7esGzTT4bh9lnSIzZNKBnxbLgK1L+p9kyBX7ZXiYxYpgxElcODAd1YNC7
	 V3bGyhu5Xrc0Lp3ONZG+lUKFxF/tTDH/Z6lSu4/wJq2Cdby27FpOoVCy3wfcyZEdxszqH
	 DDxc2wqyRGSsruz/BneABdNGMml3vzp0c4YG5cg4Ec+otDdktBfqt37f6405XoFvOT1ND
	 lY+WDevVZA4iQP0UdafGqGG3v1bzStPnZiqHbbevWSk9cnCpw9r2HWzEWMvaWOTTUSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eGAVuXsZ5bjmCQXXi03zWb2ewbRduyxJsIm2H1sNluU=;
	b=iU0in7VxlaCgxwTq/XA4vSxuvy0beeEKxbrMD9YIT16Tpcdz0Ho3SVF1Ra1qVcnG8d/I
	 zbLzfQFvdUAURB5Of+6W9p2iAb0fY4t6/wQi+OoHwWOt3WHJeLYUZTmUun0GjPA22IIuF
	 rgxO4csP2C8YNaUrQnLfMAGx9Iy1DQitSkC5eZntYhBsUr9uvwQDhdGZKPdclyOxg1aS1
	 Ic4H8h21P5ljOtqdhrZIPyPTWd+Ajfxi4RpPNMuImfR3eVpsLogsy3nVgoKSk1icVGmoK
	 AdiLMDWe2JFLbYKgKgpHxMQ7YmwOH7fhIVlfoYP23e2p4Dx3Z0BQX6IH2tbhokY66Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1jww5Ba;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BADB606A31A;
	Wed, 28 Oct 2026 18:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d1jww5Ba
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7E91F01825;
	Wed, 28 Oct 2026 18:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210669;
	bh=eGAVuXsZ5bjmCQXXi03zWb2ewbRduyxJsIm2H1sNluU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d1jww5BaRqssqcWXmZhWEsLmpUh6VUF8cGuv5WDfHjb5xRIuLq7n5ffs8u04OVKJ/
	 +3vsxpFhdqow7HfHpOt4UhBKUbfjVlOklPnSsxRRJF4MFdQFOqoeOow5WoNDcdobl3
	 Bbzr5L37/6qTQKJ21Tvi8vjq42gK9bLWJMxzOJW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/571] drm/amdgpu: Fix runtime PM leak in amdgpu_debugfs_test_ib_show()
Date: Wed, 28 Oct 2026 17:54:14 +0100
Message-ID: <20261028170010.561406250@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 2b86ab1bd6673c525adda88819d7658ba9e784ec ]

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
[ Adapted `down_write_killable(&adev->reset_domain->sem)` to `down_read_killable(&adev->reset_sem)`. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
index 49711776b3516..944ecf780781e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_debugfs.c
@@ -1140,8 +1140,10 @@ static int amdgpu_debugfs_test_ib_show(struct seq_file *m, void *unused)
 
 	/* Avoid accidently unparking the sched thread during GPU reset */
 	r = down_read_killable(&adev->reset_sem);
-	if (r)
+	if (r) {
+		pm_runtime_put_autosuspend(dev->dev);
 		return r;
+	}
 
 	/* hold on the scheduler */
 	for (i = 0; i < AMDGPU_MAX_RINGS; i++) {
-- 
2.53.0



