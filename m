Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C78EB4C6803;
	Wed,  9 Sep 2026 13:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961991; cv=none; b=I6XyQ5pwNeHbRaC5QVbn4B86w+yzwn7ywiOp/sD6PN+kCDZOKt4cxwaEEV92AfHHy5Gsw2tavFXZq9Z6CNjWSyAKKPopCwVah6vnpduTG4T63qiAlMFr7JylUuqpDSkRosdVUxB9xtd5goXxs7iaC2yv44uOJonuM6YrRDjgf4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961991; c=relaxed/simple;
	bh=gEruQXa1ojRfxI2kqVaWbKNd8ZxI8rhyFpF6dPUIWB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=th+3DyQukrrgLYw8CDTEmTtHa2hR2x4OYh+I8RY5wVW61uEajsCiBrr4DA8C+rPg6reDyoGcISFUP77PwoSP24L7UhjPeqa0FiH2PISPD+H6LxhqKBJTf1+xxOfwgTSAuXKs6QFzlw89P4b5rJwQdT/pjsi64fkMz121n17UOoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ATaKALSb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ATaKALSb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C691F00A3A;
	Wed,  9 Sep 2026 13:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961989;
	bh=kFUgZ8URcGQ9Ez6OAlMByHh90MX/66MofpEgs+USpi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ATaKALSbt4c6zxnI4BuDtq2M2SJqIduwJ89MaWXOxjArj60x9rbu32UwX+pEkLSaZ
	 bVmy44CPGZigVKXsf+QCcdBnt9QgXkm2vCSkpjI0FLME8PDPy5RCPzzxRdxBXdtemq
	 H6CmT/hK4oNa9xs8ot7+UucOpU9O9kt5ORz5UlTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Viktor Malik <vmalik@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 7.2 136/556] perf trace: Factor out BPF loop body
Date: Wed,  9 Sep 2026 15:36:56 +0200
Message-ID: <20260909134235.242991460@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Viktor Malik <vmalik@redhat.com>

commit acff3e1a9cc29a6a039b76b81a438c56016bc0e3 upstream.

The BPF program in augmented_raw_syscalls uses a for loop to iterate all
syscall arguments. The loop body is quite complex and often poses
problems for the BPF verifier. As a preparation step for addressing this
issue, factor out the loop body into a separate function.

Signed-off-by: Viktor Malik <vmalik@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/bpf_skel/augmented_raw_syscalls.bpf.c |  128 ++++++++++--------
 1 file changed, 73 insertions(+), 55 deletions(-)

--- a/tools/perf/util/bpf_skel/augmented_raw_syscalls.bpf.c
+++ b/tools/perf/util/bpf_skel/augmented_raw_syscalls.bpf.c
@@ -429,15 +429,80 @@ static bool pid_filter__has(struct pids_
 	return bpf_map_lookup_elem(pids, &pid) != NULL;
 }
 
