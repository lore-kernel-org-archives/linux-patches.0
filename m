Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124161F130F;
	Tue,  3 Dec 2024 15:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239463; cv=none; b=HCIvrrNCnquVunEykvpH+qFgdH5fX/JqjOlp0TMVMJncrL6XQEf4RtFFQ4bG4r1BjbFjRwcWAmt67f8VDgWou+6K1E80JA2Nfp02BrW3Q5zsguGR6aC7pU71EDvC0tPCw4qBb6On3EpFGYOefzva513rRRpVsbZevOi4DSB5vlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239463; c=relaxed/simple;
	bh=ZodDmwt0f+J5UURUMhB2BdG0T6+/+ajkXRVbDB0titI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZPe3ZU5glhmVZeoX9w+AKHoT5xNfbxKyxAG/blPHKypNPQuZCeLHBiK1k0jpguUz3t2k/0CUdmt9AP4HL4ssG3CYgOGXNJK4GYVMzAXHWjs90MzRJ+npC54AGHL/B3ZbzO83JgI52VQSdC7Y/sRHOBnIooUyYWXI2BrNASvxVC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lsHaUYGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lsHaUYGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D08EC4CECF;
	Tue,  3 Dec 2024 15:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239462;
	bh=ZodDmwt0f+J5UURUMhB2BdG0T6+/+ajkXRVbDB0titI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lsHaUYGOKVhNlljNMmaszuSSDgxgG/voAPyZ+zdlskmiunAINPJ7pMWqHCtHBWs5j
	 pPxFvZSjq+/W6tF4bzwtOMXNbrGxzgJQeAwhW/0bZXk5qHg1SeZ1HmqNo8eg8M/LOO
	 HqHjubslUJtNDpthZA95CPK5HCYFhOPYP759i7pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 623/817] ASoC: amd: yc: Fix for enabling DMIC on acp6x via _DSD entry
Date: Tue,  3 Dec 2024 15:43:15 +0100
Message-ID: <20241203144020.254191503@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



