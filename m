Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F97407CDA;
	Tue, 21 Jul 2026 22:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672238; cv=none; b=Nb2MtQGJZL2lb4sZDZtTtuPS9V0kx50po+sQ7KCTnyoZpGaySEuXsJsyjTN0jB65me5pN1LRPDz330LcFPljJyTobrOrTFe1mqogOGvbdGDgwqs8BnHYC760B4HC0FTKn21mQpouD3H/aAQO6nkvPSNcFDgoVmIqfIZ9NiBKbCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672238; c=relaxed/simple;
	bh=43RtkJdrl7xxqXouGc5f/gXgRwzzZzMHb1DBPmPjeFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlFa6u3Eta+F4RBI3hekfOH8bCLPBtGKCi2X3W3s5VFtopz59HMypQR/NmRmQu6o37YYSLfok/YIKauVACmLpmRgRT7aaWOlzibuw9Uu4J7E1kR03W1Nasi5hboTcIGNIfqZZ+3fUZJb+PDdCQJ9h5f/G8pMY5hVWxoa+3YrLv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0f8qybU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0f8qybU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373841F000E9;
	Tue, 21 Jul 2026 22:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672237;
	bh=saPIQj0t407fg/ZNM9NPiVH65xvhf+Xy5dK+kdUEp2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0f8qybUvL83/mHFOV/rGd5RDH2VlHOuxLlQ5bA6yiseauN2RPYUQswq7QoCUqbWl
	 ic24uLQ5jHHMd0rRa1a1Ncypux5avzDwFOB5jMhBJwGC6Yj3Q+Css4Y1hgyZMD1ZJn
	 ZyxewO0kLpt1LHzPOpmE4qh5BLG+3QlnDrhh4iYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timur Tabi <ttabi@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 550/843] regulator: core: regulator_lock_two() should test for EDEADLK not EDEADLOCK
Date: Tue, 21 Jul 2026 17:23:05 +0200
Message-ID: <20260721152418.419408133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a5d3d5f3f118b8..e1def5d9dd1407 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -227,7 +227,7 @@ static void regulator_lock_two(struct regulator_dev *rdev1,
 	ret = regulator_lock_nested(rdev1, ww_ctx);
 	WARN_ON(ret);
 	ret = regulator_lock_nested(rdev2, ww_ctx);
-	if (ret != -EDEADLOCK) {
+	if (ret != -EDEADLK) {
 		WARN_ON(ret);
 		goto exit;
 	}
@@ -243,7 +243,7 @@ static void regulator_lock_two(struct regulator_dev *rdev1,
 		swap(held, contended);
 		ret = regulator_lock_nested(contended, ww_ctx);
 
-		if (ret != -EDEADLOCK) {
+		if (ret != -EDEADLK) {
 			WARN_ON(ret);
 			break;
 		}
-- 
2.53.0



