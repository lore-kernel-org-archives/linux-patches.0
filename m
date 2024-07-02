Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBE31BD505;
	Tue,  2 Jul 2024 17:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940010; cv=none; b=IneN9kn8dRMpoOqM0eQbOOOvttS2koKB6wmy17IBuPdpCkIIr7tGkfFMmDL3Wx2i+rwyezsxH5eacfMReSnJnqv0XAvaqiNJ6bCxlV0V2BcnndWcJ+G1OykDJZFwHsSdeciN85xuhAM5HIu8D82Zh5heXaIEr9Ei6Zvk8OWGy+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940010; c=relaxed/simple;
	bh=qGzmHjZBnrI75XQfdq2JidqCTmTbARzXvvEEH05i6Sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TS/oboBYkjxKwYIB/Ini9tQVBnTKNft8f5q53aUa3atlMY3MieeexPRsDisGXDyCQVkymD+qr+kNRRUOZfImX3/cBKJo6Na01Gr3D36dw5KTyGAAhtdNT82dTPPvc/N9UozFbepoNodVzsCB1gxNK0SJugw5pSy33JZOB3ipazw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbZbuRSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbZbuRSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6D1C116B1;
	Tue,  2 Jul 2024 17:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940010;
	bh=qGzmHjZBnrI75XQfdq2JidqCTmTbARzXvvEEH05i6Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbZbuRSH1GBdpCSTOAPFB0OYoIPhjY6xzLiKCMGYiJx6jK6FUBiOUjJJvDMH9tCD0
	 CeX9tt9dcvZ77jqOdeh7xISaJZ5lckYu2x5XuWcK+lPuWOM6XX8AMaE5mgla2qEmU5
	 TQuPbUBehInFcfqJMxkOWQh/NJ8U8a/9IaN07Xhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 026/222] ASoC: amd: acp: add a null check for chip_pdev structure
Date: Tue,  2 Jul 2024 19:01:04 +0200
Message-ID: <20240702170244.978181409@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit 98d919dfee1cc402ca29d45da642852d7c9a2301 ]

When acp platform device creation is skipped, chip->chip_pdev value will
remain NULL. Add NULL check for chip->chip_pdev structure in
snd_acp_resume() function to avoid null pointer dereference.

Fixes: 088a40980efb ("ASoC: amd: acp: add pm ops support for acp pci driver")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://msgid.link/r/20240617072844.871468-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-pci.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/acp/acp-pci.c b/sound/soc/amd/acp/acp-pci.c
index ad320b29e87dc..aa3e72d134518 100644
--- a/sound/soc/amd/acp/acp-pci.c
+++ b/sound/soc/amd/acp/acp-pci.c
@@ -199,10 +199,12 @@ static int __maybe_unused snd_acp_resume(struct device *dev)
 	ret = acp_init(chip);
 	if (ret)
 		dev_err(dev, "ACP init failed\n");
-	child = chip->chip_pdev->dev;
-	adata = dev_get_drvdata(&child);
-	if (adata)
-		acp_enable_interrupts(adata);
+	if (chip->chip_pdev) {
+		child = chip->chip_pdev->dev;
+		adata = dev_get_drvdata(&child);
+		if (adata)
+			acp_enable_interrupts(adata);
+	}
 	return ret;
 }
 
-- 
2.43.0



