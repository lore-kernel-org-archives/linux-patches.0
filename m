Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621F817E90E;
	Mon, 27 May 2024 19:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837068; cv=none; b=l7CbzBTq27OmlTDItvMXD3hjdRdnnip1emcBc/iBL/fPmYfJ9FYbYt2EljWwV+fFpavgLR+bsLTrPs0EkrrWgaanFgN6GRLSsVKzNo8CoRbaWiBEEptgs4PQ01CjzPGUlg5p7LpmLLCxGKQQ7WILW7Cpp0yNHQWqeufUuG5DnwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837068; c=relaxed/simple;
	bh=tw8KNhAPpoXf6wt7A3otFuLMDhHKiW/zJig1qN3LQOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dZCAd851R8VDctKNn5BNbYrsWxzBapvYepjquwymr1t5d3+JgN+zTzSuo468YeOhOYXusWiWTZbOB4SMx2i04C3n1NI2p1GjMMi1xSzImnVQmrph2jpbYbO4iE5SSTV10TPyaaUaLlMYIyydc4sZ58ZHvDYoXVNw2xMTN2JDD7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eF35FRPk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eF35FRPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF3AC2BBFC;
	Mon, 27 May 2024 19:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837068;
	bh=tw8KNhAPpoXf6wt7A3otFuLMDhHKiW/zJig1qN3LQOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eF35FRPks+PaQQRMO3XC6Zo2UJv4fbdN0pzKbvHF6RzFhwebXYLAIbTp9a6lM+My/
	 53Z0UXvONMqu26QcPp7MNWQ5h9u21U0vt/Yhb4IBuucxEiVb0CtyVkAYnMRYoazThl
	 yMpO49Tx31tdid+tvRCTTkSpd6Tjvoc5gGbrXL8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 298/427] drm/mediatek: Init `ddp_comp` with devm_kcalloc()
Date: Mon, 27 May 2024 20:55:45 +0200
Message-ID: <20240527185630.069770638@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 01a2c5123e27b3c4685bf2fc4c2e879f6e0c7b33 ]

In the case where `conn_routes` is true we allocate an extra slot in
the `ddp_comp` array but mtk_drm_crtc_create() never seemed to
initialize it in the test case I ran. For me, this caused a later
crash when we looped through the array in mtk_drm_crtc_mode_valid().
This showed up for me when I booted with `slub_debug=FZPUA` which
poisons the memory initially. Without `slub_debug` I couldn't
reproduce, presumably because the later code handles the value being
NULL and in most cases (not guaranteed in all cases) the memory the
allocator returned started out as 0.

It really doesn't hurt to initialize the array with devm_kcalloc()
since the array is small and the overhead of initting a handful of
elements to 0 is small. In general initting memory to zero is a safer
practice and usually it's suggested to only use the non-initting alloc
functions if you really need to.

Let's switch the function to use an allocation function that zeros the
memory. For me, this avoids the crash.

Fixes: 01389b324c97 ("drm/mediatek: Add connector dynamic selection capability")
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20240328092248.1.I2e73c38c0f264ee2fa4a09cdd83994e37ba9f541@changeid/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_crtc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index a04499c4f9ca2..29207b2756c14 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -1009,10 +1009,10 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 
 	mtk_crtc->mmsys_dev = priv->mmsys_dev;
 	mtk_crtc->ddp_comp_nr = path_len;
-	mtk_crtc->ddp_comp = devm_kmalloc_array(dev,
-						mtk_crtc->ddp_comp_nr + (conn_routes ? 1 : 0),
-						sizeof(*mtk_crtc->ddp_comp),
-						GFP_KERNEL);
+	mtk_crtc->ddp_comp = devm_kcalloc(dev,
+					  mtk_crtc->ddp_comp_nr + (conn_routes ? 1 : 0),
+					  sizeof(*mtk_crtc->ddp_comp),
+					  GFP_KERNEL);
 	if (!mtk_crtc->ddp_comp)
 		return -ENOMEM;
 
-- 
2.43.0



