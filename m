Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657A11E489;
	Wed, 17 Sep 2025 12:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113040; cv=none; b=fUICGlUGiwjlLI09nQ4k/RbDKolZsJ2M3grDZLtAN8pteYp1TTX0UOLcV+bxpvDwOkXg/p9nwVuWx2c1mljDZ2LaPWCkXVI+VoyEcXn84U3HIzvXXJTWPF1b9cOm23qp34G8gSx5IkJ0PunNe1Ji+5MwDxRJ19fZ9fRn/j4vBZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113040; c=relaxed/simple;
	bh=n1Xj2jNwdoAGwAMVI+Pv91gZhhXqyscfg8ET0FkpMIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gTxw1BpoDw53wLU7VcQiEM7jKVz52IlYJNjSlyF0NpWI9xsGOXBzi+TPDgAIcbgqJ1VRY+IRR3M2poT0mHBMw2ss0y5k9WAiXFrg6WAu/aoIlfDV7ZkFJXGMRN/9lq2Jwx5He5Gm8E5pY/Y7ynKg1mT7LKvQxG76tqgHGHg8jz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXZA+ijz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXZA+ijz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A0FC4CEF0;
	Wed, 17 Sep 2025 12:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113040;
	bh=n1Xj2jNwdoAGwAMVI+Pv91gZhhXqyscfg8ET0FkpMIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXZA+ijzSi9uORPNbICwuIPdFWnuP7syXLSzrqUrI/lajgn7UIvC4Sh5N6tFhZoPA
	 O0GkKkFpAg0W7RtulFVaqDFp3ldOTGx9JpW/qrgDmih5XgoX5zT0NvdjuKbkmcnCbs
	 IaI///W4BuWLiFWm2mcX8wcG2yjeAi/JcjrV+fE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanislav Fort <disclosure@aisle.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 108/189] mm/damon/sysfs: fix use-after-free in state_show()
Date: Wed, 17 Sep 2025 14:33:38 +0200
Message-ID: <20250917123354.507964964@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fort <stanislav.fort@aisle.com>

commit 3260a3f0828e06f5f13fac69fb1999a6d60d9cff upstream.

state_show() reads kdamond->damon_ctx without holding damon_sysfs_lock.
This allows a use-after-free race:

CPU 0                         CPU 1
-----                         -----
state_show()                  damon_sysfs_turn_damon_on()
ctx = kdamond->damon_ctx;     mutex_lock(&damon_sysfs_lock);
                              damon_destroy_ctx(kdamond->damon_ctx);
                              kdamond->damon_ctx = NULL;
                              mutex_unlock(&damon_sysfs_lock);
damon_is_running(ctx);        /* ctx is freed */
mutex_lock(&ctx->kdamond_lock); /* UAF */

(The race can also occur with damon_sysfs_kdamonds_rm_dirs() and
damon_sysfs_kdamond_release(), which free or replace the context under
damon_sysfs_lock.)

Fix by taking damon_sysfs_lock before dereferencing the context, mirroring
the locking used in pid_show().

The bug has existed since state_show() first accessed kdamond->damon_ctx.

Link: https://lkml.kernel.org/r/20250905101046.2288-1-disclosure@aisle.com
Fixes: a61ea561c871 ("mm/damon/sysfs: link DAMON for virtual address spaces monitoring")
Signed-off-by: Stanislav Fort <disclosure@aisle.com>
Reported-by: Stanislav Fort <disclosure@aisle.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1243,14 +1243,18 @@ static ssize_t state_show(struct kobject
 {
 	struct damon_sysfs_kdamond *kdamond = container_of(kobj,
 			struct damon_sysfs_kdamond, kobj);
-	struct damon_ctx *ctx = kdamond->damon_ctx;
-	bool running;
+	struct damon_ctx *ctx;
+	bool running = false;
 
-	if (!ctx)
-		running = false;
-	else
+	if (!mutex_trylock(&damon_sysfs_lock))
+		return -EBUSY;
+
+	ctx = kdamond->damon_ctx;
+	if (ctx)
 		running = damon_sysfs_ctx_running(ctx);
 
+	mutex_unlock(&damon_sysfs_lock);
+
 	return sysfs_emit(buf, "%s\n", running ?
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_ON] :
 			damon_sysfs_cmd_strs[DAMON_SYSFS_CMD_OFF]);


