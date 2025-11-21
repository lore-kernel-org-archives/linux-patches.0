Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D152773F7;
	Fri, 21 Nov 2025 13:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731373; cv=none; b=AA01JxH73CD963tQiYR1rtmukAVJyDHT51ngcaHjyIpor3UxOL90BTKsMz6/1xCQvYZ4hEk2GHYIxcU8xoxSAwh0FJSsHk6/hPCqRih/sV3JerJG0jbtZtdCv9n9WCr0nDK+PB/Jvm9lC042FMcibReafPsnBPd4d7DzHM+pUIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731373; c=relaxed/simple;
	bh=klBc34g2dsASy2vaxZB3E7Ap0e+wHATrHkJ9AaNnSoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZAVoJ54eaZWVmEGYW/5IyUmYJZcDY9TymBayONKSzCQeGV/NuZT5O/fYevKQdxYVsg1QAvwXlHU20P5qoM5tvDAPuBoPJ06KU5Yu9UY8HvqjSk2W29AV64M0bG/3VOxrKOltKQommBVhd2d10LN0okxtLCbmfljFUMNPcYU69A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D4/HcFxJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D4/HcFxJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85BB6C116C6;
	Fri, 21 Nov 2025 13:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731372;
	bh=klBc34g2dsASy2vaxZB3E7Ap0e+wHATrHkJ9AaNnSoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D4/HcFxJ7xE/BTbMGaHQrGuDEJA8R1SofkV6X4WVQn9rXqH2IJcXQ/l/RMM3t8A0P
	 u9qj6QgOOvF5hiS35e6ZHFtLnvxu1oDmpVpffSEy/kuTCgXA8FN1bIQ6JEzOX/gwrB
	 erkMexTvuA6jgtC1K4nVbh/1Lj5qngdfXM78E//k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quanmin Yan <yanquanmin1@huawei.com>,
	SeongJae Park <sj@kernel.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	ze zuo <zuoze1@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 184/247] mm/damon/stat: change last_refresh_jiffies to a global variable
Date: Fri, 21 Nov 2025 14:12:11 +0100
Message-ID: <20251121130201.327088609@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Quanmin Yan <yanquanmin1@huawei.com>

commit 2f6ce7e714ef842e43120ecd6a7ed287b502026d upstream.

Patch series "mm/damon: fixes for the jiffies-related issues", v2.

On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
jiffies wrap bugs appear earlier.  However, this may cause the
time_before() series of functions to return unexpected values, resulting
in DAMON not functioning as intended.  Meanwhile, similar issues exist in
some specific user operation scenarios.

This patchset addresses these issues.  The first patch is about the
DAMON_STAT module, and the second patch is about the core layer's sysfs.


This patch (of 2):

In DAMON_STAT's damon_stat_damon_call_fn(), time_before_eq() is used to
avoid unnecessarily frequent stat update.

On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
jiffies wrap bugs appear earlier.  However, this causes time_before_eq()
in DAMON_STAT to unexpectedly return true during the first 5 minutes after
boot on 32-bit systems (see [1] for more explanation, which fixes another
jiffies-related issue before).  As a result, DAMON_STAT does not update
any monitoring results during that period, which becomes more confusing
when DAMON_STAT_ENABLED_DEFAULT is enabled.

There is also an issue unrelated to the system's word size[2]: if the user
stops DAMON_STAT just after last_refresh_jiffies is updated and restarts
it after 5 seconds or a longer delay, last_refresh_jiffies will retain an
older value, causing time_before_eq() to return false and the update to
happen earlier than expected.

Fix these issues by making last_refresh_jiffies a global variable and
initializing it each time DAMON_STAT is started.

Link: https://lkml.kernel.org/r/20251030020746.967174-2-yanquanmin1@huawei.com
Link: https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com [1]
Link: https://lore.kernel.org/all/20251028143250.50144-1-sj@kernel.org/ [2]
Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Suggested-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: ze zuo <zuoze1@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/stat.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -41,6 +41,8 @@ MODULE_PARM_DESC(memory_idle_ms_percenti
 
 static struct damon_ctx *damon_stat_context;
 
+static unsigned long damon_stat_last_refresh_jiffies;
+
 static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
 {
 	struct damon_target *t;
@@ -125,13 +127,12 @@ static void damon_stat_set_idletime_perc
 static int damon_stat_damon_call_fn(void *data)
 {
 	struct damon_ctx *c = data;
-	static unsigned long last_refresh_jiffies;
 
 	/* avoid unnecessarily frequent stat update */
-	if (time_before_eq(jiffies, last_refresh_jiffies +
+	if (time_before_eq(jiffies, damon_stat_last_refresh_jiffies +
 				msecs_to_jiffies(5 * MSEC_PER_SEC)))
 		return 0;
-	last_refresh_jiffies = jiffies;
+	damon_stat_last_refresh_jiffies = jiffies;
 
 	damon_stat_set_estimated_memory_bandwidth(c);
 	damon_stat_set_idletime_percentiles(c);
@@ -204,6 +205,8 @@ static int damon_stat_start(void)
 	err = damon_start(&damon_stat_context, 1, true);
 	if (err)
 		return err;
+
+	damon_stat_last_refresh_jiffies = jiffies;
 	call_control.data = damon_stat_context;
 	return damon_call(damon_stat_context, &call_control);
 }


