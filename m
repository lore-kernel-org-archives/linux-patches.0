Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F124379E0;
	Sat, 30 Dec 2023 12:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i8XSOuK5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB59C433C7;
	Sat, 30 Dec 2023 12:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937903;
	bh=vsBZ8O8GAcFMJEce/zVcus210et3y/4VA7c57vAK5d0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i8XSOuK5p7t8kHL7+PSn5d/xvw2mrG3/NQyrI0K/kHjS/PUpFoB+uNqNeauV2QSwM
	 5kfji4Ny5I7g5rrOcjXM1uvuaonelg/hIAb91aTH3dHAOp6JoabSNLQvESItkxpuS5
	 EW2N9OaHCB1W98zoDdS3A1B9whhBLwdlqUDx05T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Liu <liuhaoran14@163.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/156] Input: ipaq-micro-keys - add error handling for devm_kmemdup
Date: Sat, 30 Dec 2023 11:58:58 +0000
Message-ID: <20231230115815.108670379@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Haoran Liu <liuhaoran14@163.com>

[ Upstream commit 59b6a747e2d39227ac2325c5e29d6ab3bb070c2a ]

Check the return value of i2c_add_adapter. Static analysis revealed that
the function did not properly handle potential failures of
i2c_add_adapter, which could lead to partial initialization of the I2C
adapter and unstable operation.

Signed-off-by: Haoran Liu <liuhaoran14@163.com>
Link: https://lore.kernel.org/r/20231203164653.38983-1-liuhaoran14@163.com
Fixes: d7535ffa427b ("Input: driver for microcontroller keys on the iPaq h3xxx")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/keyboard/ipaq-micro-keys.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/keyboard/ipaq-micro-keys.c b/drivers/input/keyboard/ipaq-micro-keys.c
index 7b509bce2b332..1d71dd79ffd28 100644
--- a/drivers/input/keyboard/ipaq-micro-keys.c
+++ b/drivers/input/keyboard/ipaq-micro-keys.c
@@ -105,6 +105,9 @@ static int micro_key_probe(struct platform_device *pdev)
 	keys->codes = devm_kmemdup(&pdev->dev, micro_keycodes,
 			   keys->input->keycodesize * keys->input->keycodemax,
 			   GFP_KERNEL);
+	if (!keys->codes)
+		return -ENOMEM;
+
 	keys->input->keycode = keys->codes;
 
 	__set_bit(EV_KEY, keys->input->evbit);
-- 
2.43.0



