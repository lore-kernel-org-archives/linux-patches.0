Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BA479C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADE1C433D2;
	Thu, 12 Jan 2023 14:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533562;
	bh=xFRUKXf8zJ06rIVt1mya4gNo6gCbDNxsXQS9kxIiydU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U5++ZGf6wZiRmRo1hXXRbCxFRPMarAO7TAxqiqTiOaGTmwgRz0PxO5iTReg8Cc2lL
	 i4C2ilkJU5MMZ49cw+eOSnIQGB/eOSvE5sYL3XWmjwnK4Ik366kQuc7a59o+LtiojI
	 u08ISJNRt4yyIAieRPIh2IbwxSEtbye/nESmhoa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Leung <Martin.Leung@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 519/783] drm/amd/display: fix array index out of bound error in bios parser
Date: Thu, 12 Jan 2023 14:53:55 +0100
Message-Id: <20230112135548.263591745@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit 4fc1ba4aa589ca267468ad23fedef37562227d32 ]

[Why&How]
Firmware headers dictate that gpio_pin array only has a size of 8. The
count returned from vbios however is greater than 8.

Fix this by not using array indexing but incrementing the pointer since
gpio_pin definition in atomfirmware.h is hardcoded to size 8

Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/bios/bios_parser2.c   | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
index 29d64e7e304f..930d2b7d3448 100644
--- a/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
+++ b/drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c
@@ -352,6 +352,7 @@ static enum bp_result get_gpio_i2c_info(
 	uint32_t count = 0;
 	unsigned int table_index = 0;
 	bool find_valid = false;
+	struct atom_gpio_pin_assignment *pin;
 
 	if (!info)
 		return BP_RESULT_BADINPUT;
@@ -379,20 +380,17 @@ static enum bp_result get_gpio_i2c_info(
 			- sizeof(struct atom_common_table_header))
 				/ sizeof(struct atom_gpio_pin_assignment);
 
+	pin = (struct atom_gpio_pin_assignment *) header->gpio_pin;
+
 	for (table_index = 0; table_index < count; table_index++) {
-		if (((record->i2c_id & I2C_HW_CAP) == (
-		header->gpio_pin[table_index].gpio_id &
-						I2C_HW_CAP)) &&
-		((record->i2c_id & I2C_HW_ENGINE_ID_MASK)  ==
-		(header->gpio_pin[table_index].gpio_id &
-					I2C_HW_ENGINE_ID_MASK)) &&
-		((record->i2c_id & I2C_HW_LANE_MUX) ==
-		(header->gpio_pin[table_index].gpio_id &
-						I2C_HW_LANE_MUX))) {
+		if (((record->i2c_id & I2C_HW_CAP) 				== (pin->gpio_id & I2C_HW_CAP)) &&
+		    ((record->i2c_id & I2C_HW_ENGINE_ID_MASK)	== (pin->gpio_id & I2C_HW_ENGINE_ID_MASK)) &&
+		    ((record->i2c_id & I2C_HW_LANE_MUX) 		== (pin->gpio_id & I2C_HW_LANE_MUX))) {
 			/* still valid */
 			find_valid = true;
 			break;
 		}
+		pin = (struct atom_gpio_pin_assignment *)((uint8_t *)pin + sizeof(struct atom_gpio_pin_assignment));
 	}
 
 	/* If we don't find the entry that we are looking for then
-- 
2.35.1



