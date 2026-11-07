Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063066;
	b=oG5ZdD+iAS/FsdmEM2OpYGvEcgUaAsHNJ7dRzwKgnken2uAPHrbO2r9OhrhFh/hUn4RE
	 NPOEnzvrwtZNWLLBEP4uQ+DqC0b2/bT3G28pbSFWcA+o/h0Lxsd1WCWQE/2LyZIQRyPQG
	 pfR+3MvzqF4ExWPLXAW0LqHOgYiDYdbQH/oPRfAaS4WG2DKoKxa31ss5/ISDFnoahZkzk
	 0ftAs/bBiXKuekbdWyczU7UEaiOpdhuKgxqDqN0QfG9LJ/sV3fKfJMeqo0TN1lYKhGJdP
	 EhbWoc4aNMgxPfE88bjhTv5gx5QbMfhXF9LVmr5bwr6c2x3VYWpcQ7ivnKbSqhFBpnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eTmO/+yEMYHfC7jcxTcCmT3JgLNLS943c5Vfe0Hq/l8=;
	b=VUZUeWJZMI8Mp5S1K6aIyc6oIsM0gr115WXMKynk64WGCrlJs3+8JHKvTM1Ve7RuwPPn
	 fzkIL/duyJ8vE7OXGxHcuKM+y5lcJGxjFPZEaMDenpj+8RZyHUA5MaKfO6R+n0MNoZ987
	 lJrnJgjx1cqA4dLktHFI4hJSy+gC85nyUEgZd7BVj1WZZjlEhnASARBcHgUsoykWjv3dx
	 xS0KrPmpgDNHGuSDkskZfD6FkgfqyMDIk2NpsEbAVlReXk10TBFf/DKMfmO7m4mU1Tsvq
	 YG1gIYn2+UdHrvyFZA8T0E1u3SdQgt/0QuScycPQedFroLOD+CTyzob7kpu/0EuJ16w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKzGqwti;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9529A606D82F;
	Sat,  7 Nov 2026 14:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BKzGqwti
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4274C1F0089F;
	Sat,  7 Nov 2026 14:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063066;
	bh=eTmO/+yEMYHfC7jcxTcCmT3JgLNLS943c5Vfe0Hq/l8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKzGqwtiqkLpMlQH905Q2bpekmi+kmW6tWiLctIDaWBl68diBQ+9IvPiF3bDbCQyV
	 jxQ9tMPl8LOf3EPI1RPo/faszGr9HCK7j6f/SyFbK/Db9EwkN6a0+zmXluJA8XucAn
	 msHoPg+CjSPQSexXy+9meq+izzAGZCiwL955AC/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Rob Clark <rob.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 307/869] drm/msm/dsi: Fix VM leak in dsi_tx_buf_alloc_6g()
Date: Sat,  7 Nov 2026 08:49:49 -0500
Message-ID: <20261107134902.946298047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit ab91ba61871a896ca2ecc6e048d80a152136da44 ]

dsi_tx_buf_alloc_6g() takes a reference to the kms VM with
drm_gpuvm_get() and stores it in msm_host->vm.  If
msm_gem_kernel_new() fails, the function returns early without
dropping that reference.  Since msm_host->tx_gem_obj is cleared on
the error path, msm_dsi_tx_buf_free() will never see a non-NULL
tx_gem_obj and thus never calls drm_gpuvm_put(), leaking the VM
reference.

Drop the VM reference and clear msm_host->vm on the error path.

Fixes: 5e05be782645 ("drm/msm/dsi: free TX buffer in unbind")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Rob Clark <rob.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/754332/
Link: https://lore.kernel.org/r/20260916175738.2089950-1-vulab@iscas.ac.cn
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 4e93f8dd39d7d..1827af24a3fa1 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1254,6 +1254,8 @@ int dsi_tx_buf_alloc_6g(struct msm_dsi_host *msm_host, int size)
 
 	if (IS_ERR(data)) {
 		msm_host->tx_gem_obj = NULL;
+		drm_gpuvm_put(msm_host->vm);
+		msm_host->vm = NULL;
 		return PTR_ERR(data);
 	}
 
-- 
2.53.0



