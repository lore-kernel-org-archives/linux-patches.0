Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7C123D4134;
	Wed,  8 Apr 2026 18:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673217; cv=none; b=DY802HsjbfTWHB49Ah8XQN0eeHYw17OT74uEo2T0zi7mGXkEWx+IeslfR29f28nSQtn4CXPg6ic72ngZqzpS17e/GgTTRyuWXkMu6/NQylXmLsNXNdUBHzT1exvdC3EmQMnU+glBs5iHdpQhPx1ITLrDWm9YEAZm7ZZYPezGy+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673217; c=relaxed/simple;
	bh=iKYOXoZPTy5rM4WnJHaGRSD9+nFHjAFO5cpmBKrL49Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsTk3Keui4jvC+/10qSkiz8e335kM6H4UyqPGVYISTmbFYJQ5J5dOtdShKthCXaaPIEK+JsOzcIGwvanYaIQNNeNgD/XdM9I+C7/P0MWafXg4/G06WLE2RdRtWUO6y/ff8YG4dTE6K93+1bTCv4I527XxUJtTq0nsmstTfV/4js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5dd6ZWh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5dd6ZWh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462B5C2BCB1;
	Wed,  8 Apr 2026 18:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673217;
	bh=iKYOXoZPTy5rM4WnJHaGRSD9+nFHjAFO5cpmBKrL49Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5dd6ZWhUFw9wRw/A2PwwRnEsz4VUkma2y1odBXbWJqmvrrNaPqUY3qTgCtEiX/tL
	 8L1Xc1j7MTPdWiiz8jJGMdPn2qvnyG+B5ykwaGXPAw3EWSrQnW1bw4Y1bI+z0eH87w
	 OcyH7m2kh4WwAH+fwWAAPk4rVGCFijTOd9vWq17k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/277] spi: stm32-ospi: Fix resource leak in remove() callback
Date: Wed,  8 Apr 2026 20:01:38 +0200
Message-ID: <20260408175938.093168922@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



