Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C792582865;
	Mon,  8 Apr 2024 13:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583209; cv=none; b=kWwyKcAhaJB2Wrt0Ntujc04AilZVR1E8Ec46w/p58bNKdNwvQP54Gs07J5EbOdfx0j57o3ORoh/A+4RgX/S6g17edTRFQWJLtxU/udZ28lwcqQ/quz+J+rN59AQArhJb0NWjwDJlA0AQ2EvxmXdj/tsDeOxNXnK5K6+yrAsSdQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583209; c=relaxed/simple;
	bh=v1XyJRYidd9ymVZ5c97nYCRYeXB0iJIw++tu2Id5X68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gQsbA+Dlc79ZA3gFrrraD5h6D+2Vqz1WlRMdTaBsqjeP3QWZ6o1NIj28mXyTPR/yQUmj6BfnVQPnqxKFkoKtqh/3uAlywG+F01EZTtNN4/Su+2swFbMVf3d/LDhYT5pXvAkHEjy0obvt2epd0i0QruIgfpbALcOv+oqSwh5Yrjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rRVL2PH2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rRVL2PH2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AB0C433F1;
	Mon,  8 Apr 2024 13:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583209;
	bh=v1XyJRYidd9ymVZ5c97nYCRYeXB0iJIw++tu2Id5X68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rRVL2PH29NaBSinF9fmJhYffLFHjObblPsEPi4mK9TH5Pp1IXHfgKN4m9yObMLRvS
	 53Blji1uTZRSq4+DJzBhFJmHyWYZlpcF9OVsQY8OAQjCjySjzkB/qUTkDtZTR9NPks
	 tZgPZZx743eIaHjDK1/uK9YSTXv/HToIzyHUOd4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 152/273] ASoC: amd: acp: fix for acp pdm configuration check
Date: Mon,  8 Apr 2024 14:57:07 +0200
Message-ID: <20240408125314.000909064@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 4af565de9f8c74b9f6035924ce0d40adec211246 ]

ACP PDM configuration has to be verified for all combinations.
Remove FLAG_AMD_LEGACY_ONLY_DMIC check.

Fixes: 3a94c8ad0aae ("ASoC: amd: acp: add code for scanning acp pdm controller")

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://msgid.link/r/20240327104657.3537664-2-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-pci.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/sound/soc/amd/acp/acp-pci.c b/sound/soc/amd/acp/acp-pci.c
index 8c8b1dcac6281..440b91d4f261c 100644
--- a/sound/soc/amd/acp/acp-pci.c
+++ b/sound/soc/amd/acp/acp-pci.c
@@ -133,11 +133,9 @@ static int acp_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id
 		}
 	}
 
-	if (flag == FLAG_AMD_LEGACY_ONLY_DMIC) {
-		ret = check_acp_pdm(pci, chip);
-		if (ret < 0)
-			goto skip_pdev_creation;
-	}
+	ret = check_acp_pdm(pci, chip);
+	if (ret < 0)
+		goto skip_pdev_creation;
 
 	chip->flag = flag;
 	memset(&pdevinfo, 0, sizeof(pdevinfo));
-- 
2.43.0



