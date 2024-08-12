Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C15187342;
	Mon, 12 Aug 2024 16:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480120; cv=none; b=RfDrby36VqXV8dp+HKZr14bbYiXRLsPP9k+Ms6wxTlhchSougQ0/CmbeuaFqwWK3sveTC6qSAfNDEtM6BEBeOQcMMXc1M9wKy/Fjb9041kU6Yv/IZrHzOuYLI0rXFQkxhJIZG/KBHgVAlWSO8zq+c1KBsNYqNwIG4jkbgiGuN0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480120; c=relaxed/simple;
	bh=T1s1+ZR4mt8dAnw+JYADGWhoeYHKcuSUlUXAeGjNWCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwa5FO/7WKhINzASvQfN7uSs6KHeR7xNPgN1cu2oHb86IrSem0F4ox4UYoe1I09XWu/ebhWe0r591L/LniQ0Jzzg3DvxxguQzFepsa2rQO9E04+T3Kc4Pzi5PO0NPzziOcjsWE10lXRaL1lzOUeglQ/tMT7MlEWbjm8dluw0aK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W5QslYDQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W5QslYDQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA446C32782;
	Mon, 12 Aug 2024 16:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480120;
	bh=T1s1+ZR4mt8dAnw+JYADGWhoeYHKcuSUlUXAeGjNWCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5QslYDQ0UwSXGfV563Se0Tj9X8F1eQ7mfbG8gnNu9HSZhwwMakFGPkTNN1jVCF+E
	 5u6TK3fd3c6P4RxY+2f8QqTLmjv6KcCZs5nqEkTPFuzrTPAPv7H2hboY89pMgEADNj
	 O+Cgdcx4drSpWN7triH4sGFhlwsxAI17WDTzeH2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 102/263] drm/amd/display: Wake DMCUB before sending a command for replay feature
Date: Mon, 12 Aug 2024 18:01:43 +0200
Message-ID: <20240812160150.448744874@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

[ Upstream commit 3601a35a2e9d640233f4bc3496f7603b93f9c143 ]

[Why]
We can hang in place trying to send commands when the DMCUB isn't
powered on.

[How]
For functions that execute within a DC context or DC lock we can wrap
the direct calls to dm_execute_dmub_cmd/list with code that exits idle
power optimizations and reallows once we're done with the command
submission on success.

For DM direct submissions the DM will need to manage the enter/exit
sequencing manually.

We cannot invoke a DMCUB command directly within the DM execution helper
or we can deadlock.

Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c b/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
index 4f559a025cf00..f820647443d16 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dmub_replay.c
@@ -84,7 +84,7 @@ static void dmub_replay_enable(struct dmub_replay *dmub, bool enable, bool wait,
 
 	cmd.replay_enable.header.payload_bytes = sizeof(struct dmub_rb_cmd_replay_enable_data);
 
-	dm_execute_dmub_cmd(dc, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
+	dc_wake_and_execute_dmub_cmd(dc, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
 
 	/* Below loops 1000 x 500us = 500 ms.
 	 *  Exit REPLAY may need to wait 1-2 frames to power up. Timeout after at
@@ -127,7 +127,7 @@ static void dmub_replay_set_power_opt(struct dmub_replay *dmub, unsigned int pow
 	cmd.replay_set_power_opt.replay_set_power_opt_data.power_opt = power_opt;
 	cmd.replay_set_power_opt.replay_set_power_opt_data.panel_inst = panel_inst;
 
-	dm_execute_dmub_cmd(dc, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
+	dc_wake_and_execute_dmub_cmd(dc, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
 }
 
 /*
@@ -231,7 +231,7 @@ static void dmub_replay_set_coasting_vtotal(struct dmub_replay *dmub,
 	cmd.replay_set_coasting_vtotal.header.payload_bytes = sizeof(struct dmub_cmd_replay_set_coasting_vtotal_data);
 	cmd.replay_set_coasting_vtotal.replay_set_coasting_vtotal_data.coasting_vtotal = coasting_vtotal;
 
-	dm_execute_dmub_cmd(dc, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
+	dc_wake_and_execute_dmub_cmd(dc, &cmd, DM_DMUB_WAIT_TYPE_WAIT);
 }
 
 /*
-- 
2.43.0



