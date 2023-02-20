Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B024563BB
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:51:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383E9C433EF;
	Mon, 20 Feb 2023 13:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901116;
	bh=ux566SMcxf5tinG2b7keNJbkGbj86VcKuIV+OtvWxq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=umxf/Z3elHeeW8IUg0PjL66+RFu754q/0dsreRlTTU8mtzZoOxcgdFmDdK1BD9br/
	 P3Un5YC/Zki7NOPt8B2CR/IAotwpZC6Y7NwTrjoP1nULbUNxnfVahLfqj4+WpDzWk9
	 SQriE1ChW/0iS1Qp33Q3S5UN6UGtcX2HuqvddFi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 36/83] drm/amd/display: Fail atomic_check early on normalize_zpos error
Date: Mon, 20 Feb 2023 14:36:09 +0100
Message-Id: <20230220133554.922991644@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Leo Li <sunpeng.li@amd.com>

commit 2a00299e7447395d0898e7c6214817c06a61a8e8 upstream.

[Why]

drm_atomic_normalize_zpos() can return an error code when there's
modeset lock contention. This was being ignored.

[How]

Bail out of atomic check if normalize_zpos() returns an error.

Fixes: b261509952bc ("drm/amd/display: Fix double cursor on non-video RGB MPO")
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Tested-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Reviewed-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10889,7 +10889,11 @@ static int amdgpu_dm_atomic_check(struct
 	 * `dcn10_can_pipe_disable_cursor`). By now, all modified planes are in
 	 * atomic state, so call drm helper to normalize zpos.
 	 */
-	drm_atomic_normalize_zpos(dev, state);
+	ret = drm_atomic_normalize_zpos(dev, state);
+	if (ret) {
+		drm_dbg(dev, "drm_atomic_normalize_zpos() failed\n");
+		goto fail;
+	}
 
 	/* Remove exiting planes if they are modified */
 	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {


