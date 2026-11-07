Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062975;
	b=e3wkiI3pfSTMuj3wGR/fZoXzmWEiovaN08ZqGLUh0EjjtEWlGSfiHFQkKf9Ttu+2NWmA
	 kh6oJiBmWEMJQk6CSguLl1TM3/VFTOT8W2d0BNW5EYQ6Qmy7QelNowQQ27ANVF1+ouce/
	 RG0QipU6SwkeaGpiC6B0O3toOrCQ4SlzA8nFJjfBiHmSvoUbuMCxV2iFABUZ2Asf1WgHc
	 2MTm+3n7uEY2RDEEiL5QzVnnPvUcJJHtumLpTNVx1yS6Fv/ljbtxpL2PmBsTpZwZm1UWw
	 4sJTkAvueezUoV/RKkq5trZsU1SVW8xX2JEEVpAggnLjwV0pbP8epKITN6C+3/X5Njw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062975;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5aluARpS56yiSGi2EE1fq8mV6PBaHfTtVigx6pSr3Qw=;
	b=PN1/N8a7sv1A7YN8JQwPp42u4usX0jrurUxeH+d00vfAc08mJ/U/7O79GFnplvQLTX9V
	 btHls9ndlCuteisutqyqcdvKf0R2zVAdQEM7fevjtkqU5dEFMyU7XHZxN/VMvc5pYc4E8
	 GFhamzHxAqahUOeL1I8KUYL7tnfUMBuT0OVF4rnIvAL97MHe0rMegBsQ8oIuV9y7Km1/1
	 3mAXhvMTyRsPDTbJhcQInJMqtbq1Ue1XJMNENibO3UcLZtHndk7AMYhUQD9wM2K3hSXnM
	 JGpsKRRLAbBEllQZU628HlR9twotPeLZQWWtaJ54rW+kYhBBjMGRS7gzPrdzdU/LlXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NFTyZ/Q/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE32606A32C;
	Sat,  7 Nov 2026 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NFTyZ/Q/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CEE1F0089F;
	Sat,  7 Nov 2026 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062974;
	bh=5aluARpS56yiSGi2EE1fq8mV6PBaHfTtVigx6pSr3Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFTyZ/Q/khsSqprsDzql0m4L1N++GGYj/GG9qZX2rOJVHs48PANHBXbYFbnPXL9uE
	 ciUFyOLJY9Blyyt9xYfbqSXjg4mrJL5eolkWiFFqLEAes3euAayve8mcKPFUGy5nfb
	 HyP85l0nK+TlNFUOcnzhGcKqsDWorCfMknB+8Zow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Hongyan Xu <getshell@seu.edu.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 228/869] mfd: da903x: Cancel IRQ work during teardown
Date: Sat,  7 Nov 2026 08:48:30 -0500
Message-ID: <20261107134859.589784710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit fd2258999ecdc7164ef0cda2d4102e4558a5660f ]

The IRQ handler disables the IRQ and schedules irq_work. Releasing the
IRQ does not drain that work, which can continue to use the devm-allocated
chip and notifier state.

Manage both IRQ-work cancellation and subdevice removal with devres.
Register the subdevice-removal action before requesting the IRQ, then add
the IRQ-work action after the request. This avoids leaving a live IRQ
without work cancellation if action registration fails. Devres cleanup
then disables the IRQ and drains the work before releasing the IRQ and
removing child devices. Register both actions before creating the children
so partial probe failures use the same ordering.

This issue was found by the author's in-house static analysis tool.
The patch was reviewed by the author against the latest mainline tree.

Fixes: 26b8f5e1e2d1 ("mfd: add base support for Dialog DA9030/DA9034 PMICs")
Cc: stable@vger.kernel.org
Suggested-by: Lee Jones <lee@kernel.org>
Assisted-by: Codex:GPT-5
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Link: https://patch.msgid.link/20260814153019.1114-1-getshell@seu.edu.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/da903x.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/da903x.c b/drivers/mfd/da903x.c
index e86b39de3303a..e4ad48e1f139b 100644
--- a/drivers/mfd/da903x.c
+++ b/drivers/mfd/da903x.c
@@ -421,6 +421,14 @@ static irqreturn_t da903x_irq_handler(int irq, void *data)
 	return IRQ_HANDLED;
 }
 
+static void da903x_cancel_irq_work(void *data)
+{
+	struct da903x_chip *chip = data;
+
+	disable_irq(chip->client->irq);
+	cancel_work_sync(&chip->irq_work);
+}
+
 static const struct da903x_chip_ops da903x_ops[] = {
 	[0] = {
 		.init_chip	= da9030_init_chip,
@@ -456,6 +464,13 @@ static int da903x_remove_subdevs(struct da903x_chip *chip)
 	return device_for_each_child(chip->dev, NULL, __remove_subdev);
 }
 
+static void da903x_remove_subdevs_action(void *data)
+{
+	struct da903x_chip *chip = data;
+
+	da903x_remove_subdevs(chip);
+}
+
 static int da903x_add_subdevs(struct da903x_chip *chip,
 					struct da903x_platform_data *pdata)
 {
@@ -484,7 +499,6 @@ static int da903x_add_subdevs(struct da903x_chip *chip,
 	return 0;
 
 failed:
-	da903x_remove_subdevs(chip);
 	return ret;
 }
 
@@ -520,6 +534,11 @@ static int da903x_probe(struct i2c_client *client)
 	chip->ops->mask_events(chip, chip->events_mask);
 	chip->ops->read_events(chip, &tmp);
 
+	ret = devm_add_action_or_reset(&client->dev,
+				       da903x_remove_subdevs_action, chip);
+	if (ret)
+		return ret;
+
 	ret = devm_request_irq(&client->dev, client->irq, da903x_irq_handler,
 			IRQF_TRIGGER_FALLING,
 			"da903x", chip);
@@ -529,14 +548,12 @@ static int da903x_probe(struct i2c_client *client)
 		return ret;
 	}
 
-	return da903x_add_subdevs(chip, pdata);
-}
-
-static void da903x_remove(struct i2c_client *client)
-{
-	struct da903x_chip *chip = i2c_get_clientdata(client);
+	ret = devm_add_action_or_reset(&client->dev, da903x_cancel_irq_work,
+				       chip);
+	if (ret)
+		return ret;
 
-	da903x_remove_subdevs(chip);
+	return da903x_add_subdevs(chip, pdata);
 }
 
 static struct i2c_driver da903x_driver = {
@@ -544,7 +561,6 @@ static struct i2c_driver da903x_driver = {
 		.name	= "da903x",
 	},
 	.probe		= da903x_probe,
-	.remove		= da903x_remove,
 	.id_table	= da903x_id_table,
 };
 
-- 
2.53.0



