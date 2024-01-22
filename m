Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD741272D1;
	Tue, 23 Jan 2024 00:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968677; cv=none; b=Q1TAeUnMsn9NvvvS/vrzteNomKk7Jj+RTUTv7sBFMNDZqjREV4sIxonNGvVKPiEL3KZfXRbLL73csXADLZOC3EVK5REsKXsfrZKMdFhZzCkxoL0t/MzGXfB9UyYxWV2tXXE9FA/voZjKgfOXI2XF2MTBogoVwS1AvOejy6FkBlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968677; c=relaxed/simple;
	bh=OA4ggVGsVhmF9UZ6uWf7NRyh1yeG3OL91L9YuZoR+68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=od+/k8s1T4CgYFkWE51VLqzTHzBb/Rrhd95Y6iMio6VHtVllDEAylMUjT1/ddvMdMP7hLNhoezHPohLsuiqyAU/4V1CZhN8xy6Mp6cr1/DbV0GttCh1lwJyrj5Keah7MKddoYj0SZV8ggxd17VKYj9A9G/gHCkZClUZl6n1pumo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vT3Dr0FB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT3Dr0FB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5B9C433F1;
	Tue, 23 Jan 2024 00:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968677;
	bh=OA4ggVGsVhmF9UZ6uWf7NRyh1yeG3OL91L9YuZoR+68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vT3Dr0FBpVu6Bp7NsreFtlOwzyZTGxEB3vONjbZANWI+3EDaBmwvcaOC7uFVcA2kf
	 PPpCO+dS+XtYiaM6TKyWs5VjTLK32ZMLlBtmeVG0Yi38sDoW+nbAKaLZuGpVt+PJfv
	 7cImuZQ1zXHqo5wqJXNYsHHD0ySBFzun3mlaVHIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 099/148] drm/radeon/trinity_dpm: fix a memleak in trinity_parse_power_table
Date: Mon, 22 Jan 2024 15:57:35 -0800
Message-ID: <20240122235716.396578089@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 28c28d7f77c06ac2c0b8f9c82bc04eba22912b3b ]

The rdev->pm.dpm.ps allocated by kcalloc should be freed in every
following error-handling path. However, in the error-handling of
rdev->pm.power_state[i].clock_info the rdev->pm.dpm.ps is not freed,
resulting in a memleak in this function.

Fixes: d70229f70447 ("drm/radeon/kms: add dpm support for trinity asics")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/trinity_dpm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/radeon/trinity_dpm.c b/drivers/gpu/drm/radeon/trinity_dpm.c
index 5d317f763eea..e9e44df4a22a 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1769,8 +1769,10 @@ static int trinity_parse_power_table(struct radeon_device *rdev)
 		non_clock_array_index = power_state->v2.nonClockInfoIndex;
 		non_clock_info = (struct _ATOM_PPLIB_NONCLOCK_INFO *)
 			&non_clock_info_array->nonClockInfo[non_clock_array_index];
-		if (!rdev->pm.power_state[i].clock_info)
+		if (!rdev->pm.power_state[i].clock_info) {
+			kfree(rdev->pm.dpm.ps);
 			return -EINVAL;
+		}
 		ps = kzalloc(sizeof(struct sumo_ps), GFP_KERNEL);
 		if (ps == NULL) {
 			kfree(rdev->pm.dpm.ps);
-- 
2.43.0



