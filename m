Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27EF268691;
	Tue,  8 Apr 2025 10:56:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109789; cv=none; b=MBt7z3kGalYmwtm5bMD2OmpKKOVBn/brlAb4BD02IM7vpEW/4+Hf1K3aocGXIDUa3V+3gghKFRgKfbkbcv4/iyusJpqxwUZ8/YEIgrrtaa8CC2jjDSxXcLp8tQJ2lnuaKTzuR5tPxXYCED/f4LT1aRFXq6xDE/PRfOnnulOvvi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109789; c=relaxed/simple;
	bh=4r0NStNDllZgh7OulDlJjE6bXtfA5oXFzwY3HLoJyMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgvnN2aCrfODzIN5nSN1npdhcQIm5+HigWCDZcEFrH6gdvZQAKYsmQCI0qoIce5DmN5fVKerof1WyRuDYLTL/a19784OvgYosO3/1ubxR7JyYeA33z6+JOnf9uP3yh2a3b27N9sdCRG5XFVd8B6rzVPqE89p1+bRgxp0TJ3+LtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dk8G5l2A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dk8G5l2A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A82C4CEE5;
	Tue,  8 Apr 2025 10:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109789;
	bh=4r0NStNDllZgh7OulDlJjE6bXtfA5oXFzwY3HLoJyMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dk8G5l2A6Q9JN9dMTBnta3oT2M2Xtc+MrOwp/4UZDOzPP8Uq8M7U/YZkEVuTgcQp7
	 bJwfFoIXXRQuLiTqSem38VajmjOq/PqB5MRcuncKsCriTgEsY4rgwmFUO1xwhXUi60
	 WPGI78wYMJ3U1mOlnQFzNranvKzxm5xB/kuOgClU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 5.10 054/227] drm/amd/display: Fix slab-use-after-free on hdcp_work
Date: Tue,  8 Apr 2025 12:47:12 +0200
Message-ID: <20250408104822.020298390@linuxfoundation.org>
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
@@ -383,6 +383,7 @@ void hdcp_destroy(struct kobject *kobj,
 	for (i = 0; i < hdcp_work->max_link; i++) {
 		cancel_delayed_work_sync(&hdcp_work[i].callback_dwork);
 		cancel_delayed_work_sync(&hdcp_work[i].watchdog_timer_dwork);
+		cancel_delayed_work_sync(&hdcp_work[i].property_validate_dwork);
 	}
 
 	sysfs_remove_bin_file(kobj, &hdcp_work[0].attr);


