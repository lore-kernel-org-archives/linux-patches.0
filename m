Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B193415F14;
	Tue, 21 Jul 2026 19:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661685; cv=none; b=YwFX6GFdhHu+rhlYUdrjgIeS/ix1lAee1Ucv9qp8H1lQ6dKuSxc6ULn8t+EpAZDN+1WNXYNdzjEGpJPzw9119rMh99FLmqVqQXoGocKXv84obcH65q+51myzDXbluO8Gmrd2ISaJ3ER/+cU+R+2c9mme6UzgaorYyHeQD1+jUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661685; c=relaxed/simple;
	bh=6zLYkpWeM+42MdQC2LvQd2VrctcnbDF0wzUS3VLXxk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k/fZchDNRFatThQ0BqqXDWFFKAFjIqjIGGBaA+sbbOK3yNR7q64yvfVxZ1LJDH8JbZJhT3YXPYakoNDSbm4pjZ30lihZmqtIbVm12ppM9++lG8iezFYf9K5IEpidFvqbDdfaeXxWhT6LuY0rTRh5K5mgptYHDSLOmlACoj06RRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXXQtpjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXXQtpjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7DF1F000E9;
	Tue, 21 Jul 2026 19:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661683;
	bh=hdYRNzZG247C9E173SUy2PfF9hxCfYfu3bkeoA7YP2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CXXQtpjQRqxfrbo84T98Jph6PPaagGFdBrB3N+3AHn5gYOp6d3AvTpe32ERTV3ARf
	 vJErSZ9MZPdKuovNTTnoZbp1o8aA0vkgvUUfGDkiTfc+RqEoV67MaSmQ7Jui/YU4C9
	 UeQq/nAqBgYnatJYRJPzQU6u71DDml3lJ5ZxxfME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0159/1276] PM: sleep: Use complete() in device_pm_sleep_init()
Date: Tue, 21 Jul 2026 17:10:02 +0200
Message-ID: <20260721152449.658949378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index abb16a5bb79671..6e5586d1e43c5f 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -100,7 +100,7 @@ void device_pm_sleep_init(struct device *dev)
 	dev->power.is_noirq_suspended = false;
 	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
-	complete_all(&dev->power.completion);
+	complete(&dev->power.completion);
 	dev->power.wakeup = NULL;
 	INIT_LIST_HEAD(&dev->power.entry);
 }
@@ -237,6 +237,10 @@ static void dpm_wait(struct device *dev, bool async)
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



