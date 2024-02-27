Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262491420A6;
	Tue, 27 Feb 2024 13:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041780; cv=none; b=A27iJfGvJ+VolqeKKEH4mHodqW4Sas8R6caPxd1/fc8306q2Grh0v1sIvREEMGbmWpPJvLnI1InRzAGEXjOMo1s+PqIR0QAhfjzo8nSREPfXDC2UBPsaIqm42N8I94g3b2K0QNAmKkGeec3ym3bVu0dc3bNUJnikys2XIbNJBkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041780; c=relaxed/simple;
	bh=zmWU4eE4G1CDCyGyZ352acaD8ZUP/RBg3SLxKXx66KE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIKwSqU01Ej6fdcn8FX+dnFGaFoOLe2rEKOKCB7e2Py+5e1fLn4/nxzaJGeEBJzMW0kEAwrQyQ+a737RolGeMX4bFHgvnCTC43pL5w3AvkIdT89TARCHlXvkDGPjlV60oEkTvCV8oJIh72xk8dKsAMbPCFd4ViQOf2R95KwDfZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oejdRHwC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oejdRHwC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A571FC433F1;
	Tue, 27 Feb 2024 13:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041780;
	bh=zmWU4eE4G1CDCyGyZ352acaD8ZUP/RBg3SLxKXx66KE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oejdRHwCjkdIYai3Gk8uJLbXjAAaFGJkCamdtw/WUHF6vOwONXfoiwW2oKWQXzYRL
	 EFXkGlB8rV18dAoIaybwInUZOafewv8Q4+KyZ8lHHKIweGuU/0az+iWIofuAMJx5SP
	 Td8TfKYb+ol2r0K4whtpotVhMAcz+wcQYkqPNCtc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/299] ASoC: amd: acp: Add check for cpu dai link initialization
Date: Tue, 27 Feb 2024 14:22:29 +0100
Message-ID: <20240227131627.205257698@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit 6cc2aa9a75f2397d42b78d4c159bc06722183c78 ]

Add condition check for cpu dai link initialization for amplifier
codec path, as same pcm id uses for both headset and speaker path
for RENOIR platforms.

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://msgid.link/r/20240118143023.1903984-3-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-mach-common.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/sound/soc/amd/acp/acp-mach-common.c b/sound/soc/amd/acp/acp-mach-common.c
index a06af82b80565..fc4e91535578b 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -1416,8 +1416,13 @@ int acp_sofdsp_dai_links_create(struct snd_soc_card *card)
 	if (drv_data->amp_cpu_id == I2S_SP) {
 		links[i].name = "acp-amp-codec";
 		links[i].id = AMP_BE_ID;
-		links[i].cpus = sof_sp_virtual;
-		links[i].num_cpus = ARRAY_SIZE(sof_sp_virtual);
+		if (drv_data->platform == RENOIR) {
+			links[i].cpus = sof_sp;
+			links[i].num_cpus = ARRAY_SIZE(sof_sp);
+		} else {
+			links[i].cpus = sof_sp_virtual;
+			links[i].num_cpus = ARRAY_SIZE(sof_sp_virtual);
+		}
 		links[i].platforms = sof_component;
 		links[i].num_platforms = ARRAY_SIZE(sof_component);
 		links[i].dpcm_playback = 1;
-- 
2.43.0



