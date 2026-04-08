Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ADF348453;
	Wed,  8 Apr 2026 18:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674639; cv=none; b=kh8hZnC9e6V9yIRHGzTB+B6ISCtTsESAOH2xTg3Tt2f/r8HvFyYcBR/B9dkOHYo1UV1rXGh71I4SuTFk0/slVbG5NQj0Tx99vEhJN1tnabuLf9lSPivbnzSLglcg2pRKlNXMDK5RiGUDp01nT6h7MljbNa32mizfHtnEvaxdu0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674639; c=relaxed/simple;
	bh=kvHFAqsmunY9+BT1J5cve/WwtqGe+ptjKJrovhHLIXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tItutc+zGhv3Wd4CV2rRRerh0Mg3ZIKdJwe8ZJcdDn+vM6aZMCQLe7gVuw+pT+Y/bURoF+D8MpYhSKtEUjEcatn3m5DlI+9TzTl/AQjmTNlzmnxyZDFEdV5ErDYN32Z1lI8Ueb3RI9BFHoU4OPOS8ZM6kdystylcSv3ve+r3xd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0opUh8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0opUh8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 978F8C2BC87;
	Wed,  8 Apr 2026 18:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674638;
	bh=kvHFAqsmunY9+BT1J5cve/WwtqGe+ptjKJrovhHLIXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0opUh8vM2lI62Y5zn0s5qWf71Pxzar4M6dKH6O9QH1zXx7Md8/KiN3HhHTU0K1d+
	 nzOsNOLvntiDVQ0LVUyGXrsw9OG1vKvHOXlXlWGQg6DQKRep3Gij3Vb+IAgpuyRZty
	 VLVRaZiskj7nYDGsqeBUxiPWYaflBdopqWDS18tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 142/311] spi: stm32-ospi: Fix resource leak in remove() callback
Date: Wed,  8 Apr 2026 20:02:22 +0200
Message-ID: <20260408175944.716432657@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 73cd1f97946ae3796544448ff12c07f399bb2881 ]

The remove() callback returned early if pm_runtime_resume_and_get()
failed, skipping the cleanup of spi controller and other resources.

Remove the early return so cleanup completes regardless of PM resume
result.

Fixes: 79b8a705e26c ("spi: stm32: Add OSPI driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://patch.msgid.link/20260329-ospi-v1-1-cc8cf1c82c4a@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32-ospi.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/spi/spi-stm32-ospi.c b/drivers/spi/spi-stm32-ospi.c
index f36fd36da2692..5fa27de89210a 100644
--- a/drivers/spi/spi-stm32-ospi.c
+++ b/drivers/spi/spi-stm32-ospi.c
@@ -963,11 +963,8 @@ static int stm32_ospi_probe(struct platform_device *pdev)
 static void stm32_ospi_remove(struct platform_device *pdev)
 {
 	struct stm32_ospi *ospi = platform_get_drvdata(pdev);
-	int ret;
 
-	ret = pm_runtime_resume_and_get(ospi->dev);
-	if (ret < 0)
-		return;
+	pm_runtime_resume_and_get(ospi->dev);
 
 	spi_unregister_controller(ospi->ctrl);
 	/* Disable ospi */
-- 
2.53.0



