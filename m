Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B690359A63
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302410; cv=none; b=FqYSbz4KkO89GsWpfwNSrl6hc4cCYVfw4FPZW/Y05MXnpu/okAL+aiuJ3Uee4U+p7S0DyFKi9BI2Bq255JyFguhqTRI7Ioz1FmDnCXRrIjs4/PoSVqlLkTZRo+D7UEaMyCNACvVcJo0hBai20bTdxaJ7wwigbvMt8rYj3P64VB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302410; c=relaxed/simple;
	bh=1cPKyVlEf8SAhxJWpXaVqcAa8PDUszgUwl7yA84vCXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJZsoOsxJVfqB/zNuqJUkUaZf831dRzIltpqvFbKr83Q8IaPtl1p2rU/SlBcHOnzgPOnDXoiBdKnrPDFm/FGO+db9YP70xo+lmSEccYOa/iAubFerBQRoZn8V2ftZZlqyOfpLQMIT2ixOgbj1gOzVbuFYWa7K+n01T1uuVctBR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QY12tsIA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QY12tsIA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B54F3C116D0;
	Sat, 28 Feb 2026 18:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302410;
	bh=1cPKyVlEf8SAhxJWpXaVqcAa8PDUszgUwl7yA84vCXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QY12tsIAFcp0cnSxyXtbnrgg1IsSdTTgHHfNdJhCb7bg/rpv99toR+MXlSNgEXGx3
	 UoilOsl+Y49jYUobQcq4G2dAKROu87YrCbFTq1Dssn8pbDaXFhRc2KflA2zgUdqLuM
	 cic4R2buQe9LUOJbPzNqGwnX/uhmsnVdfQIEnVbuVjU85Xa8WcpHePqUJJtSnKyWsF
	 pUiu+3Nj5NthXwKoVYQtQVykpvixMxuOwjR7a7P64LPyuBavbLR5ygDp45HhNr8YBv
	 Iincn7WjslEdR7zhK2mxchIcOhidioKf3emZHwECaBN6gSk4JU7PaeKf7R7zu/T3df
	 DaxnMdsaD8Evg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Matt Ranostay <matt@ranostay.sg>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 143/232] power: supply: bq27xxx: fix wrong errno when bus ops are unsupported
Date: Sat, 28 Feb 2026 13:09:56 -0500
Message-ID: <20260228181127.1592657-143-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 5a11424ae774e..f973b25c7bf3d 100644
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

