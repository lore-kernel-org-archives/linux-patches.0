Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B7DFC1B
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:47:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262DEC433D2;
	Mon, 15 May 2023 17:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172836;
	bh=8E8uH+tayCkP/JNoEemaa8uU+tXfPd3bERWLmW8TZIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tcAvQpu87HbTCJChbFWI6CCydJSIPtLHH3wXwfRgFCsDr8VwAqwTJ3gp7Eni0SvyY
	 xdvMfJfcfutASzULKJZNYnYxVF+3VJrvbyDicH8YC0+1XJHHLk8tCSJrAleiWdU7Kb
	 879a5zPBq8rHNPYgS4P038Z2HN6MGqG6XN1XMrM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Mattijs Korpershoek <mkorpershoek@baylibre.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/381] Input: raspberrypi-ts - fix refcount leak in rpi_ts_probe
Date: Mon, 15 May 2023 18:28:26 +0200
Message-Id: <20230515161748.239883638@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 5bca3688bdbc3b58a2894b8671a8e2378efe28bd ]

rpi_firmware_get() take reference, we need to release it in error paths
as well. Use devm_rpi_firmware_get() helper to handling the resources.
Also remove the existing rpi_firmware_put().

Fixes: 0b9f28fed3f7 ("Input: add official Raspberry Pi's touchscreen driver")
Fixes: 3b8ddff780b7 ("input: raspberrypi-ts: Release firmware handle when not needed")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Link: https://lore.kernel.org/r/20221223074657.810346-1-linmq006@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/raspberrypi-ts.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/raspberrypi-ts.c b/drivers/input/touchscreen/raspberrypi-ts.c
index 5000f5fd9ec38..45c575df994e0 100644
--- a/drivers/input/touchscreen/raspberrypi-ts.c
+++ b/drivers/input/touchscreen/raspberrypi-ts.c
@@ -134,7 +134,7 @@ static int rpi_ts_probe(struct platform_device *pdev)
 		return -ENOENT;
 	}
 
-	fw = rpi_firmware_get(fw_node);
+	fw = devm_rpi_firmware_get(&pdev->dev, fw_node);
 	of_node_put(fw_node);
 	if (!fw)
 		return -EPROBE_DEFER;
@@ -160,7 +160,6 @@ static int rpi_ts_probe(struct platform_device *pdev)
 	touchbuf = (u32)ts->fw_regs_phys;
 	error = rpi_firmware_property(fw, RPI_FIRMWARE_FRAMEBUFFER_SET_TOUCHBUF,
 				      &touchbuf, sizeof(touchbuf));
-	rpi_firmware_put(fw);
 	if (error || touchbuf != 0) {
 		dev_warn(dev, "Failed to set touchbuf, %d\n", error);
 		return error;
-- 
2.39.2



