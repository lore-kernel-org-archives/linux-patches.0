Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F1733F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301170; cv=none; b=WlCOnQ11LCk4kh3GCb8HylRn6cehjwyGltP9nmQnhEs5NNf3UAesxqz57h+cP7HGtu9sq2C3SEKjoilKNzlMuMvuMxdWdKgT1JzkoPmVZPAjf7mNseDVkc+AG9KuxWGi5HS/WqjsjTrFx0tkCaBFhl4n/ouQFXQ4525suuXJx9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301170; c=relaxed/simple;
	bh=m1ZSAN/ySeKCQCFbk2w7m2/15nYVBMXoKuwOBd1+OFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X896hbTa+AwIgxMQ8dCB5tehK9soYOLmcx2w5OcPRxaVd6mi9IA66ciW1jUVX1bR/2MZKBoQBcevRwWqEVCt4CXT4yvjGBg8VnEP73WqVrBSitZyBQQz5esdf9khaTK3G07Kv2zFl/LKwyrQLejLcgzunjLMI8PiKi+dw2ZuPTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FFyTGRYx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FFyTGRYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D5EC19424;
	Sat, 28 Feb 2026 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301170;
	bh=m1ZSAN/ySeKCQCFbk2w7m2/15nYVBMXoKuwOBd1+OFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFyTGRYx/hjdw55cvxMMk8Fy0CFtKiDeuQVburpXN7sd9IqgARPU+S82O85rBcYm3
	 fDRcU6UOyIefEQ45M0qbqIDJVyXf7dJ8rn9G+zbbNpoIejgauUy9NEFwSWKBaVxmkf
	 HxybDaO6kppNH/3TZ9to84gsaRlrs6e5QgwNhCUjyvtMu6wxYbcoKqCK7CJBzBWAyX
	 3MdBtqC+wARmBACpuYHvPkaw1zfADHycS/MP+C/kUB8OY9yhvEBDlRFV55aaAMda28
	 T2sciRNZ5shBf7xOLzSXtKYcaLmfslD+1ijKaLV52JqMkd/BJ6ztXtc9mX3Mp6yhBj
	 hq80M9KQI57gQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Markus Perkins <markus@notsyncing.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 337/752] misc: eeprom: Fix EWEN/EWDS/ERAL commands for 93xx56 and 93xx66
Date: Sat, 28 Feb 2026 12:40:48 -0500
Message-ID: <20260228174750.1542406-337-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Markus Perkins <markus@notsyncing.net>

[ Upstream commit b54c82d6cbfc76647ba558e8e3647eb2b0ba0e2b ]

commit 14374fbb3f06 ("misc: eeprom_93xx46: Add new 93c56 and 93c66
compatible strings") added support for 93xx56 and 93xx66 eeproms, but
didn't take into account that the write enable/disable + erase all
commands are hardcoded for the 6-bit address of the 93xx46.

This commit fixes the command word generation by increasing the number
of shifts as the address field grows, keeping the command intact.

Also, the check for 8-bit or 16-bit mode is no longer required as this
is already taken into account in the edev->addrlen field.

Signed-off-by: Markus Perkins <markus@notsyncing.net>
Link: https://patch.msgid.link/20251202104823.429869-3-markus@notsyncing.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/eeprom/eeprom_93xx46.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/eeprom/eeprom_93xx46.c b/drivers/misc/eeprom/eeprom_93xx46.c
index 9cae6f530679b..5230e910a1d11 100644
--- a/drivers/misc/eeprom/eeprom_93xx46.c
+++ b/drivers/misc/eeprom/eeprom_93xx46.c
@@ -45,6 +45,7 @@ struct eeprom_93xx46_platform_data {
 #define OP_START	0x4
 #define OP_WRITE	(OP_START | 0x1)
 #define OP_READ		(OP_START | 0x2)
+/* The following addresses are offset for the 1K EEPROM variant in 16-bit mode */
 #define ADDR_EWDS	0x00
 #define ADDR_ERAL	0x20
 #define ADDR_EWEN	0x30
@@ -191,10 +192,7 @@ static int eeprom_93xx46_ew(struct eeprom_93xx46_dev *edev, int is_on)
 	bits = edev->addrlen + 3;
 
 	cmd_addr = OP_START << edev->addrlen;
-	if (edev->pdata->flags & EE_ADDR8)
-		cmd_addr |= (is_on ? ADDR_EWEN : ADDR_EWDS) << 1;
-	else
-		cmd_addr |= (is_on ? ADDR_EWEN : ADDR_EWDS);
+	cmd_addr |= (is_on ? ADDR_EWEN : ADDR_EWDS) << (edev->addrlen - 6);
 
 	if (has_quirk_instruction_length(edev)) {
 		cmd_addr <<= 2;
@@ -328,10 +326,7 @@ static int eeprom_93xx46_eral(struct eeprom_93xx46_dev *edev)
 	bits = edev->addrlen + 3;
 
 	cmd_addr = OP_START << edev->addrlen;
-	if (edev->pdata->flags & EE_ADDR8)
-		cmd_addr |= ADDR_ERAL << 1;
-	else
-		cmd_addr |= ADDR_ERAL;
+	cmd_addr |= ADDR_ERAL << (edev->addrlen - 6);
 
 	if (has_quirk_instruction_length(edev)) {
 		cmd_addr <<= 2;
-- 
2.51.0

