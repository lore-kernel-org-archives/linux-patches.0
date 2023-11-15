Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499843C470
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lLGUWhvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9FB5C433CB;
	Wed, 15 Nov 2023 19:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077346;
	bh=t+fNQsicTuzOWKLDMU14nGQZZsNmDvjFjfEYnu+4FDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLGUWhvbfkh969glB4T7JLCxoerCKHnz98zL2ibYfyQBS7jPjkNJont+LGGE/sCy8
	 DhptToFW71Z/KF4JSNsG2+cvr0D8C1wJJB9aam5Oph6xW8UBN1xpRs3Yx+Pcul1b/z
	 W1WAjIuQMotvkVQFuOfy4Ghiy0mxKp1NMch5dNvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Michel=20D=C3=A4nzer?= <mdaenzer@redhat.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/603] drm/amd/display: Check all enabled planes in dm_check_crtc_cursor
Date: Wed, 15 Nov 2023 14:13:11 -0500
Message-ID: <20231115191630.263131637@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michel Dänzer <mdaenzer@redhat.com>

[ Upstream commit 003048ddf44b1a6cfa57afa5a0cf40673e13f1ba ]

It was only checking planes which had any state changes in the same
commit. However, it also needs to check other enabled planes.

Not doing this meant that a commit might spuriously "succeed", resulting
in the cursor plane displaying with incorrect scaling. See
https://gitlab.gnome.org/GNOME/mutter/-/merge_requests/3177#note_1824263
for an example.

Fixes: d1bfbe8a3202 ("amd/display: check cursor plane matches underlying plane")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Michel Dänzer <mdaenzer@redhat.com>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 4120ae9d10248..342988f52d960 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9908,14 +9908,24 @@ static int dm_check_crtc_cursor(struct drm_atomic_state *state,
 	 * blending properties match the underlying planes'.
 	 */
 
-	new_cursor_state = drm_atomic_get_new_plane_state(state, cursor);
-	if (!new_cursor_state || !new_cursor_state->fb)
+	new_cursor_state = drm_atomic_get_plane_state(state, cursor);
+	if (IS_ERR(new_cursor_state))
+		return PTR_ERR(new_cursor_state);
+
+	if (!new_cursor_state->fb)
 		return 0;
 
 	dm_get_oriented_plane_size(new_cursor_state, &cursor_src_w, &cursor_src_h);
 	cursor_scale_w = new_cursor_state->crtc_w * 1000 / cursor_src_w;
 	cursor_scale_h = new_cursor_state->crtc_h * 1000 / cursor_src_h;
 
+	/* Need to check all enabled planes, even if this commit doesn't change
+	 * their state
+	 */
+	i = drm_atomic_add_affected_planes(state, crtc);
+	if (i)
+		return i;
+
 	for_each_new_plane_in_state_reverse(state, underlying, new_underlying_state, i) {
 		/* Narrow down to non-cursor planes on the same CRTC as the cursor */
 		if (new_underlying_state->crtc != crtc || underlying == crtc->cursor)
-- 
2.42.0



