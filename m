Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6066E381EBB;
	Sat, 12 Sep 2026 09:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205660; cv=none; b=I1WDyArYj0jCggS0pq8hsnrjjdxp1TirqRPtLXY/TYgosSKg9ni4pUVyVRvAqBnvIQX4stSRFmncs4/WNz4UXbj33l61JWDtCK1NQ2Bc4kApM7mYj32oxA0x5zq505yxofDTcfb+LyCPdlcb94S5awg8ONp++AjDG/J9wujp760=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205660; c=relaxed/simple;
	bh=FRiYmeRT9LO6ShlncnyGoUadQBzrGB0SwpDu7NLXy8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zd0VIMotr9jEcXoMWsQUbBcwj/tlytIUksx/QxYD0DPul0TeYPUMYAibGeNO6+KGuTNX//oVkDQc+9AkifK1AhkkRgnay26+bRp5ezolUeceG72b3FMkbzaApHZPQIbqlFUc13yDbTZa6QHuXgP0GGzdg30TO6Ym7TquoDKTTKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gZjbVA3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gZjbVA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 388A41F000FF;
	Sat, 12 Sep 2026 09:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205659;
	bh=PK93sx7Nyh0s3MhjN4uYJ+MkoRAnqSnSsoisjCi7pgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gZjbVA3kOj1hK6fTobkLH1Mok/Vs+83EkOFX8t43sl5cAKxOsUXtHrVZm9OHjjP8
	 rlskB2FdahqGDO+A+8nHgkRcpDEca7dob8fmz1jpOybsOOpeQo/L/v8K4MsPtQRsLM
	 IXzEL5oRe/+6naUxfahCPdRcMoMbAd0UBKfjxvVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0006/1518] mm/damon/sysfs: read ops_id only once in damon_sysfs_apply_inputs()
Date: Sat, 12 Sep 2026 08:36:15 +0200
Message-ID: <20260912065623.549989937@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit 5adaaa28be8a79ddd7e103b171f9d6e14e7fc26e ]

damon_sysfs_apply_inputs() reads ops_id twice.  It could race with
ops_id_store().  As a result, the min_region_sz could wrongly be set up.
Read it once.

The user impact is trivial.  Sane users ain't update the parameter in
parallel.  Even if it happens, the DAMON core layer handles the wrong
min_region_sz (!is_power_of_2()).  Even if somehow the race ended up
making a min_region_sz that is different from the user's intention but
still valid, only monitoring itself runs differently than expected.  No
critical consequences like kernel panic or memory corruption happen

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260715031002.108504-7-sj@kernel.org
Link: https://lore.kernel.org/20260703172417.95426-1-sj@kernel.org [1]
Fixes: 8d009da32f13 ("mm/damon/sysfs: set damon_ctx->min_sz_region only for paddr use case")
Signed-off-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 53f99f05eb38e..7f52470be36e3 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1440,14 +1440,16 @@ static inline bool damon_sysfs_kdamond_running(
 static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 		struct damon_sysfs_context *sys_ctx)
 {
+	enum damon_ops_id ops_id;
 	int err;
 
-	err = damon_select_ops(ctx, sys_ctx->ops_id);
+	ops_id = READ_ONCE(sys_ctx->ops_id);
+	err = damon_select_ops(ctx, ops_id);
 	if (err)
 		return err;
 	ctx->addr_unit = READ_ONCE(sys_ctx->addr_unit);
 	/* addr_unit is respected by only DAMON_OPS_PADDR */
-	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
+	if (ops_id == DAMON_OPS_PADDR)
 		ctx->min_sz_region = max(
 				DAMON_MIN_REGION / ctx->addr_unit, 1);
 	err = damon_sysfs_set_attrs(ctx, sys_ctx->attrs);
-- 
2.53.0



