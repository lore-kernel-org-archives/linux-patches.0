Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E41D3B42C6;
	Tue, 21 Jul 2026 20:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665839; cv=none; b=Hz76VxOmuqe9n9BqdWz8YPjVvV2+echvvxBjhMY7qAxxXGEIjN0Rsjq91xHSlUXWQ9101ql5E8fz39ILOI4LobALyrNt2wNK6g+PRXM12ARHc5KCmYeLUx40refhrG1CQ7IhR13sK+qjDloR+CNwwUQOmydAmsM6C2U0odrcuzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665839; c=relaxed/simple;
	bh=Zs5EHMm3mGe63DREQRzBHMKRWbYhAJWProMq5HoR36o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VYkYeJMU3eeUnski/drVKyEC3fTxfz3nxc0mg44GEVpLa/CaWg4X24tyzF63wLkuM0rHADorKtgxWjrud8Z8Z1dHNAedQXhfEW2fX7ckbxuN+CCkKUb5bTlBUzrj4eYbNQN19uFMa0OU/WqZH7B72Rc8CkC92x2jccgs3e23wAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XTCMgY9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XTCMgY9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746761F00A3D;
	Tue, 21 Jul 2026 20:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665837;
	bh=nJ1uEetRql8IMiWZmpOzLNjx7LvXgGHWikSlaBUb73s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTCMgY9WaLQOt/Fu0EHG/3PXcKG2ANwWZcXovycAUhKf6zdCZnQpN83eqJa87Zs+j
	 878XbN+13s6EXmVJLLAP0u0a5YFBbgML9P4HetH1PyAf+nX0x8EIfph3jWhlTjFm95
	 8oI1pUXY2nB2fs6Iuz39oDJpKE8S7Nb1QugtylPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Carlos Llamas <cmllamas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0453/1266] libbpf: Fix UAF in strset__add_str()
Date: Tue, 21 Jul 2026 17:14:50 +0200
Message-ID: <20260721152451.973848697@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit b23705e6afb6ac4ae6d220dcb35975698667dd76 ]

strset_add_str_mem() might reallocate the strset data buffer in order to
accommodate the provided string 's'. However, if 's' points to a string
already present in the buffer, it becomes dangling after the realloc.
This leads to a use-after-free when attempting to memcpy() the string
into the new buffer.

One scenario that triggers this problematic path is when resolve_btfids
attempts to patch kfunc prototypes using existing BTF parameter names:

 | resolve_btfids: function bpf_list_push_back_impl already exists in BTF
 | Segmentation fault (core dumped)

Compiling resolve_btfids with fsanitize=address generates a detailed
report of the UAF:

 | =================================================================
 | ERROR: AddressSanitizer: heap-use-after-free on address 0x7f4c4a500bd4
 | ==1507892==ERROR: AddressSanitizer: heap-use-after-free on address 0x7f4c4a500bd4 at pc 0x55d25155a2a8 bp 0x7ffcef879060 sp 0x7ffcef878818
 | READ of size 5 at 0x7f4c4a500bd4 thread T0
 |     #0 0x55d25155a2a7 in memcpy (tools/bpf/resolve_btfids/resolve_btfids+0xcf2a7)
 |     #1 0x55d2515d708e in strset__add_str tools/lib/bpf/strset.c:162:2
 |     #2 0x55d2515c730b in btf__add_str tools/lib/bpf/btf.c:2109:8
 |     #3 0x55d2515c9020 in btf__add_func_param tools/lib/bpf/btf.c:3108:14
 |     #4 0x55d25159f0b5 in process_kfunc_with_implicit_args tools/bpf/resolve_btfids/main.c:1196:9
 |     #5 0x55d25159e004 in btf2btf tools/bpf/resolve_btfids/main.c:1229:9
 |     #6 0x55d25159cee7 in main tools/bpf/resolve_btfids/main.c:1535:6
 |     #7 0x7f4c78e29f76 in __libc_start_call_main csu/../sysdeps/nptl/libc_start_call_main.h:58:16
 |     #8 0x7f4c78e2a026 in __libc_start_main csu/../csu/libc-start.c:360:3
 |     #9 0x55d2514bb860 in _start (tools/bpf/resolve_btfids/resolve_btfids+0x30860)
 |
 | 0x7f4c4a500bd4 is located 13268 bytes inside of 2829000-byte region [0x7f4c4a4fd800,0x7f4c4a7b02c8)
 | freed by thread T0 here:
 |     #0 0x55d25155b700 in realloc (tools/bpf/resolve_btfids/resolve_btfids+0xd0700)
 |     #1 0x55d2515c426c in libbpf_reallocarray tools/lib/bpf/./libbpf_internal.h:220:9
 |     #2 0x55d2515c426c in libbpf_add_mem tools/lib/bpf/btf.c:224:13
 |
 | previously allocated by thread T0 here:
 |     #0 0x55d25155b2e3 in malloc (tools/bpf/resolve_btfids/resolve_btfids+0xd02e3)
 |     #1 0x55d2515d6e7d in strset__new tools/lib/bpf/strset.c:58:20

