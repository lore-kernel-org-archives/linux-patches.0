Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BE4168C9
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:05:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80219C4339B;
	Mon,  8 May 2023 11:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543915;
	bh=I6YvetD1qWttRXEm+8celIczEEwvdQxK3G7osOUiPUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eC522D8Fpa8sG6feHGYfV3ALRao3zsp7biIAF4gzCEWUHkiyxV+vb2Bs5ueLKEZcb
	 X3VOSSbE2iaUFwWWHQAjfIzX0Nqe0iaZipVJ8iZ17LVxO8HSAX6/sdYq4w4RQRFb8n
	 Y+iV4KIwEnw47BpwTv+p4bFqMDWNLF59157983a8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Qiang Yu <yuq825@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 241/694] drm/lima/lima_drv: Add missing unwind goto in lima_pdev_probe()
Date: Mon,  8 May 2023 11:41:16 +0200
Message-Id: <20230508094440.150886247@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit c5647cae2704e58d1c4e5fedbf63f11bca6376c9 ]

Smatch reports:
drivers/gpu/drm/lima/lima_drv.c:396 lima_pdev_probe() warn:
	missing unwind goto?

Store return value in err and goto 'err_out0' which has
lima_sched_slab_fini() before returning.

Fixes: a1d2a6339961 ("drm/lima: driver for ARM Mali4xx GPUs")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Qiang Yu <yuq825@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230314052711.4061652-1-harshit.m.mogalapalli@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/lima/lima_drv.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/lima/lima_drv.c b/drivers/gpu/drm/lima/lima_drv.c
index 7b8d7178d09aa..39cab4a55f572 100644
--- a/drivers/gpu/drm/lima/lima_drv.c
+++ b/drivers/gpu/drm/lima/lima_drv.c
@@ -392,8 +392,10 @@ static int lima_pdev_probe(struct platform_device *pdev)
 
 	/* Allocate and initialize the DRM device. */
 	ddev = drm_dev_alloc(&lima_drm_driver, &pdev->dev);
-	if (IS_ERR(ddev))
-		return PTR_ERR(ddev);
+	if (IS_ERR(ddev)) {
+		err = PTR_ERR(ddev);
+		goto err_out0;
+	}
 
 	ddev->dev_private = ldev;
 	ldev->ddev = ddev;
-- 
2.39.2



