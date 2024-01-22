Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDA462814;
	Tue, 23 Jan 2024 00:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971136; cv=none; b=ucQ0cQqjV4sJtayxBDlsegLFVOapg0PkV+hYZ42IP2UXuFBIvRrYQy6s98kcxwHMK0ztBLs5wiwRXaLiuIiGnNI3kmREJLrO5nzYfO/tnW9CfD9YKuhZJ7HKtu8j6p0Z9pHLeF/F/NYYIEYpecOyKk1ZhmsUGjOHbDl1eazioO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971136; c=relaxed/simple;
	bh=qF34d9jI2jC6/2KLGNvWOU3QJgUcPek3M9An6r/NITE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMvVuDu2TT+rogzAWLmymbW2sNdksvbgHvEJvb1nbuGkEog/ri+TldV8bbjo3bM3+K1r/Gj9QhgVt40O9Ls+jyitWWdKhchTPreZBnlaAO6jrwohwGdRngTsXEh1F/XGe3NxsXdKVLqcQHSOiuyyILamfHJahCDiWNiX1g5ikmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzPe7qi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzPe7qi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358ABC43394;
	Tue, 23 Jan 2024 00:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971136;
	bh=qF34d9jI2jC6/2KLGNvWOU3QJgUcPek3M9An6r/NITE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzPe7qi4MHQdO5wz4gylX8X/04oe43gF39yxxsipbvezTU3qlo28e8XBbPWZaAa/H
	 yxNEmRJG0/MtY07p7knSrOlgl6/npf8eaTFIPIAeHLWPgnKT19sG2wJ7jkVvw5H9bd
	 tD6hDeuUOcJkUAdDNJp8aC+coh+saW3EucMKduQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 188/417] drm/radeon/trinity_dpm: fix a memleak in trinity_parse_power_table
Date: Mon, 22 Jan 2024 15:55:56 -0800
Message-ID: <20240122235758.418285761@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 08ea1c864cb2..ef1cc7bad20a 100644
--- a/drivers/gpu/drm/radeon/trinity_dpm.c
+++ b/drivers/gpu/drm/radeon/trinity_dpm.c
@@ -1726,8 +1726,10 @@ static int trinity_parse_power_table(struct radeon_device *rdev)
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



