Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0D0403B13;
	Tue, 21 Jul 2026 20:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665781; cv=none; b=MCzPuRZa8MkQE7ZmmWG+L5F0ffsD5DF3ZHlGicIYM/ciCrpy6TInZCZwqGe0scRKLgT9s1WvzE9Ud8yXxOV6/6MrULcWSIh31VrMO3+rLnRVl7MBQYr60L8siFoL1GOEo8HkBoPu0GtecgnP/Cq5tg/6RrKVGRrcSNtOf+p9OpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665781; c=relaxed/simple;
	bh=ZYQK/LgOr2nj59SvlpDacZTyfc/kgaqq0Kun+yw2qLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsfKctA9XadkfgEUYrqjlJeZsdYTe2yZUSvm3Mmt4nfgdegWWvDY3sTsptHcRPcxWMv+DlyLYKIb/cT4UghxhOQXj3ygk+6Gq3f2QhmaZJxfSTNJ5eLSPriZ5g47fpYqiDU+KbECdcVEmjXnjw2X76c3xvLA9I3x1fJ6IMff5Ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwdfug6a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwdfug6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7B31F000E9;
	Tue, 21 Jul 2026 20:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665779;
	bh=mmf5W1WIQv1AGgMeovv8NX13F72zSjkc7xOP5aB1VrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwdfug6agV2MHNdd5E0W5WEEg0ub6U2xwVfObbtZ66A2TmQtlMGmROdtx/AeDm3rE
	 73Ioxu00TitjQaMTZDexWw51qbHbxzuUgrAvN/9GXc7Dx1LoriZZRcbAMdiFzlkT/b
	 ToMuhunCKL7ng8/w2ZEavh6oHVH9l3X03j8Z+0hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0433/1266] PM: sleep: Use complete() in device_pm_sleep_init()
Date: Tue, 21 Jul 2026 17:14:30 +0200
Message-ID: <20260721152451.529372204@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>

[ Upstream commit 3855941f1e4069182c895d5093c5fa589f5b38bd ]

Replace complete_all() with complete() in device_pm_sleep_init() to allow
it to be called in atomic contexts without triggering a false-positive
WARNING from lockdep_assert_RT_in_threaded_ctx() when
CONFIG_PROVE_RAW_LOCK_NESTING is enabled.

device_pm_sleep_init() may be called during device initialization while
holding a raw_spinlock (e.g., from within device_initialize()), and
complete_all() is unsafe in atomic contexts on PREEMPT_RT kernels.
complete(), which is safe to call from any context, is sufficient here.

complete_all() sets the completion count to UINT_MAX/2 (permanently
signaled), while complete() increments it by 1. Since no threads can be
waiting during device initialization, both are functionally equivalent.
The completion is always reinitialized via reinit_completion() in
dpm_clear_async_state() before each suspend/resume cycle.

However, changing to complete() introduces a potential deadlock for
devices with no PM support (dev->power.no_pm = true). Such devices are
never added to the dpm_list and never go through dpm_clear_async_state(),
so their completion is never reinitialized. A parent device waiting on a
no_pm child across multiple suspend phases would consume the single-use
token in the first phase and block forever in the second.

Fix this by adding an early return in dpm_wait() when dev->power.no_pm is
set, since no_pm devices do not participate in system suspend/resume.

Fixes: 152e1d592071 ("PM: Prevent waiting forever on asynchronous resume after failing suspend")
Signed-off-by: Jiakai Xu <xujiakai24@mails.ucas.ac.cn>
[ rjw: Subject adjustment ]
Link: https://patch.msgid.link/20260523022314.2657232-1-xujiakai24@mails.ucas.ac.cn
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/power/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index ef5157fc8dcc51..dc3d30860ef328 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -101,7 +101,7 @@ void device_pm_sleep_init(struct device *dev)
 	dev->power.is_noirq_suspended = false;
 	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
-	complete_all(&dev->power.completion);
+	complete(&dev->power.completion);
 	dev->power.wakeup = NULL;
 	INIT_LIST_HEAD(&dev->power.entry);
 }
@@ -238,6 +238,10 @@ static void dpm_wait(struct device *dev, bool async)
 	if (!dev)
 		return;
 
+	/* Devices with no PM support don't use the completion. */
+	if (dev->power.no_pm)
+		return;
+
 	if (async || (pm_async_enabled && dev->power.async_suspend))
 		wait_for_completion(&dev->power.completion);
 }
-- 
2.53.0



