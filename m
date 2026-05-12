Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CCDB336891;
	Tue, 12 May 2026 18:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609497; cv=none; b=oZX4hmBNk4BQXEXZVGw9JWjkEf3a5xN8FmJ6QjHDS58ZMxaK6UGu9r04Mk3dmSvUryT27jBgvPYbO9nqV/jYLnOZOldBbS6vx3B0gJb/tnrDG+WJME8T4h+gt89LgUenRS/VkRRy6GDjIyRRHiJ8aLPV3KTX/6+kEpWWwp0hk4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609497; c=relaxed/simple;
	bh=2F4nI40DFkUMCQ6e5aFfCFNUGnv1VKwg1SnUKP/1ZsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaWtZ0BMoSyZVNKLRL67r4szvOqQtKtdGQwfrGPgBgUoLIRW8DMlbNcSpTukuv5i9I9nh14hb+RwvfkdTKLEN3znPzS0HopYvBNZiId6apZkHYwY9qsr/PTWMj/ZVYmJlliSU3gJbvrKkL/7jdtFUGiObOrK0linNiipXJiVWLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KygW2WRJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KygW2WRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F0EC2BCB0;
	Tue, 12 May 2026 18:11:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609497;
	bh=2F4nI40DFkUMCQ6e5aFfCFNUGnv1VKwg1SnUKP/1ZsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KygW2WRJNJcTbhNlqaGMoSECAvynHX9XDfmVIuMx8BdBASrYKHDJcS9AMQ8Zi2kaF
	 uaqSEwVFzjV1afeJSEe+HKronF2fXY9hUCbJ1U//WyPLes7AiU0OCLh3Iu0K/+n7+h
	 fQ+Dgh35I8VhyiV51soy26IooSes3if2ed8p1iks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 219/307] mm/damon/stat: detect and use fresh enabled value
Date: Tue, 12 May 2026 19:40:14 +0200
Message-ID: <20260512173944.738269146@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit f98590bc08d4aea435e1c2213e38bae0d9e9a7bb upstream.

DAMON_STAT updates 'enabled' parameter value, which represents the running
status of its kdamond, when the user explicitly requests start/stop of the
kdamond.  The kdamond can, however, be stopped even if the user explicitly
requested the stop, if ctx->regions_score_histogram allocation failure at
beginning of the execution of the kdamond.  Hence, if the kdamond is
stopped by the allocation failure, the value of the parameter can be
stale.

Users could show the stale value and be confused.  The problem will only
rarely happen in real and common setups because the allocation is arguably
too small to fail.  Also, unlike the similar bugs that are now fixed in
DAMON_RECLAIM and DAMON_LRU_SORT, kdamond can be restarted in this case,
because DAMON_STAT force-updates the enabled parameter value for user
inputs.  The bug is a bug, though.

The issue stems from the fact that there are multiple events that can
change the status, and following all the events is challenging.
Dynamically detect and use the fresh status for the parameters when those
are requested.

The issue was dicovered [1] by Sashiko.

Link: https://lore.kernel.org/20260419161003.79176-4-sj@kernel.org
Link: https://lore.kernel.org/20260416040602.88665-1-sj@kernel.org [1]
Fixes: 369c415e6073 ("mm/damon: introduce DAMON_STAT module")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: <stable@vger.kernel.org> # 6.17.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/stat.c |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -19,14 +19,17 @@
 static int damon_stat_enabled_store(
 		const char *val, const struct kernel_param *kp);
 
+static int damon_stat_enabled_load(char *buffer,
+		const struct kernel_param *kp);
+
 static const struct kernel_param_ops enabled_param_ops = {
 	.set = damon_stat_enabled_store,
-	.get = param_get_bool,
+	.get = damon_stat_enabled_load,
 };
 
 static bool enabled __read_mostly = IS_ENABLED(
 	CONFIG_DAMON_STAT_ENABLED_DEFAULT);
-module_param_cb(enabled, &enabled_param_ops, &enabled, 0600);
+module_param_cb(enabled, &enabled_param_ops, NULL, 0600);
 MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
 
 static unsigned long estimated_memory_bandwidth __read_mostly;
@@ -273,17 +276,23 @@ static void damon_stat_stop(void)
 	damon_stat_context = NULL;
 }
 
+static bool damon_stat_enabled(void)
+{
+	if (!damon_stat_context)
+		return false;
+	return damon_is_running(damon_stat_context);
+}
+
 static int damon_stat_enabled_store(
 		const char *val, const struct kernel_param *kp)
 {
-	bool is_enabled = enabled;
 	int err;
 
 	err = kstrtobool(val, &enabled);
 	if (err)
 		return err;
 
-	if (is_enabled == enabled)
+	if (damon_stat_enabled() == enabled)
 		return 0;
 
 	if (!damon_initialized())
@@ -293,16 +302,17 @@ static int damon_stat_enabled_store(
 		 */
 		return 0;
 
-	if (enabled) {
-		err = damon_stat_start();
-		if (err)
-			enabled = false;
-		return err;
-	}
+	if (enabled)
+		return damon_stat_start();
 	damon_stat_stop();
 	return 0;
 }
 
+static int damon_stat_enabled_load(char *buffer, const struct kernel_param *kp)
+{
+	return sprintf(buffer, "%c\n", damon_stat_enabled() ? 'Y' : 'N');
+}
+
 static int __init damon_stat_init(void)
 {
 	int err = 0;


