Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5153230DD29;
	Mon, 13 Oct 2025 14:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367380; cv=none; b=Gc6dPROK0sAimxN1kU3FdK8Cw5w7rOkhT52LqtgYekK7kyWpW1gJB1AnWzBWTGGjsubRAe9Vwi2aFLi2SwFmMPZZ20JJsbcZXiv2atKonse2farswOB6un41hlKgnVLqiluT2rgmlQKqFKzn2aO3Xon+Q2UquqsZXZqfKdojM4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367380; c=relaxed/simple;
	bh=BRF2YHbp493wZiUm9YBlo2WGrd9qDyWaAVCnnHN2Oi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ootOImWmVQmpmot5qx7fa8L0FpcNF5Bd2+eDUEk7fgDPJ1gnc0AZDE8LumWmE3IwSZbbLeCwNs6mEopli4mGyq4dcMwZAZEVKfcSXU9nMBx7aDrvJSThac9koO+7Z0VKkrXN3FCe44dUlFax39s+MZ/mmL2BRhySv9XtWF3RUIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MZbzm4Ha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MZbzm4Ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F3CC19421;
	Mon, 13 Oct 2025 14:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367380;
	bh=BRF2YHbp493wZiUm9YBlo2WGrd9qDyWaAVCnnHN2Oi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MZbzm4Har45tQaePjeGKpQVnYbWaUunqXdUAveFxdA8dJP9L2jQvODhXZD17bzWHm
	 YE5H8PP1oDJCxkvAsegG7v1qD1nBoPfkZ5HO499IQI1zd2qJHBDwtNbW9+ZK/lIq2y
	 9hkH8HhnrgITqxcny39ChkZKiwsJo0XbXm7pcWy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut@mailbox.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 187/196] Input: atmel_mxt_ts - allow reset GPIO to sleep
Date: Mon, 13 Oct 2025 16:46:00 +0200
Message-ID: <20251013144321.457071392@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3239,7 +3239,7 @@ static int mxt_probe(struct i2c_client *
 	if (data->reset_gpio) {
 		/* Wait a while and then de-assert the RESET GPIO line */
 		msleep(MXT_RESET_GPIO_TIME);
-		gpiod_set_value(data->reset_gpio, 0);
+		gpiod_set_value_cansleep(data->reset_gpio, 0);
 		msleep(MXT_RESET_INVALID_CHG);
 	}
 


