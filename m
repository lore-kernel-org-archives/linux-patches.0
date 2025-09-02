Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D35D3054D8;
	Tue,  2 Sep 2025 13:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819446; cv=none; b=babJNhh7TJjKJ/eFiXTHCNZ9HXABY+pVY1SosCDVvRia8pG8PNd3Y7GsbTsq7+QVGc6bOOJZzLlVo3mpSBW5WGq5Tce6U4q1dGEDBYZl4MPqjb3KDwKlAeANgZ43A5g3+ZTrFiXTRsL3ySZqXT0l6HQ1yMfkmCIcf2U00Afhc78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819446; c=relaxed/simple;
	bh=beNxsUH1B9xG4UHXbxZUoKfUXi2l/udl82QdBlkrLSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRj60Ze3MSNeck6Nh0KvQ3NpzNIm62lUN9j+o2ucRYEbXSO59uCUERPZG84pG0t4GJv8GdzKGJFCVxZ9K1ahnWLupnU0W/mio+c5bZKFi3xiYPOvkW+JLPSFLIoLALyhztzekLO5t+ZGp2h+ubH3dOPMhv5LhmSjEVk3UDkc02s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gkbK18F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gkbK18F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D50E8C4CEED;
	Tue,  2 Sep 2025 13:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819446;
	bh=beNxsUH1B9xG4UHXbxZUoKfUXi2l/udl82QdBlkrLSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gkbK18FfvKbqgigmG2f5vOEgZTHf+GdoAGLstOk7cdDDuv269jIwb7Mc4NizYb+a
	 GvUxtqowqYkNDp5uY++HNDQr4LX/m6pZIxKDix2eqKht7oBeQgwsZa82sjVGiPZ/2N
	 S8QBV2QU26U8OMk17j15F+hZkxWDxMwCX3Ue48oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 037/142] drm/mediatek: Add error handling for old state CRTC in atomic_disable
Date: Tue,  2 Sep 2025 15:18:59 +0200
Message-ID: <20250902131949.569648429@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason-JH Lin <jason-jh.lin@mediatek.com>

[ Upstream commit 0c6b24d70da21201ed009a2aca740d2dfddc7ab5 ]

Introduce error handling to address an issue where, after a hotplug
event, the cursor continues to update. This situation can lead to a
kernel panic due to accessing the NULL `old_state->crtc`.

E,g.
Unable to handle kernel NULL pointer dereference at virtual address
Call trace:
 mtk_crtc_plane_disable+0x24/0x140
 mtk_plane_atomic_update+0x8c/0xa8
 drm_atomic_helper_commit_planes+0x114/0x2c8
 drm_atomic_helper_commit_tail_rpm+0x4c/0x158
 commit_tail+0xa0/0x168
 drm_atomic_helper_commit+0x110/0x120
 drm_atomic_commit+0x8c/0xe0
 drm_atomic_helper_update_plane+0xd4/0x128
 __setplane_atomic+0xcc/0x110
 drm_mode_cursor_common+0x250/0x440
 drm_mode_cursor_ioctl+0x44/0x70
 drm_ioctl+0x264/0x5d8
 __arm64_sys_ioctl+0xd8/0x510
 invoke_syscall+0x6c/0xe0
 do_el0_svc+0x68/0xe8
 el0_svc+0x34/0x60
 el0t_64_sync_handler+0x1c/0xf8
 el0t_64_sync+0x180/0x188

Adding NULL pointer checks to ensure stability by preventing operations
on an invalid CRTC state.

Fixes: d208261e9f7c ("drm/mediatek: Add wait_event_timeout when disabling plane")
Signed-off-by: Jason-JH Lin <jason-jh.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20250728025036.24953-1-jason-jh.lin@mediatek.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_plane.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_plane.c b/drivers/gpu/drm/mediatek/mtk_plane.c
index cbc4f37da8ba8..02349bd440017 100644
--- a/drivers/gpu/drm/mediatek/mtk_plane.c
+++ b/drivers/gpu/drm/mediatek/mtk_plane.c
@@ -292,7 +292,8 @@ static void mtk_plane_atomic_disable(struct drm_plane *plane,
 	wmb(); /* Make sure the above parameter is set before update */
 	mtk_plane_state->pending.dirty = true;
 
-	mtk_crtc_plane_disable(old_state->crtc, plane);
+	if (old_state && old_state->crtc)
+		mtk_crtc_plane_disable(old_state->crtc, plane);
 }
 
 static void mtk_plane_atomic_update(struct drm_plane *plane,
-- 
2.50.1



