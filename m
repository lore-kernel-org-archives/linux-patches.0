Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBBE62206A5;
	Thu, 12 Dec 2024 17:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023956; cv=none; b=UWszgODesvUS9wbYBEM6rmRtxWKxs221g+7YXW9H3R8OypUAuNIDlc4/VQrSkiJGOWtDdmCNXydU5VDL3hI0/zSwhwwPFt/GA+jMhJckjRYjRlV/q1UkekNmYmQsH3Xa6WqAp4ZzSSl19BmOgSnHgoFH0KzkrQwwad4FtKsUeV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023956; c=relaxed/simple;
	bh=zypSsm86xXGEcuS7ur8s+lMNzJKGtpAJnSsQRjxddKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S0OlvtQmzQxFh4OZWAdgoUlD3fCMFNFiCpx2OeInNz0PA2pmtSejCr9uPTBDq3T0ro+MLZr0L6N/OH8le17q8X2dm1S25CMTcBb7CbeOiPJkOGWOhI6srFilsUMCdpOFfdMwukrswOt3UsDkNu7favc+VRIfWbOd423eIhfLFEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYbFErYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYbFErYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48EE4C4CED3;
	Thu, 12 Dec 2024 17:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023956;
	bh=zypSsm86xXGEcuS7ur8s+lMNzJKGtpAJnSsQRjxddKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYbFErYkk4xLVlqDSuNiN/WeOQPJInteHq5aXt+m0zj7U5WgrgyA9k7N1Ug5avYTa
	 mv7R4PAkRCDSt/lEF6J++uFw4qKyCeDz6PLbalJezFUC5OYekXsAGWXm0XmcEAUWiF
	 Zc3CxxMz9lOi67dVHnUIEoXHk6PSHFJCtAXG/AbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 138/459] wifi: wfx: Fix error handling in wfx_core_init()
Date: Thu, 12 Dec 2024 15:57:56 +0100
Message-ID: <20241212144258.960085156@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 3b88a9876779b55478a4dde867e73f7a100ffa23 ]

The wfx_core_init() returns without checking the retval from
sdio_register_driver().
If the sdio_register_driver() failed, the module failed to install,
leaving the wfx_spi_driver not unregistered.

Fixes: a7a91ca5a23d ("staging: wfx: add infrastructure for new driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241022090453.84679-1-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wfx/main.c b/drivers/staging/wfx/main.c
index d5dacd5583c6e..5a54dd22fad53 100644
--- a/drivers/staging/wfx/main.c
+++ b/drivers/staging/wfx/main.c
@@ -477,10 +477,23 @@ static int __init wfx_core_init(void)
 {
 	int ret = 0;
 
-	if (IS_ENABLED(CONFIG_SPI))
+	if (IS_ENABLED(CONFIG_SPI)) {
 		ret = spi_register_driver(&wfx_spi_driver);
-	if (IS_ENABLED(CONFIG_MMC) && !ret)
+		if (ret)
+			goto out;
+	}
+	if (IS_ENABLED(CONFIG_MMC)) {
 		ret = sdio_register_driver(&wfx_sdio_driver);
+		if (ret)
+			goto unregister_spi;
+	}
+
+	return 0;
+
+unregister_spi:
+	if (IS_ENABLED(CONFIG_SPI))
+		spi_unregister_driver(&wfx_spi_driver);
+out:
 	return ret;
 }
 module_init(wfx_core_init);
-- 
2.43.0



