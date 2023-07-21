Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C9020F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431C4C433C8;
	Fri, 21 Jul 2023 19:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967184;
	bh=D7FY89jS0eww/FqRuswgJiEtyq7MWSyhA6ACkA3gFC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewif6H6ePFMNwiGNMG1+R3UQlUWpNn5WuDc3xvW1x0p412jS/oQLVht8mIDcOEt77
	 uM4GZlZDRzdBnRnHMisyK5HiV1Lu7cTPJceywy3x6U35nGinMIwiK6WC6jkwtrGMdZ
	 QPui1hXC5rUTmWULk/fA2FOn3AWm+kubAkqg4E1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <Alexander.Deucher@amd.com>,
	Luben Tuikov <luben.tuikov@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 073/223] drm/amdgpu: Fix minmax warning
Date: Fri, 21 Jul 2023 18:05:26 +0200
Message-ID: <20230721160523.975740832@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luben Tuikov <luben.tuikov@amd.com>

commit abd51738fe754a684ec44b7a9eca1981e1704ad9 upstream.

Fix minmax warning by using min_t() macro and explicitly specifying
the assignment type.

Cc: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Reviewed-by: Alex Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -1441,7 +1441,9 @@ static int smu_v13_0_irq_process(struct
 			case 0x8:
 				high = smu->thermal_range.software_shutdown_temp +
 					smu->thermal_range.software_shutdown_temp_offset;
-				high = min(SMU_THERMAL_MAXIMUM_ALERT_TEMP, high);
+				high = min_t(typeof(high),
+					     SMU_THERMAL_MAXIMUM_ALERT_TEMP,
+					     high);
 				dev_emerg(adev->dev, "Reduce soft CTF limit to %d (by an offset %d)\n",
 							high,
 							smu->thermal_range.software_shutdown_temp_offset);
@@ -1454,8 +1456,9 @@ static int smu_v13_0_irq_process(struct
 				WREG32_SOC15(THM, 0, regTHM_THERMAL_INT_CTRL, data);
 				break;
 			case 0x9:
-				high = min(SMU_THERMAL_MAXIMUM_ALERT_TEMP,
-					smu->thermal_range.software_shutdown_temp);
+				high = min_t(typeof(high),
+					     SMU_THERMAL_MAXIMUM_ALERT_TEMP,
+					     smu->thermal_range.software_shutdown_temp);
 				dev_emerg(adev->dev, "Recover soft CTF limit to %d\n", high);
 
 				data = RREG32_SOC15(THM, 0, regTHM_THERMAL_INT_CTRL);


