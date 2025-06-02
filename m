Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79477238C26;
	Mon,  2 Jun 2025 14:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873433; cv=none; b=iGit3ZNztqqItOUdNu5B5n9Q38fiddFW68/aiP8hTTrW5ZRThS5YiHoUk7q9OT54zd2DIuX83O2w119M/Sy/TM/Oa4Ol45b4XGl3vkTscypA+i2EnctQZiUY8RAe6MGzAN1xoMyY0yQHTa5uCfkQbGrlUkX7MHMJSYJVF5XXqeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873433; c=relaxed/simple;
	bh=0aQQvVjQAX4gBLjNoWIkrWo214ef5fJU0CDso+JC87k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IyneKuqInm4Tz+SV+J1oDSq8uDZu90M3rZ+cRB0xWlT6QuTQ6zK5vovrJqVWkiKir83WWogf/z79osklhOkgka4/DAh1rQ7d89D/9qDfz1HMoPTtrYLoK8LWQLOIvsjxk1PExZGzjIx7kPqqxhw0mmgRBR5k0IFbQNJ1GYzLTn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+sdYXwY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+sdYXwY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47A8C4CEEB;
	Mon,  2 Jun 2025 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873433;
	bh=0aQQvVjQAX4gBLjNoWIkrWo214ef5fJU0CDso+JC87k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+sdYXwYq5UD2dmK49ORxlVFAuafTJMqjK+ykJVrK1wHGcU0mfNHc5YJSwhjnI5M9
	 YiCE65RP4fY4ukFxjNhH+5hFxLbarg4FhJE99m4kxl5KuttsdFmn4M07hpZgfIS4yl
	 8AxVGhX5bNAqS53Sw+k87Z9C9amLt7HPMWMXE2hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/444] rtc: ds1307: stop disabling alarms on probe
Date: Mon,  2 Jun 2025 15:43:22 +0200
Message-ID: <20250602134346.493924686@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 506b7d1c23970..0c78451960926 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -1802,10 +1802,8 @@ static int ds1307_probe(struct i2c_client *client)
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



