Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DDA17BBF;
	Mon,  2 Jun 2025 14:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876076; cv=none; b=Xf/5aVPJ5yhVnFdYuovicphZK7Qm48NTFuuA3RsJlWaqWla4HrH8G2SDtBOmFRlqHl3btfO7HERY9S1/zfR2CH7Qg6zEu3AimTYgcBxkz74aQvD5lkM0JCV8DzmR0VRPFxbZxHCl1XvuG35N2+peC2DKm0rT8Zi2xFJ7ajKayj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876076; c=relaxed/simple;
	bh=BmBHhTneHEx7z6vCgj1q6+YnJ2epAHUtYG++9CnBAIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/9OoaaKKrbctnXcQ9tUFrheRkZL61maS8hRbQwu/tzkVN3goUBX+/Pj3FUpcreFGB7cqcRlvp/+e9+FfKSlCvw74iIPl2R47jLKPRBWH2ElQXsRzBA2fnlowfE1xvxV61+8diqzMh8nZyeakvKdYlMVGGHwpUqm+mYmfYbJ/Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyRE/kUI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyRE/kUI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08067C4CEEB;
	Mon,  2 Jun 2025 14:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876075;
	bh=BmBHhTneHEx7z6vCgj1q6+YnJ2epAHUtYG++9CnBAIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyRE/kUIyiv1ZsHFy71OdiE4QUgxt5v9UwfSbouQKzKogBl+J9h+H6g0QkFEVv7MY
	 +G37Q+/2ZLLWTQANTQCT8KtgomZYrbBfxbOJiz58TnVP94ybF3t+XcYKSC7YC9LJjv
	 7ev/X2iNvNAjJY1YoluU624cun31kcvX2h2PAfwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 064/207] rtc: ds1307: stop disabling alarms on probe
Date: Mon,  2 Jun 2025 15:47:16 +0200
Message-ID: <20250602134301.252554491@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 336cb9aa5e336..d5a7a377e4a61 100644
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



