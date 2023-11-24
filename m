Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C859B381D2;
	Fri, 24 Nov 2023 18:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KWgMnPyg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55458C433C7;
	Fri, 24 Nov 2023 18:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851505;
	bh=SuKdLNOpOUsraIfYgJDRpf6mFOTYFLuDz034GZcql+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KWgMnPyg+jblZWV+pwOAPZ6JooBXOj5nmPhGPIqkuXpBmgmRO8aVfR8P6M641LHw0
	 LxNK/PUZluPyLt/Y/wFoM3EGUf8iuslO+XWBhMwTOpJm9W/wIVGJxqF+VfmdPEY6dq
	 TxcPQtWgp8cX6/VFoL9v47DTfeFVmb5fla6VmFO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Jun <Jun.Ma2@amd.com>,
	Kenneth Feng <kenneth.feng@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.5 475/491] drm/amd/pm: Fix error of MACO flag setting code
Date: Fri, 24 Nov 2023 17:51:51 +0000
Message-ID: <20231124172038.909560494@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -343,12 +343,12 @@ static int smu_v13_0_0_check_powerplay_t
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
 
 	/*
 	 * We are in the transition to a new OD mechanism.
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -333,12 +333,13 @@ static int smu_v13_0_7_check_powerplay_t
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
 
 #if 0
 	if (!overdrive_lowerlimits->FeatureCtrlMask ||


