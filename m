Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AAD843E071;
	Tue, 21 Jul 2026 22:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673551; cv=none; b=jhH5stx7LzmTVYjnQv3YI9jI56y06qyGa1l9KLGYreqTnu5Ylwdid2WhfenQlgt0JV9lWZyhxi1XsYqyVwmPShovxmvi6E0DXXI37OxyW4X3Cy+xhhxr5tdryWdINC6DnJsq3Eo/yG70gcrMASy+nE/e2pGv0sxa3fynWUqM6oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673551; c=relaxed/simple;
	bh=RpMqQdJyYnb0u2QbLil/KKQOFthHZYouLSa3REjBj2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKtGyk2JPnN4rqE0WCbQuqG8rEV3kJsjUauQl9/OAwbzNxhWk9q9yqoBiJPPYRVyphs0nOJIXXtjMpfAKrYZYjjodEHxgAmVbtBJM9cWnwE5ADs4NvmRf1wikC8Do/0wxwQ5Hz6FdiXdLvNvJG0kvGiPkYQ9l4IRYWCOLmiU2Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fEfC59pX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fEfC59pX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A93B1F000E9;
	Tue, 21 Jul 2026 22:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673548;
	bh=dTlKhffXrhWBIwNClTk33bjU/HEc1O2dufHh8jl67lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fEfC59pX4VazlsuP4txs9CHAseQKQNPHjFqN5gBE3myviiNB10i7mAalI6M9p9OIk
	 QdEfOMHosAkVAq9pTcRGNGt1ZHAB2OldoQYMG2GdD6MWkyC/FQbFOLmYZxL/91LUez
	 oC9Lh1MVYGyVJ920dkVuIdG2KreVMcadEGcK58Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 203/699] PM: sleep: Use complete() in device_pm_sleep_init()
Date: Tue, 21 Jul 2026 17:19:22 +0200
Message-ID: <20260721152400.274002718@linuxfoundation.org>
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
index 964573e30d6910..24a7e280e30076 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -102,7 +102,7 @@ void device_pm_sleep_init(struct device *dev)
 	dev->power.is_noirq_suspended = false;
 	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
-	complete_all(&dev->power.completion);
+	complete(&dev->power.completion);
 	dev->power.wakeup = NULL;
 	INIT_LIST_HEAD(&dev->power.entry);
 }
@@ -242,6 +242,10 @@ static void dpm_wait(struct device *dev, bool async)
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



