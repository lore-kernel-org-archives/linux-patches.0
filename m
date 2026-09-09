Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFBC856B843;
	Wed,  9 Sep 2026 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963487; cv=none; b=orB3Uk6f8P1piKktDB66j2Ho8rMKRhoOoitGvTZIYh63VJlFNMNDL1ytS3d/Uj5/QBfP8ubhh0l0ld8ZsqfqYDZdm1KwImLXTnhqVkZ058X2eTRe+VP5W0IZSefBGdQiq7KdBZcRse2E95peDs19zPuyz3LS9MrP1CVeN4usZ80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963487; c=relaxed/simple;
	bh=iY+5NSVc8UX7Oqq2IIRCNJ5MejwauNBPdFwQtZBhTms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KstA4ZyMx659EEffA2HCbtvdycb20iW7jlyuE62HPoY323c6LmRotr96ssAk8umQsMzrkdyAgf/spUeoo19db4HkfRf/x9F/Z5p9oniQKUKQyrZDdJCg6sDKydkeLVbSKYKuzGhZAyun896X81UMkVAUdqydfZnscv70YOngqaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ur2d4zR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ur2d4zR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12A2D1F00A3A;
	Wed,  9 Sep 2026 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963485;
	bh=u/0XLZbIS0eui47iB2Ip9QwAU7wGXOuDdmtrxjbwDnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ur2d4zR59vTWKRqPYgVP79tLmnnXyYnz/gIpR8lAni7exl4S+M2ZOg6PtmTo5oLjI
	 uicI6KHUFkgQwvzaWLODrxVA8kL6jcNBN59kDeg6gYx1AI7vtZSy334uuXOrk2GFZX
	 taKr0hICjkL4tu0LAiq+84jxMndK5dtEO7NHlez4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.18 095/583] perf trace: Refactor augmented_raw_syscalls using bpf_for
Date: Wed,  9 Sep 2026 15:36:20 +0200
Message-ID: <20260909134241.419158811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Viktor Malik <vmalik@redhat.com>

commit ea6992784d65ef2c01f3525217dbf3a44afa9917 upstream.

The loop for processing syscall args in augment_raw_syscalls has a
history of breaking with Clang updates, see e.g. commit 013eb043f37b
("perf trace: Fix BPF loading failure (-E2BIG)") from Clang 15 to 16.

Now, a similar thing happened between Clang 21 and 22. While the issue
is mitigated on the main line by a recent verifier update, it remains
broken on the 6.12 and 6.18 stable branches:

    [linux-6.18.y]# sudo perf trace true
    libbpf: prog 'sys_enter': BPF program load failed: -E2BIG
    libbpf: prog 'sys_enter': -- BEGIN PROG LOAD LOG --
    [...]
    BPF program is too large. Processed 1000001 insn
    processed 1000001 insns (limit 1000000) max_states_per_insn 40 total_states 37941 peak_states 232 mark_read 0
    -- END PROG LOAD LOG --
    libbpf: prog 'sys_enter': failed to load: -E2BIG
    libbpf: failed to load object 'augmented_raw_syscalls_bpf'
    libbpf: failed to load BPF skeleton 'augmented_raw_syscalls_bpf': -E2BIG
    Error: failed to get syscall or beauty map fd
    [...]

The reason is that the loop is quite complex and the BPF verifier often
struggles to prove that it terminates.

Fix the issue by replacing the standard for loop with the bpf_for macro,
which uses a numeric BPF iterator. This should prevent future breakages
of this kind since the verifier has a much easier job proving that the
loop terminates.

Small adjustments were necessary for the loop to make it work.  The main
problem is that the verifier sometimes has problems with bpf_for loops
that use a carry-over state, such as the `payload_offset` and `output`
vars here, since the verifier tries to track their values too precisely
and cannot prove loop convergence. To resolve the issue, we (1)
explicitly recompute `payload_offset` in every iteration and (2) use a
trick with adding a global zero to `output` to help the verifier forget
its precise state and use a range instead.

Finally, to keep backwards compatibility with older kernel versions that
don't have bpf_for (i.e. numeric iterators), fall back to standard loop.

