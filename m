Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FD815FB21;
	Mon, 29 Jan 2024 17:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548309; cv=none; b=GKhYFx90JFBKdFWxY/Qasc0rxjb0ModB6q/UVp5KmzWmXc4UyymjLTeA6sHGF56UmAy/2m5Pn2RpJmMYVQ7647YQ7SmsaPvofJIC02oR/Ru7YlHsV+byItVd9jNnalbktNLD2S9CbZQ7qUWG5MeBN2Ex9qQFn3NejNlAfPQZzKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548309; c=relaxed/simple;
	bh=Kw345+PTE0wUUEuSO08Y4GjYIp8WDKqYfPb9xpZIyn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XVxS/BB2Fd3bf5PIHjvmB8X9x+3thw+sx/4LzrfM/jOGkAjw37/RHywTZynj1Nw0m9pqkki/TrZzYPu7t8CrGqxMBliBms+xsLyr1xOggDAHUcWpFVBV28kFBwPQsBthJ1DS2Qpb7fUpbmiO7pNwU0/aAwrf1w9j9lZ5pxcrb/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9SjQFXJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9SjQFXJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAF9C43394;
	Mon, 29 Jan 2024 17:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548309;
	bh=Kw345+PTE0wUUEuSO08Y4GjYIp8WDKqYfPb9xpZIyn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N9SjQFXJZN8OGTgJ6yWoRug+DAKjNLmDyqvR5goVAMmyaxOgLyl3EjCg/SlKeeT6j
	 r51dSScDshuOPeDhz6MsJPD4Ve07L58Ea6ahG5fnt2m3c8xYBW0n0cQkqe5I0W7ySY
	 LKpXYM2KQZuaIzJASUUe0mpOcOZZo+3ZvOMwop4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.1 059/185] serial: sc16is7xx: remove wasteful static buffer in sc16is7xx_regmap_name()
Date: Mon, 29 Jan 2024 09:04:19 -0800
Message-ID: <20240129170000.503450377@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit 6bcab3c8acc88e265c570dea969fd04f137c8a4c upstream.

Using a static buffer inside sc16is7xx_regmap_name() was a convenient and
simple way to set the regmap name without having to allocate and free a
buffer each time it is called. The drawback is that the static buffer
wastes memory for nothing once regmap is fully initialized.

Remove static buffer and use constant strings instead.

This also avoids a truncation warning when using "%d" or "%u" in snprintf
which was flagged by kernel test robot.

Fixes: 3837a0379533 ("serial: sc16is7xx: improve regmap debugfs by using one regmap per port")
Cc:  <stable@vger.kernel.org> # 6.1.x: 3837a03 serial: sc16is7xx: improve regmap debugfs by using one regmap per port
Suggested-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20231211171353.2901416-2-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1698,13 +1698,15 @@ static struct regmap_config regcfg = {
 	.max_register = SC16IS7XX_EFCR_REG,
 };
 
-static const char *sc16is7xx_regmap_name(unsigned int port_id)
+static const char *sc16is7xx_regmap_name(u8 port_id)
 {
-	static char buf[6];
-
-	snprintf(buf, sizeof(buf), "port%d", port_id);
-
-	return buf;
+	switch (port_id) {
+	case 0:	return "port0";
+	case 1:	return "port1";
+	default:
+		WARN_ON(true);
+		return NULL;
+	}
 }
 
 static unsigned int sc16is7xx_regmap_port_mask(unsigned int port_id)


