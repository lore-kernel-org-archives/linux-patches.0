Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C68526CE11;
	Fri, 15 May 2026 16:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862142; cv=none; b=LZGVwQOIHQXKBBH0Wsa09pEuZDSmOtl55/k+7pj2OmIA3ps1huq9S7RCWOvb09NpzzvNVtK9nwsUria2LHrghitDLjV97cpyR3H+HDHouRMA/pIlsoOcnoafqYiwF1ZWc17fIYwjmPdehdB44BKDD6aFIgBhw4vXTufiDYuPdHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862142; c=relaxed/simple;
	bh=Senjnna+x8d2tPkDXJ66phg0qDvbYCScfG2BtMennfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXonkV/ILqqRxtuTz9Shww0dCe1fgb6rKY3BVo4zyony2sVU0ht1Ejmt25U5XglbSDU4nnsJmlHHBOCSdyS/khwwIyaXG08jlm2w7H4sOuNuFkEXyo5Nmp1rWreiZrLp48tDGXlsummxoMwsRY/Up5CLtAiy9qI9AZNLUGP92g8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HTMClpFh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HTMClpFh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCA0C2BCB0;
	Fri, 15 May 2026 16:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862141;
	bh=Senjnna+x8d2tPkDXJ66phg0qDvbYCScfG2BtMennfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HTMClpFhFZeUgLbq4d3Gova0p6MPGdPzRe8ifZr0eyqCq0H0azp+6nSMuG64pkg74
	 2lBMVTRAz1Fr37IRdmg1FmYtJKz87h5sgpbzRaGniLcurhjKX0mwcFJsVCg78mOukk
	 gb8Q2Py3qwGMPhGnjoOvQlm1e04eX2CbbWsmW648=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: [PATCH 6.18 125/188] drm/panel: himax-hx83102: restore MODE_LPM after sending disable cmds
Date: Fri, 15 May 2026 17:49:02 +0200
Message-ID: <20260515154700.041097359@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Icenowy Zheng <zhengxingda@iscas.ac.cn>

commit 2d4e80271f784aa0c7b17676e9762c7e8156be1c upstream.

When preparing the panel, it seems that it always expects commands to be
transferred in LP mode. However, the disable function removes the
MIPI_DSI_MODE_LPM flag, and no other function re-adds it.

As the unprepare function contains no DSI commands, re-adding the flag
just after disabling the panel should be safe. Add the code re-adding
the flag after the two commands for disabling the panel are sent.

This fixes screen unblanking (after blanking once) on
mt8188-geralt-ciri-sku1 device.

Cc: stable@vger.kernel.org # 6.11+
Fixes: 0ef94554dc40 ("drm/panel: himax-hx83102: Break out as separate driver")
Signed-off-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260425165751.1716569-1-zhengxingda@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-himax-hx83102.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/panel/panel-himax-hx83102.c
+++ b/drivers/gpu/drm/panel/panel-himax-hx83102.c
@@ -850,6 +850,8 @@ static int hx83102_disable(struct drm_pa
 	mipi_dsi_dcs_set_display_off_multi(&dsi_ctx);
 	mipi_dsi_dcs_enter_sleep_mode_multi(&dsi_ctx);
 
+	dsi->mode_flags |= MIPI_DSI_MODE_LPM;
+
 	mipi_dsi_msleep(&dsi_ctx, 150);
 
 	return dsi_ctx.accum_err;


