Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0845085C6C;
	Mon,  8 Apr 2024 13:35:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583329; cv=none; b=XKyzOcEyBj9VbX9v5K5AjDZ8w5MtlbdkagdEmMOHqaifikpA/Nc5T42KlNFs0ZnfGmmMkeYMPz2OR1oyZd1v/VvcjDvv4dbj0yJ86L4mSByntwr4y1swBtNOgXAGli95Wma1d/r5hxUU1BSM5LZyBhU17Nd2INYxJ6XCIdJFg34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583329; c=relaxed/simple;
	bh=txEtT6kt2rbURRHmbTTNja6eRIiM2QzeVJ+tm0MSfq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntNCdBBPygBfsbF2h9HLoEu1pokcQ9htHNhalwWKWBLtqIwzHQAeQy3kRZAQFUzh9XOkcmgb9jCSQAk1uwQY3ptqYmzXIlm0viZoSqMRlF8vZjqJpmEbghuPdggyPJom2lM9etpxqLrwn+b24oJBnCo3WhoVhcjqitQkJGtPCUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tM2u4Gau; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tM2u4Gau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869EBC433C7;
	Mon,  8 Apr 2024 13:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583328;
	bh=txEtT6kt2rbURRHmbTTNja6eRIiM2QzeVJ+tm0MSfq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tM2u4GauwimWvy/n4zx6v7JjHw1tB4dLy5/vi7hwAV57Oh00OBdbtJ4yIfdzeNin0
	 wXhzZ2OyVgZL4hLoyCcgwacrWP4DWIh9Jg29SRXOZQszASz/rUopauBSEg8/MmwGuy
	 WO6ywIkKM7STSwyxRStmb78anyvYXPz7NLMKZzTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 182/252] ASoC: amd: acp: fix for acp_init function error handling
Date: Mon,  8 Apr 2024 14:58:01 +0200
Message-ID: <20240408125312.314768629@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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
index a32c14a109b77..223238f662f83 100644
--- a/sound/soc/amd/acp/acp-pci.c
+++ b/sound/soc/amd/acp/acp-pci.c
@@ -107,7 +107,10 @@ static int acp_pci_probe(struct pci_dev *pci, const struct pci_device_id *pci_id
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



