Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCAD3B9DA5;
	Tue, 21 Jul 2026 20:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666968; cv=none; b=Myef3cUfteiRo3fNthIrPOGH+qdywuHjQAw7n+NQQpJ3Z4tsGM/d2dmA/rT8uA/WKum4qXfzrGf4BJTodHdXxxSRPVuAs9hTDM59RtxYgbPEc5qUEUzg3XJAKcP35Wx01J4GcH3Iyf6WXAnAg3jH4Lgjy94rMiRo0wbnwEkut3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666968; c=relaxed/simple;
	bh=74GoWo3SAtis16m6uM+m6WucbSX5c2+fhncdOY4qB1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KkSgVlgRUtr9RPkXx8j+3jT2IYox+mIIM0QOefMDgIT6cDL7/im+Bof/x3+UM0dKJj0X0h8bYOkAlfrZaYSEuLalqmI8Bqgmdd4akHq1m5sL8ehGQvmOs3HxZswkLR3DXoDMiXsisUCVUc5AZO95PJW/memlmim4Zgn6wn09A1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eOQc0Sl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eOQc0Sl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11B01F000E9;
	Tue, 21 Jul 2026 20:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666967;
	bh=cX1puHiZzwvLAtl23tI5hkvB4J8gv3BS2JEAFpOSJys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1eOQc0Sl7FvS9HGch3Pt6qcH4meiOFwtC63mzZcKdgmf8MTe1B9dWZHlR5z4P/rJG
	 zGplqyekNT7mcR+0+YAl9xM3LMbuFro4djMrT/ZBU6umNC+aIHuEcvMetjFdW60LUw
	 6AQyknAClMlfz90fcCf5NTXxxqHkp9QBd9xdrWvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0884/1266] regulator: core: regulator_lock_two() should test for EDEADLK not EDEADLOCK
Date: Tue, 21 Jul 2026 17:22:01 +0200
Message-ID: <20260721152501.631115421@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0eadf6dc30e231..3f352d1c64b7d1 100644
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