Signed-off-by: Viktor Malik <vmalik@redhat.com>
Cc: stable@vger.kernel.org
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Fixes: a68fd6a6cdd3 ("perf trace: Collect augmented data using BPF")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/bpf_skel/augmented_raw_syscalls.bpf.c |   47 +++++++++++++-----
 1 file changed, 35 insertions(+), 12 deletions(-)

--- a/tools/perf/util/bpf_skel/augmented_raw_syscalls.bpf.c
+++ b/tools/perf/util/bpf_skel/augmented_raw_syscalls.bpf.c
@@ -429,6 +429,8 @@ static bool pid_filter__has(struct pids_
 	return bpf_map_lookup_elem(pids, &pid) != NULL;
 }
 
+u64 ZERO = 0;
+
 /*
  * Determine what type of argument and how many bytes to read from user space, using the
  * value in the beauty_map. This is the relation of parameter type and its corresponding
@@ -440,9 +442,10 @@ static bool pid_filter__has(struct pids_
  */
 static inline int augment_arg(struct syscall_enter_args *args, int i,
 			      unsigned int *beauty_map,
-			      struct augmented_arg *payload_offset)
+			      struct beauty_payload_enter *payload, u64 offset)
 {
 	int index, value_size = sizeof(struct augmented_arg) - offsetof(struct augmented_arg, value);
+	struct augmented_arg *payload_offset;
 	s64 aug_size, size;
 	bool augmented;
 	void *arg;
@@ -455,6 +458,12 @@ static inline int augment_arg(struct sys
 	if (size == 0 || arg == NULL)
 		return 0;
 
+	/* bounds check for the verifier */
+	if (offset > sizeof(payload->aug_args) - sizeof(payload->aug_args[0]))
+		return -1;
+	barrier_var(offset);
+	payload_offset = (struct augmented_arg *)((void *)&payload->aug_args + offset);
+
 	if (size == 1) { /* string */
 		aug_size = bpf_probe_read_user_str(payload_offset->value, value_size, arg);
 		/* minimum of 0 to pass the verifier */
@@ -498,11 +507,10 @@ static inline int augment_arg(struct sys
 static int augment_sys_enter(void *ctx, struct syscall_enter_args *args)
 {
 	bool do_output = false;
-	int zero = 0, written;
+	int i, zero = 0, written;
 	u64 output = 0; /* has to be u64, otherwise it won't pass the verifier */
 	unsigned int nr, *beauty_map;
 	struct beauty_payload_enter *payload;
-	void *payload_offset;
 
 	/* fall back to do predefined tail call */
 	if (args == NULL)
@@ -514,7 +522,6 @@ static int augment_sys_enter(void *ctx,
 
 	/* set up payload for output */
 	payload        = bpf_map_lookup_elem(&beauty_payload_enter_map, &zero);
-	payload_offset = (void *)&payload->aug_args;
 
 	if (beauty_map == NULL || payload == NULL)
 		return 1;
@@ -522,14 +529,30 @@ static int augment_sys_enter(void *ctx,
 	/* copy the sys_enter header, which has the syscall_nr */
 	__builtin_memcpy(&payload->args, args, sizeof(struct syscall_enter_args));
 
-	for (int i = 0; i < 6; i++) {
-		written = augment_arg(args, i, beauty_map, (struct augmented_arg *)payload_offset);
-		if (written < 0)
-			return 1;
-		if (written > 0) {
-			output += written;
-			payload_offset += written;
-			do_output = true;
+	if (bpf_ksym_exists(bpf_iter_num_new)) {
+		bpf_for(i, 0, 6) {
+			written = augment_arg(args, i, beauty_map, payload, output);
+			if (written < 0)
+				return 1;
+			if (written > 0) {
+				output += written;
+				/*
+				 * guide the verifier to forget range of `output`, which
+				 * helps to prove convergence of the loop
+				 */
+				output += ZERO;
+				do_output = true;
+			}
+		}
+	} else {
+		for (i = 0; i < 6; i++) {
+			written = augment_arg(args, i, beauty_map, payload, output);
+			if (written < 0)
+				return 1;
+			if (written > 0) {
+				output += written;
+				do_output = true;
+			}
 		}
 	}
 


