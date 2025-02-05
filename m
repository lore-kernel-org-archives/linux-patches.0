Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1110415198D;
	Wed,  5 Feb 2025 14:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764083; cv=none; b=YQirD7UueK7G5GlN4w3V+8t+Jeab+5X7TdQd1HF4/yMiQMe2meRYNZ7VjnkZvn3bSkXhITmvnrgA/DFCtkt4zJ1I+Ft9m7kncwGZACkH25EItfj6TCrpZUldax+BUxw6iRjsf/fTWR0CY9NcCnVYSwxuva9ktxqyiM2H1QRHTLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764083; c=relaxed/simple;
	bh=BtGUvI063dh9EgidxylBKzaAFgdbKG22z0meNwxPUPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mYIAmyMv0Ra0WfnqB7JLKFMeDukQ+/kOm+6KyZece/tcBcMw3kEaKi6iB9ilXzIHkIGaj/G4qx1sjZyuuQLUy7ihoFOQGpghMZCIf7d+CTw8P5cVtPvvOqFjGP/keAvgC5RY9NDFjDEgHXQ0KrC52wvqtVtj5aNLz4fmbY1SjXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i+sdpUhA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i+sdpUhA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D73C4CED1;
	Wed,  5 Feb 2025 14:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764082;
	bh=BtGUvI063dh9EgidxylBKzaAFgdbKG22z0meNwxPUPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i+sdpUhADS1YsqNPpwAlUOIE8JA+DpXYloua/GhIqofW0YVwXsxcg4oQb3+TzJkpA
	 TsiPfR/qHy9EacoX0dwnWVZFgCLQza516BraE+H+xyg/vR916aLSwvUmeBGz+N2iW1
	 AYQATqs8lNv4W1O3HX401jfzs7vvfJEpel2CcjL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 046/623] drm/amd/pm: Fix an error handling path in vega10_enable_se_edc_force_stall_config()
Date: Wed,  5 Feb 2025 14:36:28 +0100
Message-ID: <20250205134457.992332269@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit a3300782d5375e280ba7040f323d01960bfe3396 ]

In case of error after a amdgpu_gfx_rlc_enter_safe_mode() call, it is not
balanced by a corresponding amdgpu_gfx_rlc_exit_safe_mode() call.

Add the missing call.

Fixes: 9b7b8154cdb8 ("drm/amd/powerplay: added didt support for vega10")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_powertune.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_powertune.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_powertune.c
index 3007b054c873c..776d58ea63ae9 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_powertune.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/vega10_powertune.c
@@ -1120,13 +1120,14 @@ static int vega10_enable_se_edc_force_stall_config(struct pp_hwmgr *hwmgr)
 	result = vega10_program_didt_config_registers(hwmgr, SEEDCForceStallPatternConfig_Vega10, VEGA10_CONFIGREG_DIDT);
 	result |= vega10_program_didt_config_registers(hwmgr, SEEDCCtrlForceStallConfig_Vega10, VEGA10_CONFIGREG_DIDT);
 	if (0 != result)
-		return result;
+		goto exit_safe_mode;
 
 	vega10_didt_set_mask(hwmgr, false);
 
+exit_safe_mode:
 	amdgpu_gfx_rlc_exit_safe_mode(adev, 0);
 
-	return 0;
+	return result;
 }
 
 static int vega10_disable_se_edc_force_stall_config(struct pp_hwmgr *hwmgr)
-- 
2.39.5



