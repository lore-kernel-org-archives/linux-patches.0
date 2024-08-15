Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EFBE1AC8A2;
	Thu, 15 Aug 2024 13:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729125; cv=none; b=hQvvzNIfzLglAU1x3x7V3qKz6HlKi9ygLomyE+uaSBQUdlW/1yumMmxbVUXWBaAN6s6q2OjD375/wEPv4jVVht/wb2WufOw1MXnMiuZiUyF42eJ+Lo9b9MzJpwX+xU86HFNH84xxcLmCtdXBAZ3iH9kI4y1WOQ1KOA3sohoWzIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729125; c=relaxed/simple;
	bh=LYOl6wybieI/MXHceiEba8E/5z1gBhRX6wQ6/9fTDTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9YqFqDtpYDNpmSjzWDRIToZgy2z0kWfbmZh4MheMYDcpkFwNDFUZ/Y1NCNaKolSrnG7C3t80oS710C+tey/0bDkXm2xU+IhatghAJABZbTza8NKLMynMMCBNymhZT0cE22algeBoTYXU7zT001+41u2wkhSYQBnWQCLBdEi89g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NY8Klw3L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NY8Klw3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B51C7C32786;
	Thu, 15 Aug 2024 13:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729125;
	bh=LYOl6wybieI/MXHceiEba8E/5z1gBhRX6wQ6/9fTDTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NY8Klw3L5oINJmYRgp0xHKJH8HqO69kDGwaxJpvsGyak5cvq9FdFL4nLMHjFI6/Ha
	 cB6/bKhaB8hXzNg22YVAJVuvmJgyLQFy+YZvxQzmMvAdaWTQo/C92eal+MHB2FYbhb
	 MiFPN0w7t5M/erSeBcflDFwbDt94I5Mo7kBoX8QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayne Lin <Wayne.Lin@amd.com>,
	Fangzhi Zuo <jerry.zuo@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.10 21/22] drm/amd/display: Solve mst monitors blank out problem after resume
Date: Thu, 15 Aug 2024 15:25:29 +0200
Message-ID: <20240815131832.074200528@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
References: <20240815131831.265729493@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayne Lin <Wayne.Lin@amd.com>

commit e33697141bac18906345ea46533a240f1ad3cd21 upstream.

[Why]
In dm resume, we firstly restore dc state and do the mst resume for topology
probing thereafter. If we change dpcd DP_MSTM_CTRL value after LT in mst reume,
it will cause light up problem on the hub.

[How]
Revert commit 202dc359adda ("drm/amd/display: Defer handling mst up request in resume").
And adjust the reason to trigger dc_link_detect by DETECT_REASON_RESUMEFROMS3S4.

Cc: stable@vger.kernel.org
Fixes: 202dc359adda ("drm/amd/display: Defer handling mst up request in resume")
Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
Reviewed-by: Fangzhi Zuo <jerry.zuo@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2418,6 +2418,7 @@ static void resume_mst_branch_status(str
 
 	ret = drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL,
 				 DP_MST_EN |
+				 DP_UP_REQ_EN |
 				 DP_UPSTREAM_IS_SRC);
 	if (ret < 0) {
 		drm_dbg_kms(mgr->dev, "mst write failed - undocked during suspend?\n");
@@ -3017,7 +3018,7 @@ static int dm_resume(void *handle)
 		} else {
 			mutex_lock(&dm->dc_lock);
 			dc_exit_ips_for_hw_access(dm->dc);
-			dc_link_detect(aconnector->dc_link, DETECT_REASON_HPD);
+			dc_link_detect(aconnector->dc_link, DETECT_REASON_RESUMEFROMS3S4);
 			mutex_unlock(&dm->dc_lock);
 		}
 


