Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F74182D7;
	Tue, 27 May 2025 17:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366195; cv=none; b=c6qAUu/jxH78YXR9Yha48fOFKUHUlykpmyOgg4dc1z4bdscoPifuPSLVaZkHHZN3iOn20qqnx2KyIEmLwj4uFPegIxMWWLp/3PxAYBVvJeuKto+C32mLh9M7itlAH5Z8Ir7OwdDHkorqDvsbHh2OiMu3a7OWkVlalKAEW9KE/9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366195; c=relaxed/simple;
	bh=lCbPu07x32TolFMWOdYwdRd3HTrBmqX4CVOgFjT8/Xg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/ObBPmVqJipqwN6DGSS+tcqEUJdrTA3AYnpTHvfA0qrL30y7CltpQPI9qoBrtULqyXZGt37x7hfVQKHjtk/XJYWInNT+mMzJVOfYvZCic3JVGncrf7ctzbQw0Kh3Q+DUe/AyKxJf54uaSzD+IArVGvK5fCkl77d2ELJl+1E4/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZPTMOfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZPTMOfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACDCC4CEEB;
	Tue, 27 May 2025 17:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366195;
	bh=lCbPu07x32TolFMWOdYwdRd3HTrBmqX4CVOgFjT8/Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZPTMOflGs1ptyghhHtKXt23NCsf/fHu8jVySMPTALB1Y8zUl49sioHAvl4Uz1kJL
	 KNN0CYJ2TDUFAVttQ/ZtUMldcja6ZfyDp/zSJkSdRCJ999cLFEHbbaRvFRNQ6UyYOL
	 PoKt/8yTwnx26Bb2H8jWgyUKuOT1llGW31YiD0Ao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlene Liu <charlene.liu@amd.com>,
	Ovidiu Bunea <Ovidiu.Bunea@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 618/626] drm/amd/display: Exit idle optimizations before accessing PHY
Date: Tue, 27 May 2025 18:28:31 +0200
Message-ID: <20250527162510.109544502@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Bunea <Ovidiu.Bunea@amd.com>

commit c488967488d7eff7b9c527d5469c424c15377502 upstream.

[why & how]
By default, DCN HW is in idle optimized state which does not allow access
to PHY registers. If BIOS powers up the DCN, it is fine because they will
power up everything. Only exit idle optimized state when not taking control
from VBIOS.

Fixes: be704e5ef4bd ("Revert "drm/amd/display: Exit idle optimizations before attempt to access PHY"")
Reviewed-by: Charlene Liu <charlene.liu@amd.com>
Signed-off-by: Ovidiu Bunea <Ovidiu.Bunea@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dce110/dce110_hwseq.c
@@ -1888,6 +1888,7 @@ void dce110_enable_accelerated_mode(stru
 	bool can_apply_edp_fast_boot = false;
 	bool can_apply_seamless_boot = false;
 	bool keep_edp_vdd_on = false;
+	struct dc_bios *dcb = dc->ctx->dc_bios;
 	DC_LOGGER_INIT();
 
 
@@ -1964,6 +1965,8 @@ void dce110_enable_accelerated_mode(stru
 			hws->funcs.edp_backlight_control(edp_link_with_sink, false);
 		}
 		/*resume from S3, no vbios posting, no need to power down again*/
+		if (dcb && dcb->funcs && !dcb->funcs->is_accelerated_mode(dcb))
+			clk_mgr_exit_optimized_pwr_state(dc, dc->clk_mgr);
 
 		power_down_all_hw_blocks(dc);
 
@@ -1976,6 +1979,8 @@ void dce110_enable_accelerated_mode(stru
 		disable_vga_and_power_gate_all_controllers(dc);
 		if (edp_link_with_sink && !keep_edp_vdd_on)
 			dc->hwss.edp_power_control(edp_link_with_sink, false);
+		if (dcb && dcb->funcs && !dcb->funcs->is_accelerated_mode(dcb))
+			clk_mgr_optimize_pwr_state(dc, dc->clk_mgr);
 	}
 	bios_set_scratch_acc_mode_change(dc->ctx->dc_bios, 1);
 }


