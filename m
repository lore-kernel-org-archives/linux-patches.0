Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E879142586B;
	Sat, 12 Sep 2026 13:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218252; cv=none; b=orL+PtGpgT0jaT0PhZmTwsLPLPMpVDRffcH+0wTDK0Lvah7ug4L2F2NhGi20Q6TUEs07PPIFol+O420GMMdVk1NRrB/IKPNqKzIFxpRFrc0q7NFL2MhfScn5RmnJrKMkixKT61dbOtl5kzxrCOqP7RFExCXBq+1JW/iR76hDHKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218252; c=relaxed/simple;
	bh=A2O4Zm4hz568BLhYIfGkZSfu87PFFXNLI+kjAkCe2UI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g3BtIW7Js0UQaz2l1WbLAKJHlYLw31NTg0kJ5M/UZ0TQTx6PWKpnyS81qdX1Aa61VL1g8RraFu3MNfENeB2bLWomPvJbeCZsbT9oJ5wi3B8RnhTuusKUsLS6OFivnnRiwqUovRaWCEgdZ8/cRCbXTXl5kSBgCRCWxw1k/ZuYyXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPE5gEsf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPE5gEsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A2C1F000FF;
	Sat, 12 Sep 2026 13:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218250;
	bh=v8zXpehKazI1Q7Zzu38/G4548vpBRRS6oe3X1XpY2iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPE5gEsfw2NKZ2kQ0FowJn1bglMA1Zeec5A47knvCjSPR4OPYFQrWX2K9zz7qlxZi
	 TpAt1iOJ9ZNb8laUzefRKmbTDdlVhONxND0DoypTQtXZzUTRePqfdpTvTmY4NVpAFa
	 Hjf+YToYzjeeXXt8RxfBJfqQJAN58JUHBoarp7EI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henrik Grimler <henrik.grimler@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1104/1376] power: supply: bq27xxx: bq27z561: fix invalid AverageEnergy address
Date: Sat, 12 Sep 2026 08:58:50 +0200
Message-ID: <20260912065632.164554238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Henrik Grimler <henrik.grimler@axis.com>

[ Upstream commit 2da28b059e0ddcd2e1956eeae383246207965573 ]

bq27z561 currently uses the AveragePower reg, 0x22, for reading both
AveragePower and AvailableEnergy. The technical reference manual does
not mention AvailableEnergy, and it does not make sense to read a
cumulative, always positive, property like AvailableEnergy from a rate
property like AveragePower. Set REG_AE as invalid to fix it.

Fixes: 6f24ff97e323 ("power: supply: bq27xxx_battery: Add the BQ27Z561 Battery monitor")
Signed-off-by: Henrik Grimler <henrik.grimler@axis.com>
Link: https://patch.msgid.link/20260811-bq27z746-v1-5-3a4fa38205cc@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 34a230e54cfea..fb16354fcb975 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -489,7 +489,7 @@ static u8
 		[BQ27XXX_REG_RC] = 0x10,
 		[BQ27XXX_REG_FCC] = 0x12,
 		[BQ27XXX_REG_CYCT] = 0x2a,
-		[BQ27XXX_REG_AE] = 0x22,
+		[BQ27XXX_REG_AE] = INVALID_REG_ADDR,
 		[BQ27XXX_REG_SOC] = 0x2c,
 		[BQ27XXX_REG_DCAP] = 0x3c,
 		[BQ27XXX_REG_AP] = 0x22,
-- 
2.53.0



