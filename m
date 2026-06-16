Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096733CEBBD;
	Tue, 16 Jun 2026 18:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632965; cv=none; b=ApaCJbUNmjaKrBhg8wIl+ekC1OliwmSOT7SEf/754sT+N/JDhNnNwcKYBArfEzAmE5oP+q835gan+wA1x6cXB4AoUabbmwXszbzfEmZ5Y0YFThEuZZcW3xIO7Ya/pOWhUlE961/KkXLHEKv3GIlHAEpX1qoDWMgXuJR/8p3luVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632965; c=relaxed/simple;
	bh=lwxoO7q1BS4KohOH99CwschGTjg5W8Azreb8Kmqyq3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPvSUWQ0OjewZRTJmjxwO+GuE0YltOEV01q3nzWjhyGYzYqPtNFmtN+pEoefNpdsfcmiad/KN3k/wyiohEea8PkNQBE+9CZcC6WOpZGoorMS9I0ApxgI2sWgJcfsJe1AEX3YX1wgO6TdHYZJwVk3Q8Qmz0CF6IYAc6xlZ5mIgfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKzUS/R+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKzUS/R+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6ED81F000E9;
	Tue, 16 Jun 2026 18:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632963;
	bh=PL1tL2+n/ubm5MbhIpf9WIruAYKdL+iAEPmF3zH543g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JKzUS/R+AJpjhCZq3cnZooOpxBLHSXQLh1VHSQelMwBM+vZf9+29AQ7l51mgzruRE
	 3ZrKUMD3WVfh4cSsEV3K3+lXPWcUCFzSpfckQ9cZGDaygm9MWvNoKG+mOw5mhp4Xo0
	 im0K8Mm30syLa7JOfTVPKD/+U0qPzAj+9s3oCIkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 509/522] mm/damon/core: implement damon_kdamond_pid()
Date: Tue, 16 Jun 2026 20:30:56 +0530
Message-ID: <20260616145149.557561627@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: SeongJae Park <sj@kernel.org>

commit 4262c53236977de3ceaa3bf2aefdf772c9b874dd upstream.

Patch series "mm/damon: hide kdamond and kdamond_lock from API callers".

'kdamond' and 'kdamond_lock' fields initially exposed to DAMON API callers
for flexible synchronization and use cases.  As DAMON API became somewhat
complicated compared to the early days, Keeping those exposed could only
encourage the API callers to invent more creative but complicated and
difficult-to-debug use cases.

Fortunately DAMON API callers didn't invent that many creative use cases.
There exist only two use cases of 'kdamond' and 'kdamond_lock'.  Finding
whether the kdamond is actively running, and getting the pid of the
kdamond.  For the first use case, a dedicated API function, namely
'damon_is_running()' is provided, and all DAMON API callers are using the
function for the use case.  Hence only the second use case is where the
fields are directly being used by DAMON API callers.

To prevent future invention of complicated and erroneous use cases of the
fields, hide the fields from the API callers.  For that, provide new
dedicated DAMON API functions for the remaining use case, namely
damon_kdamond_pid(), migrate DAMON API callers to use the new function,
and mark the fields as private fields.


This patch (of 5):

'kdamond' and 'kdamond_lock' are directly being used by DAMON API callers
for getting the pid of the corresponding kdamond.  To discourage invention
of creative but complicated and erroneous new usages of the fields that
require careful synchronization, implement a new API function that can
simply be used without the manual synchronizations.

Link: https://lkml.kernel.org/r/20260115152047.68415-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20260115152047.68415-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/damon.h |    1 +
 mm/damon/core.c       |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -572,6 +572,7 @@ static inline unsigned int damon_max_nr_
 
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
+int damon_kdamond_pid(struct damon_ctx *ctx);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end);
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -643,6 +643,23 @@ static bool damon_check_reset_time_inter
 	return true;
 }
 
+/**
+ * damon_kdamond_pid() - Return pid of a given DAMON context's worker thread.
+ * @ctx:	The DAMON context of the question.
+ *
+ * Return: pid if @ctx is running, negative error code otherwise.
+ */
+int damon_kdamond_pid(struct damon_ctx *ctx)
+{
+	int pid = -EINVAL;
+
+	mutex_lock(&ctx->kdamond_lock);
+	if (ctx->kdamond)
+		pid = ctx->kdamond->pid;
+	mutex_unlock(&ctx->kdamond_lock);
+	return pid;
+}
+
 /*
  * Check whether it is time to flush the aggregated information
  */


