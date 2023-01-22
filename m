Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF43D2590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73D8AC433EF;
	Sun, 22 Jan 2023 15:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674401266;
	bh=VBzj1nwD08Igz9KIq9CTrmauazBFDdPE2zOcpgmLVJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKD+c4N74ErqFiGzgkYmX73uC3lwzve86Fsa+jpmoOaKsyky21gcFOWBeO7iS7ubS
	 P4zfUCEFLw+QpcGqWy9FXzNcaPbSsTPxDDqsmk9jnTWP0sCMCTpoVE3Qe4lpvykyik
	 S+DjVhi5tKqH4gcZqKZ6hitvMUE6CfSyNrotBHdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Huang <tim.huang@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Aaron Liu <aaron.liu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 6.1 174/193] drm/amdgpu/pm: use the specific mailbox registers only for SMU IP v13.0.4
Date: Sun, 22 Jan 2023 16:05:03 +0100
Message-Id: <20230122150254.372285039@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tim Huang <tim.huang@amd.com>

commit 069a5af97ce3a1448a3566ce8b63b60e51e19958 upstream.

The SMU IP v13.0.4 ppt interface is shared by IP v13.0.11, they use
the different mailbox register offset. So use the specific mailbox
registers offset for v13.0.4.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_4_ppt.c
@@ -1026,6 +1026,15 @@ static const struct pptable_funcs smu_v1
 	.set_gfx_power_up_by_imu = smu_v13_0_set_gfx_power_up_by_imu,
 };
 
+static void smu_v13_0_4_set_smu_mailbox_registers(struct smu_context *smu)
+{
+	struct amdgpu_device *adev = smu->adev;
+
+	smu->param_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_82);
+	smu->msg_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_66);
+	smu->resp_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_90);
+}
+
 void smu_v13_0_4_set_ppt_funcs(struct smu_context *smu)
 {
 	struct amdgpu_device *adev = smu->adev;
@@ -1035,7 +1044,9 @@ void smu_v13_0_4_set_ppt_funcs(struct sm
 	smu->feature_map = smu_v13_0_4_feature_mask_map;
 	smu->table_map = smu_v13_0_4_table_map;
 	smu->is_apu = true;
-	smu->param_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_82);
-	smu->msg_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_66);
-	smu->resp_reg = SOC15_REG_OFFSET(MP1, 0, mmMP1_SMN_C2PMSG_90);
+
+	if (adev->ip_versions[MP1_HWIP][0] == IP_VERSION(13, 0, 4))
+		smu_v13_0_4_set_smu_mailbox_registers(smu);
+	else
+		smu_v13_0_set_smu_mailbox_registers(smu);
 }


