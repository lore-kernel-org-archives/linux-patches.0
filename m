Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A437664A6;
	Tue, 23 Jan 2024 00:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971556; cv=none; b=gB7yZAVt2pg6GatmDEjcw/vgot4tIHxwk691hiwVPhjJPQgvfXSSaS1jscbqBTJ2FxSEr/boMeWsHwNfvg5Azq320fpCFmd5K4MChGIBUc5HBQv6B37Vdw0TbgMprw2CfF8LlzyGzBB4SwsW70ZnzrKZ+6tMHKuxemocoOpYsgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971556; c=relaxed/simple;
	bh=NYqLkmoBJC8pHY4fcdVtVTp6e6MfTomP1ml1JCWAfZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qaWCVSvIu9aVekPJe59nlexTrPAXNHFJvIRQxm/buu1s6erDcr86enm7yYNSfHuin4xC3e009u4s9wMfON5giKv1HKGs2F70HsOmxGbiwWGsgdkMPm7hvfx5iNjfV046O74bwZAjAxiD6HdGFmsw0SZiMl0BtZmUQIuGN9n9pfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/Tz141v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/Tz141v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7134C433C7;
	Tue, 23 Jan 2024 00:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971555;
	bh=NYqLkmoBJC8pHY4fcdVtVTp6e6MfTomP1ml1JCWAfZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/Tz141v475/G0ywH7j/528TbDlrdWZcIB0W7g3Xe+ZmLhOB126ABq1AVeUnzneMx
	 8t/kue6OIYgysahlO5NeeQwwJV95Qsm3Zi4UDforcZ4U+WfdR/MYJmI/cQC4ghY9Nx
	 pPpVcXkZ8dTGAXu2z2Jroc2HA3IblgO40aZ/ifQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/417] drm/amd/pm/smu7: fix a memleak in smu7_hwmgr_backend_init
Date: Mon, 22 Jan 2024 15:56:49 -0800
Message-ID: <20240122235800.231908426@linuxfoundation.org>
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
index a31a62a1ce0b..5e9410117712 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -2987,6 +2987,8 @@ static int smu7_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 		result = smu7_get_evv_voltages(hwmgr);
 		if (result) {
 			pr_info("Get EVV Voltage Failed.  Abort Driver loading!\n");
+			kfree(hwmgr->backend);
+			hwmgr->backend = NULL;
 			return -EINVAL;
 		}
 	} else {
@@ -3032,8 +3034,10 @@ static int smu7_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
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



