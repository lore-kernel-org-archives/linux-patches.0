Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE0D2E84A;
	Fri, 24 Nov 2023 19:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uf+Blj63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C52CC433CA;
	Fri, 24 Nov 2023 19:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852446;
	bh=ZTxfEQ9/gWYJgZH6FuxYCyOAMVRdWwz2C6PeT0TUCGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uf+Blj635F3r1NAyRfRWSbpInkemiNl5k72MQGwNS4uVxrXlqYAyZ9jVfabcq+IAW
	 nXPI+t4c54e0n311pYT2tOmpyKgVlUPK/+XI/OqjHcUcmstLEgycf7KndHmFtRi/Tj
	 pnPVyUV9s222D8vzTWeVW81bN3ML9l5EG81nWKIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 360/372] drm/amd/pm: Fix error of MACO flag setting code
Date: Fri, 24 Nov 2023 17:52:27 +0000
Message-ID: <20231124172022.297692392@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

From: Ma Jun <Jun.Ma2@amd.com>

commit 7f3e6b840fa8b0889d776639310a5dc672c1e9e1 upstream.

MACO only works if BACO is supported

Signed-off-by: Ma Jun <Jun.Ma2@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c |    8 ++++----
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c |    9 +++++----
 2 files changed, 9 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -324,12 +324,12 @@ static int smu_v13_0_0_check_powerplay_t
 	if (powerplay_table->platform_caps & SMU_13_0_0_PP_PLATFORM_CAP_HARDWAREDC)
 		smu->dc_controlled_by_gpio = true;
 
-	if (powerplay_table->platform_caps & SMU_13_0_0_PP_PLATFORM_CAP_BACO ||
-	    powerplay_table->platform_caps & SMU_13_0_0_PP_PLATFORM_CAP_MACO)
+	if (powerplay_table->platform_caps & SMU_13_0_0_PP_PLATFORM_CAP_BACO) {
 		smu_baco->platform_support = true;
 
-	if (powerplay_table->platform_caps & SMU_13_0_0_PP_PLATFORM_CAP_MACO)
-		smu_baco->maco_support = true;
+		if (powerplay_table->platform_caps & SMU_13_0_0_PP_PLATFORM_CAP_MACO)
+			smu_baco->maco_support = true;
+	}
 
 	table_context->thermal_controller_type =
 		powerplay_table->thermal_controller_type;
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -326,12 +326,13 @@ static int smu_v13_0_7_check_powerplay_t
 	if (powerplay_table->platform_caps & SMU_13_0_7_PP_PLATFORM_CAP_HARDWAREDC)
 		smu->dc_controlled_by_gpio = true;
 
-	if (powerplay_table->platform_caps & SMU_13_0_7_PP_PLATFORM_CAP_BACO ||
-	    powerplay_table->platform_caps & SMU_13_0_7_PP_PLATFORM_CAP_MACO)
+	if (powerplay_table->platform_caps & SMU_13_0_7_PP_PLATFORM_CAP_BACO) {
 		smu_baco->platform_support = true;
 
-	if (smu_baco->platform_support && (BoardTable->HsrEnabled || BoardTable->VddqOffEnabled))
-		smu_baco->maco_support = true;
+		if ((powerplay_table->platform_caps & SMU_13_0_7_PP_PLATFORM_CAP_MACO)
+					&& (BoardTable->HsrEnabled || BoardTable->VddqOffEnabled))
+			smu_baco->maco_support = true;
+	}
 
 	table_context->thermal_controller_type =
 		powerplay_table->thermal_controller_type;


