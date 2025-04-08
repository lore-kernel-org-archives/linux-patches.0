Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E153119AD5C;
	Tue,  8 Apr 2025 11:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112418; cv=none; b=bl0O4PigYPb4Hmbw1AgRV2zsY7p+GeaYvCUDkbxyToer0OBRJBdB+OE9qpy+PdYn1EaRhx7Fpj9joCOSwRwuX/ePjNRnfg3pDsjFCfD5sPhXoEdifQBeoPm+wFXJYFV7JQi7CjozZ4LlqDYL5EI/TLvGypqOo8vDwQQMAqaE4w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112418; c=relaxed/simple;
	bh=Jy0VYueuJrzbE41CDE3E16x2lrIaJ1G09NLqjNI1JhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jcDewg8pyJR0EUYeyfYT83Czc8ywGlJ/hLSjkQFmvoi6hojiqKJfTm6FwqmaftDnwY1grVWIMqkTIh3hfLbUWEICLd9ga/P62dzkTeqNxDnA99qscFY3TIfEGFED9Cho8onDEqkUytmPBxpi6JZdlEvbo3AvlscmX7vbo1HH7J0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZsOZbyd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZsOZbyd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7395FC4CEE5;
	Tue,  8 Apr 2025 11:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112417;
	bh=Jy0VYueuJrzbE41CDE3E16x2lrIaJ1G09NLqjNI1JhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZsOZbydZ8zV5r4DvTorjislnY490MPWXOKweShrsbMazWrHha+dz76sSwzGe46uy
	 h+P02/wC38fDizaRFGmKEegKvedi/b/a8+4VqIQND0ZlXv7b528P70eOy50cp1xNf5
	 2d/0NvkM1qqHO0EjRIV4P+dWeYvCp4a3Qimv2doE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 5.15 061/279] drm/amd/display: Fix slab-use-after-free on hdcp_work
Date: Tue,  8 Apr 2025 12:47:24 +0200
Message-ID: <20250408104827.996242790@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -396,6 +396,7 @@ void hdcp_destroy(struct kobject *kobj,
 	for (i = 0; i < hdcp_work->max_link; i++) {
 		cancel_delayed_work_sync(&hdcp_work[i].callback_dwork);
 		cancel_delayed_work_sync(&hdcp_work[i].watchdog_timer_dwork);
+		cancel_delayed_work_sync(&hdcp_work[i].property_validate_dwork);
 	}
 
 	sysfs_remove_bin_file(kobj, &hdcp_work[0].attr);


