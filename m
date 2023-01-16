Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05B733EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:57:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 278D5C433EF;
	Mon, 16 Jan 2023 15:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884678;
	bh=dV3T2K0wm/vcbInio0P0c+0afNHzeJwUEaiboLCpBb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/juXQP5tHzdMKP30DD2MlQ/rqqeW829IcYjYmf/g07fvSSFhG3dmNkOuuwbPLp/M
	 1VPksO+n9yy30D052NmCkuVlLz6Ms8D7VfuJG7GRo+HFMAWabCIJgzXYtJpSJ6eKk7
	 o8H9EbDq3XUfvCTr7a6sQFSkRRhCf5ZKttOUvdhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/183] regulator: da9211: Use irq handler when ready
Date: Mon, 16 Jan 2023 16:50:20 +0100
Message-Id: <20230116154807.508332193@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 02228f6aa6a64d588bc31e3267d05ff184d772eb ]

If the system does not come from reset (like when it is kexec()), the
regulator might have an IRQ waiting for us.

If we enable the IRQ handler before its structures are ready, we crash.

This patch fixes:

[    1.141839] Unable to handle kernel read from unreadable memory at virtual address 0000000000000078
[    1.316096] Call trace:
[    1.316101]  blocking_notifier_call_chain+0x20/0xa8
[    1.322757] cpu cpu0: dummy supplies not allowed for exclusive requests
[    1.327823]  regulator_notifier_call_chain+0x1c/0x2c
[    1.327825]  da9211_irq_handler+0x68/0xf8
[    1.327829]  irq_thread+0x11c/0x234
[    1.327833]  kthread+0x13c/0x154

Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Adam Ward <DLG-Adam.Ward.opensource@dm.renesas.com>
Link: https://lore.kernel.org/r/20221124-da9211-v2-0-1779e3c5d491@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9211-regulator.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/da9211-regulator.c b/drivers/regulator/da9211-regulator.c
index e01b32d1fa17..00828f5baa97 100644
--- a/drivers/regulator/da9211-regulator.c
+++ b/drivers/regulator/da9211-regulator.c
@@ -498,6 +498,12 @@ static int da9211_i2c_probe(struct i2c_client *i2c)
 
 	chip->chip_irq = i2c->irq;
 
+	ret = da9211_regulator_init(chip);
+	if (ret < 0) {
+		dev_err(chip->dev, "Failed to initialize regulator: %d\n", ret);
+		return ret;
+	}
+
 	if (chip->chip_irq != 0) {
 		ret = devm_request_threaded_irq(chip->dev, chip->chip_irq, NULL,
 					da9211_irq_handler,
@@ -512,11 +518,6 @@ static int da9211_i2c_probe(struct i2c_client *i2c)
 		dev_warn(chip->dev, "No IRQ configured\n");
 	}
 
-	ret = da9211_regulator_init(chip);
-
-	if (ret < 0)
-		dev_err(chip->dev, "Failed to initialize regulator: %d\n", ret);
-
 	return ret;
 }
 
-- 
2.35.1



