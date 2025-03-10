Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5C323644A;
	Mon, 10 Mar 2025 18:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741630534; cv=none; b=ArKNwo/5nvsNXSqXWZh4LkdC2OLt4ye0SpsUT/V2xZ7bNBRsxqknnTW9Nr7tkYdoWYH4JTqPNVm428r+XgeFHnKB7mSOjLBaxYS9f6zjabw63tWhKAZqJvfKM2Jse0f3E0n0BtjWFzl4LnGmWvztOrzcZEb6Kr8vTY4lLFUGG1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741630534; c=relaxed/simple;
	bh=LToPF2A1MexopEuHTOBHZVrZS6vPxByuGfg6m32zols=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seSKdhPw+SClqZNnyjR6xUC3qkfMoUY6Xd84bbIw8k4ISLswgOtdtL23iTNtm0Dnzkqq827y+RuGhDLXn2agkHCWzXuSLFKYwiNzH54WH3/XzWR0rrJU07H88FEArWB2AWwhXEk5oz+aPE0tHhWVsVmZ5lLgCWXpepr5VcIg8DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uz18IzDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uz18IzDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FA3C4CEEC;
	Mon, 10 Mar 2025 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741630534;
	bh=LToPF2A1MexopEuHTOBHZVrZS6vPxByuGfg6m32zols=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uz18IzDYcuFs7QwrXvbbTeMNVFg/SzjYUD3VKfyedG5IZHxMSdPnOUCIgdVIpCMhh
	 JHDIYOwQ7trL26I020u+koSfRDN0MmoY+KSDf8EV3RmohLI3vLiP69TZCPd149W7E3
	 WB7WAp+lidTNqgJ7OaYf97x9VA0AqNGh2I8V9Tcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	huangshaobo <huangshaobo6@huawei.com>,
	chenzefeng <chenzefeng2@huawei.com>,
	Marco Elver <elver@google.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Wangbing <wangbing6@huawei.com>,
	Jubin Zhong <zhongjubin@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 447/620] kfence: enable check kfence canary on panic via boot param
Date: Mon, 10 Mar 2025 18:04:53 +0100
Message-ID: <20250310170603.239224040@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: huangshaobo <huangshaobo6@huawei.com>

[ Upstream commit 3c81b3bb0a33e2b555edb8d7eb99a7ae4f17d8bb ]

Out-of-bounds accesses that aren't caught by a guard page will result in
corruption of canary memory.  In pathological cases, where an object has
certain alignment requirements, an out-of-bounds access might never be
caught by the guard page.  Such corruptions, however, are only detected on
kfree() normally.  If the bug causes the kernel to panic before kfree(),
KFENCE has no opportunity to report the issue.  Such corruptions may also
indicate failing memory or other faults.

To provide some more information in such cases, add the option to check
canary bytes on panic.  This might help narrow the search for the panic
cause; but, due to only having the allocation stack trace, such reports
are difficult to use to diagnose an issue alone.  In most cases, such
reports are inactionable, and is therefore an opt-in feature (disabled by
default).

[akpm@linux-foundation.org: add __read_mostly, per Marco]
Link: https://lkml.kernel.org/r/20220425022456.44300-1-huangshaobo6@huawei.com
Signed-off-by: huangshaobo <huangshaobo6@huawei.com>
Suggested-by: chenzefeng <chenzefeng2@huawei.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Wangbing <wangbing6@huawei.com>
Cc: Jubin Zhong <zhongjubin@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: e64f81946adf ("kfence: skip __GFP_THISNODE allocations on NUMA systems")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/kfence/core.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 1a2dc187a72f9..0d1a66811c32b 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -21,6 +21,8 @@
 #include <linux/log2.h>
 #include <linux/memblock.h>
 #include <linux/moduleparam.h>
+#include <linux/notifier.h>
+#include <linux/panic_notifier.h>
 #include <linux/random.h>
 #include <linux/rcupdate.h>
 #include <linux/sched/clock.h>
@@ -93,6 +95,10 @@ module_param_named(skip_covered_thresh, kfence_skip_covered_thresh, ulong, 0644)
 static bool kfence_deferrable __read_mostly = IS_ENABLED(CONFIG_KFENCE_DEFERRABLE);
 module_param_named(deferrable, kfence_deferrable, bool, 0444);
 
+/* If true, check all canary bytes on panic. */
+static bool kfence_check_on_panic __read_mostly;
+module_param_named(check_on_panic, kfence_check_on_panic, bool, 0444);
+
 /* The pool of pages used for guard pages and objects. */
 char *__kfence_pool __ro_after_init;
 EXPORT_SYMBOL(__kfence_pool); /* Export for test modules. */
@@ -697,6 +703,31 @@ static int kfence_debugfs_init(void)
 
 late_initcall(kfence_debugfs_init);
 
+/* === Panic Notifier ====================================================== */
+
+static void kfence_check_all_canary(void)
+{
+	int i;
+
+	for (i = 0; i < CONFIG_KFENCE_NUM_OBJECTS; i++) {
+		struct kfence_metadata *meta = &kfence_metadata[i];
+
+		if (meta->state == KFENCE_OBJECT_ALLOCATED)
+			for_each_canary(meta, check_canary_byte);
+	}
+}
+
+static int kfence_check_canary_callback(struct notifier_block *nb,
+					unsigned long reason, void *arg)
+{
+	kfence_check_all_canary();
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kfence_check_canary_notifier = {
+	.notifier_call = kfence_check_canary_callback,
+};
+
 /* === Allocation Gate Timer ================================================ */
 
 static struct delayed_work kfence_timer;
@@ -784,6 +815,9 @@ void __init kfence_init(void)
 	else
 		INIT_DELAYED_WORK(&kfence_timer, toggle_allocation_gate);
 
+	if (kfence_check_on_panic)
+		atomic_notifier_chain_register(&panic_notifier_list, &kfence_check_canary_notifier);
+
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
 
-- 
2.39.5



