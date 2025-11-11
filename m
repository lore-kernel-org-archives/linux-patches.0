Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA5B4C97;
	Tue, 11 Nov 2025 00:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822440; cv=none; b=iLLCW8Drk83lsFQuJGk30/fW0SCInPw5Xdtt3E9xp0OoI+Df2eYLXsdXUjNPRFkIwcC8dgvHBv2OsDsO4qj7Lk5kFZUNpXEP9qMhrCgstRfevqonxRnsiJTE1PYBMbt1FKjl2R7+gyHvdz86XkFjfrj1L4t1kKe/g9XBStEggHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822440; c=relaxed/simple;
	bh=n8qSX+iKrhLNMSYIzba2CZXdxdGIiB7OWS67vYvm3X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u9s1sRdpzzXHaVdyWSaLLxEn2wnB91muxBGLTV8rT2rsXs0PcEhkSYHWMj3kNhOEKh7urN+tRi6JNJFP3HKEzcnePIVl0ctEPfUo22g09GA5NM+iiWWFlKbRgfYSqNGeOiSSnlJviz+l6qPPOPfFAhq4wN8MHclpIXU3G/dYGWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TsQLPDyf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TsQLPDyf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ECA2C4CEF5;
	Tue, 11 Nov 2025 00:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822439;
	bh=n8qSX+iKrhLNMSYIzba2CZXdxdGIiB7OWS67vYvm3X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TsQLPDyflF1lmWz5hB1VJ+53ReFUBHEksbZZQJ4jCTDsBb6Zt7xxvR9TvXR1tR9VM
	 tb1QXiLXKXf/p4P4l2+pBZmk3KK/PZiOLOKAap8m0v+/Km1ZMKP1lseYegT/Jk8hOe
	 vUw/+HVEmXlW0ZIlFGAdvKvunoGjDs/zV9+ttHd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Harry Wentland <harry.wentland@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 108/849] drm/amd/display: Dont program BLNDGAM_MEM_PWR_FORCE when CM low-power is disabled on DCN30
Date: Tue, 11 Nov 2025 09:34:38 +0900
Message-ID: <20251111004539.008021952@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Schwartz <matthew.schwartz@linux.dev>

commit 382bd6a792836875da555fe9a2b51222b813fed1 upstream.

Before commit 33056a97ae5e ("drm/amd/display: Remove double checks for
`debug.enable_mem_low_power.bits.cm`"), dpp3_program_blnd_lut(NULL)
checked the low-power debug flag before calling
dpp3_power_on_blnd_lut(false).

After commit 33056a97ae5e ("drm/amd/display: Remove double checks for
`debug.enable_mem_low_power.bits.cm`"), dpp3_program_blnd_lut(NULL)
unconditionally calls dpp3_power_on_blnd_lut(false). The BLNDGAM power
helper writes BLNDGAM_MEM_PWR_FORCE when CM low-power is disabled, causing
immediate SRAM power toggles instead of deferring at vupdate. This can
disrupt atomic color/LUT sequencing during transitions between
direct scanout and composition within gamescope's DRM backend on
Steam Deck OLED.

To fix this, leave the BLNDGAM power state unchanged when low-power is
disabled, matching dpp3_power_on_hdr3dlut and dpp3_power_on_shaper.

Fixes: 33056a97ae5e ("drm/amd/display: Remove double checks for `debug.enable_mem_low_power.bits.cm`")
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 13ff4f63fcddfc84ec8632f1443936b00aa26725)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c b/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c
index 09be2a90cc79..4f569cd8a5d6 100644
--- a/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dpp/dcn30/dcn30_dpp.c
@@ -578,9 +578,6 @@ static void dpp3_power_on_blnd_lut(
 			dpp_base->ctx->dc->optimized_required = true;
 			dpp_base->deferred_reg_writes.bits.disable_blnd_lut = true;
 		}
-	} else {
-		REG_SET(CM_MEM_PWR_CTRL, 0,
-				BLNDGAM_MEM_PWR_FORCE, power_on == true ? 0 : 1);
 	}
 }
 
-- 
2.51.2



