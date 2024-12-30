Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265CA42AA6;
	Mon, 30 Dec 2024 15:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574107; cv=none; b=MSGu4yJ7UmBKP8qcrvuDImxEzmmd2XqmGVgtClr0jCDfVvuxuE4I7MYH/vPmZmP46Yh13aBqZHizCVOndglWG05BSKwV6MZxkJJCAYwIktKDDcRdtXTehTXnRViAMKo+gic2YhmnVg1DYfLeb4rFDPSmuw/uOOP5WSFi+CjZMWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574107; c=relaxed/simple;
	bh=2gknVYVkl7yoxO2DFug7mhmSpzcuHvC8kG8ggdPfXbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WDMnqU9yVRkyNgAVSJ1JO8P0ouz48lGxzzvKiPHH2vmjQ4dmriysC8sG1iPGdRkWlStHqqvdoQmnK2Zp8miJANj/lC1r0WPurmxJug2iD4e96BVR/oXwuU4LvGruv8ZAJgblwjGmElXYQJInzgovGowkvPORdUbRLAUo0JD1hUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gZRoSqTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gZRoSqTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FD8C4CED0;
	Mon, 30 Dec 2024 15:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574107;
	bh=2gknVYVkl7yoxO2DFug7mhmSpzcuHvC8kG8ggdPfXbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZRoSqTA09Jk5Jy5XCcDxaIUtgS3LMdRMaXGQgMsCTKxC3Dbmaur9dlCDtf5tteiS
	 jLJLE3G/TN1Agc2h+Gxlk+eEzCEaigv0bEoMh4IOYDvZH9BYPM6FenT8YV5ErP2vkG
	 /2wbydtdseErEZcCdYvXzN2nyvPFYOuRf1j5WuC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 038/114] ASoC: amd: ps: Fix for enabling DMIC on acp63 platform via _DSD entry
Date: Mon, 30 Dec 2024 16:42:35 +0100
Message-ID: <20241230154219.529617394@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

commit 88438444fdddd0244c8b2697713adcca3e71599e upstream.

Add condition check to register ACP PDM sound card by reading
_WOV acpi entry.

Fixes: 0386d765f27a ("ASoC: amd: ps: refactor acp device configuration read logic")

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://patch.msgid.link/20241213061147.1060451-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/ps/pci-ps.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/sound/soc/amd/ps/pci-ps.c
+++ b/sound/soc/amd/ps/pci-ps.c
@@ -375,11 +375,18 @@ static int get_acp63_device_config(struc
 {
 	struct acpi_device *pdm_dev;
 	const union acpi_object *obj;
+	acpi_handle handle;
+	acpi_integer dmic_status;
 	u32 config;
 	bool is_dmic_dev = false;
 	bool is_sdw_dev = false;
+	bool wov_en, dmic_en;
 	int ret;
 
+	/* IF WOV entry not found, enable dmic based on acp-audio-device-type entry*/
+	wov_en = true;
+	dmic_en = false;
+
 	config = readl(acp_data->acp63_base + ACP_PIN_CONFIG);
 	switch (config) {
 	case ACP_CONFIG_4:
@@ -412,10 +419,18 @@ static int get_acp63_device_config(struc
 			if (!acpi_dev_get_property(pdm_dev, "acp-audio-device-type",
 						   ACPI_TYPE_INTEGER, &obj) &&
 						   obj->integer.value == ACP_DMIC_DEV)
-				is_dmic_dev = true;
+				dmic_en = true;
 		}
+
+		handle = ACPI_HANDLE(&pci->dev);
+		ret = acpi_evaluate_integer(handle, "_WOV", NULL, &dmic_status);
+		if (!ACPI_FAILURE(ret))
+			wov_en = dmic_status;
 	}
 
+	if (dmic_en && wov_en)
+		is_dmic_dev = true;
+
 	if (acp_data->is_sdw_config) {
 		ret = acp_scan_sdw_devices(&pci->dev, ACP63_SDW_ADDR);
 		if (!ret && acp_data->info.link_mask)


