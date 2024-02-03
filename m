Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD83168CD;
	Sat,  3 Feb 2024 04:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933505; cv=none; b=fkIYtnFznmJmxORHPfjYIEeSTTEC1LjzIJqSxw2vb0Qj9j00piQmbuBz7ZM61o5SrDtaNEeG6ycLcEl7UUSw2vrEl8unwd823Bx6zLpmnmVmQ4gMRStrmWxG2N3cfSnhq25asnrXZQOHrBT9UiDB4NKPowg9IVpSPw1wvgzcY40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933505; c=relaxed/simple;
	bh=6DHIj3uzGiOrre+seHwxPy255G0Z3jp3wbnpLL2pZBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDjQynZ9tcyxT9TvfWdz+HNOCZSKipqctH6WGkeMkJAj20dJzZcBu6Vr1AobyqfbstJSD5t1gQIkElXDR+jmzBT1dyISCpLk2ifuAeHHuv3TqX/tCK29xK3zMk9NCNUjpbdQav2XhN7BIjAsGq3wj4mkJ0o3Jcua4nwmv9hTKuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNOFwsGB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNOFwsGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36669C433F1;
	Sat,  3 Feb 2024 04:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933505;
	bh=6DHIj3uzGiOrre+seHwxPy255G0Z3jp3wbnpLL2pZBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YNOFwsGB00G2R5RFYDFuw3V1KafZQlK5VKdGO4TLRuZdEjqNKnNEddUmH7snDnLwX
	 +/9C8D23jOxNlEyPIHBEb9gainX++Rl0u9joOBMNscRCZls0wWp9mlLAKKTxbLqV0D
	 8UIw2RFnuGowzGTjviuGmhdEEux5LxSiS/I2xqPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Zhang <zr.zhang@vivo.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/322] regulator: core: Only increment use_count when enable_count changes
Date: Fri,  2 Feb 2024 20:01:52 -0800
Message-ID: <20240203035359.543037642@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rui Zhang <zr.zhang@vivo.com>

[ Upstream commit 7993d3a9c34f609c02171e115fd12c10e2105ff4 ]

The use_count of a regulator should only be incremented when the
enable_count changes from 0 to 1. Similarly, the use_count should
only be decremented when the enable_count changes from 1 to 0.

In the previous implementation, use_count was sometimes decremented
to 0 when some consumer called unbalanced disable,
leading to unexpected disable even the regulator is enabled by
other consumers. With this change, the use_count accurately reflects
the number of users which the regulator is enabled.

This should make things more robust in the case where a consumer does
leak references.

Signed-off-by: Rui Zhang <zr.zhang@vivo.com>
Link: https://lore.kernel.org/r/20231103074231.8031-1-zr.zhang@vivo.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 56 +++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 26 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 3137e40fcd3e..a7b3e548ea5a 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2918,7 +2918,8 @@ static int _regulator_enable(struct regulator *regulator)
 		/* Fallthrough on positive return values - already enabled */
 	}
 
-	rdev->use_count++;
+	if (regulator->enable_count == 1)
+		rdev->use_count++;
 
 	return 0;
 
@@ -2993,37 +2994,40 @@ static int _regulator_disable(struct regulator *regulator)
 
 	lockdep_assert_held_once(&rdev->mutex.base);
 
-	if (WARN(rdev->use_count <= 0,
+	if (WARN(regulator->enable_count == 0,
 		 "unbalanced disables for %s\n", rdev_get_name(rdev)))
 		return -EIO;
 
-	/* are we the last user and permitted to disable ? */
-	if (rdev->use_count == 1 &&
-	    (rdev->constraints && !rdev->constraints->always_on)) {
-
-		/* we are last user */
-		if (regulator_ops_is_valid(rdev, REGULATOR_CHANGE_STATUS)) {
-			ret = _notifier_call_chain(rdev,
-						   REGULATOR_EVENT_PRE_DISABLE,
-						   NULL);
-			if (ret & NOTIFY_STOP_MASK)
-				return -EINVAL;
-
-			ret = _regulator_do_disable(rdev);
-			if (ret < 0) {
-				rdev_err(rdev, "failed to disable: %pe\n", ERR_PTR(ret));
-				_notifier_call_chain(rdev,
-						REGULATOR_EVENT_ABORT_DISABLE,
+	if (regulator->enable_count == 1) {
+	/* disabling last enable_count from this regulator */
+		/* are we the last user and permitted to disable ? */
+		if (rdev->use_count == 1 &&
+		    (rdev->constraints && !rdev->constraints->always_on)) {
+
+			/* we are last user */
+			if (regulator_ops_is_valid(rdev, REGULATOR_CHANGE_STATUS)) {
+				ret = _notifier_call_chain(rdev,
+							   REGULATOR_EVENT_PRE_DISABLE,
+							   NULL);
+				if (ret & NOTIFY_STOP_MASK)
+					return -EINVAL;
+
+				ret = _regulator_do_disable(rdev);
+				if (ret < 0) {
+					rdev_err(rdev, "failed to disable: %pe\n", ERR_PTR(ret));
+					_notifier_call_chain(rdev,
+							REGULATOR_EVENT_ABORT_DISABLE,
+							NULL);
+					return ret;
+				}
+				_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
 						NULL);
-				return ret;
 			}
-			_notifier_call_chain(rdev, REGULATOR_EVENT_DISABLE,
-					NULL);
-		}
 
-		rdev->use_count = 0;
-	} else if (rdev->use_count > 1) {
-		rdev->use_count--;
+			rdev->use_count = 0;
+		} else if (rdev->use_count > 1) {
+			rdev->use_count--;
+		}
 	}
 
 	if (ret == 0)
-- 
2.43.0



