Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E0E342538
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301842; cv=none; b=s2h5QwwNBsOrf9lZ6pDVMur0SNB9IJWcaEXrlHukMnCpoSOnPhhbdUggdFwd3PJvo0QbMnERs1koziFjhIFepfLN4D34ZfRwBSqiwKarHAstDtGpPDCYtHl7ON+33NKcoi4JRMqSB1QMPI5XOBsj/Cexhh3/yEVhJiDyXxuCNZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301842; c=relaxed/simple;
	bh=4xVNhS+evETgXaG666z1hmxUGfJIWnw564wpP827PZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ljk20WD1r0Y0ZnpxcarF3E9wsw17BVMwxfRLiabqP49rOYLOB5gUsw0i4cGDRyoFArezgCuMl6EzdVLalBnz2hUz0IkeAyGixOlX97diNtpVH+dTO8gmsSQ/KmTgvvQMDhum+o4vgWxm8V3YPgWzf/0y8qcsKiQdLo74CEj7Vr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/Ry73jP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/Ry73jP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 879FBC19423;
	Sat, 28 Feb 2026 18:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301842;
	bh=4xVNhS+evETgXaG666z1hmxUGfJIWnw564wpP827PZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I/Ry73jPcO6pDyGMpbtXb0qCCsfkzXklPdlyPRuF+mCQrdoAjWzdLmNbLUcrsceNt
	 OIs8HZ2lwWpfGuBXq3KMScD+I7KHmcC1nJq9pBAJGxvIbxcDCNEiAGVsSf7Jk5aEjD
	 I1CpUZsk1w9x5MdRom6tvkRat1s7MdYAf5jebCdxd1sY7fXUx0E0pvb9WtI0i4c7Wj
	 yZQht71b/Zi4Nq7BuBNiyMY/BikVCIq+QtrI1dxuSpyuc8U3FHha0Q/ExjysYdc5V+
	 oWEAP8j5rNE39s+9oMhObJHcehXhupA9LNICXNuo8gwqDWh7y6xbCijPwykZJFnumQ
	 Juk1a84cmAmxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Matt Ranostay <matt@ranostay.sg>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 261/385] power: supply: bq27xxx: fix wrong errno when bus ops are unsupported
Date: Sat, 28 Feb 2026 12:58:03 -0500
Message-ID: <20260228180011.1568201-261-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 14be797e89c3d..a5a3ab4f8a631 100644
--- a/drivers/power/supply/bq27xxx_battery.c
+++ b/drivers/power/supply/bq27xxx_battery.c
@@ -1162,7 +1162,7 @@ static inline int bq27xxx_write(struct bq27xxx_device_info *di, int reg_index,
 		return -EINVAL;
 
 	if (!di->bus.write)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	ret = di->bus.write(di, di->regs[reg_index], value, single);
 	if (ret < 0)
@@ -1181,7 +1181,7 @@ static inline int bq27xxx_read_block(struct bq27xxx_device_info *di, int reg_ind
 		return -EINVAL;
 
 	if (!di->bus.read_bulk)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	ret = di->bus.read_bulk(di, di->regs[reg_index], data, len);
 	if (ret < 0)
@@ -1200,7 +1200,7 @@ static inline int bq27xxx_write_block(struct bq27xxx_device_info *di, int reg_in
 		return -EINVAL;
 
 	if (!di->bus.write_bulk)
-		return -EPERM;
+		return -EOPNOTSUPP;
 
 	ret = di->bus.write_bulk(di, di->regs[reg_index], data, len);
 	if (ret < 0)
-- 
2.51.0

