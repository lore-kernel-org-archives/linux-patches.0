Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F72046F4B0;
	Tue, 21 Jul 2026 17:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656055; cv=none; b=B2yTh8F29bqDzcOpvyycxjdZjvX1e8N6FrUFLZ2gwgI8clJrbXYKDgpfPEue1hbhUh5cW9/VUskO4owu4o5AU+MC9e5EOKw5nffz8+BW7Wnmy5GvpZjKayUX+mzCA/bacolyiSDhJMOtr5qZG4JO4ylJzd4gcyZzBvt/tzHNNGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656055; c=relaxed/simple;
	bh=ZE3ON+IHRbWaBHxewnvIt5KapCDdcX1OLkT1Wzap2C4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnQUslpcVyV9oPbh2B1OkPA+5/uIxZXUd4pnqjjT4yeq0DpE1tCjrinASpfjZnHHr0gIFlqiaoKAluWQlYc6OPQwlc2+xF98sRw0o1uIyvMG/eOzb/EjU7g9nKUwJBCJgAp+uH5thRm+hPdVjJYyIEz1xgwhXYHUk55OrmKgWvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUWIisbg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUWIisbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116981F00A3A;
	Tue, 21 Jul 2026 17:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656054;
	bh=MXNLub2gtd2bgV+9X+rvPYeDR7TYyfII0jTXPda2M6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oUWIisbgChSsmcwEr7mO8ed+rnR6syENCE5fqghFLZ0un1JzVnmdCugD+EAPOcBd5
	 saomC3JGV/7WbEQwock3JovR7a+oaQZ9rzz3N6EwF7aDSZglxkkjKMU0kHji3oMi1u
	 Yqz6euRYFOCQEm8HiQ1XxLP9XpgDU/a+N0ObLfIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia He <justin.he@arm.com>,
	David Disseldorp <ddiss@suse.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0235/1611] init/initramfs_test: wait_for_initramfs() before running
Date: Tue, 21 Jul 2026 17:05:51 +0200
Message-ID: <20260721152520.297750207@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Jia He <justin.he@arm.com>

[ Upstream commit ec3f4e0443a61e68092ac07111f16dd4ca89ddb4 ]

initramfs_test_extract() and friends call unpack_to_rootfs() from a
kunit kthread while do_populate_rootfs() may still be running
asynchronously from rootfs_initcall. unpack_to_rootfs() keeps its
parser state in module-static variables (victim, byte_count, state,
this_header, header_buf, name_buf, ...), so the two writers corrupt
each other.

On arm64 v7.0-rc5+ this oopses early in boot:

  Unable to handle kernel paging request at virtual address ffff80018f9f0ffc
  pc : do_reset+0x3c/0x98
  Call trace:
   do_reset
   initramfs_test_extract
   kunit_try_run_case
  Initramfs unpacking failed: junk within compressed archive

do_reset() faults because 'victim' was overwritten by the boot-time
unpacker; the boot unpacker meanwhile logs the bogus "junk within
compressed archive" on the real initrd because the test wrecked its
state machine.

Add a .suite_init callback that calls wait_for_initramfs() so the async
unpack is quiescent before the first case runs. suite_init runs once per
suite rather than before every individual test case.

Fixes: 83c0b27266ec ("initramfs_test: kunit tests for initramfs unpacking")
Signed-off-by: Jia He <justin.he@arm.com>
Link: https://patch.msgid.link/20260519093937.1064628-1-justin.he@arm.com
Reviewed-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/initramfs_test.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/init/initramfs_test.c b/init/initramfs_test.c
index 5d2db455e60c55..3f0241ca907597 100644
--- a/init/initramfs_test.c
+++ b/init/initramfs_test.c
@@ -3,7 +3,9 @@
 #include <linux/fcntl.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/init.h>
 #include <linux/init_syscalls.h>
+#include <linux/initrd.h>
 #include <linux/stringify.h>
 #include <linux/timekeeping.h>
 #include "initramfs_internal.h"
@@ -462,8 +464,21 @@ static struct kunit_case __refdata initramfs_test_cases[] = {
 	{},
 };
 
-static struct kunit_suite initramfs_test_suite = {
+static int __init initramfs_test_init(struct kunit_suite *suite)
+{
+	/*
+	 * unpack_to_rootfs() uses module-static state (victim, byte_count,
+	 * state, ...). The boot-time async do_populate_rootfs() may still be
+	 * running, so wait for it to finish before we call unpack_to_rootfs()
+	 * from the test thread, otherwise the two writers race and crash.
+	 */
+	wait_for_initramfs();
+	return 0;
+}
+
+static struct kunit_suite __refdata initramfs_test_suite = {
 	.name = "initramfs",
+	.suite_init = initramfs_test_init,
 	.test_cases = initramfs_test_cases,
 };
 kunit_test_init_section_suites(&initramfs_test_suite);
-- 
2.53.0



