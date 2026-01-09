Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD6D35A95C;
	Fri,  9 Jan 2026 12:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961851; cv=none; b=YVq7yEok5DTtMWIcOh08EP8PohKwIT7D5fJNty9hHzHG7TjCdLkhaVsOOUEuK3Hpqyoq0zHuVxCZ4BAar2V0X12/UEePx+RMhhUjgo/CEUwLSVOKw9qZACCHW85zm1vdjnyobVSjSMMb+rCqZUlerhnBqoph+3+Oh5SfZ+S5V4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961851; c=relaxed/simple;
	bh=koo+zDC5KfKDv9nu+BUlqlxVIMtfMJ/gl+nPje0i5Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DcjgYG9U2G2LtFjXxgkLy19ATrrN6TneU1sF7uKA9PqkDgUIAFTXoDAU4djsvP4QSK2RTWSoinIT2LI7kls5m1VMQqH0lRENIS3F59cH8ZtEX2OuUtY9haUuhLEGriBfOYsj+dDo/EuCrbNlN3P2Qq0uJOQ86zVTShoymKWPSrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O95Ve221; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O95Ve221"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0D9C4CEF1;
	Fri,  9 Jan 2026 12:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961851;
	bh=koo+zDC5KfKDv9nu+BUlqlxVIMtfMJ/gl+nPje0i5Zs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O95Ve221a/zbPfz7Zk2Q4mZBgCgkYfHoZIYWkTqk55a6Mo4xisdefHSrdRHQXopI1
	 pW/l4cqoLnnqmi1+6x6BRA+wMp82KaYy1WmYQHxZQjSGCpOpU/ru8N+jYaUnCFFm6r
	 H+oDtfH9+Dd7AwwiozDQjLHZrNZ2UAiv/AzFpHNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 158/634] drm/amd/display: Fix logical vs bitwise bug in get_embedded_panel_info_v2_1()
Date: Fri,  9 Jan 2026 12:37:16 +0100
Message-ID: <20260109112123.397081771@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 1a79482699b4d1e43948d14f0c7193dc1dcad858 ]

The .H_SYNC_POLARITY and .V_SYNC_POLARITY variables are 1 bit bitfields
of a u32.  The ATOM_HSYNC_POLARITY define is 0x2 and the
ATOM_VSYNC_POLARITY is 0x4.  When we do a bitwise negate of 0, 2, or 4
then the last bit is always 1 so this code always sets .H_SYNC_POLARITY
and .V_SYNC_POLARITY to true.

This code is instead intended to check if the ATOM_HSYNC_POLARITY or
ATOM_VSYNC_POLARITY flags are set and reverse the result.  In other
words, it's supposed to be a logical negate instead of a bitwise negate.

Fixes: ae79c310b1a6 ("drm/amd/display: Add DCE12 bios parser support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index 75e44d8a7b40f..f2d37572f2a69 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -1480,10 +1480,10 @@ static enum bp_result get_embedded_panel_info_v2_1(
 	/* not provided by VBIOS */
 	info->lcd_timing.misc_info.HORIZONTAL_CUT_OFF = 0;
 
-	info->lcd_timing.misc_info.H_SYNC_POLARITY = ~(uint32_t) (lvds->lcd_timing.miscinfo
-			& ATOM_HSYNC_POLARITY);
-	info->lcd_timing.misc_info.V_SYNC_POLARITY = ~(uint32_t) (lvds->lcd_timing.miscinfo
-			& ATOM_VSYNC_POLARITY);
+	info->lcd_timing.misc_info.H_SYNC_POLARITY = !(lvds->lcd_timing.miscinfo &
+						       ATOM_HSYNC_POLARITY);
+	info->lcd_timing.misc_info.V_SYNC_POLARITY = !(lvds->lcd_timing.miscinfo &
+						       ATOM_VSYNC_POLARITY);
 
 	/* not provided by VBIOS */
 	info->lcd_timing.misc_info.VERTICAL_CUT_OFF = 0;
-- 
2.51.0



