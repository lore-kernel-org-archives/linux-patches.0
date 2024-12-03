Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BB31F8924;
	Tue,  3 Dec 2024 16:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242248; cv=none; b=eo8fJNlDIzc6OO60ICWqEGoBKoQ3rh/jAwofnBlzrcGMUFlDt1ehz5sEKaw9axCEb6SUBHr601I5YGDIHtbl+ReFfSkcrL6p7/NW8rG1hR9hjSCQt7BBup1BxTWxsf6AtRdMAVaPabIOJ3Pf4axp389mXEZg9Ixuq1ZguO5Uoyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242248; c=relaxed/simple;
	bh=OL9EtpsDcJtUfuEqyV9mjklKEDJf4o3zVz4rY2n9/WE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ko+OnmiFNpvbFUl6N9PJLxkquDKZGTGC2ALgbf1MXERDqET9qjHwG7uqMCNySlUQfkzWsQEjCPAD9Jr0l06sSkLGtBOpQkwZ58D/d2sxuipSs5VJHTEIv+18rMPOxqBRWneipXpgloy0BdzYC7GmD5tW4ImMrIclyGtvSDsGWtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XztMbcJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XztMbcJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6A6C4CECF;
	Tue,  3 Dec 2024 16:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242248;
	bh=OL9EtpsDcJtUfuEqyV9mjklKEDJf4o3zVz4rY2n9/WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XztMbcJt9U80vi8qf0+oGeZne9pgVE7/KGMxH5qPx8qeIrFNqjc6h1FU9x5JoeNqv
	 REvnUWcjwL3EuyJs7b7kk8kdWDiaFAF9ipALsoxkfMKEnE/SigLH0DQt/Wr+d083mr
	 kRcZsWGGmSa10G0FBI3yVCNN8OCoRC7UF2c5dW60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 619/826] ASoC: amd: yc: Fix for enabling DMIC on acp6x via _DSD entry
Date: Tue,  3 Dec 2024 15:45:46 +0100
Message-ID: <20241203144807.898781012@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit 4095cf872084ecfdfdb0e681f3e9ff9745acfa75 ]

Add condition check to register ACP PDM sound card by reading
_WOV acpi entry.

Fixes: 5426f506b584 ("ASoC: amd: Add support for enabling DMIC on acp6x via _DSD")

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://patch.msgid.link/20241127112227.227106-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 2436e8deb2be4..639e7136ef2a7 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -537,8 +537,14 @@ static int acp6x_probe(struct platform_device *pdev)
 	struct acp6x_pdm *machine = NULL;
 	struct snd_soc_card *card;
 	struct acpi_device *adev;
+	acpi_handle handle;
+	acpi_integer dmic_status;
 	int ret;
+	bool is_dmic_enable, wov_en;
 
+	/* IF WOV entry not found, enable dmic based on AcpDmicConnected entry*/
+	is_dmic_enable = false;
+	wov_en = true;
 	/* check the parent device's firmware node has _DSD or not */
 	adev = ACPI_COMPANION(pdev->dev.parent);
 	if (adev) {
@@ -546,9 +552,19 @@ static int acp6x_probe(struct platform_device *pdev)
 
 		if (!acpi_dev_get_property(adev, "AcpDmicConnected", ACPI_TYPE_INTEGER, &obj) &&
 		    obj->integer.value == 1)
-			platform_set_drvdata(pdev, &acp6x_card);
+			is_dmic_enable = true;
 	}
 
+	handle = ACPI_HANDLE(pdev->dev.parent);
+	ret = acpi_evaluate_integer(handle, "_WOV", NULL, &dmic_status);
+	if (!ACPI_FAILURE(ret))
+		wov_en = dmic_status;
+
+	if (is_dmic_enable && wov_en)
+		platform_set_drvdata(pdev, &acp6x_card);
+	else
+		return 0;
+
 	/* check for any DMI overrides */
 	dmi_id = dmi_first_match(yc_acp_quirk_table);
 	if (dmi_id)
-- 
2.43.0



