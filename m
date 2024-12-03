Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD761F7060;
	Tue,  3 Dec 2024 15:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240966; cv=none; b=RKnd3uA/Sm2/cXNLWanBsbqpQ2N5Uol961ZtyJoNhD495xbc4LtDEzU9LvGyvnq75/+ZC2bZ8KOX32QWYfQcqrzNP8AhHPrnuIZ2q7wGm6cTTWNYF7bFVr1ZankWGifZm2zQveXTVGLNLn5AHYhPrxsGZ1YYST52QZDcNRLi9JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240966; c=relaxed/simple;
	bh=icUcQMO5YuqYrzWLAkKjF+eTe+GBzNn/wwfG/+o+AeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=We5DEsrhpFO8m5SjyNA3aYCUXKf/YktqF4w6rPsBKDgdN5YoZNwaI7yiWiyMyL4yuvMSJg0Pc50HlmpiMztGYh/WMdEgwWkNk1BeWUpTQv+BB81sB79xCniAZID4pnIa9CTsDeluktK7S7kWmtidB2mJcoSCyj+mhvNpt5s6q2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gi+E90dx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gi+E90dx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DDCC4CED8;
	Tue,  3 Dec 2024 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240966;
	bh=icUcQMO5YuqYrzWLAkKjF+eTe+GBzNn/wwfG/+o+AeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gi+E90dx4btn2Zu74JhDJhTfm3bfmgWXGKEcpF7klPtam7tOeOrB/kIR8EpMO8HN8
	 JNJ3t/J6lc6ntNuRRtlSVUYyL2JAsqN48tn6lERqJeJMObnnNd7Hvc11RSqennEzPi
	 OzpQCdTOe8vcPDg++NyiDCj7KivCeU6Zk3fBrWaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	=?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= <jerome.pouiller@silabs.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 288/826] wifi: wfx: Fix error handling in wfx_core_init()
Date: Tue,  3 Dec 2024 15:40:15 +0100
Message-ID: <20241203144755.004225331@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e7198520bdffc..64441c8bc4606 100644
--- a/drivers/net/wireless/silabs/wfx/main.c
+++ b/drivers/net/wireless/silabs/wfx/main.c
@@ -480,10 +480,23 @@ static int __init wfx_core_init(void)
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



