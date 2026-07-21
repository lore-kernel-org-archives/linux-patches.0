Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8920142EEB8;
	Tue, 21 Jul 2026 22:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671478; cv=none; b=iiueP2zNiAp7y3sRbrgX0dZU1LuZBVKxMIEvjT9c+LCOYt36EzoPlJ7lssWNsEY/Py9iYzwSogrFaSAwuX/o+f9Ur+0PKUzDRR4ZU/csTixT6vsgmE7y+/1R18gQvZTZp0GDQBzjUTXaby788cviqPemThUa91I9J1rzEnbWK1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671478; c=relaxed/simple;
	bh=O594E1yJQNO5JNx1+ka0za3C7CBMaurgDwMOVWi0VHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i7ofnzQU7ur3WzWYM+Xgesz8dUXQS72Yz6CuLM4b6vXXVtHOg3r90RZg5Xun9gFBc3uZwHDkL3yj7I4hHZtJ3di9Ssyc+L2ElwjASAwvMvWVDFQpAHiYHt5Em7D6Ct6zGvwkdr/rkhw7xHjLRNyTldA2bdRjRoWNVwIFpNyaEKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CZOB6r4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CZOB6r4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5061F000E9;
	Tue, 21 Jul 2026 22:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671477;
	bh=pX2rALyXk4+brN0Slk7oE7JntAmqs7rTvDDYmp+dbLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZOB6r4n5F7Pk9pK2/P1GEG6zCbGN+UWGOLq6omy/pFYHDJsA29aM8GyRnTCN5i20
	 IXIOseF6iJ7bHt4v+gKCkRSyTT99G0BscaZ/d/VVN8fypl1sVWGbVd3wp6LbrVzQrJ
	 MMnUOHImlqwMSrKhMSodj1G5vfTvE76kvaXxu568=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 259/843] PM: sleep: Use complete() in device_pm_sleep_init()
Date: Tue, 21 Jul 2026 17:18:14 +0200
Message-ID: <20260721152411.854577244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9cd0a837af4259..3d3e710f71733c 100644
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
@@ -239,6 +239,10 @@ static void dpm_wait(struct device *dev, bool async)
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



