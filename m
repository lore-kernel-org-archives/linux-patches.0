Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03709221550;
	Tue, 17 Jun 2025 16:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176899; cv=none; b=IK/ttKb47kSTj5DneUG52PUUliVHjQQcaL+llKyRnzo7am9dGzAZe7n/FrbPqN+HPkzYvbtK4GnyJdNXc90bvsUXECx/4MkBs+hB+Nkh5eRBlZlCXrhSmICFQgH/E5krdKnNpF5snOBAemgXvMtWjZuMXJG7xv5fJD2S+i83nms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176899; c=relaxed/simple;
	bh=wEzG6Kytl2HqQ35jWEPpsS0ue3Y8lzEMUbvtBJHxwmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9BdmAuolFUZtiQn7IyKgf6FtvQuuOr1iEF3ADPXIe8wtt1XaWF2yqriwnl4uCiRRYKqhfHgIAtJbMILVrfdSvhAg4NyvtgtcT1iGwxRUc9dY7JISCMv4jHCP8WXrVeKgg60ERKILG2Z/sX8iIxGHFr8BUADGIjpPajwwh4PNwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pbiveEmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pbiveEmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B794C4CEE7;
	Tue, 17 Jun 2025 16:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176898;
	bh=wEzG6Kytl2HqQ35jWEPpsS0ue3Y8lzEMUbvtBJHxwmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pbiveEmD4HKl4pUxRIJgT8sMnwltnWTiPXSGOazMlzNaBVmsCydLYmdnDW36Q1lUz
	 BRua1PdJDAcGDvjPa1+1fYp6t8z0s/ZBeg08K2XDAg9FKW2zlXtbjj8dHv7vMHBYge
	 9NCTGNMuXEqkP1bS56YjrdnbizruXQzwmuObHySc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Feng Yang <yangfeng@kylinos.cn>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 218/780] libbpf: Fix event name too long error
Date: Tue, 17 Jun 2025 17:18:46 +0200
Message-ID: <20250617152500.334554690@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit 4dde20b1aa85d69c4281eaac9a7cfa7d2b62ecf0 ]

When the binary path is excessively long, the generated probe_name in libbpf
exceeds the kernel's MAX_EVENT_NAME_LEN limit (64 bytes).
This causes legacy uprobe event attachment to fail with error code -22.

The fix reorders the fields to place the unique ID before the name.
This ensures that even if truncation occurs via snprintf, the unique ID
remains intact, preserving event name uniqueness. Additionally, explicit
checks with MAX_EVENT_NAME_LEN are added to enforce length constraints.

Before Fix:
	./test_progs -t attach_probe/kprobe-long_name
	......
	libbpf: failed to add legacy kprobe event for 'bpf_testmod_looooooooooooooooooooooooooooooong_name+0x0': -EINVAL
	libbpf: prog 'handle_kprobe': failed to create kprobe 'bpf_testmod_looooooooooooooooooooooooooooooong_name+0x0' perf event: -EINVAL
	test_attach_kprobe_long_event_name:FAIL:attach_kprobe_long_event_name unexpected error: -22
	test_attach_probe:PASS:uprobe_ref_ctr_cleanup 0 nsec
	#13/11   attach_probe/kprobe-long_name:FAIL
	#13      attach_probe:FAIL

	./test_progs -t attach_probe/uprobe-long_name
	......
	libbpf: failed to add legacy uprobe event for /root/linux-bpf/bpf-next/tools/testing/selftests/bpf/test_progs:0x13efd9: -EINVAL
	libbpf: prog 'handle_uprobe': failed to create uprobe '/root/linux-bpf/bpf-next/tools/testing/selftests/bpf/test_progs:0x13efd9' perf event: -EINVAL
	test_attach_uprobe_long_event_name:FAIL:attach_uprobe_long_event_name unexpected error: -22
	#13/10   attach_probe/uprobe-long_name:FAIL
	#13      attach_probe:FAIL
After Fix:
	./test_progs -t attach_probe/uprobe-long_name
	#13/10   attach_probe/uprobe-long_name:OK
	#13      attach_probe:OK
	Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED

	./test_progs -t attach_probe/kprobe-long_name
	#13/11   attach_probe/kprobe-long_name:OK
	#13      attach_probe:OK
	Summary: 1/1 PASSED, 0 SKIPPED, 0 FAILED

