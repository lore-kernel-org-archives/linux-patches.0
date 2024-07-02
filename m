Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ACD01C68A2;
	Tue,  2 Jul 2024 17:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940751; cv=none; b=uizpxOGhrbjxOfw6zXs7tF8j0Eyv564uLKbh3laTUCNZiExPWVxsCR9AfxpSnTtlbBjqrGnStHy5Rd1JbWAC+4H5DKda0VFpNiED4chFrzdDEmLknD68N8yygAQyYJtP3cOCVIHiAgDUA/wcdH8dsDF5qGDM11H1W1A2WL8KOcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940751; c=relaxed/simple;
	bh=CLSB9l0uAV2LmR/nCDkiIY9+Sd5P/rVjBnRQ9sJhZ5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXwxuFEQAsoh5xTgiiTMTCfpRtDTZM15uw6XebVKn0dL4vdpauk82EzjBozDVZ8IUkkdEI/3/vH1kjrhqLsJEVk+mAQmzvgMhW8ySD8LE1XfJCW5rfI2jHNJiJD3JgXJreRirlcQphxmwlGOIxgEfjLvIxHKMdAO100a/yR0V/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktdljd86; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktdljd86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AF9C4AF0A;
	Tue,  2 Jul 2024 17:19:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940751;
	bh=CLSB9l0uAV2LmR/nCDkiIY9+Sd5P/rVjBnRQ9sJhZ5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ktdljd86PHm4yn3H2r0Xa9/QkZFHALU1yX41CdrDNukPxhvVVPqsdsm7u6xttAJSr
	 gOXc1469qjujoKQVFS3TRfrL6ghxn9rrYhH5FoTKNbiLLP5skoPKKFhXM3rgXQQFNC
	 YrS8O9Uhp2So4qntvg8hhAXKAYHx/h5g0GiXCtX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/163] ASoC: amd: acp: add a null check for chip_pdev structure
Date: Tue,  2 Jul 2024 19:02:19 +0200
Message-ID: <20240702170234.011585649@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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
index 223238f662f83..7de6446e6f7c1 100644
--- a/sound/soc/amd/acp/acp-pci.c
+++ b/sound/soc/amd/acp/acp-pci.c
@@ -185,10 +185,12 @@ static int __maybe_unused snd_acp_resume(struct device *dev)
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



