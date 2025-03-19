Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4549E1DE3CA;
	Wed, 19 Mar 2025 14:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394960; cv=none; b=sofjFOF18wFc/bictz8+BwikBYvKq1KCNZrZ/DRKj8PdmDEP4Q7jXp61rZxuWa0CSZ6/wBXg+Bu+nR7meAIWv6LWIBcbiDaePDi6GAyiUC2mnf6MFPrpgqH1gzJcGQ7EOa9pgLkICHS3Yq97ZEve+bc0bK4Tz4IZ8YgQal05kS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394960; c=relaxed/simple;
	bh=cyR23pjeg8l4NrC7MVo5sPhrzWUloHiFnNrzzNKiNU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1uty7Jcj6FD7DJqknT/cjwIOwYmafDBssIVfAxoUGZgJvTguwjuJbipbIl8OlDx/vWBXY7b0MqPjl/yUEvd14MzzSNd6VfGzy9TEyUryrwtN1bUVtP8y0ncLKSDMpM6XlWkvOlK5DAISfgyqFg/if2gprAg7OBV/gHlT27gbSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdfiG9rN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdfiG9rN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B8F7C4CEE4;
	Wed, 19 Mar 2025 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394960;
	bh=cyR23pjeg8l4NrC7MVo5sPhrzWUloHiFnNrzzNKiNU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdfiG9rN/dsSPPSxB5tays42PK9gxOTX/XbV277HcB+PUXHyvmxrineNfqniFldnD
	 viH95gd9LhybNWDholSaTvjgo3npmQ7QNk8/cYsHHfVy/cUkGaLUxwp0maVZKyFdsM
	 0YtAvggBeKy7mBz2C/IwcTPNH7tdn0lN6oqua3uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.13 188/241] drm/amd/display: Fix slab-use-after-free on hdcp_work
Date: Wed, 19 Mar 2025 07:30:58 -0700
Message-ID: <20250319143032.371506397@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


