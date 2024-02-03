Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9D810A1F;
	Sat,  3 Feb 2024 04:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933692; cv=none; b=VOSYXbL5hJuxtkvnrl+kmFE1b40cg/Fk/8AUfB4DHgQWf+6Fnb2DuY6yvqeRLn1PJJ6rdlmWT7Z+uUprsJrXdiNz0tyIwHXWK+K/c2+iL9tZDWn+HQmbSeluTZJhinMsKC9wpqL4LFC0S8cUy645xhl7heKmuTh5nJoITRvFaSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933692; c=relaxed/simple;
	bh=XpsHwfU7bsmbHwfb6eCVf4PL51NgpnhIaNiX+1Njkgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XdBgCJ0n3zaYw9DTCJCEmZjEwqf9ioUeruftBd2O3dLoCLLFnR14Y8PlXLd4PVi2R/+EsPdKHKxng0t/uneYa6+F0BT6XY8d54hIZK7m9blz7YGbPLR4pQFyfWH6k1C1LUVDhQPvjhhljZt8NpYNCHUq+asJmXQgpFrIhoQtfM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQXskG88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQXskG88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910EAC43394;
	Sat,  3 Feb 2024 04:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933692;
	bh=XpsHwfU7bsmbHwfb6eCVf4PL51NgpnhIaNiX+1Njkgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQXskG887ZaRlYTNdIvc9gLZCsIvUeQpmaKm3IzhVMt5f/Sw559D2WPceJFcwCAoG
	 o3ui8eNbmIG+yneztSmW/h1D1yWa2a9zhb9/6xUEIR8sZSrAVpGdBJNiqelrExwAm8
	 /1eVUoSouwvvpDGaalYFrYyAcIVYL3o7aCDrq6W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Rae Moar <rmoar@google.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Marco Pagani <marpagan@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 265/322] kunit: run test suites only after module initialization completes
Date: Fri,  2 Feb 2024 20:06:02 -0800
Message-ID: <20240203035407.692810772@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marco Pagani <marpagan@redhat.com>

[ Upstream commit a1af6a2bfa0cb46d70b7df5352993e750da6c79b ]

Commit 2810c1e99867 ("kunit: Fix wild-memory-access bug in
kunit_free_suite_set()") fixed a wild-memory-access bug that could have
happened during the loading phase of test suites built and executed as
loadable modules. However, it also introduced a problematic side effect
that causes test suites modules to crash when they attempt to register
fake devices.

When a module is loaded, it traverses the MODULE_STATE_UNFORMED and
MODULE_STATE_COMING states before reaching the normal operating state
MODULE_STATE_LIVE. Finally, when the module is removed, it moves to
MODULE_STATE_GOING before being released. However, if the loading
function load_module() fails between complete_formation() and
do_init_module(), the module goes directly from MODULE_STATE_COMING to
MODULE_STATE_GOING without passing through MODULE_STATE_LIVE.

This behavior was causing kunit_module_exit() to be called without
having first executed kunit_module_init(). Since kunit_module_exit() is
responsible for freeing the memory allocated by kunit_module_init()
through kunit_filter_suites(), this behavior was resulting in a
wild-memory-access bug.

Commit 2810c1e99867 ("kunit: Fix wild-memory-access bug in
kunit_free_suite_set()") fixed this issue by running the tests when the
module is still in MODULE_STATE_COMING. However, modules in that state
are not fully initialized, lacking sysfs kobjects. Therefore, if a test
module attempts to register a fake device, it will inevitably crash.

This patch proposes a different approach to fix the original
wild-memory-access bug while restoring the normal module execution flow
by making kunit_module_exit() able to detect if kunit_module_init() has
previously initialized the tests suite set. In this way, test modules
can once again register fake devices without crashing.

This behavior is achieved by checking whether mod->kunit_suites is a
virtual or direct mapping address. If it is a virtual address, then
kunit_module_init() has allocated the suite_set in kunit_filter_suites()
using kmalloc_array(). On the contrary, if mod->kunit_suites is still
pointing to the original address that was set when looking up the
.kunit_test_suites section of the module, then the loading phase has
failed and there's no memory to be freed.

v4:
- rebased on 6.8
- noted that kunit_filter_suites() must return a virtual address
v3:
- add a comment to clarify why the start address is checked
v2:
- add include <linux/mm.h>

Fixes: 2810c1e99867 ("kunit: Fix wild-memory-access bug in kunit_free_suite_set()")
Reviewed-by: David Gow <davidgow@google.com>
Tested-by: Rae Moar <rmoar@google.com>
Tested-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Marco Pagani <marpagan@redhat.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kunit/executor.c |  4 ++++
 lib/kunit/test.c     | 14 +++++++++++---
 2 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
index 1236b3cd2fbb..51013feba58b 100644
--- a/lib/kunit/executor.c
+++ b/lib/kunit/executor.c
@@ -144,6 +144,10 @@ void kunit_free_suite_set(struct kunit_suite_set suite_set)
 	kfree(suite_set.start);
 }
 
+/*
+ * Filter and reallocate test suites. Must return the filtered test suites set
+ * allocated at a valid virtual address or NULL in case of error.
+ */
 struct kunit_suite_set
 kunit_filter_suites(const struct kunit_suite_set *suite_set,
 		    const char *filter_glob,
diff --git a/lib/kunit/test.c b/lib/kunit/test.c
index 7452d1a2acd9..1d151f6dc1cd 100644
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -16,6 +16,7 @@
 #include <linux/panic.h>
 #include <linux/sched/debug.h>
 #include <linux/sched.h>
+#include <linux/mm.h>
 
 #include "debugfs.h"
 #include "hooks-impl.h"
@@ -807,12 +808,19 @@ static void kunit_module_exit(struct module *mod)
 	};
 	const char *action = kunit_action();
 
+	/*
+	 * Check if the start address is a valid virtual address to detect
+	 * if the module load sequence has failed and the suite set has not
+	 * been initialized and filtered.
+	 */
+	if (!suite_set.start || !virt_addr_valid(suite_set.start))
+		return;
+
 	if (!action)
 		__kunit_test_suites_exit(mod->kunit_suites,
 					 mod->num_kunit_suites);
 
-	if (suite_set.start)
-		kunit_free_suite_set(suite_set);
+	kunit_free_suite_set(suite_set);
 }
 
 static int kunit_module_notify(struct notifier_block *nb, unsigned long val,
@@ -822,12 +830,12 @@ static int kunit_module_notify(struct notifier_block *nb, unsigned long val,
 
 	switch (val) {
 	case MODULE_STATE_LIVE:
+		kunit_module_init(mod);
 		break;
 	case MODULE_STATE_GOING:
 		kunit_module_exit(mod);
 		break;
 	case MODULE_STATE_COMING:
-		kunit_module_init(mod);
 		break;
 	case MODULE_STATE_UNFORMED:
 		break;
-- 
2.43.0



