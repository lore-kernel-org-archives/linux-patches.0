Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4ED443C7AE;
	Tue, 21 Jul 2026 21:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669848; cv=none; b=QWT2c7J1PEg9cuOhE4HpMPRyTZBCXxZ9lZ7lfieOEz9c2qNGqm10/3vtkK3Gki1VAoD2JU/MNJ1TkhzvUokK70iMUvBEVu7m9cZ88z0F/py2gW0+6H5wZPYo9oyvKSA38KD9429HLXE/JF3PlqUqgYtOEzuBpvdPDo2T3hhZ0do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669848; c=relaxed/simple;
	bh=DQrSAAzkb63H4tsoF2X8yhdoCIH4hb86jACb2RdsVc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxWi3uPP7cs/K0RlrDQqPJt3iVcImi69o+08yRYCBW0lC+Xyo6pKU3Ll2TACYUo4zwi2oD5L2IX9zrncmzMkzpuJaZPvf1gINO6QCm1li7HtY5IO85gHbwcRYJBQV8zG4K+icQfxbQReqTPWv1zmWZc35lpgKAyhVD04VJRAK9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSUfy73e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSUfy73e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147011F000E9;
	Tue, 21 Jul 2026 21:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669846;
	bh=QnGO8Nb5+lDW1fl5G2mKH9rxc2P2pbuEQ5Dpt28V3vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSUfy73euaBOJvR3HRPuvzVPxboFCG+AuwcjERMbdvzKObsjsNXaNKt+T6sdF/8Rg
	 1pFuX2GNjzyhSd5NDTBj4kJ4hJ15ftwsoRtzMPkaWthK+yvHa4+3AEo9i9pw2SqQ+1
	 hEzHDMbLjzRTmixIYN4wGOj625wgsjNhWCy9cffQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0710/1067] regulator: core: Make regulator_lock_two() logic easier to follow
Date: Tue, 21 Jul 2026 17:21:51 +0200
Message-ID: <20260721152440.475048871@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 37473397b852f556d8b9428ccbfd51886037842d ]

The regulator_lock_two() function could be made clearer in the case of
lock contention by having a local variable for each of the held and
contended locks. Let's do that. At the same time, let's use the swap()
function instead of open coding it.

This change is expected to be a no-op and simply improves code
clarity.

Suggested-by: Stephen Boyd <swboyd@chromium.org>
Link: https://lore.kernel.org/r/CAE-0n53Eb1BeDPmjBycXUaQAF4ppiAM6UDWje_jiB9GAmR8MMw@mail.gmail.com
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20230413173359.1.I1ae92b25689bd6579952e6d458b79f5f8054a0c9@changeid
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: d38f8bd771c4 ("regulator: core: regulator_lock_two() should test for EDEADLK not EDEADLOCK")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index d55a80f05d31ab..2b8e210daa6a3d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -219,7 +219,7 @@ static void regulator_lock_two(struct regulator_dev *rdev1,
 			       struct regulator_dev *rdev2,
 			       struct ww_acquire_ctx *ww_ctx)
 {
-	struct regulator_dev *tmp;
+	struct regulator_dev *held, *contended;
 	int ret;
 
 	ww_acquire_init(ww_ctx, &regulator_ww_class);
@@ -233,25 +233,18 @@ static void regulator_lock_two(struct regulator_dev *rdev1,
 		goto exit;
 	}
 
+	held = rdev1;
+	contended = rdev2;
 	while (true) {
-		/*
-		 * Start of loop: rdev1 was locked and rdev2 was contended.
-		 * Need to unlock rdev1, slowly lock rdev2, then try rdev1
-		 * again.
-		 */
-		regulator_unlock(rdev1);
-
-		ww_mutex_lock_slow(&rdev2->mutex, ww_ctx);
-		rdev2->ref_cnt++;
-		rdev2->mutex_owner = current;
-		ret = regulator_lock_nested(rdev1, ww_ctx);
-
-		if (ret == -EDEADLOCK) {
-			/* More contention; swap which needs to be slow */
-			tmp = rdev1;
-			rdev1 = rdev2;
-			rdev2 = tmp;
-		} else {
+		regulator_unlock(held);
+
+		ww_mutex_lock_slow(&contended->mutex, ww_ctx);
+		contended->ref_cnt++;
+		contended->mutex_owner = current;
+		swap(held, contended);
+		ret = regulator_lock_nested(contended, ww_ctx);
+
+		if (ret != -EDEADLOCK) {
 			WARN_ON(ret);
 			break;
 		}
-- 
2.53.0



