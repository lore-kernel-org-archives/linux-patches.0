Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A555C46AA68;
	Tue, 21 Jul 2026 15:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648228; cv=none; b=hgRdTsCA+4u8gPkUJI/2AKei2MxFGjTAAiQiURG8Ttj1s5st9rCI1WJK3JnTOh0pFbobOJHcbxVSOgEbbce94foRh9mUdiaV4zDAM0/dQLtyCA18WqpLESQebkvBbXoWTgEfx/xTkqTgYkjlV9bt2D0Auksq8+0fg7uXivnjDCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648228; c=relaxed/simple;
	bh=o3zdF/zB8EHfTPs0eXNUwTQvdd6uFtR10YWQwvcqJbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klUyIvyGke7c0/+1i49NoLXe+48y89UUtFLwkmIygW8W7shKhqf2mHznBCr4aevKDS1W9LBA9WsKdY6nU/AleCw67OsmuT7o5Zn5svYH9GR0IUaRMlWak3gAwsmhmhCcQMSm4nM4e6+VjvJnK9tLXKenJf90bQFH+f33BEgN5cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZssDSWcX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZssDSWcX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A6B1F000E9;
	Tue, 21 Jul 2026 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648227;
	bh=q1uAxfjZnEdFsZfu1ApQ69AHQclMBpUrYTdBnQs3XCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZssDSWcXfZdy7hWJ3SxTugyhpoBRqhu73srBhqPRyHIMCVczBy6b4DfD7LeMzKpi5
	 IvqbCYEDIAml/ETJOtHC2fp/3VftYsRQCaNSORJc9p0nV0MVIb7oBptId4WQ15sImT
	 CYwB62mhoHop7o7fVQA1ZNQT4xx2O1c6BPZg1bX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0119/2077] drm: verisilicon: call atomic helpers plane state check even if no CRTC
Date: Tue, 21 Jul 2026 16:56:32 +0200
Message-ID: <20260721152555.506555336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <zhengxingda@iscas.ac.cn>

[ Upstream commit eae3903e33797a28d0d37e693d4314d58338918e ]

The `drm_atomic_helper_check_plane_state()` helper function needs to be
called even if the plane is bound to no CRTCs.

Remove the early return in the primary plane's atomic_check, and use
NULL for crtc_state in this situation.

Fixes: dbf21777caa8 ("drm: verisilicon: add a driver for Verisilicon display controllers")
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260331060126.1291966-4-zhengxingda@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/verisilicon/vs_primary_plane.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/verisilicon/vs_primary_plane.c b/drivers/gpu/drm/verisilicon/vs_primary_plane.c
index e8fcb5958615c0..a383b70f1ea0fc 100644
--- a/drivers/gpu/drm/verisilicon/vs_primary_plane.c
+++ b/drivers/gpu/drm/verisilicon/vs_primary_plane.c
@@ -26,14 +26,10 @@ static int vs_primary_plane_atomic_check(struct drm_plane *plane,
 	struct drm_plane_state *new_plane_state = drm_atomic_get_new_plane_state(state,
 										 plane);
 	struct drm_crtc *crtc = new_plane_state->crtc;
-	struct drm_crtc_state *crtc_state;
+	struct drm_crtc_state *crtc_state = NULL;
 
-	if (!crtc)
-		return 0;
-
-	crtc_state = drm_atomic_get_new_crtc_state(state, crtc);
-	if (WARN_ON(!crtc_state))
-		return -EINVAL;
+	if (crtc)
+		crtc_state = drm_atomic_get_new_crtc_state(state, crtc);
 
 	return drm_atomic_helper_check_plane_state(new_plane_state,
 						   crtc_state,
-- 
2.53.0



