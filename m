Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB6B954B1C6;
	Wed,  9 Sep 2026 13:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961815; cv=none; b=iMcJ+K7cUIyY7fBm/kwXvf5e5wIYZRFJfEi5pf7lfvVGuGN+Z9Zo1wLZRN6AvYW/ChCuYEy5hB3lVWrPQUgqwiZLNgJxG3UNI9Oi9unk+0DZjZRL3b7sJXtjm1ZOVD/EuUyfOJpKYhOyq0V6Q731Z0xoo+IKHdCH3ORFOtlB7c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961815; c=relaxed/simple;
	bh=32eQrAKKEeGy2Vuri3TXymhBJluQJg4lm92xroqmPxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l/JL/yAXvmcAJ4zjZB5R8MIq9SciU03imNGhp8F/DVteYqfNh5d+m0B1B8HQN9bWLgK4YoOA2ZQ03djV7wicmp7DKDRPUBtQrf/2m0uhUYHIbW9efFzyuS+M9lGBqZCVTWpQScvejhSLQTiL9i5qgdYGqZ8j0i3EW8wpKhgrrTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eJSiBjyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eJSiBjyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A1B1F00A3A;
	Wed,  9 Sep 2026 13:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961814;
	bh=H3TryBrUPoDb8cGxpa4V4uxGSRJiRC3rgxE79ypQrE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJSiBjyUx3MAs4F1yKQEWQohJ0Ns2fal2l4VE8LMl0VEjq0i+M4yIgWoq1kpXeyF+
	 auqERXEv/A3KqteUB4y3L+bCZP1gQfijv/IdZbUa4s21OMy8gwpQyzI1XNdMKx5R9V
	 B4R+FfMieEPgx6GH9EElEPRm8ETixu9Pa0WbTb3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 074/556] mm/damon/sysfs: read ops_id only once in damon_sysfs_apply_inputs()
Date: Wed,  9 Sep 2026 15:35:54 +0200
Message-ID: <20260909134233.100564625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

commit 5adaaa28be8a79ddd7e103b171f9d6e14e7fc26e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2042,14 +2042,16 @@ static inline bool damon_sysfs_kdamond_r
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
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;


