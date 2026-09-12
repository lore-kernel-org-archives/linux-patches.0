Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D50342146;
	Sat, 12 Sep 2026 07:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198019; cv=none; b=ZcKi4nKrvd3cOFDKJVN1I1SW8Tq0xz1bBu8w0+ZHXj5D1tCWfug4qhHsXD3XOdhh6Q9R5GfTfrir6SJ4ZJcI6RxL09jVFrFhXlSuprWNLuXMTwFXYtBnhJfRjC7kc9k0QsKPEuIl6D6CdDv9xid4CoGkgwY5aSmqeN/XBOHEruo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198019; c=relaxed/simple;
	bh=Pk/E2RxqlJ7ApK9y3Cw1JuOwiUUQaMQb0e/Nd2yrqsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LTtlNs9MhjDfocDNZ51AmfW/VtZe7MOos7rX6ZDJD0D2iiir9ijqRzkh09pyuG2mtcTmAD4wWQhTcLE9ffwlKiHQugUFAQQAxxiX4ywcsw2AkoJDTx35J3a8103MkfKXStXOKeAxrjQ0F4l74tyJL/p4ZvrJUEoi9EqzOMa+bfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KnMGJcMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KnMGJcMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37D31F000FF;
	Sat, 12 Sep 2026 07:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198016;
	bh=mjHCTbCVECfWp/dozcod3CmUosMiQQoidhBjLmFiwTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KnMGJcMubF6G/xHpqKSjIrgHNkDmFVbE4NaDbafXsVTJrkG/e4ludm/4HghZnMcKi
	 N9lMZn32HPjPAzQGTYpOBrZF6nHTJgIlwcYw1MKmmQ2/JDPCLuTjyc48WdYzeF6W3c
	 riJeerOTF8ki/qXTS1+sPwncJXqMMReAgfTNpmu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0294/1815] leds: st1202: Fix spurious pattern sequence start in setup
Date: Sat, 12 Sep 2026 08:34:04 +0200
Message-ID: <20260912065655.855974619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manuel Fombuena <fombuena@outlook.com>

[ Upstream commit dcc31246aaf0d330a3ba9a725f56c33e6d634caa ]

st1202_setup() writes PATS and PATSR to the Configuration register as
its final step, which starts the hardware pattern sequencer during
device probe before any patterns have been programmed. This causes the
device to run a sequence with whatever values happen to be in the
pattern registers at the time.

Remove the write. The device reset at the start of setup restores all
registers to their power-on defaults, leaving PATS and PATSR cleared.

Fixes: 259230378c65 ("leds: Add LED1202 I2C driver")
Signed-off-by: Manuel Fombuena <fombuena@outlook.com>
Assisted-by: Claude:claude-sonnet-4-6
Link: https://patch.msgid.link/GV1PR08MB849724B0FF00255F4760FAE0C5F52@GV1PR08MB8497.eurprd08.prod.outlook.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-st1202.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/leds/leds-st1202.c b/drivers/leds/leds-st1202.c
index 6bf3493f8e707..ce09cedc869fd 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -330,11 +330,6 @@ static int st1202_setup(struct st1202_chip *chip)
 	if (ret < 0)
 		return ret;
 
-	ret = st1202_write_reg(chip, ST1202_CONFIG_REG,
-				ST1202_CONFIG_REG_PATS | ST1202_CONFIG_REG_PATSR);
-	if (ret < 0)
-		return ret;
-
 	return 0;
 }
 
-- 
2.53.0



