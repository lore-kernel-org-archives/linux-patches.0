Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B71377EBF;
	Wed, 23 Sep 2026 14:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173286; cv=none; b=eeDonJauow3Lr2hmwoXpQ3a464Dq2lcPQtd2XTcDoWCJvCcAivoqWjPaDaJ0FEibCplfoVi8A/74GGXFkupNtbcbW5CiSePtbZAA6eicFQ/cZIdydA06zAP3EMBM+vmlWh/RKqEZsp/BfrCbWf6IK4VtMXycAfTze003Aslfj14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173286; c=relaxed/simple;
	bh=Y/C474Ha2GQ2Ezt0BWcjA4RaIbCfry4VAdr7RG/MwR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6S2AR9HPnqOMmNVpYmWIx4bF6csstQo5DBPwXxW0xqf1byGb22749ZrFSOStJyc4Y9XgV7GATlT8KvvPAXpkAUwXu4s51y99T7XbnPelrpy2IsUzW1V+UxXunwI8nlA4OhkaCo+yzujL+YE9AqWADKJzG9Tslbxr6BZBM8JxCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNnkROOx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNnkROOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56171F000FF;
	Wed, 23 Sep 2026 14:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173285;
	bh=SKOseVNEZpl2lD+Q+mfMHifs9dNtsyn7XWpq68oXb6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNnkROOxAxvgPqTO/ujeHIOlMkU73KeTndd4fXUnkoIXDcpohsYbhuNrReddF58fO
	 5vnQ7JTqul7UWp/zglBvhGL+qboflpmlILxcMOXAEDnCUYs3j3xU6jsp+/5b7moXmb
	 d5L7UdEwa8w5g342XaTk4fYLt/1fwToENQSjKZn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 200/438] ASoC: amd: acp: bounds-check SoundWire link ID in machine drivers
Date: Wed, 23 Sep 2026 16:03:41 +0200
Message-ID: <20260923140649.943302199@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 29218a4d11a31a8157389bc2b9e62dd768d7ea42 ]

Add a bounds check in create_sdw_dailink() to validate that the
SoundWire link ID derived from link_mask does not exceed the maximum
supported by the platform. If the link ID is out of range or link_mask
is zero, log an error and return -EINVAL to prevent accessing invalid
CPU pin ID tables.

Applied to both acp-sdw-sof-mach.c and acp-sdw-legacy-mach.c.

Fixes: 6d8348ddc56e ("ASoC: amd: acp: refactor SoundWire machine driver code")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>
Link: https://patch.msgid.link/20260910161728.1452808-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-legacy-mach.c | 10 ++++++++++
 sound/soc/amd/acp/acp-sdw-sof-mach.c    |  9 +++++++++
 2 files changed, 19 insertions(+)

diff --git a/sound/soc/amd/acp/acp-sdw-legacy-mach.c b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
index e8b6819cc4b45..1a6be664be279 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -205,6 +205,16 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 			return -EINVAL;
 		}
 
+		if (!soc_end->link_mask) {
+			dev_err(dev, "invalid zero link_mask\n");
+			return -EINVAL;
+		}
+		if ((ffs(soc_end->link_mask) - 1) >= amd_ctx->max_sdw_links) {
+			dev_err(dev, "link_id %d exceeds max_sdw_links %d\n",
+				ffs(soc_end->link_mask) - 1, amd_ctx->max_sdw_links);
+			return -EINVAL;
+		}
+
 		switch (amd_ctx->acp_rev) {
 		case ACP63_PCI_REV:
 			ret = get_acp63_cpu_pin_id(ffs(soc_end->link_mask - 1),
diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index a423853f3a97d..f66228435984a 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -121,6 +121,15 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 			return -EINVAL;
 		}
 
+		if (!sof_end->link_mask) {
+			dev_err(dev, "invalid zero link_mask\n");
+			return -EINVAL;
+		}
+		if ((ffs(sof_end->link_mask) - 1) >= amd_ctx->max_sdw_links) {
+			dev_err(dev, "link_id %d exceeds max_sdw_links %d\n",
+				ffs(sof_end->link_mask) - 1, amd_ctx->max_sdw_links);
+			return -EINVAL;
+		}
 		switch (amd_ctx->acp_rev) {
 		case ACP63_PCI_REV:
 			ret = get_acp63_cpu_pin_id(ffs(sof_end->link_mask - 1),
-- 
2.53.0



