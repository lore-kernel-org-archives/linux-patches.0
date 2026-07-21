Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E50415F10;
	Tue, 21 Jul 2026 21:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669850; cv=none; b=QLBnLsHcOBaG1MuNd8mCay6DuuWvbrIX3gv7tBhlvCHDn5rhz2HrjC8HXeReYVcv9uHJGSkEPy+zP384Rf/kvQ6Cuv8eQpk+hArrh1Qd3f2GlQFPD2UD37Tt52asvFr1RESV1tR4Zcy56U4GcYsFvpsUAFmCjZpPxLLVAGbBbWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669850; c=relaxed/simple;
	bh=E1i3us7jY9RmLYzqhxRnkEL/o2GYSjQxrY753S06mj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZ5B3A5AQ/nkZcNF/DPPKXRBgDTRHLity329KhFzbIVrwKLN/JPOAWR8HCerP9x3fYjQ49ISjViU9tSG7FzfX4hyTI/4ttqIo7HGI3OiK4uMUlCnqCHUn+pjtPAJqDMzfEgrZMWgnkAr2EKghqi7aZ3CPKcMYyvEFNfrGzvhtdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoFH5XrP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoFH5XrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42911F000E9;
	Tue, 21 Jul 2026 21:37:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669849;
	bh=583rVlwhl8vRL8b3bKziclpyXKTVKrmlfHEWcuZecC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZoFH5XrP4VZ3R8FwrhbHn3gd163QcFoIbfplhSGEPrXe9ESEBvXztKM4MtoC3lVJW
	 GPlfGzsz/vzACCn15lIoHRx9dK62JSY1u/HHRCnZZQ5T9qeTaJbl3uku2ZkflM4cpj
	 9CGKOASvA2fNevtSTbbiiZKIYziqHaShySGXME+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0711/1067] regulator: core: regulator_lock_two() should test for EDEADLK not EDEADLOCK
Date: Tue, 21 Jul 2026 17:21:52 +0200
Message-ID: <20260721152440.496533117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit d38f8bd771c4999b797d7074b348cf201414bd34 ]

Compare against -EDEADLK, which is what ww_mutex_lock() actually
returns and what every other deadlock check in this file already uses.

Function regulator_lock_two() acquires two regulators via
regulator_lock_nested() -> ww_mutex_lock().  On contention,
ww_mutex_lock() returns -EDEADLK, which is the caller's signal to drop
the lock it holds and retry the acquisition in the canonical order.

However, regulator_lock_two() tests the return value against -EDEADLOCK
rather than -EDEADLK.  On most architectures, EDEADLK and EDEADLOCK are
the same value, so the comparison happens to be correct and the bug is
invisible.  But on MIPS, SPARC, and PowerPC, those two errors have
different values.  The test is wrong: a genuine -EDEADLK backoff no
longer matches -EDEADLOCK, so instead of unlocking and retrying, the
code falls into WARN_ON(ret) and returns with only one of the two
regulators locked.

In practice, this is a bug only on MIPS, because the regulator core is
not built or used on the other two platforms.

In general, EDEADLK is preferred over EDEADLOCK for new code.

Fixes: cba6cfdc7c3f ("regulator: core: Avoid lockdep reports when resolving supplies")
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Link: https://patch.msgid.link/20260708235722.2953579-1-ttabi@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2b8e210daa6a3d..ae1a52e1842453 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -228,7 +228,7 @@ static void regulator_lock_two(struct regulator_dev *rdev1,
 	ret = regulator_lock_nested(rdev1, ww_ctx);
 	WARN_ON(ret);
 	ret = regulator_lock_nested(rdev2, ww_ctx);
-	if (ret != -EDEADLOCK) {
+	if (ret != -EDEADLK) {
 		WARN_ON(ret);
 		goto exit;
 	}
@@ -244,7 +244,7 @@ static void regulator_lock_two(struct regulator_dev *rdev1,
 		swap(held, contended);
 		ret = regulator_lock_nested(contended, ww_ctx);
 
-		if (ret != -EDEADLOCK) {
+		if (ret != -EDEADLK) {
 			WARN_ON(ret);
 			break;
 		}
-- 
2.53.0



