Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7D351C2D;
	Mon, 11 Dec 2023 18:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8aNOlCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F41C433C7;
	Mon, 11 Dec 2023 18:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320710;
	bh=foMup+bY4E6hFoJEnsjMGPMzcRpW/H7OHHsZXQQgIGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8aNOlCN4EVSGrQ5IXuBrK+X+ScxhYSGGA8iVhe2X1cYcV0b/DtRIzBJMlef3UM/7
	 mlptBIgFA/gPMqLkqPdObTAYa56sfFzBejhm7iVEQsaCutSkDR6jmlbfTEKPId5LCz
	 K3UQRbvwIC+6lTIcYM7eG5aIDltXjtB8dmU92e4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 162/194] drm/amdgpu: Return from switch early for EEPROM I2C address
Date: Mon, 11 Dec 2023 19:22:32 +0100
Message-ID: <20231211182043.870961002@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit 8782007b5f5795f118c5167f46d8c8142abcc92f ]

As soon as control->i2c_address is set, return; remove the "break;" from the
switch--it is unnecessary. This mimics what happens when for some cases in the
switch, we call helper functions with "return <helper function>".

Remove final function "return true;" to indicate that the switch is final and
terminal, and that there should be no code after the switch.

Cc: Candice Li <candice.li@amd.com>
Cc: Kent Russell <kent.russell@amd.com>
Cc: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e0409021e34a ("drm/amdgpu: Update EEPROM I2C address for smu v13_0_0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index b908d575b5a98..40cd9d8c4e870 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -181,14 +181,14 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 	switch (adev->asic_type) {
 	case CHIP_VEGA20:
 		control->i2c_address = EEPROM_I2C_MADDR_0;
-		break;
+		return true;
 
 	case CHIP_ARCTURUS:
 		return __get_eeprom_i2c_addr_arct(adev, control);
 
 	case CHIP_SIENNA_CICHLID:
 		control->i2c_address = EEPROM_I2C_MADDR_0;
-		break;
+		return true;
 
 	case CHIP_ALDEBARAN:
 		if (strnstr(atom_ctx->vbios_version, "D673",
@@ -196,7 +196,7 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 			control->i2c_address = EEPROM_I2C_MADDR_4;
 		else
 			control->i2c_address = EEPROM_I2C_MADDR_0;
-		break;
+		return true;
 
 	case CHIP_IP_DISCOVERY:
 		return __get_eeprom_i2c_addr_ip_discovery(adev, control);
@@ -204,8 +204,6 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 	default:
 		return false;
 	}
-
-	return true;
 }
 
 static void
-- 
2.42.0



