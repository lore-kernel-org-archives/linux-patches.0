Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9BD6FAF;
	Tue,  5 Dec 2023 03:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHY0PmMH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEEDDC433C8;
	Tue,  5 Dec 2023 03:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746695;
	bh=njU3GXIGQ5ja2b28MDazjM9qFvk/k9pOb/zLcWpqtv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GHY0PmMHQfMiK5LnAeRpulNPnbVDa+C6SUalxWpAEJbyAYlV5BVRE9ct2653jsArV
	 +MhL1oBCvVBJOC+4jys40/dXDNssrAdPwdMGqfHQY6NXm2wWxrG7kpWN0iwttnQjnm
	 PRRJCiYm4aw4gvFb9DQR1LsfnLtJIyBhzvYnE+9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/134] drm/panel: nt36523: fix return value check in nt36523_probe()
Date: Tue,  5 Dec 2023 12:16:34 +0900
Message-ID: <20231205031543.192100653@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fb18fe0fdf22a2f4512a8b644bb5ea1473829cda ]

mipi_dsi_device_register_full() never returns NULL pointer, it
will return ERR_PTR() when it fails, so replace the check with
IS_ERR().

Fixes: 0993234a0045 ("drm/panel: Add driver for Novatek NT36523")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231129090715.856263-1-yangyingliang@huaweicloud.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20231129090715.856263-1-yangyingliang@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-novatek-nt36523.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-novatek-nt36523.c b/drivers/gpu/drm/panel/panel-novatek-nt36523.c
index 9632b9e95b715..c4a804c5d6aac 100644
--- a/drivers/gpu/drm/panel/panel-novatek-nt36523.c
+++ b/drivers/gpu/drm/panel/panel-novatek-nt36523.c
@@ -1266,9 +1266,9 @@ static int nt36523_probe(struct mipi_dsi_device *dsi)
 			return dev_err_probe(dev, -EPROBE_DEFER, "cannot get secondary DSI host\n");
 
 		pinfo->dsi[1] = mipi_dsi_device_register_full(dsi1_host, info);
-		if (!pinfo->dsi[1]) {
+		if (IS_ERR(pinfo->dsi[1])) {
 			dev_err(dev, "cannot get secondary DSI device\n");
-			return -ENODEV;
+			return PTR_ERR(pinfo->dsi[1]);
 		}
 	}
 
-- 
2.42.0



