Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A4239B977
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302594; cv=none; b=C1FNItutVEl7pABk3rTyUkeKI6Y/uWMce+N8NZL4YagYCC/3ZGsyaNBeMCac+bG6KMQLuLqiVZJtgLeH6xaNOKavDHDhKuzWEAPjkPLf7R6jN09VdRaprrvfyNvYA94Jdcr0FdPoRfEtmq8VhOmeBF2q3xAvGEmFuxFMy1CiqSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302594; c=relaxed/simple;
	bh=eUyDij6iDie5TfPav/wDk1bMLjAnydG55RspiRlm+Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o86zr0JCoxXqVxt1/f1FdcjsytSTLHqCDxp5lvI2K4SkR6tnc2lFxfS7+kcAAdD0HuoCKEyvEDDP4BhcWav4MNjqrVYcKBR+FN6tUWmglYLd24vx2+m6gPzhc5q6xcA98/uLiTmfgTv13AwDj1MmbOpOlWwYtV68Rd+U+RSWqe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WgtZaIAx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WgtZaIAx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED7CC19423;
	Sat, 28 Feb 2026 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302593;
	bh=eUyDij6iDie5TfPav/wDk1bMLjAnydG55RspiRlm+Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgtZaIAxIzi59o6oeqHeFwviv1b7dqOL+/zX22QGp6rHR7piguhaDFIsvonZ747Dy
	 Z97Uu3rz7TBkL+cVsq4GfBNV9qUSuxCfL6RXPInE3GbtPaFGO4TJ+4/d5RLhJe/79Q
	 2hvSXo/h78qgkMf3XAAX7YZM4eZhQ8sDh2DdSKHXuL9BTOTWDG2eNIiVKuyMb81f1u
	 kU5qRO3bgQV4j4ckxBFdD+h8RM/YrabEiv3wXfBDqAB3uHk+SmNlRBo2pwMRl2PwLc
	 8TkBxF2VaBuMVoAsFhGL7bWxWZb10PioETsb6z9kVMxF8I3DNSL+LzE8MPDxjFP3wC
	 O+75ISiGxtcwg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Haotian Zhang <vulab@iscas.ac.cn>,
	Matt Ranostay <matt@ranostay.sg>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 105/164] power: supply: bq27xxx: fix wrong errno when bus ops are unsupported
Date: Sat, 28 Feb 2026 13:14:04 -0500
Message-ID: <20260228181505.1600663-105-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 2b45187234001..844d8fef014f1 100644
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

