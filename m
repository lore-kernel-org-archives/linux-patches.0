Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC0446D560;
	Tue, 21 Jul 2026 15:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648734; cv=none; b=WOrj7UcZUFU+Nx+FtpxuuslWonziiiDl7jPaP7QHUUALxruR9LV5wvq+EnPIDsfCjClOVBwJgKowTARgQAcqBxO52HEZJ5cj3DD/1w5AGFVvbr0rKZxDSFYOm8jxhDO2Lia5i5mHZeCj8Ru5fs8ujtchhiDbOqD4h3rfCk2b/s0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648734; c=relaxed/simple;
	bh=qTGr/eONlk5/CGvSSHvEFteMSApv2G1ES1zdP2E3lZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oqEnfcagcFI63WeFiz96lCifF5o/1kh4DMjEYuN7BQLhw9ctSBQMIajrda4moes14D/yfNwr6VK063rfE65ARBBtuPA2V+NgmZlUVPIYPqF01Ym9ei2P3SKGoIamuH8LsRL4GZ2xdCyXcKHm0KpQ3+CUGkPa1BMPVtCfh8E80BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ol9bK7m7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ol9bK7m7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C8A11F000E9;
	Tue, 21 Jul 2026 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648733;
	bh=fXI7UE0qrjNVhqZyH1hbWPxiCk4rGBYIg6aWCpIf7nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ol9bK7m7z98RP43i16sZ60vzrI0TLw6a0MhLtk9tFgY/6Uir2wmJx4b9w/xRYxw/F
	 4F6/ZQno+JH8Ddg19b9DKuYZkNMuzwqkps6IapsxuI0MgpHfP0YlE+k/BCUUrg6Bkc
	 eYXcepI3ZCEC69m1ShqtdJwz4vTwcfn9LXi5xQw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiakai Xu <xujiakai24@mails.ucas.ac.cn>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0309/2077] PM: sleep: Use complete() in device_pm_sleep_init()
Date: Tue, 21 Jul 2026 16:59:42 +0200
Message-ID: <20260721152559.968536083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index e1b550664babbf..ed48c292f57576 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -115,7 +115,7 @@ void device_pm_sleep_init(struct device *dev)
 	dev->power.is_noirq_suspended = false;
 	dev->power.is_late_suspended = false;
 	init_completion(&dev->power.completion);
-	complete_all(&dev->power.completion);
+	complete(&dev->power.completion);
 	dev->power.wakeup = NULL;
 	INIT_LIST_HEAD(&dev->power.entry);
 }
@@ -252,6 +252,10 @@ static void dpm_wait(struct device *dev, bool async)
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



