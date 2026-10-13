Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F2B0199FAB;
	Tue, 13 Oct 2026 12:37:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895061; cv=none; b=AIQsbZEOeTPKHK/zaKWLkdF05u7T/sAAYp3agRaEzr6KS3nGVlE//Erkw9BaojNDUpJhaliLs6m/Fws7zC/1Qa9HYP4MJ6518t753gO4AthrZnjuHVtr/g+A1xhcyj4b8gV1HUWfgdD7+LluU20WZRiqVyWQYX5H6DC8T3uTHPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895061; c=relaxed/simple;
	bh=hjIXZEQooQ3bbJutYdvtafagEHnKCzJ6d/yLU4FtzYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SXWbAkYUgDMyheeogLLkBdR1LghU+fmkx2Fwbt1dlNAnGS8Q5/8//1HhHvPkNvwVkjBbd8AykGv3YO4VWJBTRheOcV9JqCRK8JAHvirdIxIBJ4Qv0QGbOT94xF+FJew0PuZNnfVTIzG9CD8T8W/rZpTU1ipBjc146ApdM1FvRCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JxKvI075; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JxKvI075"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB381F000FF;
	Tue, 13 Oct 2026 12:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895060;
	bh=LPB7NIeSh/gc+F+LO9NxyeJhFcerB88l/IDw1adv9sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JxKvI075vjSxZRSge6+1MyBSxWtAdspypOxJ3IfYeL1VlPMd77m+tSS9b2o0zohHx
	 /3HdulYILmvUmlHxf2Ek/WR2d7yw8jmPZq3m9fo4XCzqVNbi2wnongliw5zY8sgKAf
	 phLcIBu99WMHamiYmooVNU/aK/0uEHqvOYqMo/Y4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Peter Chen <peter.chen@kernel.org>
Subject: [PATCH 6.12 149/497] usb: chipidea: tegra: disable runtime PM on resume failure
Date: Tue, 13 Oct 2026 13:35:16 +0200
Message-ID: <20261013112911.424414234@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Myeonghun Pak <mhun512@gmail.com>

commit f1d6f7d25fe88ee49aaad96c8649e090fc3a4b68 upstream.

tegra_usb_probe() enables runtime PM before resuming the device. If
pm_runtime_resume_and_get() fails, probe returns without disabling runtime
PM. The later error paths reach pm_runtime_force_suspend(), but this early
return bypasses that cleanup.

Disable runtime PM before returning the resume error. Do not use the
fail_power_off path: the failed resume did not retain a usage reference,
so its pm_runtime_put_sync_suspend() would be unbalanced.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 8b85e11c1a7a ("usb: chipidea: tegra: Add runtime PM and OPP support")
Cc: stable <stable@kernel.org>
Assisted-by: OpenAI:GPT-5.6
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://patch.msgid.link/20260913041033.25144-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/chipidea/ci_hdrc_tegra.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/ci_hdrc_tegra.c
+++ b/drivers/usb/chipidea/ci_hdrc_tegra.c
@@ -306,8 +306,10 @@ static int tegra_usb_probe(struct platfo
 
 	pm_runtime_enable(&pdev->dev);
 	err = pm_runtime_resume_and_get(&pdev->dev);
-	if (err)
+	if (err) {
+		pm_runtime_disable(&pdev->dev);
 		return err;
+	}
 
 	if (device_property_present(&pdev->dev, "nvidia,needs-double-reset"))
 		usb->needs_double_reset = true;


