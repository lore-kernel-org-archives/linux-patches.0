Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CC6270545
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302179; cv=none; b=mSYpip5VmMr/Mk/YG44tMlYsR9OWJX2T2R7wHp7R+rR8fpxF0y1YiFYV8xcxX7YsBqaJ8NNZIw3CeHUuLgsxR9NCOEp4QmJMVExEyVtlgMrYedG7uJjhjjWLrCTpyegivUjUUqRK+oCN/krbh/wJOZzTyie0RmEAJgIXT/DICQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302179; c=relaxed/simple;
	bh=XSYw8N+21TtiMdKmwDRvwFUQc43Yiw5hTO7532u2ZNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTSO4NERDKFb4w6HbnzEb9/9sjWTX6NajOO2WyOPAFdMY726f9mTilu/5k5ClPGsj9jCru3kSylMB4BVrPqfIHG4b97mHiotiiDyxCXSche3SbTtNk+QiO4YIayzYIP/zo+LXs78aoDRDXayygvkgd0Z1+90gJYOC7Kppp4WUOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoVRZRea; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoVRZRea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3EF1C19423;
	Sat, 28 Feb 2026 18:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302179;
	bh=XSYw8N+21TtiMdKmwDRvwFUQc43Yiw5hTO7532u2ZNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LoVRZRearPEegGLNCc0r94UWRuc4TfPsnM4Hu97WgyyoflVnQJW3qtfxHDb+4i9rV
	 wIGZO3NLxcbaQkloZdm4nQBnqOeDu3tYiDMisPX5OcMnNbcsvePdNvlDx0FeT+D2WM
	 ZCMC4fYuqYLXdfdXKE/Q/6dadL95lFogyjIQ0Xn41ntYoyqUsBPiJZNecZ1LqK+3yk
	 2Jq2ajcVWGFFRaNO6mkZZCxROPBlK1c5jloDUjZeWNIrfCrwKqCElvElLRXYTDUoZi
	 FF9ty+t0J6StbM4O0a7P1fvIbVEiPIwanLaiKE5+Z+6oKIk+0ej+a8BsVVr4bwHkSm
	 7PY9al7vA1n/Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Matt Ranostay <matt@ranostay.sg>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/283] power: supply: bq27xxx: fix wrong errno when bus ops are unsupported
Date: Sat, 28 Feb 2026 13:05:21 -0500
Message-ID: <20260228180709.1583486-179-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 1f06dee4b8b4e..ff01d5d850f9a 100644
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

