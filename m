Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAFB58597A;
	Wed,  9 Sep 2026 14:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964325; cv=none; b=tRytXWNEzwob8CDGyHrLlQI+eyXrKwjjm7izLb6VvdAGAs1jKR7A5bjLvvvjpys89yDv9SecI09cNreba8N6MOMzxkPSTYJb39YxhjNHDxAA7ZFAT6QP1l4baKhrC+F4l56eLjqAxv1R5jaObAKFtM/GkI3fW2SJb8qXegzNlEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964325; c=relaxed/simple;
	bh=e+M1awrkiE2KXINcBQ656MPRFAtkUbXrVQBYBNf2X6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMTHRTmN7EICgyyxSX1NvtHtI+FfzTLf2v7+6uVISw76t4WEzidKsX70zUkWeR8EiwFp4bVt5fhge5Q14hC0iHEm1NFeFVLlL6K1WVahefNGvTOn5MrrSiIUU/O/3zdaxiRvj3ykDKhlu9eJO3AblxaR2l3lVSZJO6nBTfsdt6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pq31Ytuz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pq31Ytuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 967361F00A3D;
	Wed,  9 Sep 2026 14:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964324;
	bh=dIejKE8YEMvTebuO7nJdiqdvoQkPmNRt9VtFOGyFgn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pq31YtuzofWm1Juwkj09q+NvJVOfYjPgJy9txqdlyx3D7JfU4kSLzJE9fTH/nwORV
	 uRifZHwJgrs2luhriXovBJ3fn8NnA6up7iMmOY8vih1BBv/Rtu6u7Cb/W9dsEj3IfW
	 +i4lwAS+3Y82Hu4E1AXNUtH0pQWygN8ZGyzzpAhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 384/583] drm/amd/display: fix dc_lock leak on GPU reset error paths
Date: Wed,  9 Sep 2026 15:41:09 +0200
Message-ID: <20260909134251.301290627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3261,6 +3261,9 @@ static int dm_suspend(struct amdgpu_ip_b
 		res = amdgpu_dm_commit_zero_streams(dm->dc);
 		if (res != DC_OK) {
 			drm_err(adev_to_drm(adev), "Failed to commit zero streams: %d\n", res);
+			dc_state_release(dm->cached_dc_state);
+			dm->cached_dc_state = NULL;
+			mutex_unlock(&dm->dc_lock);
 			return -EINVAL;
 		}
 
@@ -3505,6 +3508,9 @@ static int dm_resume(struct amdgpu_ip_bl
 		r = dm_dmub_hw_init(adev);
 		if (r) {
 			drm_err(adev_to_drm(adev), "DMUB interface failed to initialize: status=%d\n", r);
+			dc_state_release(dm->cached_dc_state);
+			dm->cached_dc_state = NULL;
+			mutex_unlock(&dm->dc_lock);
 			return r;
 		}
 


