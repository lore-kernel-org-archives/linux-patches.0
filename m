Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD18B3EDE42;
	Tue, 12 May 2026 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608703; cv=none; b=uucCVRSP8n3KaEZx3bxYPAAMXKW16yT//P3KqreeUcRAGteyCNqRgR4ZxT8McdwH1afdLNCOTPrdLr+47S/+POVDRwWGcSzK4Va3ZG8Bf9ILR4qjRp8QvOG4H/fj3pyOvnbDnWnX4GUAEiJYIaOxDHvh86787+wt8geVDKB+EEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608703; c=relaxed/simple;
	bh=iloBqmujaEWSWP6JnZ0xx4XUmAxW0KpZj/MNa+O3EOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n5VrEfLRame2GRcx2cAlgLDYPtD3U9xMLVOxnYlA9bdJWSiUs0Fu8Py9MB0lqYdGvU41OIoU5+8opDPaOOkgy8mJswmzM0RsifK80ricAhjZfjWA3fLqeXUMnrv/UvEjVpQL2c44rXj/seuoV+pyHKvmxctMzfWGPjVLs+GMRb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7ZZLlHA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7ZZLlHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BE9C2BCB0;
	Tue, 12 May 2026 17:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608703;
	bh=iloBqmujaEWSWP6JnZ0xx4XUmAxW0KpZj/MNa+O3EOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7ZZLlHA61rJBmNZ4XmNOw0OCRxZfkvlelH/7AaT5azIBa7UP7bHBZ1YYth70Ezw+
	 zw3Jx6PFcJO8HfBZZb0ojD+UIcmVa5JI8ojZYloXFTc7kwyKvFfF4nUnBGFoCRdADx
	 1f//bgYoGSXXLNkFCA0mKZ0oCFyXENDE0Rx0mTk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 183/270] mm/damon/stat: detect and use fresh enabled value
Date: Tue, 12 May 2026 19:39:44 +0200
Message-ID: <20260512173942.299851733@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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
@@ -265,17 +268,23 @@ static void damon_stat_stop(void)
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
@@ -285,16 +294,17 @@ static int damon_stat_enabled_store(
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


