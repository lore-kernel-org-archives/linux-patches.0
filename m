Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6CC1E98EF;
	Sun,  7 Jun 2026 10:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827177; cv=none; b=dTpQYKGTYWEBP/6HKf6X6h1Qrpzq5PThUAF8IF+fFPTmW0xH5KXs6WRUJLKMF2P61I9Q3HxuMCeLyvchtdpPS+ctb4UTItX6aE6E4OzK76I3CEDrkq5w9IRD+ZjygB5ONPx1Grme4EI1AdoKPCNG6jiecysd+awURDPTCWv0Zqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827177; c=relaxed/simple;
	bh=Bi2oaocvpWL3JFXIF//x/Tzl9qFiROYUxntUC5JysGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YR5GtxYl1+TA+XQ3QhT6enjQbvHYvXzaAwgenDh2yJc2n+HOro+tZjSLCdWajY7kLeNBRzSo6F0EGpUHBkGKmddmOUYonaqObmQMv1+HYSyJcFXxNJWdS0GsNWbLyCRa7JojYtBnRgyV9Z4d3IlpEjlmGnTFe0uccEtU4J/OWZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MF62AZma; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MF62AZma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32A81F00893;
	Sun,  7 Jun 2026 10:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827176;
	bh=2pH70HtxF+YgcnZ87zhNzWXfLnKbJMwWZmVLrWqnfek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MF62AZmaiGGS3YqRQyeyiXGO+O5xCCIkt/VQSawi6Sja1MffiRpVwUrs+WPmihapX
	 CtmdKR+7qbk3aSwsS1ME3w6YQcR8ZF+ZoKb09nmJITF4YxcltSJtTb+Z/QnYBSGeOD
	 6maq79o7Ma79VDKmHwvWnX8cgOkRxxV1EoPXcDmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Schmaus <florian.schmaus@codasip.com>,
	Martin Kaiser <martin@kaiser.cx>,
	David Gow <david@davidgow.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/307] kunit: fix use-after-free in debugfs when using kunit.filter
Date: Sun,  7 Jun 2026 11:57:06 +0200
Message-ID: <20260607095728.727040766@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Florian Schmaus <florian.schmaus@codasip.com>

[ Upstream commit fb6988b83b4cafe8db63999c1ddff1b7c66d2ff5 ]

When the kernel is booted with a kunit filter (e.g.,
kunit.filter="speed!=slow"), the kunit executor dynamically allocates
copies of the filtered test suites using kmalloc/kmemdup.

During the initial boot execution, kunit_debugfs_create_suite() creates
debugfs files (such as /sys/kernel/debug/kunit/<suite>/run) and
permanently stores a pointer to the dynamically allocated suite in the
inode's i_private field.

Previously, the executor freed this dynamically allocated suite_set
immediately after executing the boot-time tests. Because the debugfs
nodes were not destroyed, any subsequent interaction with the debugfs
`run` file from userspace triggered a use-after-free (UAF). On systems
with architectural capabilities, like CHERI RISC-V, this resulted in
an immediate fatal hardware exception due to the invalidation of the
capability tags on the reclaimed memory. On other architectures, it
resulted in silent memory corruption.

Fix this UAF by properly coupling the lifetime of the filtered suite
memory allocation to the lifetime of the kunit subsystem and its
associated VFS nodes. Ownership of the boot-time suite_set is now
transferred to a global tracker ('kunit_boot_suites'), and the memory
is cleanly released in kunit_exit() during module teardown.

Link: https://lore.kernel.org/r/20260507084854.233984-1-florian.schmaus@codasip.com
Fixes: e2219db280e3 ("kunit: add debugfs /sys/kernel/debug/kunit/<suite>/results display")
Signed-off-by: Florian Schmaus <florian.schmaus@codasip.com>
Reviewed-by: Martin Kaiser <martin@kaiser.cx>
Reviewed-by: David Gow <david@davidgow.net>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/kunit/test.h |  1 +
 lib/kunit/executor.c | 19 ++++++++++++++++---
 lib/kunit/test.c     |  1 +
 3 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/include/kunit/test.h b/include/kunit/test.h
index 34b71e42fb107c..6132faa314fcb8 100644
--- a/include/kunit/test.h
+++ b/include/kunit/test.h
@@ -547,6 +547,7 @@ unsigned long kunit_vm_mmap(struct kunit *test, struct file *file,
 			    unsigned long offset);
 
 void kunit_cleanup(struct kunit *test);
+void kunit_free_boot_suites(void);
 
 void __printf(2, 3) kunit_log_append(struct string_stream *log, const char *fmt, ...);
 
diff --git a/lib/kunit/executor.c b/lib/kunit/executor.c
index 34b7b6833df3d5..7cd1c87eb2edfb 100644
--- a/lib/kunit/executor.c
+++ b/lib/kunit/executor.c
@@ -15,6 +15,16 @@ extern struct kunit_suite * const __kunit_suites_end[];
 extern struct kunit_suite * const __kunit_init_suites_start[];
 extern struct kunit_suite * const __kunit_init_suites_end[];
 
+static struct kunit_suite_set kunit_boot_suites;
+
+void kunit_free_boot_suites(void)
+{
+	if (kunit_boot_suites.start) {
+		kunit_free_suite_set(kunit_boot_suites);
+		kunit_boot_suites = (struct kunit_suite_set){ NULL, NULL };
+	}
+}
+
 static char *action_param;
 
 module_param_named(action, action_param, charp, 0400);
@@ -392,9 +402,12 @@ int kunit_run_all_tests(void)
 		pr_err("kunit executor: unknown action '%s'\n", action_param);
 
 free_out:
-	if (filter_glob_param || filter_param)
-		kunit_free_suite_set(suite_set);
-	else if (init_num_suites > 0)
+	if (filter_glob_param || filter_param) {
+		if (err)
+			kunit_free_suite_set(suite_set);
+		else
+			kunit_boot_suites = suite_set;
+	} else if (init_num_suites > 0)
 		/* Don't use kunit_free_suite_set because suites aren't individually allocated */
 		kfree(suite_set.start);
 
diff --git a/lib/kunit/test.c b/lib/kunit/test.c
index 089c832e3cdbd5..b808826e6de2cf 100644
--- a/lib/kunit/test.c
+++ b/lib/kunit/test.c
@@ -954,6 +954,7 @@ static void __exit kunit_exit(void)
 	kunit_bus_shutdown();
 
 	kunit_debugfs_cleanup();
+	kunit_free_boot_suites();
 }
 module_exit(kunit_exit);
 
-- 
2.53.0



