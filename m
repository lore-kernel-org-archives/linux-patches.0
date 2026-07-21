Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECE82335555;
	Tue, 21 Jul 2026 15:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648782; cv=none; b=Ev3OwRCBdrkmnrYFHF5+xlcA/5vDM5xpZ139uv0VPk+UDSRNpDTYzaeSwpm3oI28+zSNKtT5vjgWpKPntAZttQusS39bB4KSjf1Yb+PFiukUe2/0EVzJoyaa3jpIDu1ZIjqnkdOSkT3EjN259TwDHCNJe/02P0eVzVQpto4suYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648782; c=relaxed/simple;
	bh=IOgEWu6ZJfcCXxIeP9/JjmWlNOc3T+1B3A19YeDT59Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PA//ogcxF3EiWaZjfknpEaOv1g3hkf7Yqijm9EOv3Q4rX8SASvBnBTfopmkDcIbiCQG0mR5CEL6Xy8hZJVWhhzkY/2ww2BDiZ8pOrimx2hgUdfTVGjjCLyJvIwWSfle+zxGI18g+65YAClj44PbuoXj6oDj1tAZw1Vj7YwPxpRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ee5QbYVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ee5QbYVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606151F00A3A;
	Tue, 21 Jul 2026 15:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648780;
	bh=X63p6fCxosZWe12moBib3HHg7le+YjLDoJlcUJ7s0Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ee5QbYVo3mCdFkoOIL8Locuub5zw/Vpv5Iq7WeTK4dlRJA4tO8fXMRa4Qy3c3FqQg
	 uRT/XD98+vC9nOoh81GBSYmjrBRQc/AtwbcHCWoCPEULOJNjZ7lIl9xzJb+7KagS5l
	 Q/gqhiAoJDe3Jal1QcnNC9DYJeBkVG8+6yycNCLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jia He <justin.he@arm.com>,
	David Disseldorp <ddiss@suse.de>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0330/2077] init/initramfs_test: wait_for_initramfs() before running
Date: Tue, 21 Jul 2026 17:00:03 +0200
Message-ID: <20260721152600.466677833@linuxfoundation.org>
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
index 2ce38d9a8fd0fa..a4c06ec3436899 100644
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
@@ -510,8 +512,21 @@ static struct kunit_case __refdata initramfs_test_cases[] = {
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