Fixes: 46ed5fc33db9 ("libbpf: Refactor and simplify legacy kprobe code")
Fixes: cc10623c6810 ("libbpf: Add legacy uprobe attaching support")
Signed-off-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250417014848.59321-2-yangfeng59949@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 43 ++++++++++++++++--------------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index cfb952d7002f6..087bb8daa46b5 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -60,6 +60,8 @@
 #define BPF_FS_MAGIC		0xcafe4a11
 #endif
 
+#define MAX_EVENT_NAME_LEN	64
+
 #define BPF_FS_DEFAULT_PATH "/sys/fs/bpf"
 
 #define BPF_INSN_SZ (sizeof(struct bpf_insn))
@@ -11112,16 +11114,16 @@ static const char *tracefs_available_filter_functions_addrs(void)
 			     : TRACEFS"/available_filter_functions_addrs";
 }
 
-static void gen_kprobe_legacy_event_name(char *buf, size_t buf_sz,
-					 const char *kfunc_name, size_t offset)
+static void gen_probe_legacy_event_name(char *buf, size_t buf_sz,
+					const char *name, size_t offset)
 {
 	static int index = 0;
 	int i;
 
-	snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx_%d", getpid(), kfunc_name, offset,
-		 __sync_fetch_and_add(&index, 1));
+	snprintf(buf, buf_sz, "libbpf_%u_%d_%s_0x%zx", getpid(),
+		 __sync_fetch_and_add(&index, 1), name, offset);
 
-	/* sanitize binary_path in the probe name */
+	/* sanitize name in the probe name */
 	for (i = 0; buf[i]; i++) {
 		if (!isalnum(buf[i]))
 			buf[i] = '_';
@@ -11246,9 +11248,9 @@ int probe_kern_syscall_wrapper(int token_fd)
 
 		return pfd >= 0 ? 1 : 0;
 	} else { /* legacy mode */
-		char probe_name[128];
+		char probe_name[MAX_EVENT_NAME_LEN];
 
-		gen_kprobe_legacy_event_name(probe_name, sizeof(probe_name), syscall_name, 0);
+		gen_probe_legacy_event_name(probe_name, sizeof(probe_name), syscall_name, 0);
 		if (add_kprobe_event_legacy(probe_name, false, syscall_name, 0) < 0)
 			return 0;
 
@@ -11304,10 +11306,10 @@ bpf_program__attach_kprobe_opts(const struct bpf_program *prog,
 					    func_name, offset,
 					    -1 /* pid */, 0 /* ref_ctr_off */);
 	} else {
-		char probe_name[256];
+		char probe_name[MAX_EVENT_NAME_LEN];
 
-		gen_kprobe_legacy_event_name(probe_name, sizeof(probe_name),
-					     func_name, offset);
+		gen_probe_legacy_event_name(probe_name, sizeof(probe_name),
+					    func_name, offset);
 
 		legacy_probe = strdup(probe_name);
 		if (!legacy_probe)
@@ -11851,20 +11853,6 @@ static int attach_uprobe_multi(const struct bpf_program *prog, long cookie, stru
 	return ret;
 }
 
-static void gen_uprobe_legacy_event_name(char *buf, size_t buf_sz,
-					 const char *binary_path, uint64_t offset)
-{
-	int i;
-
-	snprintf(buf, buf_sz, "libbpf_%u_%s_0x%zx", getpid(), binary_path, (size_t)offset);
-
-	/* sanitize binary_path in the probe name */
-	for (i = 0; buf[i]; i++) {
-		if (!isalnum(buf[i]))
-			buf[i] = '_';
-	}
-}
-
 static inline int add_uprobe_event_legacy(const char *probe_name, bool retprobe,
 					  const char *binary_path, size_t offset)
 {
@@ -12288,13 +12276,14 @@ bpf_program__attach_uprobe_opts(const struct bpf_program *prog, pid_t pid,
 		pfd = perf_event_open_probe(true /* uprobe */, retprobe, binary_path,
 					    func_offset, pid, ref_ctr_off);
 	} else {
-		char probe_name[PATH_MAX + 64];
+		char probe_name[MAX_EVENT_NAME_LEN];
 
 		if (ref_ctr_off)
 			return libbpf_err_ptr(-EINVAL);
 
-		gen_uprobe_legacy_event_name(probe_name, sizeof(probe_name),
-					     binary_path, func_offset);
+		gen_probe_legacy_event_name(probe_name, sizeof(probe_name),
+					    strrchr(binary_path, '/') ? : binary_path,
+					    func_offset);
 
 		legacy_probe = strdup(probe_name);
 		if (!legacy_probe)
-- 
2.39.5



