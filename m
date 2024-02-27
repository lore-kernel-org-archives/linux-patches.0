Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC56145326;
	Tue, 27 Feb 2024 13:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040589; cv=none; b=W73j3vzDPnyXG439cgW8moF7rjCiTJDzC86WF14sJlchV45wPOkncpQBFwLHAeVInyGCP7mKxxCNjTV10aFWFof1O1pDvGGnvxwLRzl8VHy64aPKbGe7JhT6BQhS771psKO6WraykHQ647LAvsu66BQLt3CQIBuawNQywR9aoT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040589; c=relaxed/simple;
	bh=2Ko2nqEAEzyKXO+Ex56mFv5XdifFowdrozPHzjK3jRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMz+2ErRXO3h5eHulBQlWkvwsqBhDekoullcH2ryFYFt8gKKQAlR0HWBOM3Qm1sFLEk4o4yxTv4a6R0PqUIbcpBvhXIUHNaoAsp6Qtav1OYKBEEx/EEBnNAS5XOith7n+tmITZLtFleqd42uzFShxy+p/7St4c+TcRHxqndycD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pcM8CRLu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pcM8CRLu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEDBC433F1;
	Tue, 27 Feb 2024 13:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040589;
	bh=2Ko2nqEAEzyKXO+Ex56mFv5XdifFowdrozPHzjK3jRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pcM8CRLufT14HzykSW1g/6W76iHCMZrsIEw204wRxrgXKMms4CUJveGWyiRFww3G5
	 cybEdV/RV0VLwm/aKXwxCrZWoJldgPKdAUB0bJQ4pgsZi27Rf7CpS43xdNScapIwr7
	 Efux51JuJT6yjaVcEPKVJorOrOyG7AE27B/COthU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 039/334] ASoC: amd: acp: Add check for cpu dai link initialization
Date: Tue, 27 Feb 2024 14:18:17 +0100
Message-ID: <20240227131631.852827795@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 34b14f2611ba8..12ff0a558ea8f 100644
--- a/sound/soc/amd/acp/acp-mach-common.c
+++ b/sound/soc/amd/acp/acp-mach-common.c
@@ -1428,8 +1428,13 @@ int acp_sofdsp_dai_links_create(struct snd_soc_card *card)
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



