Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13579125AA;
	Fri,  9 Oct 2026 14:33:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556403; cv=none; b=Uu3MgjxkHqzpKoYfZI5m+5mDgtaJZVjNj4OqIi2sYMM/tra8qTu+zhpFwZnCe8vYA4NQJpVXQHoBuGDn6KmHlA1QQT0RUMJxMeP9PEFzsaDQR4MaS+rU0JVjlKoU2DAfDPnH7hyyHK1LMCiWBqRal7Y4oX6MpNdwvFzfz5rYg+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556403; c=relaxed/simple;
	bh=yQOhWdDhVBfJ+vBwnznmV/yGrYT5gaSTTCuwOUH9ShI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sq5nvqdCX2uSXwwLc+XgAgJ4DF7lHd030E9qLMIOYCWFOxMs94dRCrXqli+y9DMooNegazFNrUsGUzyg8Gm0PwztfrDkYVuDv6zagjcdRn4ggV5IbTdqhDw+7iMBvsDoz3gY+6gTA7n1zTWJL2obtl3hf0lvbFQDRB8lyK1VMf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMoYIjOf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMoYIjOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E1A1F000FF;
	Fri,  9 Oct 2026 14:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556402;
	bh=Qpx7Sa1idOM86RG4IUYc+meo1s8wmuWupUnOCB7Ja1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMoYIjOf5Q2WLD4IchAUW77Aa7xZm/rz9x2XIjXDU0n58saRFhXBIuNNwnn0nVtPu
	 l1qb8BHBgkmCVDP1DzdKMr3Jy3F0EJ8qfOjvtxSpBOS754bNSZDipH7NiDG9pOSThj
	 JMC//rZ2+7MxAIJaF3zf8H/9aDmtTmTgaz02QfeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Zhang <george.zhang@amd.com>,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 170/428] drm/amd/display: check dc_state_create_copy() for NULL in dm_suspend
Date: Fri,  9 Oct 2026 16:08:27 +0200
Message-ID: <20261009140949.889321596@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit 015e72cde567d2450e282c2790773463156b2d0a upstream.

dc_state_create_copy() can return NULL on allocation failure.
dm_suspend() only conditionally skips dm_gpureset_toggle_interrupts()
and continues execution, returning success.  dm_resume() then
dereferences the NULL cached_dc_state in link_enc_cfg_copy() and the
following dc_state->stream_count loop, crashing during GPU reset
recovery.

Return -ENOMEM immediately if the copy fails, so the caller aborts
suspend instead of leaving a NULL cached state for resume.

Fixes: 8092aa3ab8f7 ("drm/amd/display: Add null checker before passing variables")
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 84b6d7932fdd2857795a257f9f258562a3cddcab)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3516,9 +3516,14 @@ static int dm_suspend(struct amdgpu_ip_b
 		dc_allow_idle_optimizations(adev->dm.dc, false);
 
 		dm->cached_dc_state = dc_state_create_copy(dm->dc->current_state);
+		if (!dm->cached_dc_state) {
+			drm_err(adev_to_drm(adev),
+				"Failed to allocate cached DC state during suspend\n");
+			mutex_unlock(&dm->dc_lock);
+			return -ENOMEM;
+		}
 
-		if (dm->cached_dc_state)
-			dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
+		dm_gpureset_toggle_interrupts(adev, dm->cached_dc_state, false);
 
 		res = amdgpu_dm_commit_zero_streams(dm->dc);
 		if (res != DC_OK) {