While resolve_btfids could be refactored to avoid this call path, let's
instead fix this issue at the source in strset__add_str() and avoid
similar scenarios.

Let's check if set->strs_data was reallocated and whether 's' points to
an internal string within the old strset buffer. In such case, 's' is
reconstructed to point to the new buffer.

While already here, also fix strset__find_str() which suffers from the
same problem by factoring out the common operations into a new helper
function strset_str_append().

Fixes: 90d76d3ececc ("libbpf: Extract internal set-of-strings datastructure APIs")
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Suggested-by: Mykyta Yatsenko <yatsenko@meta.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20260523162722.2718940-1-cmllamas@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/strset.c | 62 ++++++++++++++++++++++++++++--------------
 1 file changed, 41 insertions(+), 21 deletions(-)

diff --git a/tools/lib/bpf/strset.c b/tools/lib/bpf/strset.c
index 2464bcbd04e037..ace73c6b3d62b4 100644
--- a/tools/lib/bpf/strset.c
+++ b/tools/lib/bpf/strset.c
@@ -107,6 +107,41 @@ static void *strset_add_str_mem(struct strset *set, size_t add_sz)
 			      set->strs_data_len, set->strs_data_max_len, add_sz);
 }
 
+static long strset_str_append(struct strset *set, const char *s)
+{
+	uintptr_t old_data = (uintptr_t)set->strs_data;
+	size_t old_data_len = set->strs_data_len;
+	uintptr_t old_s = (uintptr_t)s;
+	long len = strlen(s) + 1;
+	void *p;
+
+	/*
+	 * Hashmap keys are always offsets within set->strs_data, so to even
+	 * look up some string from the "outside", we need to first append it
+	 * at the end, so that it can be addressed with an offset. Luckily,
+	 * until set->strs_data_len is incremented, that string is just a piece
+	 * of garbage for the rest of the code, so no harm, no foul. On the
+	 * other hand, if the string is unique, it's already appended and
+	 * ready to be used, only a simple set->strs_data_len increment away.
+	 */
+	p = strset_add_str_mem(set, len);
+	if (!p)
+		return -ENOMEM;
+
+	/*
+	 * The set->strs_data might have reallocated and if 's' pointed
+	 * to an internal string within the old buffer, then it became
+	 * dangling and needs to be reconstructed before the copy.
+	 */
+	if (old_data && old_data != (uintptr_t)set->strs_data &&
+	    old_s >= old_data && old_s < old_data + old_data_len)
+		s = set->strs_data + (old_s - old_data);
+
+	memcpy(p, s, len);
+
+	return len;
+}
+
 /* Find string offset that corresponds to a given string *s*.
  * Returns:
  *   - >0 offset into string data, if string is found;
@@ -116,16 +151,12 @@ static void *strset_add_str_mem(struct strset *set, size_t add_sz)
 int strset__find_str(struct strset *set, const char *s)
 {
 	long old_off, new_off, len;
-	void *p;
 
-	/* see strset__add_str() for why we do this */
-	len = strlen(s) + 1;
-	p = strset_add_str_mem(set, len);
-	if (!p)
-		return -ENOMEM;
+	len = strset_str_append(set, s);
+	if (len < 0)
+		return len;
 
 	new_off = set->strs_data_len;
-	memcpy(p, s, len);
 
 	if (hashmap__find(set->strs_hash, new_off, &old_off))
 		return old_off;
@@ -142,24 +173,13 @@ int strset__find_str(struct strset *set, const char *s)
 int strset__add_str(struct strset *set, const char *s)
 {
 	long old_off, new_off, len;
-	void *p;
 	int err;
 
-	/* Hashmap keys are always offsets within set->strs_data, so to even
-	 * look up some string from the "outside", we need to first append it
-	 * at the end, so that it can be addressed with an offset. Luckily,
-	 * until set->strs_data_len is incremented, that string is just a piece
-	 * of garbage for the rest of the code, so no harm, no foul. On the
-	 * other hand, if the string is unique, it's already appended and
-	 * ready to be used, only a simple set->strs_data_len increment away.
-	 */
-	len = strlen(s) + 1;
-	p = strset_add_str_mem(set, len);
-	if (!p)
-		return -ENOMEM;
+	len = strset_str_append(set, s);
+	if (len < 0)
+		return len;
 
 	new_off = set->strs_data_len;
-	memcpy(p, s, len);
 
 	/* Now attempt to add the string, but only if the string with the same
 	 * contents doesn't exist already (HASHMAP_ADD strategy). If such
-- 
2.53.0



