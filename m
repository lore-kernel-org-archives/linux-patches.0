Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E3311193;
	Sat,  3 Feb 2024 04:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933334; cv=none; b=KZIfAwfQekS3lXUuJgD+rzOf6BjoYN4Tnh5VLjzeaJ5cE+8hL1wp3nzd4oBvb9xGFP3oK6j7aj+M2x7i5LJ+qvOmoAxK9NuJ0i7RI53RQFsPnMJl4NcDRbk7czs5C+vQDYgNlK6sA2vObLpKAeSsy9iEOkDWmd3B/Uk8MYuPdIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933334; c=relaxed/simple;
	bh=cSa3nhQOk4q/ITqGnMAnkE+qls+KkLsKoTVg+3Q/W+o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHZ3p3cCdbL6/CiX0mfm293bQvmmL8iOxlJnbSEI8Gxj7uUqSolnCArXUzgUlp8WIaaBIYIkFos9OY1WcZjlFUEYnrVJWR62sjX3+A5LKrSGqtQDe5aZ9+cZCJs+oR1itLHpSfCgcK77h9qQ/t3i3Dysw6i1lHWZhXwY5V8uFxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUlVxDkU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUlVxDkU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC1CC433F1;
	Sat,  3 Feb 2024 04:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933334;
	bh=cSa3nhQOk4q/ITqGnMAnkE+qls+KkLsKoTVg+3Q/W+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUlVxDkUVaAqzpPj1Q7IYlX8rrfiqKPd9h0BWJKC3ePi6BYeUKdV3LDa7H/P29CWT
	 QAEyUaT/Pq0v637h5LbcaZHXFqKhEM3RoXJLpc+BZsXej92rr3X3P5ax9qXfDoNhM7
	 +Yrrx0Lc8wYPWT363pqE2Se25w6KSubdNmUA78uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Zhang <zr.zhang@vivo.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/219] regulator: core: Only increment use_count when enable_count changes
Date: Fri,  2 Feb 2024 20:03:07 -0800
Message-ID: <20240203035318.573653816@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 34d3d8281906..c8702011b761 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2925,7 +2925,8 @@ static int _regulator_enable(struct regulator *regulator)
 		/* Fallthrough on positive return values - already enabled */
 	}
 
-	rdev->use_count++;
+	if (regulator->enable_count == 1)
+		rdev->use_count++;
 
 	return 0;
 
@@ -3000,37 +3001,40 @@ static int _regulator_disable(struct regulator *regulator)
 
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



