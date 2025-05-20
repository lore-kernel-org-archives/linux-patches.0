Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAA22459FE;
	Tue, 20 May 2025 13:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749391; cv=none; b=VEak57YLihJm+apieNG1TUdeys7h8uJw5FsrMwljbHNJZzwM1GgjiQwMX7uOuvyyD0Ea+Qs79ssbLt/4kfIOrJdsUg3qYs3AMS0/ZMslXLVfUiFvmJ2NVwZIrui8Xxpaps4MJ2MF5xWBX4gYJkf4jUdBwGQv44fVz3dcmWabG2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749391; c=relaxed/simple;
	bh=cltzuY1C74a2llN2oNVTC04YRmHVetVTeZCww2cYhjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iX/I72KkSu0AkU3OC/X/58XGCZaWb2w53wnu4UR2DAN8htT5UN5nUFir8LwESXYpdM2zHf1naN1WD07b2tcDvzrmm6S58+0PshrKkhDUW7BPQslwRWNRe0zFEbSehLSuibvVgGCQ7LATo6G3AxC487Q7PnB8DNUNIru9RUNHaXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GZ3SBBDP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GZ3SBBDP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817E4C4CEEF;
	Tue, 20 May 2025 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749391;
	bh=cltzuY1C74a2llN2oNVTC04YRmHVetVTeZCww2cYhjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GZ3SBBDPaJGLCq6d6buADDHG6hlhdjGYbqVGa7awHOEfIt26e7TRXOC5ZU5CYe1u4
	 jUzs7vnG4xSXHUh4lm+Toe2dcBtq6obPzsMJiqNa/4M75RQb2W1MRj8PaVTbImwuz2
	 F6rVICcG140pgUnsMSD5O85EGc0syYG7N7Ku6r8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 06/97] selftests/exec: Build both static and non-static load_address tests
Date: Tue, 20 May 2025 15:49:31 +0200
Message-ID: <20250520125800.914764503@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125800.653047540@linuxfoundation.org>
References: <20250520125800.653047540@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit b57a2907c9d96c56494ef25f8ec821cd0b355dd6 ]

