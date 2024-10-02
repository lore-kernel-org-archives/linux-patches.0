Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F191D0493;
	Wed,  2 Oct 2024 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878684; cv=none; b=Dmg+e0c6xU4Kw4jYjdgeHCupi9+NN4+EqA+GAEL/shUPJYx9U0gdyKuhwkvwaab4gjVpW5xGBZEaJiDQO3dO82wjmRsf9P9hlQMcjcoUfFPXv/0ekb6vEr5OsIxoqemxTr1heSLh1URvpAsPCn0FCvAxQGc8tqJ1qreQBidklB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878684; c=relaxed/simple;
	bh=iPM8Jfo5DB7Z5VkQiiIBg5WeKSMrJyHa1ReDCe9HvRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYrMEkye4UGv8RjpaUFlwHF10EpHjpepXeSXPXat4sS8sZ/rKboYIed/NpVMzzkcibS3K3FwixmI/NQpNMRT0azKefoPsNS4z9u1aa8b5mmHA6Sd94eTEgNTZxcx+npzcq1v1b0S5fnIXMOPZW2j5UeCn3/iORjPygoayeiFiOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmsc+a9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmsc+a9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D00C4CEC2;
	Wed,  2 Oct 2024 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878684;
	bh=iPM8Jfo5DB7Z5VkQiiIBg5WeKSMrJyHa1ReDCe9HvRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmsc+a9gOA0nxPIUcO+N7cYeUcnDqN/08nnEWiWjYjcZo86udE1XzFrnWD2Uyg5Hb
	 K8TkCeX0XWf6XWHTMeGrQcv5dlPIME9osJDWeNzkBFYAuUAf/WbWUTIYW1896vOufI
	 kAsTO/ufTOOgIQHn37riS/ApZGI+QyqBw6JrS9TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Charlene Liu <charlene.liu@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.10 497/634] drm/amd/display: Block dynamic IPS2 on DCN35 for incompatible FW versions
Date: Wed,  2 Oct 2024 14:59:57 +0200
Message-ID: <20241002125830.715826737@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 401c90c4d64f2227fc2f4c02d2ad23296bf5ca6f upstream.

[WHY]
Hangs with Z8 can occur if running an older unfixed PMFW version.

[HOW]
Fallback to RCG only for dynamic IPS2 states if it's not newer than
93.12. Limit to DCN35.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
+++ b/drivers/gpu/drm/amd/display/dc/clk_mgr/dcn35/dcn35_clk_mgr.c
@@ -1149,6 +1149,12 @@ void dcn35_clk_mgr_construct(
 			ctx->dc->debug.disable_dpp_power_gate = false;
 			ctx->dc->debug.disable_hubp_power_gate = false;
 			ctx->dc->debug.disable_dsc_power_gate = false;
+
+			/* Disable dynamic IPS2 in older PMFW (93.12) for Z8 interop. */
+			if (ctx->dc->config.disable_ips == DMUB_IPS_ENABLE &&
+			    ctx->dce_version == DCN_VERSION_3_5 &&
+			    ((clk_mgr->base.smu_ver & 0x00FFFFFF) <= 0x005d0c00))
+				ctx->dc->config.disable_ips = DMUB_IPS_RCG_IN_ACTIVE_IPS2_IN_OFF;
 		} else {
 			/*let's reset the config control flag*/
 			ctx->dc->config.disable_ips = DMUB_IPS_DISABLE_ALL; /*pmfw not support it, disable it all*/


