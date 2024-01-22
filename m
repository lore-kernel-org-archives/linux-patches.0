Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BD8629E1;
	Tue, 23 Jan 2024 01:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974971; cv=none; b=MCec46r3zEDxeHeSW8iaWdTamzVCq756+R5sZQV+SQgkUadjN7XnUqrqEFbdstlwQb6qnz/LNpmpSS0KDY98C5YQmieZDOd2ObmYKTGpFLy1A7CXjTl70Y2ozxcYBqPc4NmdNdhAW5ml00W9kDlakqSiscX7wwSymJjXIZ1SCgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974971; c=relaxed/simple;
	bh=jQPJ/pBRFtQc5EbN/cLyRoiu0R2+Od4gSytAFXBUqSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjkjAckyz0kip7LZn8nbfvyxJkm0R2Lks0ZP2C9V49IZujQvu4I2XyK59fPnVBh0nPs3ftjoo1dDMqyb5O08cz0YN35PZTVJNrp9E4gfJWPMPcNywZdMYJYe/7Ipc0XtN5SHxEq76fMViEct/AJJjXgmoY0kyCWJrdtMksQrzzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8l0hew4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8l0hew4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFE4C43390;
	Tue, 23 Jan 2024 01:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974971;
	bh=jQPJ/pBRFtQc5EbN/cLyRoiu0R2+Od4gSytAFXBUqSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H8l0hew4zge/jq2ZrzOsr2S7q4QdOv2V1dJKObyelUoRE3ibISLYMYir91ZjrdYi2
	 pm/D6lgfiupKirfE/Y0Yrt4mAvjpVmHT7PBUmj2AAvieuR9tojALhji9afsERJUaCy
	 8hoHLzMWqDvYjWhCm5N4tkKjz8l5hG1fCOIonYYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 302/374] power: supply: bq256xx: fix some problem in bq256xx_hw_init
Date: Mon, 22 Jan 2024 15:59:18 -0800
Message-ID: <20240122235755.299302896@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit b55d073e6501dc6077edaa945a6dad8ac5c8bbab ]

smatch complains that there is a buffer overflow and clang complains
'ret' is never read.

Smatch error:
drivers/power/supply/bq256xx_charger.c:1578 bq256xx_hw_init() error:
buffer overflow 'bq256xx_watchdog_time' 4 <= 4

Clang static checker:
Value stored to 'ret' is never read.

Add check for buffer overflow and error code from regmap_update_bits().

Fixes: 32e4978bb920 ("power: supply: bq256xx: Introduce the BQ256XX charger driver")
Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20231116041822.1378758-1-suhui@nfschina.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq256xx_charger.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq256xx_charger.c b/drivers/power/supply/bq256xx_charger.c
index f501ecd49202..9fb7b44e890a 100644
--- a/drivers/power/supply/bq256xx_charger.c
+++ b/drivers/power/supply/bq256xx_charger.c
@@ -1514,13 +1514,16 @@ static int bq256xx_hw_init(struct bq256xx_device *bq)
 			wd_reg_val = i;
 			break;
 		}
-		if (bq->watchdog_timer > bq256xx_watchdog_time[i] &&
+		if (i + 1 < BQ256XX_NUM_WD_VAL &&
+		    bq->watchdog_timer > bq256xx_watchdog_time[i] &&
 		    bq->watchdog_timer < bq256xx_watchdog_time[i + 1])
 			wd_reg_val = i;
 	}
 	ret = regmap_update_bits(bq->regmap, BQ256XX_CHARGER_CONTROL_1,
 				 BQ256XX_WATCHDOG_MASK, wd_reg_val <<
 						BQ256XX_WDT_BIT_SHIFT);
+	if (ret)
+		return ret;
 
 	ret = power_supply_get_battery_info(bq->charger, &bat_info);
 	if (ret) {
-- 
2.43.0



