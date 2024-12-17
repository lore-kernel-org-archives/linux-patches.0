Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B14142E77;
	Tue, 17 Dec 2024 17:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455937; cv=none; b=FctLzTPrh/+yVWeLCSqEUo1rKlIgbaftGPJwDzcofSgp9Ic5xyjz1/lBPY2vmeNnfCzmCYkIM59GOPbafIFUsxiE5Y7/8r9LkDkHtjEkQO6VlwsNa3X6cGETTX35aolJuf2rl800Zd6r05sLXD5rGoZ57x5DJmwiyZAS2ARva60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455937; c=relaxed/simple;
	bh=4J6jtz2Cd37FlJrFCeU1YSPxiof6f+HrStldQdgfqdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXPSgM4ZnyS5LQOLlSwR8Zu0ZMwHahV6PYWfL227e0G7x9j9ovrhBdJ3SBABnhSOgmUDtk635/UEbAvS41rtlnkaAxbWdK/hOuTruOTw8yX2qOFuwMGmuF9efZymnjjvqr5tNuKrDxJJdx9ZFHpzUnLDYC1ZaUEdmY9B/Vkb6O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EsMnCAA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EsMnCAA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFB8C4CED7;
	Tue, 17 Dec 2024 17:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455937;
	bh=4J6jtz2Cd37FlJrFCeU1YSPxiof6f+HrStldQdgfqdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EsMnCAA2OHUfAilyF82pQaE4IBa9XP5JAXOLTd011ZX8cB9uycBlPJAXx/9SMVbve
	 2rYlczTk6v19QqvNaKoc8sI1H/9H9s2gwyim6qKJdvs4SaK2O90VsE/G1gsWehlB6+
	 sroCQRIKLQLZ0yktqv8Mi+WtCLrWiTAG6pi/wHzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 56/76] ASoC: amd: yc: Fix the wrong return value
Date: Tue, 17 Dec 2024 18:07:36 +0100
Message-ID: <20241217170528.593400005@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>

[ Upstream commit 984795e76def5c903724b8d6a8228e356bbdf2af ]

With the current implementation, when ACP driver fails to read
ACPI _WOV entry then the DMI overrides code won't invoke,
may cause regressions for some BIOS versions.

Add a condition check to jump to check the DMI entries incase of
ACP driver fail to read ACPI _WOV method.

Fixes: 4095cf872084 (ASoC: amd: yc: Fix for enabling DMIC on acp6x via _DSD entry)

Signed-off-by: Venkata Prasad Potturu <venkataprasad.potturu@amd.com>
Link: https://patch.msgid.link/20241210091026.996860-1-venkataprasad.potturu@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index af9601bea275..9c1bf0eb2deb 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -473,14 +473,19 @@ static int acp6x_probe(struct platform_device *pdev)
 
 	handle = ACPI_HANDLE(pdev->dev.parent);
 	ret = acpi_evaluate_integer(handle, "_WOV", NULL, &dmic_status);
-	if (!ACPI_FAILURE(ret))
+	if (!ACPI_FAILURE(ret)) {
 		wov_en = dmic_status;
+		if (!wov_en)
+			return -ENODEV;
+	} else {
+		/* Incase of ACPI method read failure then jump to check_dmi_entry */
+		goto check_dmi_entry;
+	}
 
-	if (is_dmic_enable && wov_en)
+	if (is_dmic_enable)
 		platform_set_drvdata(pdev, &acp6x_card);
-	else
-		return 0;
 
+check_dmi_entry:
 	/* check for any DMI overrides */
 	dmi_id = dmi_first_match(yc_acp_quirk_table);
 	if (dmi_id)
-- 
2.39.5