After commit 4d1cd3b2c5c1 ("tools/testing/selftests/exec: fix link
error"), the load address alignment tests tried to build statically.
This was silently ignored in some cases. However, after attempting to
further fix the build by switching to "-static-pie", the test started
failing. This appears to be due to non-PT_INTERP ET_DYN execs ("static
PIE") not doing alignment correctly, which remains unfixed[1]. See commit
aeb7923733d1 ("revert "fs/binfmt_elf: use PT_LOAD p_align values for
static PIE"") for more details.

Provide rules to build both static and non-static PIE binaries, improve
debug reporting, and perform several test steps instead of a single
all-or-nothing test. However, do not actually enable static-pie tests;
alignment specification is only supported for ET_DYN with PT_INTERP
("regular PIE").

Link: https://bugzilla.kernel.org/show_bug.cgi?id=215275 [1]
Link: https://lore.kernel.org/r/20240508173149.677910-1-keescook@chromium.org
Signed-off-by: Kees Cook <kees@kernel.org>
Stable-dep-of: 11854fe263eb ("binfmt_elf: Move brk for static PIE even if ASLR disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/exec/Makefile       | 19 +++---
 tools/testing/selftests/exec/load_address.c | 67 +++++++++++++++++----
 2 files changed, 66 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index a0b8688b08369..b54986078d7ea 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -3,8 +3,13 @@ CFLAGS = -Wall
 CFLAGS += -Wno-nonnull
 CFLAGS += -D_GNU_SOURCE
 
+ALIGNS := 0x1000 0x200000 0x1000000
+ALIGN_PIES        := $(patsubst %,load_address.%,$(ALIGNS))
+ALIGN_STATIC_PIES := $(patsubst %,load_address.static.%,$(ALIGNS))
+ALIGNMENT_TESTS   := $(ALIGN_PIES)
+
 TEST_PROGS := binfmt_script.py
-TEST_GEN_PROGS := execveat load_address_4096 load_address_2097152 load_address_16777216 non-regular
+TEST_GEN_PROGS := execveat non-regular $(ALIGNMENT_TESTS)
 TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile
@@ -28,9 +33,9 @@ $(OUTPUT)/execveat.symlink: $(OUTPUT)/execveat
 $(OUTPUT)/execveat.denatured: $(OUTPUT)/execveat
 	cp $< $@
 	chmod -x $@
-$(OUTPUT)/load_address_4096: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000 -pie -static $< -o $@
-$(OUTPUT)/load_address_2097152: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x200000 -pie -static $< -o $@
-$(OUTPUT)/load_address_16777216: load_address.c
-	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=0x1000000 -pie -static $< -o $@
+$(OUTPUT)/load_address.0x%: load_address.c
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=$(lastword $(subst ., ,$@)) \
+		-fPIE -pie $< -o $@
+$(OUTPUT)/load_address.static.0x%: load_address.c
+	$(CC) $(CFLAGS) $(LDFLAGS) -Wl,-z,max-page-size=$(lastword $(subst ., ,$@)) \
+		-fPIE -static-pie $< -o $@
diff --git a/tools/testing/selftests/exec/load_address.c b/tools/testing/selftests/exec/load_address.c
index 17e3207d34ae7..8257fddba8c8d 100644
--- a/tools/testing/selftests/exec/load_address.c
+++ b/tools/testing/selftests/exec/load_address.c
@@ -5,11 +5,13 @@
 #include <link.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <stdbool.h>
 #include "../kselftest.h"
 
 struct Statistics {
 	unsigned long long load_address;
 	unsigned long long alignment;
+	bool interp;
 };
 
 int ExtractStatistics(struct dl_phdr_info *info, size_t size, void *data)
@@ -26,11 +28,20 @@ int ExtractStatistics(struct dl_phdr_info *info, size_t size, void *data)
 	stats->alignment = 0;
 
 	for (i = 0; i < info->dlpi_phnum; i++) {
+		unsigned long long align;
+
+		if (info->dlpi_phdr[i].p_type == PT_INTERP) {
+			stats->interp = true;
+			continue;
+		}
+
 		if (info->dlpi_phdr[i].p_type != PT_LOAD)
 			continue;
 
-		if (info->dlpi_phdr[i].p_align > stats->alignment)
-			stats->alignment = info->dlpi_phdr[i].p_align;
+		align = info->dlpi_phdr[i].p_align;
+
+		if (align > stats->alignment)
+			stats->alignment = align;
 	}
 
 	return 1;  // Terminate dl_iterate_phdr.
@@ -38,27 +49,57 @@ int ExtractStatistics(struct dl_phdr_info *info, size_t size, void *data)
 
 int main(int argc, char **argv)
 {
-	struct Statistics extracted;
-	unsigned long long misalign;
+	struct Statistics extracted = { };
+	unsigned long long misalign, pow2;
+	bool interp_needed;
+	char buf[1024];
+	FILE *maps;
 	int ret;
 
 	ksft_print_header();
-	ksft_set_plan(1);
+	ksft_set_plan(4);
+
+	/* Dump maps file for debugging reference. */
+	maps = fopen("/proc/self/maps", "r");
+	if (!maps)
+		ksft_exit_fail_msg("FAILED: /proc/self/maps: %s\n", strerror(errno));
+	while (fgets(buf, sizeof(buf), maps)) {
+		ksft_print_msg("%s", buf);
+	}
+	fclose(maps);
 
+	/* Walk the program headers. */
 	ret = dl_iterate_phdr(ExtractStatistics, &extracted);
 	if (ret != 1)
 		ksft_exit_fail_msg("FAILED: dl_iterate_phdr\n");
 
-	if (extracted.alignment == 0)
-		ksft_exit_fail_msg("FAILED: No alignment found\n");
-	else if (extracted.alignment & (extracted.alignment - 1))
-		ksft_exit_fail_msg("FAILED: Alignment is not a power of 2\n");
+	/* Report our findings. */
+	ksft_print_msg("load_address=%#llx alignment=%#llx\n",
+		       extracted.load_address, extracted.alignment);
+
+	/* If we're named with ".static." we expect no INTERP. */
+	interp_needed = strstr(argv[0], ".static.") == NULL;
+
+	/* Were we built as expected? */
+	ksft_test_result(interp_needed == extracted.interp,
+			 "%s INTERP program header %s\n",
+			 interp_needed ? "Wanted" : "Unwanted",
+			 extracted.interp ? "seen" : "missing");
+
+	/* Did we find an alignment? */
+	ksft_test_result(extracted.alignment != 0,
+			 "Alignment%s found\n", extracted.alignment ? "" : " NOT");
+
+	/* Is the alignment sane? */
+	pow2 = extracted.alignment & (extracted.alignment - 1);
+	ksft_test_result(pow2 == 0,
+			 "Alignment is%s a power of 2: %#llx\n",
+			 pow2 == 0 ? "" : " NOT", extracted.alignment);
 
+	/* Is the load address aligned? */
 	misalign = extracted.load_address & (extracted.alignment - 1);
-	if (misalign)
-		ksft_exit_fail_msg("FAILED: alignment = %llu, load_address = %llu\n",
-				   extracted.alignment, extracted.load_address);
+	ksft_test_result(misalign == 0, "Load Address is %saligned (%#llx)\n",
+			 misalign ? "MIS" : "", misalign);
 
-	ksft_test_result_pass("Completed\n");
 	ksft_finished();
 }
-- 
2.39.5



