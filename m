Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D89343893;
	Sat, 12 Sep 2026 09:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206828; cv=none; b=Bw6bTL1UZd5dK4s0SANveZxtkmqTf70ec5wLXIkudZhqTlehZXa9uwuHITz6rGTFq0dG8eC4oUZ50rzgbCwFlYeV2NUAV6FVM0Y00wTqHG5EftL/yfAA9TmX6qd8k0oK94tHJzuAjdk8WB3kbu0M2pDk+XZ1sUn6LHcMnCHnbmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206828; c=relaxed/simple;
	bh=PimOBA1/F35B3w3VhSK/zu01srP7V+oEhB8IURNM4eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XILSUEI/pPNaAWHpdeCiRq+V07PoPh51kmvkujYGOA0EdB/dwO6ifRj9nLQO1VLeyXHYwJpSUyfy/egeRU2ldqENhGSQhb+Ek+VbzP+/zVNdUxtHennpv95yfSTwK3ketWIcylps6hWk3ZFErTbu16UwkyO0l+w78VnPjJWhdF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbpPb8MH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbpPb8MH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 336611F000FF;
	Sat, 12 Sep 2026 09:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206827;
	bh=GGCgx9wKmaWWN0GTZGldVkyNZFOIOpHAsTUDKM+oX/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbpPb8MHdTCo65aQsqkrc2JPzhzkguX5UtArjEwQ5p1wRmCqfke1tMGilfLIlhJxx
	 7yr4hBYE62hWfF0e50LFXONm66vvvGVBo7KvBh1UYwBk7iU7MVmRV8+/oK0mizLoBf
	 H7aQGsmGkWNkvYkFQHWA0kFBLrgZguxZZiozpKcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manuel Fombuena <fombuena@outlook.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0288/1518] leds: st1202: Fix spurious pattern sequence start in setup
Date: Sat, 12 Sep 2026 08:40:57 +0200
Message-ID: <20260912065629.997401117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 6bc726f9ef467..413c2bd68dab5 100644
--- a/drivers/leds/leds-st1202.c
+++ b/drivers/leds/leds-st1202.c
@@ -331,11 +331,6 @@ static int st1202_setup(struct st1202_chip *chip)
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



