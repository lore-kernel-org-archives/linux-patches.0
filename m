Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8C44CB5B;
	Sun,  7 Jun 2026 10:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827574; cv=none; b=VuaSRmaUD9IKoSHUPWAALB/vvjzG3EeFnYNtmZPpiDY20z9yKp5XX5SgrCBJ6cLru94JAF7y+puCaDzX/hYlaj/uwTmzXCJOb8Iczia/C6oo5dXhSgeHiTc5wSi4G347LOE1ygRg/CeeXHWPhQ4GXRLpIEmx/4dtwaurRF4m+ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827574; c=relaxed/simple;
	bh=BMqV3H0T7xw6jBJ1CY1u6KNxvZdR8lQS+FmNL5ThFsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VAiBeVnAtu6gZET3ZiAygeBxcTr0NioOjRmJ5txDRi1lztgJLbso5F6ZR6NXylDZpPEeFTCg9WFRR5RtAXOQrZ97cGQWxRYkmXYeFaJ6oozyTCQ73yWxqV54tA6A++AyfLi3VKgM6OJa8gH77Y/n4sPxAh8kRVMxJ2n5PiNBf5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VoiHqIGr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VoiHqIGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D56C1F00893;
	Sun,  7 Jun 2026 10:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827573;
	bh=oMK4hNN/7LoXW1PSk+e/PZtlQKoCVCsdGjc4N8p1ptc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VoiHqIGrZeIRlmuXf/9J5akr7X0bMc9x/5T0DKVmF1AmHliy30uLakI9IczAoBvPh
	 +vCLZXeGEoSr7ZN7ONVkkReI5KMO1JWblf6GVAoFxOzSd7APadl+wdRLhz552dhjgY
	 S4U9chs+P6LipdaT5SKy9z6M3JA/PeDWyzesRWY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 084/315] gpio: adnp: fix flow control regression caused by scoped_guard()
Date: Sun,  7 Jun 2026 11:57:51 +0200
Message-ID: <20260607095730.706093481@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit a5c627d90809b793fc053849b3a00609db305776 ]

scoped_guard() is implemented as a for loop. Using it to protect code
using the continue statement changes the flow as we now only break out
of the hidden loop inside scoped_guard(), not the original for loop. Use
a regular code block instead.

Fixes: c7fe19ed3973 ("gpio: adnp: use lock guards for the I2C lock")
Reported-by: David Lechner <dlechner@baylibre.com>
Closes: https://lore.kernel.org/all/cde2abb2-4cc8-4fc9-b34a-0c5d2b95779f@baylibre.com/
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260522073527.9812-1-bartosz.golaszewski@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-adnp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-adnp.c b/drivers/gpio/gpio-adnp.c
index e5ac2d2110137f..fe5bcaa90496aa 100644
--- a/drivers/gpio/gpio-adnp.c
+++ b/drivers/gpio/gpio-adnp.c
@@ -237,7 +237,9 @@ static irqreturn_t adnp_irq(int irq, void *data)
 		unsigned long pending;
 		int err;
 
-		scoped_guard(mutex, &adnp->i2c_lock) {
+		{
+			guard(mutex)(&adnp->i2c_lock);
+
 			err = adnp_read(adnp, GPIO_PLR(adnp) + i, &level);
 			if (err < 0)
 				continue;
-- 
2.53.0



