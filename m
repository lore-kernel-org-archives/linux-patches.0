Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81B747F53;
	Fri,  6 Dec 2024 14:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497191; cv=none; b=T8GMB5AZBf7v+xPa5l5Q8qAkdmNmhIGzF/c6ON4YqKizWvmSSVgnCpW6BMUeXdMmlTvgnnR2cC0m0Lvc6oiQ0/b5RG5yDSkN1ft6gLGEYiAxff0VpP3ExweN6VqgcQM99MU2992M3SjfvhB48C9Ls3U8RoIF8iP4Num49EslyDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497191; c=relaxed/simple;
	bh=084m8IzzClVCADBlAPHbqwl4RTACVP5TI2Qidxc5oHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MCw/CvhiKguUyY+qUsOBCF4ZId56chVzPe+QtP3hmTygGKOglBaCkURDyLrjpSmKeZogB6cMJL+6Jl7ZRu5+cwMOKFLbv+bfOoHMT69tmGu6M7cabH9nCqZEF2y6cwEYxn2SJ6ys7TGD5vxVs5VGtCGKRi2qmy779PyBbymWdQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blPDI/Mc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blPDI/Mc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E43BC4CEDC;
	Fri,  6 Dec 2024 14:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497191;
	bh=084m8IzzClVCADBlAPHbqwl4RTACVP5TI2Qidxc5oHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blPDI/Mc2t1+qu0r70bcsJHvJuZXr5ydyKyOUuO74xqNvAHy6AlPv7YpxTtFr4m7H
	 J8QzgnMn56Fuhwe12RUTT930myB6bls3xUxPxQXVI2e2PBa1NOvDwpGz7Eyum9dRnu
	 r8tWmXo0z0I4ckih3PlWjzqUuTJNb3Py0YJ5qYOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/676] wifi: wfx: Fix error handling in wfx_core_init()
Date: Fri,  6 Dec 2024 15:30:40 +0100
Message-ID: <20241206143701.971654563@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/wireless/silabs/wfx/main.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wireless/silabs/wfx/main.c
index ede822d771aaf..f2409830d87e3 100644
--- a/drivers/net/wireless/silabs/wfx/main.c
+++ b/drivers/net/wireless/silabs/wfx/main.c
@@ -475,10 +475,23 @@ static int __init wfx_core_init(void)
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



