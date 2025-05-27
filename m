Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F2B26F469;
	Tue, 27 May 2025 17:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367049; cv=none; b=WlaaosaxSjMoUuMNpXT2l48bXx8dLJJGuNAqOgfoSUUtkAijosEU0PbJnmKTyh3uc7K/FJvqePnXl40VynvwbpR19iFVJSKM0sgtdVNCkrsDRmmj0GmzAxr2wXA1jKslbEXGoE8JSNpE4u7zNbta8so7q2B1G/rK0x/JzDEgAqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367049; c=relaxed/simple;
	bh=LtUyeHzb+k8xwfzE57RpdsoBsu2P75czLi4Ja5oX0Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOp734g3QkCJQTX88Rftp/iQnBD9uaB/N75B1cF3+7twCz+a/oWbh/u4jxfvuN9sGok4ICTzr95LAulaN+GkvobgQAHjCcGGHxgx5vIQU18f+U0vmvdjiguQGVhNk9It26dBTLpMwL+MbJ8MYm9dj0ckYntU9oNuJRI/QB2SMbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXZOgvyj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXZOgvyj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9C4BC4CEEB;
	Tue, 27 May 2025 17:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367048;
	bh=LtUyeHzb+k8xwfzE57RpdsoBsu2P75czLi4Ja5oX0Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXZOgvyjsySXjALAlXURi3DV1+VEM8oOznm9Hd2NvPJlXOKvekB3ObW5SJAG/xW/L
	 +sv8kS/POYvUHTV5fLU2dBdbzoepGZjpGRzRN6nW+mZRXSBAn8TU/Oz6sdwElpKW0i
	 DgQwrxcBbgCWu3I8zQMSDsyZlSGn1GQTfqBLefAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 262/783] rtc: ds1307: stop disabling alarms on probe
Date: Tue, 27 May 2025 18:20:59 +0200
Message-ID: <20250527162523.763407219@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 872e0b679be48..5efbe69bf5ca8 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1807,10 +1807,8 @@ static int ds1307_probe(struct i2c_client *client)
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



