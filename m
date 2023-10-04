Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE281D6B0
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYzcZqbF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3128FC433C9;
	Wed,  4 Oct 2023 18:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444038;
	bh=QenUVkLac7uqXtCdafclVFbN2LShplMcuWcJG+o2icw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYzcZqbFDv1yHZtvPfhBoevAMXR/1Tzehnl1g/iqiYeLLeA3crvY8jJtk36Pc4rAC
	 AmLbH2IRhztis0YCjNssOUg9ZUNngt799qnA1CFRYtli9HAFvuZcglVk7PwU9Aocmh
	 3PCGgScRHZ/fHy93ukXU3MriLcypsfS0UxogWKU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoke Wang <xkernel.wang@foxmail.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 108/321] i2c: mux: demux-pinctrl: check the return value of devm_kstrdup()
Date: Wed,  4 Oct 2023 19:54:13 +0200
Message-ID: <20231004175234.247373017@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit 7c0195fa9a9e263df204963f88a22b21688ffb66 ]

devm_kstrdup() returns pointer to allocated string on success,
NULL on failure. So it is better to check the return value of it.

Fixes: e35478eac030 ("i2c: mux: demux-pinctrl: run properly with multiple instances")
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-demux-pinctrl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/muxes/i2c-demux-pinctrl.c b/drivers/i2c/muxes/i2c-demux-pinctrl.c
index a3a122fae71e0..22f2280eab7f7 100644
--- a/drivers/i2c/muxes/i2c-demux-pinctrl.c
+++ b/drivers/i2c/muxes/i2c-demux-pinctrl.c
@@ -243,6 +243,10 @@ static int i2c_demux_pinctrl_probe(struct platform_device *pdev)
 
 		props[i].name = devm_kstrdup(&pdev->dev, "status", GFP_KERNEL);
 		props[i].value = devm_kstrdup(&pdev->dev, "ok", GFP_KERNEL);
+		if (!props[i].name || !props[i].value) {
+			err = -ENOMEM;
+			goto err_rollback;
+		}
 		props[i].length = 3;
 
 		of_changeset_init(&priv->chan[i].chgset);
-- 
2.40.1



