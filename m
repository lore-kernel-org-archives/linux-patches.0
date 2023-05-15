Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63F32FC08
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4EDC433EF;
	Mon, 15 May 2023 17:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172285;
	bh=yHoZdrMyzojXfxJn9OcPDeX0pm/49ACkVoyILodDSBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HLLGmGP2JEjY4pvP0mC2i/EGIeo7zrErvstm/zF9t/Awz5BeKNyGGz58CgPsep1+7
	 FYq7ov8tsMQq+Jde3WNYHrBFYZVWrfQ6NfbweNKdsOmYgenN+D2sDBcdrlIUdVa21H
	 LzWTuRU9hXyZ6hATpoJdFLIXr4zuTicc3jAHt3Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mairacanal@riseup.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/381] drm/vgem: add missing mutex_destroy
Date: Mon, 15 May 2023 18:25:25 +0200
Message-Id: <20230515161740.168597157@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit 7c18189b14b33c1fbf76480b1bd217877c086e67 ]

vgem_fence_open() instantiates a mutex for a particular fence
instance, but never destroys it by calling mutex_destroy() in
vgem_fence_close().

So, add the missing mutex_destroy() to guarantee proper resource
destruction.

Fixes: 407779848445 ("drm/vgem: Attach sw fences to exported vGEM dma-buf (ioctl)")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Signed-off-by: Maíra Canal <mairacanal@riseup.net>
Link: https://patchwork.freedesktop.org/patch/msgid/20230202125517.427976-1-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vgem/vgem_fence.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vgem/vgem_fence.c b/drivers/gpu/drm/vgem/vgem_fence.c
index 17f32f550dd99..575bc331716e8 100644
--- a/drivers/gpu/drm/vgem/vgem_fence.c
+++ b/drivers/gpu/drm/vgem/vgem_fence.c
@@ -249,4 +249,5 @@ void vgem_fence_close(struct vgem_file *vfile)
 {
 	idr_for_each(&vfile->fence_idr, __vgem_fence_idr_fini, vfile);
 	idr_destroy(&vfile->fence_idr);
+	mutex_destroy(&vfile->fence_mutex);
 }
-- 
2.39.2



