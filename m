Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407F151CF6B;
	Wed, 23 Sep 2026 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174736; cv=none; b=TPLgBZcNhrPrj782FFor2gtmlznMevy8KVc1vD8BC4qL6ZqPV7JvE0GvKCYZdYDry5XKsiyjvuCsPFh2JZTPchS8XOsB3AExI4707Ag+Yg2c/ZVEfNbb4asYG+usc/zqcHB9Di3HzWLE6gS0ZpN22wlEQT1VsmnmdDcjJVWygdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174736; c=relaxed/simple;
	bh=3uR5e++nKjLUejUeKRoEbelC6gDod9llDihaIWBslj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNfZKEy2GwT9YK8f/k1snGY0CKleVC/ubFW3NlF0lsts1g3ASXynbOlXKM+8uiGEU3FYeiBOb6Hm04Vhlxyo/8ByxYjlXm5qR/dpS0HsXWzT1rrOluWAxp3TOOqeqxKU5088M08TlDJVXce4Svazv9vSS57pFNgtvVButYwVgIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ytk0/UoQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ytk0/UoQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FB11F00899;
	Wed, 23 Sep 2026 14:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174735;
	bh=TtQiX7xCxSDXyAL1LU0SXG6+U7p1nYzUe0UlXGo2Ro0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ytk0/UoQdT50ao8rl2dHU3TdsYlwcne4SmDpMpejZQdCqiZ7SMlIDMDeRignOCMOY
	 OllMrsDjhinUvKf/7aPZpkC8xvdgz6nupgIMKDWHhR0/yX/T1f7gU7hPedtQUfnjl9
	 3niSJ3O0HJ29cxP3bLuYb5XvCZf9zHn9ZjolMNhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 168/398] ASoC: amd: acp: bounds-check SoundWire link ID in machine drivers
Date: Wed, 23 Sep 2026 16:04:02 +0200
Message-ID: <20260923140647.789615339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ac955a9b51dc3..09387accd1269 100644
--- a/sound/soc/amd/acp/acp-sdw-legacy-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-legacy-mach.c
@@ -189,6 +189,16 @@ static int create_sdw_dailink(struct snd_soc_card *card,
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
index 14d6e31d50408..d365c51bb99c1 100644
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



