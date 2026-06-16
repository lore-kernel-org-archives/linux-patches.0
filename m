Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01CD3D8105;
	Tue, 16 Jun 2026 18:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781634201; cv=none; b=Y9oNBpee5v/IEwcefMqibjncO4Tb6O1nXIvsuhYpg2EH8lcK0gja5tl3JY6RR9Qy6uzR2lvHtCbI2MaqNwC1GVxSDscCET9nVoZEWrIy6HTvly59HIut47HDob+CP67m1J3lrGwmIPFGqiIJ90MNvMdqI+PUcJ3PplzHrVTCw5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781634201; c=relaxed/simple;
	bh=6bKZXmRCBOGuf40Pwnqw8mxwdwzJ95rOq2MsYcpcoX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XyGM3TVxHjmPXAfSiNTJt5FfFuTCmPIYX/HrX44sIlUIJ30+WaaifTX1mUwyT91EMNvC31j+Tea8EqIWBB5c9y4S0WBvJXL3ADCm//e5D08qO/GBdc36zuAuvNI4eM6elciBg3Yrm8kNNVgnzg02dF8vMdrUho9Nff6UbPf3WQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=unmyLtX8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="unmyLtX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3B61F000E9;
	Tue, 16 Jun 2026 18:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781634200;
	bh=OB8XrELkEwdfNiqJF9hBnWNtO/Nxeuhh/V2Yqf61iTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=unmyLtX8Mp/SMlYkqb8g/NSqKUNWl0M1F+gvSxWMnU9I5k9Ysv9M+fx9fo7/ahc2q
	 euQwWUYtHbuVvBnU7BkRPvfUl4n8Uhk0677H0pZ2D9Qh3u7i+I4BvDcL2TUaTEPgia
	 yz8Q/kQSF9wnZIaUEwNrigDTc+WSVT++Cx1DcZ7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Harry Wentland <harry.wentland@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 210/411] drm/amd/display: Reject gpio_bitshift >= 32 in bios_parser_get_gpio_pin_info()
Date: Tue, 16 Jun 2026 20:27:28 +0530
Message-ID: <20260616145111.921185290@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

commit 49c3da65961fe9857c831d47fa1989084e87514a upstream.

[Why & How]
gpio_bitshift is a uint8_t read directly from the VBIOS GPIO pin table.
If the value is >= 32, the expression "1 << gpio_bitshift" triggers
undefined behaviour in C (shift count exceeds type width). On x86 the
shift is silently masked to 5 bits, producing an incorrect GPIO mask
that may cause wrong MMIO register bits to be toggled.

Validate gpio_bitshift before use and return BP_RESULT_BADBIOSTABLE for
out-of-range values.

Fixes: ae79c310b1a6 ("drm/amd/display: Add DCE12 bios parser support")
Assisted-by: Copilot:claude-opus-4.6
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit eadf438ab8d370b9d19acee9359918c85afeb80d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -547,8 +547,10 @@ static enum bp_result bios_parser_get_gp
 		info->offset_en = info->offset + 1;
 		info->offset_mask = info->offset - 1;
 
-		info->mask = (uint32_t) (1 <<
-			header->gpio_pin[i].gpio_bitshift);
+		if (header->gpio_pin[i].gpio_bitshift >= 32)
+			return BP_RESULT_BADBIOSTABLE;
+
+		info->mask = 1u << header->gpio_pin[i].gpio_bitshift;
 		info->mask_y = info->mask + 2;
 		info->mask_en = info->mask + 1;
 		info->mask_mask = info->mask - 1;


