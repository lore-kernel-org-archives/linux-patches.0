Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB5C22CBFE;
	Mon,  2 Jun 2025 15:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876868; cv=none; b=BQGq8KU66m1pvNIgj2M0cgLqWWFHUFLZT0IE6CBdvZwf8EApjCSf1MLV01PGT+Tj6mGvI4/QWJIuUXkNjvnIjOZlAeRhNl8x5VookX/gRunIjkdWnbGRoS1/ipS5Yr/8dqnXC8c212vRJEhJU6JBLluXDA931x9wORQ4S6UtvIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876868; c=relaxed/simple;
	bh=mtDXSvJvxNhrbi5gPRDncSWj65coM6ZHGVj2uxikktA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oO/q0aN1jT+VG9MvFlGBYr7B/D5HxAc67qukpwEGufqXjsBUady57/Y6N4CHcWD3BFphBJnxgztQlec+7aEc8BZABnC/X42z82zPRmqX+flFXDiIBKpmw8wP7+2BfGvh7RH/ZGqHhdW9AvbY4hvzfgXKE9Jnc0ngY0nz9VJOA4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vojzxSul; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vojzxSul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0E79C4CEEB;
	Mon,  2 Jun 2025 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876868;
	bh=mtDXSvJvxNhrbi5gPRDncSWj65coM6ZHGVj2uxikktA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vojzxSulfcUowyjJ/mGP804hPggwpxQpi9b0DVaqP8JjoN2jpVbiFP+LqQn+HcKSv
	 yuYIYIrq4W6d3Q/E1ihA4DyBIAn2dgOUN9c9I1gXtzFqwVoIPV/sN7tZTZoEl8vZTb
	 jy1WxJJlvkfqC1Ah4yB0NLOvaJ4aZ3lc5b0IShug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/325] rtc: ds1307: stop disabling alarms on probe
Date: Mon,  2 Jun 2025 15:46:15 +0200
Message-ID: <20250602134323.806222142@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit dcec12617ee61beed928e889607bf37e145bf86b ]

It is a bad practice to disable alarms on probe or remove as this will
prevent alarms across reboots.

Link: https://lore.kernel.org/r/20250303223744.1135672-1-alexandre.belloni@bootlin.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-ds1307.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index d51565bcc1896..b7f8b3f9b0595 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1802,10 +1802,8 @@ static int ds1307_probe(struct i2c_client *client,
 		 * For some variants, be sure alarms can trigger when we're
 		 * running on Vbackup (BBSQI/BBSQW)
 		 */
-		if (want_irq || ds1307_can_wakeup_device) {
+		if (want_irq || ds1307_can_wakeup_device)
 			regs[0] |= DS1337_BIT_INTCN | chip->bbsqi_bit;
-			regs[0] &= ~(DS1337_BIT_A2IE | DS1337_BIT_A1IE);
-		}
 
 		regmap_write(ds1307->regmap, DS1337_REG_CONTROL,
 			     regs[0]);
-- 
2.39.5



