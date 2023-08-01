Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B201FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A218C433C7;
	Tue,  1 Aug 2023 09:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882754;
	bh=aGvHsGaqppuhvEI47ZtJJWpZCGoZCzwnHnrYpAdzzLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eHpBf5ZZ4cQNnBbyT/4I7sYJ6ylGmFC9inWkqNS19VqlwgbjL1bUbTSMhe2xi3vew
	 DxVFfDKGxOpcp4XThQ99V2r8D1diitXn+QdBEFcrohexVvIAm7fZgJxPzGGe80LpDY
	 5AwrMNLczFncFlkyNDpWEH9b+pRJpIDkvKlL6kZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <ben@bcheng.me>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 220/228] drm/amd/display: Write to correct dirty_rect
Date: Tue,  1 Aug 2023 11:21:18 +0200
Message-ID: <20230801091930.794315583@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091922.799813980@linuxfoundation.org>
References: <20230801091922.799813980@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benjamin Cheng <ben@bcheng.me>

commit 751281c55579f0cb0e56c9797d4663f689909681 upstream.

When FB_DAMAGE_CLIPS are provided in a non-MPO scenario, the loop does
not use the counter i. This causes the fill_dc_dity_rect() to always
fill dirty_rects[0], causing graphical artifacts when a damage clip
aware DRM client sends more than 1 damage clip.

Instead, use the flip_addrs->dirty_rect_count which is incremented by
fill_dc_dirty_rect() on a successful fill.

Fixes: 30ebe41582d1 ("drm/amd/display: add FB_DAMAGE_CLIPS support")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2453
Signed-off-by: Benjamin Cheng <ben@bcheng.me>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -5023,9 +5023,9 @@ static void fill_dc_dirty_rects(struct d
 
 		for (; flip_addrs->dirty_rect_count < num_clips; clips++)
 			fill_dc_dirty_rect(new_plane_state->plane,
-					   &dirty_rects[i], clips->x1,
-					   clips->y1, clips->x2 - clips->x1,
-					   clips->y2 - clips->y1,
+					   &dirty_rects[flip_addrs->dirty_rect_count],
+					   clips->x1, clips->y1,
+					   clips->x2 - clips->x1, clips->y2 - clips->y1,
 					   &flip_addrs->dirty_rect_count,
 					   false);
 		return;


