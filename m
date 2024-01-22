Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E456633097;
	Tue, 23 Jan 2024 00:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969639; cv=none; b=lPqVMXMUoejlkP7ValJG1eqpuYg2aDPxcEw0vrtEZWAwbi/aKq7z493xAnzB6Iex15Ccozdg+V9y/u/SOLYEywtsxxY/2kN7qxBAVptP4Z9bJs5EDnHh4WCBTH4Ro9MoRNijNdGHG3Ekl8qox8U4XC3YYsn9X6LdVtg2PM1qwf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969639; c=relaxed/simple;
	bh=gbYVo1kagpnlkFm8O7IGNopHIKC5QJozS8Rn8yBt3Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEa2SPMNqEnZ0zqWolfYsDYf+8vLrh9OMsEsgs5tnNoaBoh8MsBkya83YXaW1d7gKR/7TkKcuvymYn+irCO8JUV7Rw6B//oqIDmLRP2wlOH4XQEuZ6Qv3WnFy3uK4A+P/gQxPGu9y8y6i1YuZNdqEalofGjC4s9cPiKA9i3+KGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYbzagTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYbzagTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A14C433F1;
	Tue, 23 Jan 2024 00:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969638;
	bh=gbYVo1kagpnlkFm8O7IGNopHIKC5QJozS8Rn8yBt3Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYbzagTg/QEXo1/WGAmv5lF+45Zaydb4ekdoPaN0Y+4xEzw5dk4lIiIHHEIkKYnze
	 HC3s5uw6tftpnpeSbsz6VFTvAaVs213KfoBa0yWIFDikHpbfqGMcB35zNsVxivKUiD
	 8DVB8+3AXYTFBW5gb4SP9sR7PPEX+LUqpR97rJlo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 368/641] drm/amd/pm/smu7: fix a memleak in smu7_hwmgr_backend_init
Date: Mon, 22 Jan 2024 15:54:32 -0800
Message-ID: <20240122235829.463720109@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 11372fcc59c8..b1a8799e2dee 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu7_hwmgr.c
@@ -2974,6 +2974,8 @@ static int smu7_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
 		result = smu7_get_evv_voltages(hwmgr);
 		if (result) {
 			pr_info("Get EVV Voltage Failed.  Abort Driver loading!\n");
+			kfree(hwmgr->backend);
+			hwmgr->backend = NULL;
 			return -EINVAL;
 		}
 	} else {
@@ -3019,8 +3021,10 @@ static int smu7_hwmgr_backend_init(struct pp_hwmgr *hwmgr)
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



