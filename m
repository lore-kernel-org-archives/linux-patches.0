Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A3730FC10;
	Mon, 13 Oct 2025 15:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367941; cv=none; b=D9RCGW1ck8YZ2jUJenQ5BdREUB69AsBKUsvw/dfdPdShxiMHH4yAv8yJRAWXbi2duFaB0g7iVHzY2OOP729I4JXp7bbHNzlfC+D8oYoUlL6aAUYne+vKeAshddkmznbwPvySL3TJFZk11CPJQbFR34drWTYs6FLPz83p1IzktBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367941; c=relaxed/simple;
	bh=0V0xMzXaVvXekCX6NWKY3J8uXk5AIAkISogZwryd4Fc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mj/cXKOFr5XxpK4WY4Om3OLZqhwqxaxNRU70TzG3PfSYuL1sF5x7MucEzuDoKQmn0bEzyJVv1Xv2DoT5PPBwsR78EjGWpUc3LrvbuzE10dRUVrTjUfoGARv+vq3djpqyj1OHW46OLBbNQm4ChW2v93oaayK4hgHxJYGUZz2aQd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhk3hVhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhk3hVhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BFA5C4CEE7;
	Mon, 13 Oct 2025 15:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367941;
	bh=0V0xMzXaVvXekCX6NWKY3J8uXk5AIAkISogZwryd4Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhk3hVhPFEZNJmIWjtpdjvumfxcNoRV5Fe/rM8Ysljj1epXkjfq1yV6SuK9lthmyQ
	 4PubLK8jgX7dC/j9yAe64xg19Qjbzikmv0a2Kjvm4RBDXvb5JoraOa4gkc/rmOKM5R
	 gjKJmBiBlptwBMjVD3LiiCWPMXZbndD06WLQNTu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 187/196] Input: atmel_mxt_ts - allow reset GPIO to sleep
Date: Mon, 13 Oct 2025 16:46:18 +0200
Message-ID: <20251013144322.072132633@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut@mailbox.org>

commit c7866ee0a9ddd9789faadf58cdac6abd7aabf045 upstream.

The reset GPIO is not toggled in any critical section where it couldn't
sleep, allow the reset GPIO to sleep. This allows the driver to operate
reset GPIOs connected to I2C GPIO expanders.

Signed-off-by: Marek Vasut <marek.vasut@mailbox.org>
Link: https://lore.kernel.org/r/20251005023335.166483-1-marek.vasut@mailbox.org
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/atmel_mxt_ts.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -3324,7 +3324,7 @@ static int mxt_probe(struct i2c_client *
 	if (data->reset_gpio) {
 		/* Wait a while and then de-assert the RESET GPIO line */
 		msleep(MXT_RESET_GPIO_TIME);
-		gpiod_set_value(data->reset_gpio, 0);
+		gpiod_set_value_cansleep(data->reset_gpio, 0);
 		msleep(MXT_RESET_INVALID_CHG);
 	}
 


