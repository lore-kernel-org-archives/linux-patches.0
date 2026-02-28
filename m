Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D47341674
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301201; cv=none; b=ZcnhPV9x8Qwo0Cg5e0CcsCGd+1DmaUjzYyeUftI/+HThIzgAU8VNlfBpdxnA4a7QlBI4ZEFF//KgirPOqrp17KHVcc1/qOUWw71Il1ZuAyxKUzsYzsPZHg/lfc8+PyJmZzgg1+7aYlYVj2Z2t1F6QYl1CkCNV4OROmQgBzeWTOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301201; c=relaxed/simple;
	bh=+om7j3OIeYvJy31qwL1aOQAuJXnwldHeHf3J34hMdVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blQT/6nKqw3JGtJJE6SJqoDMEtYcSl9nAD9/4iEcsZqHJH8qmcUpOnJrRnOYkhbWJ2pWJ0GOb2292CfBoy00PI9nPKb8BiiSyBiuyT+86Vv8th92ZwwVgVn1lAlgNZ8MJdDtlCg1ioEiUwPohX/pqFSg61d3c7YZR3sSjTmmVKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EuaZ2Riy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EuaZ2Riy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2920C116D0;
	Sat, 28 Feb 2026 17:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301201;
	bh=+om7j3OIeYvJy31qwL1aOQAuJXnwldHeHf3J34hMdVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EuaZ2RiyYMUI1gIFH5R+l9ksTjK1tr4BecGcsAOy/QI5TYFtCHGUfgUasgDUpZzb0
	 ZTI5FIzpZYoUGGBEDGvaTEUaT/i3woiWm52gZdKW4Fl00M2XO0JwSRLTDKxbuxd/VJ
	 zKQB78eFJ3a+8ro9cD5V/JL/f0zwRHi5C9qi9qfReTdnwhdwLakIB9i8vjVw5g0Ej4
	 KFrDre2DdIjX3M15nIa119UYN7VuEgvvCADk+jfGBKrzzEQfGXKSmn4kLKBez70CMU
	 unPmIOQ433SdHl8mOvoS0TFntR4AIaJX6ZJXyBJ+i35zD2lAIZsUpcR2dkqEippYe5
	 3AACBAnmEBgHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 374/752] regulator: core: Remove regulator supply_name length limit
Date: Sat, 28 Feb 2026 12:41:25 -0500
Message-ID: <20260228174750.1542406-374-sashal@kernel.org>
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

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit e243cdd87b911ce9968b62e4ab2b680dfadc4341 ]

When creating the regulator object, associated with a consumer device,
the supply_name is string formatted into a statically sized buffer on
the stack, then strdup()'ed onto the heap.

Not only is the dance on the stack unnecessary, but when the device's
name is long we might not fit the constructed supply_name in the fixed
64 byte buffer on the stack.

One such case can be seen on the Qualcomm Rb3Gen2 board, where we find a
PCIe controller, with a PCIe switch, with a USB controller, with a USB
hub, consuming a regulator. In this example the dev->kobj.name itself is
62 characters long.

Drop the temporary buffer on the stack and kasprintf() the string
directly on the heap, both to simplify the code, and to remove the
length limitation.

Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Link: https://patch.msgid.link/20260211-regulator-supply-name-length-v1-1-3875541c1576@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 17c60d9547dc5..765bd1b5deb3a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1838,8 +1838,6 @@ static const struct file_operations constraint_flags_fops = {
 #endif
 };
 
-#define REG_STR_SIZE	64
-
 static void link_and_create_debugfs(struct regulator *regulator, struct regulator_dev *rdev,
 				    struct device *dev)
 {
@@ -1887,15 +1885,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 	lockdep_assert_held_once(&rdev->mutex.base);
 
 	if (dev) {
-		char buf[REG_STR_SIZE];
-		int size;
-
-		size = snprintf(buf, REG_STR_SIZE, "%s-%s",
-				dev->kobj.name, supply_name);
-		if (size >= REG_STR_SIZE)
-			return NULL;
-
-		supply_name = kstrdup(buf, GFP_KERNEL);
+		supply_name = kasprintf(GFP_KERNEL, "%s-%s", dev->kobj.name, supply_name);
 		if (supply_name == NULL)
 			return NULL;
 	} else {
-- 
2.51.0

