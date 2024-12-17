Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE93D140E38;
	Tue, 17 Dec 2024 17:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456205; cv=none; b=T5RDqdJ+P/TrpVarPddyIpkhUHArTP+5RABaZu05n3LVw1L33CYQO0PF4JO0k0FlhF31Oevv4iEctG2WoYTq2jjJ1rYyplvABHz/JjKZ3+/aiNGL2qVrLrkJzgRrtG/4ABd1Wj3YQ4v53UUZQyRqpsiopXZz+2pG403d7RHgGCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456205; c=relaxed/simple;
	bh=bX2bwFcgCWsthRS0zLXlHDtQKBeSDq0VhD169FvxcU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ib5J1LuzuTGPTTD+PHYDwCOCA4MhRzi7vfDbk7T8QOIWv4DI0E3ZO/q/dZ4O+Kf18ctXaKWLIQTUvJvalfdZnQSgSsjV8E3a7T13jpDontpKCYA9hN69Cz+4Xxn9pU3WG7FieUwf7R3JXI1L8L4UtuNjzREqt3a/4wTF3YDtZS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUFzkcPl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUFzkcPl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4228EC4CED3;
	Tue, 17 Dec 2024 17:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456205;
	bh=bX2bwFcgCWsthRS0zLXlHDtQKBeSDq0VhD169FvxcU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUFzkcPlAi92zMHx3Fxlgkjvaozef0irs9RpQ+k5Docuzpm95AOS04rksRJVkgm5T
	 rb8yBKDRLWGVYC16wb45oyRiAXLjt8L0igVx3SK387f+7EpPzXO5mQsaAS1wYWGYh/
	 HGIdqJykmSIk+gKW/5hOpYs3mK0dFCJR40fC5/Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/109] ASoC: amd: yc: Fix the wrong return value
Date: Tue, 17 Dec 2024 18:07:50 +0100
Message-ID: <20241217170536.139408619@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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
index 39f151d073a6..f7fbde1bc2ed 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -578,14 +578,19 @@ static int acp6x_probe(struct platform_device *pdev)
 
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



