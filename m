Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E8D403B1B;
	Wed, 30 Sep 2026 19:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796973; cv=none; b=b4oSehS3yESoVuP8KEPnffAc3TusKvUqr8RBzSydMh7WouHQEjahonSMyYj5Wk99mKmvfdhOrg+b+LCHcuL+VMCrueOhWexfLZmUmqy/4oZ6CmuL3djp/GDS35uxxcNitspxuf5y7HDPOekA1snix12QWB60lyyEIb4N5Ao8Z3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796973; c=relaxed/simple;
	bh=1oozQrQdrwL9BYjbjWWt3oE3d1JdRtjWBDwY1vwuwbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHxiSLzCIPGjOb77PbNh2xQroVAraQfjoAADZ/EHMqFe0TPReLKM5LpjG7X2dB2SMa8Ap9BHWDCxdsuZHqLEno2+sAvrA+uJ+cnEY/CohHgZ7c2gyB1kt+mSDN7FL9kHqKU3zoWoX3JhbALB7KvHTY+PouVSVIb/GFOp/s6YrIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kny7zx6W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kny7zx6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6A41F000FF;
	Wed, 30 Sep 2026 19:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796972;
	bh=lw0KRYy/mmpAKsbG5q9i9PrE9H9dzuAOJb4OPfAyB0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kny7zx6WurTAG4IV0JH3h8all2+0mrap34XjWsT68uBFe1qB7aUIg1CxHcZQYa2XR
	 j75C4t27nWhA2RODPmDxXZZ7wsj/2whDExezjT8Qf5k+ZQi/H9UpxDygu3VsB9TELt
	 ViPnji0VWwVQc8J7JmX97QXjH8bayc8eDtR3eVvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.6 1103/1193] gpio: arizona: Fix runtime PM leak in arizona_gpio_direction_out()
Date: Wed, 30 Sep 2026 17:29:47 +0200
Message-ID: <20260930152458.739550727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -117,8 +117,12 @@ static int arizona_gpio_direction_out(st
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


