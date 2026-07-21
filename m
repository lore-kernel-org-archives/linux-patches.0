Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898AB3AEF58;
	Tue, 21 Jul 2026 22:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674132; cv=none; b=ForQDRdtT7c4Vi07RnQmWwHlRQ6cfIGf4PXSQVdIIRh+3wx95ChSBvkcRd4O3HX8+ySxLKsnKTiEb83G/GwYEg5CzlwqcyQG4nm7w6jIfReyGBB1cmMVqqwIoTA6qu+eX7vLAh0x5Ed8zlxFyK3X33/pIlYYGJbixcduxzEYgR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674132; c=relaxed/simple;
	bh=zH8mmwYQkVQWeKrdKLQ/d+lGfgAO6p/IrmUYUMk2jtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku3M7IlF9cNmV28XZnQLU0Dj82gUbf/laURLQTihJFdJs/KkKzRu6vsF0ZerBqw63h4Yf0VJN+sANyU1NWJ/A7kv7SqY0/wMWDeS+thJGf3XlNe57FVqtlWRcLWZZrj8c3cXSQqQuFO+tjTUKZXmUOZJD0eUEB95EOSfIcaxwks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nk+1liDt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nk+1liDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E7581F000E9;
	Tue, 21 Jul 2026 22:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674131;
	bh=x99CNS4c/dRlAG90NfpWisrnepTSPbJtfuD6PHwkAaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nk+1liDtgf6BhnjbE/s4YhCNaUcFKS9cwwGFX+U9UdlMuJNTuUOVmtc9tN9FVGvuY
	 zBdOywkihONNws4zLv5JDpVvuZdtvzwwcQYDe1/ZUzQ/C3H+Zz6E88+vg/ldh3QHqQ
	 E+ni5NdRGw7xMVYNvkrgdZuSM3slL59Xm9PRcIcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Boyd <swboyd@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 425/699] regulator: core: Make regulator_lock_two() logic easier to follow
Date: Tue, 21 Jul 2026 17:23:04 +0200
Message-ID: <20260721152405.280203481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 55f667a486a11a..61971705b96fb1 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -228,7 +228,7 @@ static void regulator_lock_two(struct regulator_dev *rdev1,
 			       struct regulator_dev *rdev2,
 			       struct ww_acquire_ctx *ww_ctx)
 {
-	struct regulator_dev *tmp;
+	struct regulator_dev *held, *contended;
 	int ret;
 
 	ww_acquire_init(ww_ctx, &regulator_ww_class);
@@ -242,25 +242,18 @@ static void regulator_lock_two(struct regulator_dev *rdev1,
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



