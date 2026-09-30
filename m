Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A40A37CD22;
	Wed, 30 Sep 2026 15:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783896; cv=none; b=h48H0E6iy9mt/3wXzlZMTgd2HSbjDhj7b2aOnRd+s1/3UNBf4P6O4iys1qznYYfLYSc7eK5pEhpVzGOE8MOfS1DgCXpuui6UJH8Fg7G4NtKldYQHx+ZTeKsiJz7RDShsY8btzmByPMQagus5aDl7WhhF4/cJ/0VSG51B1fOovhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783896; c=relaxed/simple;
	bh=RstorgmMtELk9IVXdB+7bXKW1NfrWQB7KzuKtFjbnJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SzK2nDe85eU3T0X3pN2wSjPL/Cnn4/7OXg2MIpBy+oLbYpN3KaxfT7A35fsL99LB+T463nZxRtiPncyznAhWj0m/7vEZuzxFzpCRV9uTp8DvBGRpbvV3W3D0NLI5GDx2G6ysqRG8uEA9TsDQAtE/0P+C0oc6EtCXhRuoE1MdxUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wbt3Pj/0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wbt3Pj/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB4871F00893;
	Wed, 30 Sep 2026 15:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783892;
	bh=TV75a+wkwYCrfOpmOGk3bWB7Hn2qwjGJcoAMoMJkWAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wbt3Pj/0r0rA5Tb+pQftdN0yJwomDoDrbsS9AbYkVt8quDOL963+Ct3r0/md6zOyd
	 hDuTBJR2S8xcevjnbx1osX9sSac6yFSmk1+WrK50u2p9ZgRrtC5drMf85Af7pc+WSU
	 TPYVum6bWTG724kz68km1fVHVgqrEOw6Mf7WifiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 5.10 560/595] gpio: arizona: Fix runtime PM leak in arizona_gpio_direction_out()
Date: Wed, 30 Sep 2026 17:27:33 +0200
Message-ID: <20260930152359.766189336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit e9d810279f84b30738f7790c0ed15f8dd5b9024a upstream.

Switching a persistent GPIO line from input to output acquires a
runtime PM reference on the parent device, but if the subsequent
regmap_update_bits() fails the reference is never dropped and no later
direction_in() can balance it since the direction was never changed.
Drop the reference on the update failure path.

Fixes: 27a49ed17e22 ("gpio: arizona: Add support for GPIOs that need to be maintained")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260916094701.2007509-1-vulab@iscas.ac.cn
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-arizona.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpio-arizona.c
+++ b/drivers/gpio/gpio-arizona.c
@@ -118,8 +118,12 @@ static int arizona_gpio_direction_out(st
 	if (value)
 		value = ARIZONA_GPN_LVL;
 
-	return regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
-				  ARIZONA_GPN_DIR | ARIZONA_GPN_LVL, value);
+	ret = regmap_update_bits(arizona->regmap, ARIZONA_GPIO1_CTRL + offset,
+				 ARIZONA_GPN_DIR | ARIZONA_GPN_LVL, value);
+	if (ret < 0 && (val & ARIZONA_GPN_DIR) && persistent)
+		pm_runtime_put_autosuspend(chip->parent);
+
+	return ret;
 }
 
 static void arizona_gpio_set(struct gpio_chip *chip, unsigned offset, int value)


