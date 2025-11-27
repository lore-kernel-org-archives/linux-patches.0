Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C956E320CD1;
	Thu, 27 Nov 2025 14:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255229; cv=none; b=Zj+KHW4zEgVa1Kt+zQLhkRxD/xTs1MDL6Gj07Gm14JU9k59o4XziyO/Fg4r9WLsCuVGzCUcmmfKhMay2GEx7id5h5sLBK1yCyMieCanxW7uIMjBcDVS+nmLBCHr/0QDIRQl6XEkf9HPrthJDMa2Ha5u3ZB/wJ3O8P5IMfRvP0gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255229; c=relaxed/simple;
	bh=YGyqfcacFT9/d7el7J3IcK94SD5t/mLt4CjSPX+Pww4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lorS0NyBnyPsSSvnt+1Rt2+ge7+JxVQw6HUYZqthL6M/RvZ99OktKZt7colbfRNreByUozLPQrwa8z+AJm4Vd0BIDCUxAAgK5w/HDRYAXtFsSwKSh1UNJdaVvAGnPLZRVYSBqb3qZKdA/ODIyt4EyT19b53qMHYZ1xtVbYlzhJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JP4zSq11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JP4zSq11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA45C4CEF8;
	Thu, 27 Nov 2025 14:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255229;
	bh=YGyqfcacFT9/d7el7J3IcK94SD5t/mLt4CjSPX+Pww4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JP4zSq11GGEWhqOa7PzxGGhqVMw7QlbeLGCjPEV7BaRA+Vqo/f3H7GEUxgUFjFNgR
	 ClZYUprjetqOtHEPcIj+l4n2SwBNIJ4wmHE8dgiNwtgXgAM6KpAdWUPttwKnbGm8YJ
	 xGolj3vRclKUCBUujF4VnNn9U+2U2+Lm39/qLUog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aric Cyr <aric.cyr@amd.com>,
	Ivan Lipski <ivan.lipski@amd.com>,
	Dan Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 052/112] drm/amd/display: Clear the CUR_ENABLE register on DCN20 on DPP5
Date: Thu, 27 Nov 2025 15:45:54 +0100
Message-ID: <20251127144034.746658497@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Lipski <ivan.lipski@amd.com>

commit 5bab4c89390f32b2f491f49a151948cd226dd909 upstream.

[Why]
On DCN20 & DCN30, the 6th DPP's & HUBP's are powered on permanently and
cannot be power gated. Thus, when dpp_reset() is invoked for the DPP5,
while it's still powered on, the cached cursor_state
(dpp_base->pos.cur0_ctl.bits.cur0_enable)
and the actual state (CUR0_ENABLE) bit are unsycned. This can cause a
double cursor in full screen with non-native scaling.

[How]
Force disable cursor on DPP5 on plane powerdown for ASICs w/ 6 DPPs/HUBPs.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4673
Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Signed-off-by: Ivan Lipski <ivan.lipski@amd.com>
Tested-by: Dan Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 79b3c037f972dcb13e325a8eabfb8da835764e15)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/hwss/dcn20/dcn20_hwseq.c
@@ -604,6 +604,14 @@ void dcn20_dpp_pg_control(
 		 *		DOMAIN11_PGFSM_PWR_STATUS, pwr_status,
 		 * 		1, 1000);
 		 */
+
+		/* Force disable cursor on plane powerdown on DPP 5 using dpp_force_disable_cursor */
+		if (!power_on) {
+			struct dpp *dpp5 = hws->ctx->dc->res_pool->dpps[dpp_inst];
+			if (dpp5 && dpp5->funcs->dpp_force_disable_cursor)
+				dpp5->funcs->dpp_force_disable_cursor(dpp5);
+		}
+
 		break;
 	default:
 		BREAK_TO_DEBUGGER();


