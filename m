Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A1851C38;
	Mon, 11 Dec 2023 18:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DymU4lqW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F085C433C9;
	Mon, 11 Dec 2023 18:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320705;
	bh=G9DyszAhWl3WS+bF1bBpQWZ3PMSD823/ougWvXodvQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DymU4lqWvZfmUL4YvwydTM0dIC9yAgw7mg+U2P8ayzmHvGXP1fGLGe5u/Wq2hycjm
	 QVK5PAWKaoq/3etzYbYWChDB+ksSfghw6ZUR8D8//tmdQx1+t1wWvloRkSti71+n4p
	 MjSC8h16R7HrUhAt1bLxYVC9ATz2m0T9IJrbcwzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Kent Russell <kent.russell@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/194] drm/amdgpu: Add support for RAS table at 0x40000
Date: Mon, 11 Dec 2023 19:22:30 +0100
Message-ID: <20231211182043.789895247@linuxfoundation.org>
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

[ Upstream commit 64a3dbb06ad88d89a0958ccafc4f01611657f641 ]

Add support for RAS table at I2C EEPROM address of 0x40000, since on some
ASICs it is not at 0, but at 0x40000.

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Cc: Kent Russell <kent.russell@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Tested-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: e0409021e34a ("drm/amdgpu: Update EEPROM I2C address for smu v13_0_0")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index f63bd31e199c8..2d9f3f4cd79e9 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -157,6 +157,7 @@ static bool __get_eeprom_i2c_addr_ip_discovery(struct amdgpu_device *adev,
 static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 				  struct amdgpu_ras_eeprom_control *control)
 {
+	struct atom_context *atom_ctx = adev->mode_info.atom_context;
 	u8 i2c_addr;
 
 	if (!control)
@@ -190,7 +191,11 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 		break;
 
 	case CHIP_ALDEBARAN:
-		control->i2c_address = EEPROM_I2C_MADDR_0;
+		if (strnstr(atom_ctx->vbios_version, "D673",
+			    sizeof(atom_ctx->vbios_version)))
+			control->i2c_address = EEPROM_I2C_MADDR_4;
+		else
+			control->i2c_address = EEPROM_I2C_MADDR_0;
 		break;
 
 	case CHIP_IP_DISCOVERY:
-- 
2.42.0



