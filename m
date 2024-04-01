Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F86043AD6;
	Mon,  1 Apr 2024 16:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987963; cv=none; b=t1fo1gi7Fwpp+U1bFESt/5QF4wLXmka40yloXCDfTbIOfDEsqnM5QWey8lIBbehn9YLrbduO28ycykZTUSIrmrB6+kQCFUfn4yGL/X52x6UOCx5AVE20ShJsKKAStX174t4xC/AUSEN36OKZxklSCc4158C/IOjqT2YSH56GQVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987963; c=relaxed/simple;
	bh=HEe0Vsu0JcGek7mxpPeug0O5epmx7CSs5ZsnC5V+shk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=legsqG+YlFPKPbwbdBILfE7x7/3u6braZx1KY8V/WB/aRHmUsuk/a1wWj8T4+xEDZTj+NT8gC8xLLvtBmPJr7IhX0eVV6QN8ngZGgh0fvV21z8vC3wA7NRjyXw6EdpJ1UUa5jpfJ5lxhdd3cQ32aKwmAjEP8qyVlba6f6/qyQ+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVrdwNh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVrdwNh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA366C433F1;
	Mon,  1 Apr 2024 16:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987963;
	bh=HEe0Vsu0JcGek7mxpPeug0O5epmx7CSs5ZsnC5V+shk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVrdwNh2gIAsvDogQkkh9MPv4QsU+zlBDfVXbEONEvr0xJc8OIKAam+Q96G1GO/1m
	 2otJiqwf4U1MIXMhCkrRC89YAjxNmCZnvxHkJzmRI8/RAF3FRIDuENVowfm//X/ViG
	 2NFxvkZEdzlP9IhFUuWP4GOJg2BmHLnW99b/eEJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 015/432] serial: max310x: fix NULL pointer dereference in I2C instantiation
Date: Mon,  1 Apr 2024 17:40:02 +0200
Message-ID: <20240401152553.582817440@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 0d27056c24efd3d63a03f3edfbcfc4827086b110 ]

When trying to instantiate a max14830 device from userspace:

    echo max14830 0x60 > /sys/bus/i2c/devices/i2c-2/new_device

we get the following error:

    Unable to handle kernel NULL pointer dereference at virtual address...
    ...
    Call trace:
        max310x_i2c_probe+0x48/0x170 [max310x]
        i2c_device_probe+0x150/0x2a0
    ...

Add check for validity of devtype to prevent the error, and abort probe
with a meaningful error message.

Fixes: 2e1f2d9a9bdb ("serial: max310x: implement I2C support")
Cc: stable@vger.kernel.org
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240118152213.2644269-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/max310x.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/max310x.c b/drivers/tty/serial/max310x.c
index 5aff179bf2978..1a4bb55652afa 100644
--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -1635,13 +1635,16 @@ static unsigned short max310x_i2c_slave_addr(unsigned short addr,
 
 static int max310x_i2c_probe(struct i2c_client *client)
 {
-	const struct max310x_devtype *devtype =
-			device_get_match_data(&client->dev);
+	const struct max310x_devtype *devtype;
 	struct i2c_client *port_client;
 	struct regmap *regmaps[4];
 	unsigned int i;
 	u8 port_addr;
 
+	devtype = device_get_match_data(&client->dev);
+	if (!devtype)
+		return dev_err_probe(&client->dev, -ENODEV, "Failed to match device\n");
+
 	if (client->addr < devtype->slave_addr.min ||
 		client->addr > devtype->slave_addr.max)
 		return dev_err_probe(&client->dev, -EINVAL,
-- 
2.43.0



