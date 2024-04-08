Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059A7745C5;
	Mon,  8 Apr 2024 13:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583588; cv=none; b=Vre0CfE241jnOY5j01ApuDPSls5HdZT2xMCiitfOPUJmQ4GyuSUMnfqHMPNg2z3dyHCOc5X5T3HRqNRQr057AdmVeIUnVFshji5rvZTmFyMZ8kpV8eJg7wtcTp3CBrknHNSwjUjaxATb6/jNe5oUXdtm7JL4339bRyGvfC2b5Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583588; c=relaxed/simple;
	bh=tjh47309BwWynbz2Ju8UJaoAUgHjrFE7gTgxdaal4vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIGjo5kh0OJjghhsUcokowSO5hvtpd/HmZzpY9/vMvGNwGJM5egEqf706nP0Z+44pGWzBJw5IeIUXKk9AiqTdR28g9d/g73m6kw/7EJ5wbDD+YXZLhZ7mYHamTem00b/5A2BSk6evdihtKk8KCDQW2U6D7qH7RB6It7Z6F1Bo8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjzI1Z8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjzI1Z8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E169C433C7;
	Mon,  8 Apr 2024 13:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583587;
	bh=tjh47309BwWynbz2Ju8UJaoAUgHjrFE7gTgxdaal4vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjzI1Z8qJSMLAK4WnfSX1rZsO6O7apIxnwOCJHRRuecf9Ujgm4jBmP3sxhraSSqd3
	 FWF2TKBu7cI7vEmODwg6qIIbG9QUrR3NoHUat2W03P+hx2qsGb680O/rE5T1le4YIm
	 tSrtttwadSYhB0x0fmQC3pyGZjoKWs/O2/A78hkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 172/273] ASoC: amd: acp: fix for acp_init function error handling
Date: Mon,  8 Apr 2024 14:57:27 +0200
Message-ID: <20240408125314.602449940@linuxfoundation.org>
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

[ Upstream commit 2c603a4947a1247102ccb008d5eb6f37a4043c98 ]

If acp_init() fails, acp pci driver probe should return error.
Add acp_init() function return value check logic.

Fixes: e61b415515d3 ("ASoC: amd: acp: refactor the acp init and de-init sequence")
Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20240329053815.2373979-1-Vijendar.Mukunda@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-pci.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-pci.c b/sound/soc/amd/acp/acp-pci.c
index 440b91d4f261c..5f35b90eab8d3 100644
--- a/sound/soc/amd/acp/acp-pci.c
+++ b/sound/soc/amd/acp/acp-pci.c
@@ -115,7 +115,10 @@ static int acp_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id
 		goto unregister_dmic_dev;
 	}
 
-	acp_init(chip);
+	ret = acp_init(chip);
+	if (ret)
+		goto unregister_dmic_dev;
+
 	res = devm_kcalloc(&pci->dev, num_res, sizeof(struct resource), GFP_KERNEL);
 	if (!res) {
 		ret = -ENOMEM;
-- 
2.43.0



