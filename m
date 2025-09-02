Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8485B3054EC;
	Tue,  2 Sep 2025 13:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819880; cv=none; b=d/tm5k+DUTlRIOMSQiPJNcKKakO20ZrLWsQgEO7VGQ4s52Iwp6qQvwrLU3OppLmvvNM7osLsEJdCRA1uNw+V0J1QTV705QQdoEHG4FfgUNJQWZ5X2Ajg6KiVY8oczzhwdxAau/bmesz/uacsp4hPYmhHIiI+mRtvdEpT1sRBtNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819880; c=relaxed/simple;
	bh=JFA1PbaqKa+DvCHEuJgCdDgrUMi5KbPTqIsO6mLnRN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cPLpTuacPmQ/8ZXxtZhNvmAp0yp+1WmPrSXz/LhjLMjuvjrN5BwjIhFtJBylvw3b93Q/d0m1tDICEOsyroFNej214s46hiHvjhiclsvXMj9IOcEo7wyORUiqeGiTmOnmwZHLwiHKAx+KOWuEnfDPCawCN2XFSmwVfnGojfGT6wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUw4ldkH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUw4ldkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036D3C4CEED;
	Tue,  2 Sep 2025 13:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819880;
	bh=JFA1PbaqKa+DvCHEuJgCdDgrUMi5KbPTqIsO6mLnRN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rUw4ldkHuyvmKU30c4KyxfYij1NBe0PGHRhlaRf2hoa7lHShZzqdXbXQkCdNB0zxi
	 u4MYmn6/m3Juubm0PnyE2+PNEB0wUE+XPJwAjN+QnqJE39/XBJ66kOgIVPU/2wNN83
	 3AhtCmh5uyaIBHP+6jqavawYgw4W55TvYkoViuPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason-JH Lin <jason-jh.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 24/95] drm/mediatek: Add error handling for old state CRTC in atomic_disable
Date: Tue,  2 Sep 2025 15:20:00 +0200
Message-ID: <20250902131940.540888264@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 74c2704efb664..6e20f7037b5bb 100644
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



