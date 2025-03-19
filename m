Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5301E8855;
	Wed, 19 Mar 2025 14:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395121; cv=none; b=olpU7CXe/96ZPr4M/NyZp18brmaYmDrbUq4mBrcIDrbpJ4G1y9B5flv5m+bvD6ppdW62CEEu/rgpYtGNyjBMfmHUEfGDmrP2z/oKrhRk/Ejo+XKvv08oSapxf+NvzNvVg3QrcLwnHb90+F0L6EDpqKgGRch0ctnWn72FT8NItP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395121; c=relaxed/simple;
	bh=uM0F4lXusic25kBHtVOfhLtIaEOPm9RK+cbxwIjxqrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/1HePjL6ycvqAYwB0Ji/6OJ8qslg2UNQu9Uo64vTEehpaEeX4VkQDLoUkr2FB2rHhELKrp1Y1CQ625vCis8ns4yJmmkZFhrzxddv+FZJmkFi0xCMjBANBE0FeJcYl3CoBO1Dw5a14DiGTvh+5jFqRWVEC54BAPi0NlKIDXkFYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3r32fgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3r32fgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9930C4CEE4;
	Wed, 19 Mar 2025 14:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395121;
	bh=uM0F4lXusic25kBHtVOfhLtIaEOPm9RK+cbxwIjxqrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T3r32fgJp/2YDTA+3dGY83RkSK+vqO8348cZP4whVqET983GBui85VGoJtKXzl8EJ
	 bVI4b5hIASr1y47wg4FRX22mJDjVo0E6OaENr0bePwHWgjCEx0GnhOXQ/XS2tlJ0tD
	 YTFeulet2AMQ+qEGLfD21EHDKtSrx6k4z0SnxkOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.12 182/231] drm/amd/display: Fix slab-use-after-free on hdcp_work
Date: Wed, 19 Mar 2025 07:31:15 -0700
Message-ID: <20250319143031.330461450@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit e65e7bea220c3ce8c4c793b4ba35557f4994ab2b upstream.

[Why]
A slab-use-after-free is reported when HDCP is destroyed but the
property_validate_dwork queue is still running.

[How]
Cancel the delayed work when destroying workqueue.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4006
Fixes: da3fd7ac0bcf ("drm/amd/display: Update CP property based on HW query")
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Tom Chung <chiahsuan.chung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 725a04ba5a95e89c89633d4322430cfbca7ce128)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_hdcp.c
@@ -455,6 +455,7 @@ void hdcp_destroy(struct kobject *kobj,
 	for (i = 0; i < hdcp_work->max_link; i++) {
 		cancel_delayed_work_sync(&hdcp_work[i].callback_dwork);
 		cancel_delayed_work_sync(&hdcp_work[i].watchdog_timer_dwork);
+		cancel_delayed_work_sync(&hdcp_work[i].property_validate_dwork);
 	}
 
 	sysfs_remove_bin_file(kobj, &hdcp_work[0].attr);


