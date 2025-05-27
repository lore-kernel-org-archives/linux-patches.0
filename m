Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8046927FB37;
	Tue, 27 May 2025 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365037; cv=none; b=s9zKjErAgnFIIliPdhmXQ250RHJyeOgLrCh/QnFR6z4d+ETb/BWo1MZhy08/76Xh7V4YyumZ43D25hUJ6DW+Jyejvs18LpgG+XYEcWx6QRL0Q8BXE0urio2fVjpK8p9buJawdQ+GM2x0miBDaUlTCLZDwGtg/EvY14wckG3rRDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365037; c=relaxed/simple;
	bh=UPi747Bd5n74IbQflxewgJoAmwK8fUuP7/k9sU8v9SY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SB33/VlLA8hpXji1KpAEBf5zVf6EL9xUC1tY5FCqyARGZOkDtpq9FgLy3ynVmifLcdjIb6pNLboJMm/yMtAxIY0ilaEQGbqq0H+G3oEDdUKgIESQqvDWvmuWRZtbok1fhtlxAEJs/+2Jo/anDSC2qzgQ8KZD7uPAxG9yTXQ9x6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fdj1exd4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fdj1exd4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33DEC4CEE9;
	Tue, 27 May 2025 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365037;
	bh=UPi747Bd5n74IbQflxewgJoAmwK8fUuP7/k9sU8v9SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fdj1exd4vL50Q8AT9VdotEUOI1kL5e+tW/pU3INC3UccLisNmtGE9iiXMbsHCjDHm
	 /BMQDIKgWZj7sPBfkgInazMkHwrAPLvKHDZdWu1ELc5iBCf+1Qvh8fCpM5tiundPaK
	 zdN9OomNinjcI9dbnGs5Nl2Ci8WXgo9+26Tb1tPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/626] rtc: ds1307: stop disabling alarms on probe
Date: Tue, 27 May 2025 18:21:50 +0200
Message-ID: <20250527162453.835651947@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