+/*
+ * Determine what type of argument and how many bytes to read from user space, using the
+ * value in the beauty_map. This is the relation of parameter type and its corresponding
+ * value in the beauty map, and how many bytes we read eventually:
+ *
+ * string: 1			      -> size of string
+ * struct: size of struct	      -> size of struct
+ * buffer: -1 * (index of paired len) -> value of paired len (maximum: TRACE_AUG_MAX_BUF)
+ */
+static inline int augment_arg(struct syscall_enter_args *args, int i,
+			      unsigned int *beauty_map,
+			      struct augmented_arg *payload_offset)
+{
+	int index, value_size = sizeof(struct augmented_arg) - offsetof(struct augmented_arg, value);
+	s64 aug_size, size;
+	bool augmented;
+	void *arg;
+
+	arg = (void *)args->args[i];
+	augmented = false;
+	size = beauty_map[i];
+	aug_size = size; /* size of the augmented data read from user space */
+
+	if (size == 0 || arg == NULL)
+		return 0;
+
+	if (size == 1) { /* string */
+		aug_size = bpf_probe_read_user_str(payload_offset->value, value_size, arg);
+		/* minimum of 0 to pass the verifier */
+		if (aug_size < 0)
+			aug_size = 0;
+
+		augmented = true;
+	} else if (size > 0 && size <= value_size) { /* struct */
+		if (!bpf_probe_read_user(payload_offset->value, size, arg))
+			augmented = true;
+	} else if ((int)size < 0 && size >= -6) { /* buffer */
+		index = -(size + 1);
+		barrier_var(index); // Prevent clang (noticed with v18) from removing the &= 7 trick.
+		index &= 7;	    // Satisfy the bounds checking with the verifier in some kernels.
+		aug_size = args->args[index] > TRACE_AUG_MAX_BUF ? TRACE_AUG_MAX_BUF : args->args[index];
+
+		if (aug_size > 0) {
+			if (!bpf_probe_read_user(payload_offset->value, aug_size, arg))
+				augmented = true;
+		}
+	}
+
+	/* Augmented data size is limited to sizeof(augmented_arg->unnamed union with value field) */
+	if (aug_size > value_size)
+		aug_size = value_size;
+
+	/* write data to payload */
+	if (augmented) {
+		int written = offsetof(struct augmented_arg, value) + aug_size;
+
+		if (written < 0 || written > sizeof(struct augmented_arg))
+			return -1;
+
+		payload_offset->size = aug_size;
+		return written;
+	}
+
+	return 0;
+}
+
 static int augment_sys_enter(void *ctx, struct syscall_enter_args *args)
 {
-	bool augmented, do_output = false;
-	int zero = 0, index, value_size = sizeof(struct augmented_arg) - offsetof(struct augmented_arg, value);
+	bool do_output = false;
+	int zero = 0, written;
 	u64 output = 0; /* has to be u64, otherwise it won't pass the verifier */
-	s64 aug_size, size;
 	unsigned int nr, *beauty_map;
 	struct beauty_payload_enter *payload;
-	void *arg, *payload_offset;
+	void *payload_offset;
 
 	/* fall back to do predefined tail call */
 	if (args == NULL)
@@ -457,58 +522,11 @@ static int augment_sys_enter(void *ctx,
 	/* copy the sys_enter header, which has the syscall_nr */
 	__builtin_memcpy(&payload->args, args, sizeof(struct syscall_enter_args));
 
-	/*
-	 * Determine what type of argument and how many bytes to read from user space, using the
-	 * value in the beauty_map. This is the relation of parameter type and its corresponding
-	 * value in the beauty map, and how many bytes we read eventually:
-	 *
-	 * string: 1			      -> size of string
-	 * struct: size of struct	      -> size of struct
-	 * buffer: -1 * (index of paired len) -> value of paired len (maximum: TRACE_AUG_MAX_BUF)
-	 */
 	for (int i = 0; i < 6; i++) {
-		arg = (void *)args->args[i];
-		augmented = false;
-		size = beauty_map[i];
-		aug_size = size; /* size of the augmented data read from user space */
-
-		if (size == 0 || arg == NULL)
-			continue;
-
-		if (size == 1) { /* string */
-			aug_size = bpf_probe_read_user_str(((struct augmented_arg *)payload_offset)->value, value_size, arg);
-			/* minimum of 0 to pass the verifier */
-			if (aug_size < 0)
-				aug_size = 0;
-
-			augmented = true;
-		} else if (size > 0 && size <= value_size) { /* struct */
-			if (!bpf_probe_read_user(((struct augmented_arg *)payload_offset)->value, size, arg))
-				augmented = true;
-		} else if ((int)size < 0 && size >= -6) { /* buffer */
-			index = -(size + 1);
-			barrier_var(index); // Prevent clang (noticed with v18) from removing the &= 7 trick.
-			index &= 7;	    // Satisfy the bounds checking with the verifier in some kernels.
-			aug_size = args->args[index] > TRACE_AUG_MAX_BUF ? TRACE_AUG_MAX_BUF : args->args[index];
-
-			if (aug_size > 0) {
-				if (!bpf_probe_read_user(((struct augmented_arg *)payload_offset)->value, aug_size, arg))
-					augmented = true;
-			}
-		}
-
-		/* Augmented data size is limited to sizeof(augmented_arg->unnamed union with value field) */
-		if (aug_size > value_size)
-			aug_size = value_size;
-
-		/* write data to payload */
-		if (augmented) {
-			int written = offsetof(struct augmented_arg, value) + aug_size;
-
-			if (written < 0 || written > sizeof(struct augmented_arg))
-				return 1;
-
-			((struct augmented_arg *)payload_offset)->size = aug_size;
+		written = augment_arg(args, i, beauty_map, (struct augmented_arg *)payload_offset);
+		if (written < 0)
+			return 1;
+		if (written > 0) {
 			output += written;
 			payload_offset += written;
 			do_output = true;


