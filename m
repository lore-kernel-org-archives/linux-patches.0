Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7485FF09;
	Tue, 23 Jan 2024 01:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974664; cv=none; b=JABMLttpqTQ1fupngeFyvsuXUlWQfugNEp4aUnSV8cDAHJhXvPdLYgCjlPp/4SbVP98iIXa/jmlbgccBIoXQZrVRJq8BJJezuxvA951fRjWJ7mFimEyTetAXewOBtBqE6OoVUpiLx/eCkELQ3neFg0DBNsPpWgOM/V4usteElPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974664; c=relaxed/simple;
	bh=J6IwUW0DrXNZ0DwBGl+q2vqzr3aePHDhIiFzJMOSfaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hcBRCJpMIcv1VqBaX4tYf7W07RVrUyRCVlZyS+CaCPElJZGbf64VxabVqx97Rphs2O6vdSILT7hXdqMfyP5Za9it/vI68J2HQxIk01nviw6VrCxbKfUi96bEzw04T2AACrzV2hXagwNeaUatKADkJ5JEMlwCRKHrhynqm/9IiM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zjBuXNzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zjBuXNzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FCAC433C7;
	Tue, 23 Jan 2024 01:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974663;
	bh=J6IwUW0DrXNZ0DwBGl+q2vqzr3aePHDhIiFzJMOSfaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zjBuXNzAazcGrhpQfvrunsT2U+hHxRevG9LylSTGM3svZm8uvZypC9zB8fEX3hKLk
	 uUvss7dhNs9BHRv1hS98UgFxdFlqhsYfEi4gre46Dl9dctE3+GUsm1aJiNLrn0yh7d
	 hMUG8W4D4jNnILd3yZcVB4USP2ndN1U4LWHgflG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 239/374] drm/amd/pm/smu7: fix a memleak in smu7_hwmgr_backend_init
Date: Mon, 22 Jan 2024 15:58:15 -0800
Message-ID: <20240122235753.052042009@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 2f3be3ca779b11c332441b10e00443a2510f4d7b ]

The hwmgr->backend, (i.e. data) allocated by kzalloc is not freed in
the error-handling paths of smu7_get_evv_voltages and
smu7_update_edc_leakage_table. However, it did be freed in the
error-handling of phm_initializa_dynamic_state_adjustment_rule_settings,
by smu7_hwmgr_backend_fini. So the lack of free in smu7_get_evv_voltages
and smu7_update_edc_leakage_table is considered a memleak in this patch.

Fixes: 599a7e9fe1b6 ("drm/amd/powerplay: implement smu7 hwmgr to manager asics with smu ip version 7.")
Fixes: 8f0804c6b7d0 ("drm/amd/pm: add edc leakage controller setting")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
index 611969bf4520..9bfc465d08fb 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -2924,6 +2924,8 @@ static int smu7_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 		result = smu7_get_evv_voltages(hwmgr);
 		if (result) {
 			pr_info("Get EVV Voltage Failed.  Abort Driver loading!\n");
+			kfree(hwmgr->backend);
+			hwmgr->backend = NULL;
 			return -EINVAL;
 		}
 	} else {
@@ -2969,8 +2971,10 @@ static int smu7_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 	}
 
 	result = smu7_update_edc_leakage_table(hwmgr);
-	if (result)
+	if (result) {
+		smu7_hwmgr_backend_fini(hwmgr);
 		return result;
+	}
 
 	return 0;
 }
-- 
2.43.0



