Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3786F1F893E;
	Tue, 17 Dec 2024 17:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456719; cv=none; b=H98LmKpAoXxtt+YkV967yNxpqMHgklDXtvfuu81HeZgdn9ZcgDdOp5hYgRS8xCezcXWLmNFFAdlI3L9tFSFgB1mneWG9P1mcjYxltJ8fwWSnrxFSX9trsLan2uX6Zh3BBHz7sN0p6va6oFomTxBXTHSQVaXiv66obqdgvntu7Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456719; c=relaxed/simple;
	bh=7PPVqTgrOMat6nkvV464arNpWSX9PyMbmr3fYbcfN2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rS/YL8ibLUEGwPhdheUdLDD+ZRO9Henn0IyJgTwPq9VolL87IXVZNNeG0cEyRxMrJZnl8NiZEKe8sarYryIPrjbzAUEm4Ab1rDilEFNtFDZ5wP2W8SH3vtVBaX8fTeHWHhr5ZuNAEWnD0rzG93PZbrbNUvPkPT21sP9N22Iq444=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SiUtLByX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SiUtLByX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF669C4CED3;
	Tue, 17 Dec 2024 17:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456719;
	bh=7PPVqTgrOMat6nkvV464arNpWSX9PyMbmr3fYbcfN2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiUtLByXyDCYi4kujvYYcHfLpOc7NexbtC4Y6sq+Bz6b3/MEJCAiRI08QW1gTMS6P
	 GRaJzBNMv9lvusIBbJXJ03LfDEuN6peFdDWKm3JLuEa/xT0LYTD6dVLY1XOtTKv7ZE
	 cdhLcDXtkmQJa8ObgLdNNNtvBCLdRyZzaMX0g00Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkata Prasad Potturu <venkataprasad.potturu@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/172] ASoC: amd: yc: Fix the wrong return value
Date: Tue, 17 Dec 2024 18:07:53 +0100
Message-ID: <20241217170551.182254805@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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
index e38c5885dadf..ecf57a6cb7c3 100644
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



