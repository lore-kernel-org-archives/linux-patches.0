Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90BB31C31
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:52:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17C6C433C1;
	Wed, 23 Nov 2022 09:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669197149;
	bh=2OI2APBd1jExr1h7zXHFoK56XBYgjQyI4naM7V0+Tx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KlVxnt6KGpycemHsznd43iTt2/lmcckh3Ne5p9R2I7I75aiC0GhgqpA/uTj/edvu5
	 oA6ulvVk9vuVr2eH+3cri9zyMpYmOvMU3NCUeCogUI/RqFjoeC4X7v0WVzoUgrg0Rw
	 UrxPWGuqQEdI/sdG0awgRm1FZwd42kSeIM6CrcPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Feifei Xu <Feifei.Xu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 212/314] drm/amd/pm: fix SMU13 runpm hang due to unintentional workaround
Date: Wed, 23 Nov 2022 09:50:57 +0100
Message-Id: <20221123084635.142971874@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

commit 4b14841c9a820e484bc8c4c3f5a6fed1bc528cbc upstream.

The workaround designed for some specific ASICs is wrongly applied
to SMU13 ASICs. That leads to some runpm hang.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Feifei Xu <Feifei.Xu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c
@@ -1131,22 +1131,21 @@ static int smu_smc_hw_setup(struct smu_c
 	uint64_t features_supported;
 	int ret = 0;
 
-	if (adev->in_suspend && smu_is_dpm_running(smu)) {
-		dev_info(adev->dev, "dpm has been enabled\n");
-		/* this is needed specifically */
-		switch (adev->ip_versions[MP1_HWIP][0]) {
-		case IP_VERSION(11, 0, 7):
-		case IP_VERSION(11, 0, 11):
-		case IP_VERSION(11, 5, 0):
-		case IP_VERSION(11, 0, 12):
+	switch (adev->ip_versions[MP1_HWIP][0]) {
+	case IP_VERSION(11, 0, 7):
+	case IP_VERSION(11, 0, 11):
+	case IP_VERSION(11, 5, 0):
+	case IP_VERSION(11, 0, 12):
+		if (adev->in_suspend && smu_is_dpm_running(smu)) {
+			dev_info(adev->dev, "dpm has been enabled\n");
 			ret = smu_system_features_control(smu, true);
 			if (ret)
 				dev_err(adev->dev, "Failed system features control!\n");
-			break;
-		default:
-			break;
+			return ret;
 		}
-		return ret;
+		break;
+	default:
+		break;
 	}
 
 	ret = smu_init_display_count(smu, 0);


