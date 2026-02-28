Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484EB35AC32
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302729; cv=none; b=NryrN59mrm+tX/c79z2eV5FRZ8O9J/8XpkSF/Wknzj8Dv+bnkEa1BMW/av+xsQXhOM498lLWk5N0uoip1F5WcaVzYILigldeV1zd2E8P5qH9SfBAYLb+cyPg7mbMK1cSO0v3LKjG3IBc9GEvMqqji+RFGUMEUqwmqJUBJxHjbZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302729; c=relaxed/simple;
	bh=tMprWNtvkrmkXQ+u0IePWySlBBxq+/3DoMR0s+PV3hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3ITXtKhE37nvPTpPWVSRBUqrOhdHI3rDbAxgu5QBi/pzkSbct3d/gBU4YgVDbDXWuvC4Ym8E5YC+W6btnRzS1C9WqWYtiNkVO28SB7BbybiYQtbzxZfGQiM3qpDks5puFnF2rt0Xb65l7HstY6h1iSKXplF7FI3mb0DIBEzC+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N5V0blDE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N5V0blDE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DF0C19423;
	Sat, 28 Feb 2026 18:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302729;
	bh=tMprWNtvkrmkXQ+u0IePWySlBBxq+/3DoMR0s+PV3hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5V0blDEWmA3DqfnGdiuOFXNpPJjGYuui9bTBX2tyUX/hnEfEXFZwiNaVnbHCpCIs
	 MIzqY3ohY9LdQAAcP/3avyc4/1nu1rtprEJuVWFeF7GBkCPVSMlu6ucuRgIOfWhL/z
	 R0PlChUZdN9xRd2CJeC5lOc0mVj9643xOK9gTekJSdWtKE1dQBV029VLCrhmW2E3t6
	 YaotJaSfx0nNDIABchURImkyFD/+okYt++Cd1rJaq6ANIm7Cmajk7Ym9NpBi5AbJrI
	 wAmw72AGb4k1lUrY5zWD7nhWIDNgs7IulsfoUxLX+UTMvG8Pdo96EY23zsIjxOnsjW
	 hjApy0bEzqOfg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Matt Ranostay <matt@ranostay.sg>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 091/147] power: supply: bq27xxx: fix wrong errno when bus ops are unsupported
Date: Sat, 28 Feb 2026 13:16:39 -0500
Message-ID: <20260228181736.1605592-91-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 688364a11647dc09ba1e4429313e0008066ec790 ]

bq27xxx_write(), bq27xxx_read_block(), and bq27xxx_write_block()
return -EPERM when the bus callback pointer is NULL. A NULL callback
indicates the operation is not supported by the bus/driver,
not that permission is denied.

Return -EOPNOTSUPP instead of -EPERM when di->bus.write/
read_bulk/write_bulk is NULL.

Fixes: 14073f6614f6 ("power: supply: bq27xxx: Add bulk transfer bus methods")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Reviewed-by: Matt Ranostay <matt@ranostay.sg>
Link: https://patch.msgid.link/20251204083436.1367-1-vulab@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/bq27xxx_battery.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/power/supply/bq27xxx_battery.c b/drivers/power/supply/bq27xxx_battery.c
index 1bd48e4e26d49..44198b181c962 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1118,7 +1118,7 @@ static inline int bq27xxx_write(struct bq27xxx_device_info *di, int reg_index,
 		return -EINVAL;
 
 	if (!di->bus.write)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	ret = di->bus.write(di, di->regs[reg_index], value, single);
 	if (ret < 0)
@@ -1137,7 +1137,7 @@ static inline int bq27xxx_read_block(struct bq27xxx_device_info *di, int reg_ind
 		return -EINVAL;
 
 	if (!di->bus.read_bulk)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	ret = di->bus.read_bulk(di, di->regs[reg_index], data, len);
 	if (ret < 0)
@@ -1156,7 +1156,7 @@ static inline int bq27xxx_write_block(struct bq27xxx_device_info *di, int reg_in
 		return -EINVAL;
 
 	if (!di->bus.write_bulk)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	ret = di->bus.write_bulk(di, di->regs[reg_index], data, len);
 	if (ret < 0)
-- 
2.51.0

