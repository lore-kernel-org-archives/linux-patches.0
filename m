Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24209175A98;
	Sat, 28 Feb 2026 17:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301398; cv=none; b=K/mOMeS8z+kCKTqc06AuHw+a0T0uHHoH3nDJtGjwC2P3aBi+uXI2H++diOim5yT9odjg2u+nd4bzWQITDfwJYgdDsSOgKGLu1L5yW1kzX5cKsk1wuSL55JwsgoI3+vVomkCIsEckYuBx0RwDhNyeVIhSigsyt8VPZ38J+MqGrEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301398; c=relaxed/simple;
	bh=XRtyqxU1iXumR8TN+rrx/oy8/wvwLheaI0PAvK6F1FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mf24mqSvmi4V2mxE/+X+ogvVIysatJcWES/fn1pvLgUiTJf9YzB8xqWaNtbPBrXdQRokNmovRKVn+LZzafLB4dbRP22kbhe7NxZ2nM5zUGjPJJY+XiNMgIrDDX52o92vUK2yGI5yqXoDkq8n1Bwv9aB8tJ6OQdT94Tsgksgd6Kk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmGIa5hd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmGIa5hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4FBC19424;
	Sat, 28 Feb 2026 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301397;
	bh=XRtyqxU1iXumR8TN+rrx/oy8/wvwLheaI0PAvK6F1FQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mmGIa5hd7aAu2DSS4mUN4bjq3nthaVfAj58w4mO59DRYochycOvLtcFavrrawaHkG
	 LX5WYPtm3aicnGVOSAwqpQgKeEYyLG89oit94RTcF78hkvTi10qKeNQiS1dZUhLOGg
	 Zi5NQS/Kk3fYxuhyd+PYmi/T6fsCcHdBiOmuhQpSbiLxq7oBLkzU+yTK70iRobVpwJ
	 HXHJuZKZ2nfy/G3WnS4+MdV7SUTEv337dfDn6bvb2Iu8Rk3tgKTGR7U9XDdsymN6qv
	 dKzPTYaxmWQMlWN4N9FkxDHLXWpnnXSe9gJ153IfjSpZCk5azxWu5CChHsnYi0AaVU
	 WQ7hJIboCrK1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Eric Biggers <ebiggers@kernel.org>,
	stable@vger.kernel.org,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 586/752] dm: fix excessive blk-crypto operations for invalid keys
Date: Sat, 28 Feb 2026 12:44:57 -0500
Message-ID: <20260228174750.1542406-586-sashal@kernel.org>
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

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit d6d0e6b9d54532264761405a1ba8ea5bd293acb1 ]

dm_exec_wrappedkey_op() passes through the derive_sw_secret, import_key,
generate_key, and prepare_key blk-crypto operations to an underlying
device.

Currently, it calls the operation on every underlying device until one
returns success.

This logic is flawed when the operation is expected to fail, such as an
invalid key being passed to derive_sw_secret.  That can happen if
userspace passes an invalid key to the FS_IOC_ADD_ENCRYPTION_KEY ioctl.

When that happens on a device-mapper device that consists of many
dm-linear targets, a lot of unnecessary key unwrapping requests get sent
to the underlying key wrapping hardware.

Fix this by considering the first device only.  As already documented in
the comment, it was already checked that all underlying devices support
wrapped keys, so this should be fine.

Fixes: e93912786e50 ("dm: pass through operations on wrapped inline crypto keys")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-table.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ad0a60a07b935..81265ed204b54 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1237,9 +1237,6 @@ static int dm_wrappedkey_op_callback(struct dm_target *ti, struct dm_dev *dev,
 		bdev_get_queue(bdev)->crypto_profile;
 	int err = -EOPNOTSUPP;
 
-	if (!args->err)
-		return 0;
-
 	switch (args->op) {
 	case DERIVE_SW_SECRET:
 		err = blk_crypto_derive_sw_secret(
@@ -1266,9 +1263,7 @@ static int dm_wrappedkey_op_callback(struct dm_target *ti, struct dm_dev *dev,
 		break;
 	}
 	args->err = err;
-
-	/* Try another device in case this fails. */
-	return 0;
+	return 1; /* No need to continue the iteration. */
 }
 
 static int dm_exec_wrappedkey_op(struct blk_crypto_profile *profile,
@@ -1294,14 +1289,13 @@ static int dm_exec_wrappedkey_op(struct blk_crypto_profile *profile,
 	 * declared on all underlying devices.  Thus, all the underlying devices
 	 * should support all wrapped key operations and they should behave
 	 * identically, i.e. work with the same keys.  So, just executing the
-	 * operation on the first device on which it works suffices for now.
+	 * operation on the first device suffices for now.
 	 */
 	for (i = 0; i < t->num_targets; i++) {
 		ti = dm_table_get_target(t, i);
 		if (!ti->type->iterate_devices)
 			continue;
-		ti->type->iterate_devices(ti, dm_wrappedkey_op_callback, args);
-		if (!args->err)
+		if (ti->type->iterate_devices(ti, dm_wrappedkey_op_callback, args) != 0)
 			break;
 	}
 out:
-- 
2.51.0

