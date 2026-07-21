Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D543E49CA;
	Tue, 21 Jul 2026 17:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653906; cv=none; b=rVvVl5xUNK9l7vQNVhMoMtB/SpiSA+klH0ypkqaChoM4GEfcLCk8BHyRvnTa7BuYCwn3AfPsPaD7HIw2r9B2OawToGHPy8Xpfo9Eb3ebSaqzA4lNStumkj1Civa477g6RV5wwLEbEojRHd9TtW7LbNxheXzV8iYuvvtDomfzPTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653906; c=relaxed/simple;
	bh=2KyM70sbw6ZnoMxWpPLF7YNO174bD9tw7aLENASs7sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLm0gNO9uyvx9oW5pHBOsRkdmaUKwg2yrBGm7/F7K8WuIQIt3uAiY5d4+dIbMM+SI1FhE1onigkrx2MQb0DGplw1BKbU9232L0AZbF+89PW4Ype98FVHu452Q0FkV/Xtbwhk0cxWMx1hsOSg7ngic1DTBR2lR+DFMjOuhtdyvXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ire/TJ5N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ire/TJ5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C925E1F00A3A;
	Tue, 21 Jul 2026 17:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653901;
	bh=DRH04uPNxGAnY9PehHVskjX//T9a8qi8g4nzMe8V9BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ire/TJ5NxUOSPiFuJ2gbGMlft5RGqPCMeCqvsOpTpsAO11Gy4rX8DklJcbozcq4xe
	 jgJZKdaMDYAYluNS4n49+eX9kcYKRxhqTl6g7vRwW6bCCwH3hIbTKw34nAtyNyugq/
	 WvrPvJct0Iwn6j0cA/P3vgZu0qRQr6Qe2CEEfWiU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1502/2077] regulator: core: regulator_lock_two() should test for EDEADLK not EDEADLOCK
Date: Tue, 21 Jul 2026 17:19:35 +0200
Message-ID: <20260721152628.212492998@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index dc5d67767336e0..1797929dfe5663 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -248,7 +248,7 @@ static void regulator_lock_two(struct regulator_dev *rdev1,
 	ret = regulator_lock_nested(rdev1, ww_ctx);
 	WARN_ON(ret);
 	ret = regulator_lock_nested(rdev2, ww_ctx);
-	if (ret != -EDEADLOCK) {
+	if (ret != -EDEADLK) {
 		WARN_ON(ret);
 		goto exit;
 	}
@@ -264,7 +264,7 @@ static void regulator_lock_two(struct regulator_dev *rdev1,
 		swap(held, contended);
 		ret = regulator_lock_nested(contended, ww_ctx);
 
-		if (ret != -EDEADLOCK) {
+		if (ret != -EDEADLK) {
 			WARN_ON(ret);
 			break;
 		}
-- 
2.53.0



