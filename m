Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2864BA36
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C63AC433C0;
	Mon, 26 Jun 2023 18:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804459;
	bh=pIJzDSdZm6E+NnIwO57Xq2I4agMZenBysCO9cU1z8zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRMc5xV6t4rSljKpsoagVzkRb2Fe1wHREfR70QaaUjain7qPH3ZKGbY4l2OaZ20j6
	 DRGQrj0z1sn1xQwaXKdbR/W2hbT79Leq2wsp/QG98uS+45YW21ZuGVvwhqEJSvyxtt
	 4JhmdQ8GVNsC26YcQMVHBn3dvaOdpR8qJqwyU+9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min Li <lm0963hack@gmail.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 163/170] drm/exynos: fix race condition UAF in exynos_g2d_exec_ioctl
Date: Mon, 26 Jun 2023 20:12:12 +0200
Message-ID: <20230626180807.780272162@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Min Li <lm0963hack@gmail.com>

[ Upstream commit 48bfd02569f5db49cc033f259e66d57aa6efc9a3 ]

If it is async, runqueue_node is freed in g2d_runqueue_worker on another
worker thread. So in extreme cases, if g2d_runqueue_worker runs first, and
then executes the following if statement, there will be use-after-free.

Signed-off-by: Min Li <lm0963hack@gmail.com>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/exynos/exynos_drm_g2d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/exynos/exynos_drm_g2d.c b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
index 471fd6c8135f2..27613abeed961 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_g2d.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_g2d.c
@@ -1335,7 +1335,7 @@ int exynos_g2d_exec_ioctl(struct drm_device *drm_dev, void *data,
 	/* Let the runqueue know that there is work to do. */
 	queue_work(g2d->g2d_workq, &g2d->runqueue_work);
 
-	if (runqueue_node->async)
+	if (req->async)
 		goto out;
 
 	wait_for_completion(&runqueue_node->complete);
-- 
2.39.2



