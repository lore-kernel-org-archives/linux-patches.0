Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E49355409D;
	Wed,  9 Sep 2026 14:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963010; cv=none; b=c+X7aNnOr8NdAr2cUfHlCIEkARJAnbphLGPW/d50MrSXIZCCrAPjn2j6LHpkcuKi0umLD1k57P2YcG2EMZTEV31LXwG0IUJdLGv2Exc/LT9g16QqUIliTU6S/I8VupHkgFB1HfvDj6S9mWBx7NVAuq5Ff9TfL0eWSIMcJ7xCpgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963010; c=relaxed/simple;
	bh=sEWxzeDkNWwYJti3HFhmeEcJQrLTkOLJrhjrSvZUEB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2Ow10gxSM7UAQWFtc6AoI6VgCthl8Zl15Bh1wkdsDYKGW3/xa5qFFHDvIu1WRq0MrHjRePcE7rxOCKo/vQpKJv81NMFboWbdpVaYccLSCUseKFM2yAAip3M05MB1hveq/w4EMgXJK28rP4HAW9WEJPSvRvWFmJ6xVNMUhiu+K4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3/QBa5+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3/QBa5+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0001F00A3D;
	Wed,  9 Sep 2026 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963009;
	bh=j4OnQunVhKqw0k9c/R6BhPjG/NHUbdxUpQx4ziqP8XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3/QBa5+bneouU6hMv2RRKssO6Gj9NbjxvV5tXDw6Wd4CSxW0bCI3MfIlBFfg6GE1
	 f2ppsbjxDH7LbACrromYJ5NnMJKkEtowGS5rlLhwbJEODxI/I/H7tWXaIHvqUqr24q
	 l8G0VuwLSjvMy3eLReCPeJs3UHLIF7RIDaglzwTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.2 489/556] drm/amd/display: fix dc_lock leak on GPU reset error paths
Date: Wed,  9 Sep 2026 15:42:49 +0200
Message-ID: <20260909134247.698131067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

commit 92a9eebd2a1f892fe482154d83f9f1626bc73d3b upstream.

On GPU reset, dm_suspend() takes dc_lock and leaves it for dm_resume()
to drop. If amdgpu_dm_commit_zero_streams() or dm_dmub_hw_init() fails,
the function returns with the lock still held. The matching resume path
is then skipped, so every later dc_lock take hangs.

Release the cached DC state and unlock before returning the error.

Fixes: 3cf7a0bc87f0 ("drm/amd/display: Catch failures for amdgpu_dm_commit_zero_streams()")
Fixes: 2b6943df5413 ("drm/amd/display: Pass up errors for reset GPU that fails to init HW")
Cc: stable@vger.kernel.org
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3511,6 +3511,9 @@ static int dm_suspend(struct amdgpu_ip_b
 		res = amdgpu_dm_commit_zero_streams(dm->dc);
 		if (res != DC_OK) {
 			drm_err(adev_to_drm(adev), "Failed to commit zero streams: %d\n", res);
+			dc_state_release(dm->cached_dc_state);
+			dm->cached_dc_state = NULL;
+			mutex_unlock(&dm->dc_lock);
 			return -EINVAL;
 		}
 
@@ -3824,6 +3827,9 @@ static int dm_resume(struct amdgpu_ip_bl
 		r = dm_dmub_hw_init(adev);
 		if (r) {
 			drm_err(adev_to_drm(adev), "DMUB interface failed to initialize: status=%d\n", r);
+			dc_state_release(dm->cached_dc_state);
+			dm->cached_dc_state = NULL;
+			mutex_unlock(&dm->dc_lock);
 			return r;
 		}
 


