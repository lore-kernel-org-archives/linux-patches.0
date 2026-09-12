Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC2032F6931;
	Sat, 12 Sep 2026 19:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240664; cv=none; b=skHgB7dKlYR8iq1sITr/lNCtiDhWretaJRop52keyVOrHQUN3aaARHeBphmFLGFvtn0jdgpR0ApOKxm3Sv5Af1Adnpt85mSXokdn7BCEKTe5SckLmJdDDDXX69iB40A+n8TfpDPc2jfg1N24RSxbzXQlOMzZtt47Z+wQ2uUO01k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240664; c=relaxed/simple;
	bh=n7ZBaHy6U88bwg2aR+EfwN0429tmwdAZuN5ZbklDYBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iffTH7792VmZ1+mWJySvvDQISdcpslnNVGXVECHkDvCBtln2ubT2ddJVOOFEdDvO3R0UKRxIhDvopFlW/G2eCKG2ZsFpq9tt8HkLPbrjDgSjkGNqKOg6fdjUPfZjJwuXYQuUVIKefS0kKaqudCBL9XDy0/isoE56IM6YI/toOzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhLUA0aU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhLUA0aU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD971F000FF;
	Sat, 12 Sep 2026 19:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240662;
	bh=p28EhmwCNAWYdy9EimBMqkG2/ILA4dnvsQzE//HkX0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vhLUA0aUSQUMrGKCowLMq3vSqgVJXiXekWLPN2qxk+WIWopLQw8avXNzHsWTzmpje
	 gDqG+pxnEQH/onlK/Y4C+QK1TdwfVUcLEsUd0I6lWpdP65FZ1kla0DU503/emg4Af3
	 xQVNAYiWTP83YpdmYRAYUjMVMJKsi0m/dQzfplZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 915/935] selftests/arm64: Treat KSM merge_across_nodes as optional
Date: Sat, 12 Sep 2026 09:05:45 +0200
Message-ID: <20260912065547.805263828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

From: Muhammad Usama Anjum <usama.anjum@arm.com>

[ Upstream commit 1a0dba077f34a2f8faa98308d30d4b546d073145 ]

The MTE KSM test requires write access to KSM sysfs but does not check
that it is running as root. It also unconditionally saves, enables and
restores the merge_across_nodes attribute. The kernel only creates this
attribute when CONFIG_NUMA=y, so a non-NUMA kernel prints the following
message three times even though every KSM subtest passes:

  # ERR: missing /sys/kernel/mm/ksm/merge_across_nodes

Skip the test when it is not running as root. Check that the optional
attribute is readable and writable, treating ENOENT as its expected
absence on non-NUMA kernels and skipping the test for other access
failures. Only save, enable and restore the attribute when it is
available.

Check MTE availability before the privilege and sysfs checks so systems
without MTE retain the existing feature-unavailable skip result.

This preserves the existing behavior on NUMA kernels without requiring
NUMA or reducing KSM coverage on single-node systems.

Fixes: f981d8fa2646 ("kselftest/arm64: Verify KSM page merge for MTE pages")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/arm64/mte/check_ksm_options.c   | 29 +++++++++++++++++--
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/arm64/mte/check_ksm_options.c b/tools/testing/selftests/arm64/mte/check_ksm_options.c
index b5c0845fdbb35..a947e6413e562 100644
--- a/tools/testing/selftests/arm64/mte/check_ksm_options.c
+++ b/tools/testing/selftests/arm64/mte/check_ksm_options.c
@@ -6,6 +6,7 @@
 #include <errno.h>
 #include <fcntl.h>
 #include <signal.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -22,6 +23,20 @@
 
 static size_t page_sz;
 static unsigned long ksm_sysfs[5];
+static bool has_merge_across_nodes;
+
+static bool merge_across_nodes_available(void)
+{
+	const char *path = PATH_KSM "merge_across_nodes";
+
+	if (!access(path, R_OK | W_OK))
+		return true;
+	if (errno == ENOENT)
+		return false;
+
+	ksft_exit_skip("Unable to read and write %s: %s\n", path,
+		       strerror(errno));
+}
 
 static unsigned long read_sysfs(char *str)
 {
@@ -56,8 +71,10 @@ static void write_sysfs(char *str, unsigned long val)
 
 static void mte_ksm_setup(void)
 {
-	ksm_sysfs[0] = read_sysfs(PATH_KSM "merge_across_nodes");
-	write_sysfs(PATH_KSM "merge_across_nodes", 1);
+	if (has_merge_across_nodes) {
+		ksm_sysfs[0] = read_sysfs(PATH_KSM "merge_across_nodes");
+		write_sysfs(PATH_KSM "merge_across_nodes", 1);
+	}
 	ksm_sysfs[1] = read_sysfs(PATH_KSM "sleep_millisecs");
 	write_sysfs(PATH_KSM "sleep_millisecs", 0);
 	ksm_sysfs[2] = read_sysfs(PATH_KSM "run");
@@ -70,7 +87,8 @@ static void mte_ksm_setup(void)
 
 static void mte_ksm_restore(void)
 {
-	write_sysfs(PATH_KSM "merge_across_nodes", ksm_sysfs[0]);
+	if (has_merge_across_nodes)
+		write_sysfs(PATH_KSM "merge_across_nodes", ksm_sysfs[0]);
 	write_sysfs(PATH_KSM "sleep_millisecs", ksm_sysfs[1]);
 	write_sysfs(PATH_KSM "run", ksm_sysfs[2]);
 	write_sysfs(PATH_KSM "max_page_sharing", ksm_sysfs[3]);
@@ -137,6 +155,11 @@ int main(int argc, char *argv[])
 	err = mte_default_setup();
 	if (err)
 		return err;
+
+	if (geteuid() != 0)
+		ksft_exit_skip("Please run the test as root\n");
+
+	has_merge_across_nodes = merge_across_nodes_available();
 	page_sz = getpagesize();
 	if (!page_sz) {
 		ksft_print_msg("ERR: Unable to get page size\n");
-- 
2.53.0



