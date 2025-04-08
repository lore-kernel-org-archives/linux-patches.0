Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA7C26A0BD;
	Tue,  8 Apr 2025 10:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109985; cv=none; b=HNfisNbT77numuzeyRqM8Rtl4kwe1RcOoi3wtA8OorfW/Ro8oKAEpGE0cjdFH/B8UlRhVHZukCE3Qn7ed5vo8/j6oxFXKFic4fMhyWdxLgpfuWmq6BJNN8iCSbvwEa9u7vfiWzIoaF2H6o5hekfv+pGaJGLkwO9Sz8um39bSeWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109985; c=relaxed/simple;
	bh=ws+esh+ZQncNE8NKuDCVgipMYaxPvnqB8+Tan/SYWfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtcEofIb7i9FY1wTK0HDcF+z4lNzRfIY4JRqrprPOdjfFY+nDvlMrEuUI/BRCYaMiD5S23PRhe/t7VyaB/BMGCWCWTL200E7tRcx0p+tH42lVPv8dj9HOJx+nU8TLzmiZjFDvn3lSlCXQSFk1XRUS4905knJarBYa8WJ1WPin0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r38lwapn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r38lwapn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABA2C4CEE5;
	Tue,  8 Apr 2025 10:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109985;
	bh=ws+esh+ZQncNE8NKuDCVgipMYaxPvnqB8+Tan/SYWfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r38lwapn2XQl2hpNUtlwX/F6RU078H3kbzDvKcQtWvw858sFsGrxFvDIIi/e4qbSs
	 FYdws5lKr/t4txm5+LfGU1PGusjmf4df0EBV8GCNoX8MVbG3o/pUihXpO8EoYbNTx2
	 FwE8S78D6VNp+tJwv10GZGlZBUFRS85IDatjLlFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrik Jakobsson <pjakobsson@suse.de>,
	Harry Wentland <harry.wentland@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Xiangyu Chen <xiangyu.chen@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 5.10 087/227] drm/amdgpu: Fix even more out of bound writes from debugfs
Date: Tue,  8 Apr 2025 12:47:45 +0200
Message-ID: <20250408104822.986184553@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>

commit 3f4e54bd312d3dafb59daf2b97ffa08abebe60f5 upstream.

CVE-2021-42327 was fixed by:

commit f23750b5b3d98653b31d4469592935ef6364ad67
Author: Thelford Williams <tdwilliamsiv@gmail.com>
Date:   Wed Oct 13 16:04:13 2021 -0400

    drm/amdgpu: fix out of bounds write

but amdgpu_dm_debugfs.c contains more of the same issue so fix the
remaining ones.

v2:
	* Add missing fix in dp_max_bpc_write (Harry Wentland)

Fixes: 918698d5c2b5 ("drm/amd/display: Return the number of bytes parsed than allocated")
Signed-off-by: Patrik Jakobsson <pjakobsson@suse.de>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
[ Cherry-pick the fix and drop the following functions which were introduced
  since 5.13 or later: dp_max_bpc_write() was introduced in commit cca912e0a6b4
  ("drm/amd/display: Add max bpc debugfs") dp_dsc_passthrough_set() was
  introduced in commit fcd1e484c8ae ("drm/amd/display: Add debugfs entry for
  dsc passthrough"). ]
Signed-off-by: Xiangyu Chen <xiangyu.chen@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -424,7 +424,7 @@ static ssize_t dp_phy_settings_write(str
 	if (!wr_buf)
 		return -ENOSPC;
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					   (long *)param, buf,
 					   max_param_num,
 					   &param_nums)) {
@@ -576,7 +576,7 @@ static ssize_t dp_phy_test_pattern_debug
 	if (!wr_buf)
 		return -ENOSPC;
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					   (long *)param, buf,
 					   max_param_num,
 					   &param_nums)) {
@@ -1091,7 +1091,7 @@ static ssize_t dp_trigger_hotplug(struct
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 						(long *)param, buf,
 						max_param_num,
 						&param_nums)) {
@@ -1272,7 +1272,7 @@ static ssize_t dp_dsc_clock_en_write(str
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					    (long *)param, buf,
 					    max_param_num,
 					    &param_nums)) {
@@ -1426,7 +1426,7 @@ static ssize_t dp_dsc_slice_width_write(
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					    (long *)param, buf,
 					    max_param_num,
 					    &param_nums)) {
@@ -1580,7 +1580,7 @@ static ssize_t dp_dsc_slice_height_write
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					    (long *)param, buf,
 					    max_param_num,
 					    &param_nums)) {
@@ -1727,7 +1727,7 @@ static ssize_t dp_dsc_bits_per_pixel_wri
 		return -ENOSPC;
 	}
 
-	if (parse_write_buffer_into_params(wr_buf, size,
+	if (parse_write_buffer_into_params(wr_buf, wr_buf_size,
 					    (long *)param, buf,
 					    max_param_num,
 					    &param_nums)) {


