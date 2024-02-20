Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F42D14AD15;
	Tue, 20 Feb 2024 21:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463290; cv=none; b=roI/pzm7e0LbYfEXqpTJMFcXGsKrDZH52i1Swo6KKNL2CAiXmeZsSTNG/SpmfN5z7o2vH68TbvoqI1UsMCVIztCs7e00p2l6ZoD2yQRtIIyKrAjRympIdBviIZbAhjpmliEVUC4W+3q9NuDeheFA3pcE80OrzUjBwsl56CWWrx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463290; c=relaxed/simple;
	bh=Rk+YGKhTixyB/k6KwOFimMhgxLqWyVIUAVzsFsBiWeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gy6FglZhYuucW3SS+toDWI8IoGGkNHeXD8vTYt/uAUTSSYXT7l7qabJoq9/K8EId410YZWIE5bmfb3ukWrHlNT1tqccbMmFT5dCnDeMUeGgleL7TRkng1kR7pY30ANVu7VQOHhGEAZ+Tyov9mHhJvxdfUgTXv6Ao0WBut2iCfdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XWEF2B2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XWEF2B2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3F0CC433F1;
	Tue, 20 Feb 2024 21:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463290;
	bh=Rk+YGKhTixyB/k6KwOFimMhgxLqWyVIUAVzsFsBiWeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XWEF2B2KxDRCOe6SuXGPgFDHXg3WdKHB9GGRasYbpiZpvi0nEb/ftjf3sxRxrCeMT
	 psz00xm2e5Jo4vYLjnSE5zJ0dfJL5BKOrA0F6lEZfhD9RHgCAdj7UWVTQKzGh0xJoE
	 V8d9XEiYY2bkpLJ+7pRA7o0Ld8+JSbhFbHOWJeL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yhs@fb.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 194/197] bpf: Add struct for bin_args arg in bpf_bprintf_prepare
Date: Tue, 20 Feb 2024 21:52:33 +0100
Message-ID: <20240220204846.885054711@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Olsa <jolsa@kernel.org>

commit 78aa1cc9404399a15d2a1205329c6a06236f5378 upstream.

Adding struct bpf_bprintf_data to hold bin_args argument for
bpf_bprintf_prepare function.

We will add another return argument to bpf_bprintf_prepare and
pass the struct to bpf_bprintf_cleanup for proper cleanup in
following changes.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20221215214430.1336195-2-jolsa@kernel.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h      |    7 ++++++-
 kernel/bpf/helpers.c     |   24 +++++++++++++-----------
 kernel/bpf/verifier.c    |    3 ++-
 kernel/trace/bpf_trace.c |   34 ++++++++++++++++++++--------------
 4 files changed, 41 insertions(+), 27 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2740,8 +2740,13 @@ bool btf_id_set_contains(const struct bt
 
 #define MAX_BPRINTF_VARARGS		12
 
+struct bpf_bprintf_data {
+	u32 *bin_args;
+	bool get_bin_args;
+};
+
 int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
-			u32 **bin_buf, u32 num_args);
+			u32 num_args, struct bpf_bprintf_data *data);
 void bpf_bprintf_cleanup(void);
 
 /* the implementation of the opaque uapi struct bpf_dynptr */
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -795,16 +795,16 @@ void bpf_bprintf_cleanup(void)
  * Returns a negative value if fmt is an invalid format string or 0 otherwise.
  *
  * This can be used in two ways:
- * - Format string verification only: when bin_args is NULL
+ * - Format string verification only: when data->get_bin_args is false
  * - Arguments preparation: in addition to the above verification, it writes in
- *   bin_args a binary representation of arguments usable by bstr_printf where
- *   pointers from BPF have been sanitized.
+ *   data->bin_args a binary representation of arguments usable by bstr_printf
+ *   where pointers from BPF have been sanitized.
  *
  * In argument preparation mode, if 0 is returned, safe temporary buffers are
  * allocated and bpf_bprintf_cleanup should be called to free them after use.
  */
 int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
-			u32 **bin_args, u32 num_args)
+			u32 num_args, struct bpf_bprintf_data *data)
 {
 	char *unsafe_ptr = NULL, *tmp_buf = NULL, *tmp_buf_end, *fmt_end;
 	size_t sizeof_cur_arg, sizeof_cur_ip;
@@ -817,12 +817,12 @@ int bpf_bprintf_prepare(char *fmt, u32 f
 		return -EINVAL;
 	fmt_size = fmt_end - fmt;
 
-	if (bin_args) {
+	if (data->get_bin_args) {
 		if (num_args && try_get_fmt_tmp_buf(&tmp_buf))
 			return -EBUSY;
 
 		tmp_buf_end = tmp_buf + MAX_BPRINTF_BUF_LEN;
-		*bin_args = (u32 *)tmp_buf;
+		data->bin_args = (u32 *)tmp_buf;
 	}
 
 	for (i = 0; i < fmt_size; i++) {
@@ -1023,24 +1023,26 @@ out:
 }
 
 BPF_CALL_5(bpf_snprintf, char *, str, u32, str_size, char *, fmt,
-	   const void *, data, u32, data_len)
+	   const void *, args, u32, data_len)
 {
+	struct bpf_bprintf_data data = {
+		.get_bin_args	= true,
+	};
 	int err, num_args;
-	u32 *bin_args;
 
 	if (data_len % 8 || data_len > MAX_BPRINTF_VARARGS * 8 ||
-	    (data_len && !data))
+	    (data_len && !args))
 		return -EINVAL;
 	num_args = data_len / 8;
 
 	/* ARG_PTR_TO_CONST_STR guarantees that fmt is zero-terminated so we
 	 * can safely give an unbounded size.
 	 */
-	err = bpf_bprintf_prepare(fmt, UINT_MAX, data, &bin_args, num_args);
+	err = bpf_bprintf_prepare(fmt, UINT_MAX, args, num_args, &data);
 	if (err < 0)
 		return err;
 
-	err = bstr_printf(str, str_size, fmt, bin_args);
+	err = bstr_printf(str, str_size, fmt, data.bin_args);
 
 	bpf_bprintf_cleanup();
 
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7448,6 +7448,7 @@ static int check_bpf_snprintf_call(struc
 	struct bpf_reg_state *fmt_reg = &regs[BPF_REG_3];
 	struct bpf_reg_state *data_len_reg = &regs[BPF_REG_5];
 	struct bpf_map *fmt_map = fmt_reg->map_ptr;
+	struct bpf_bprintf_data data = {};
 	int err, fmt_map_off, num_args;
 	u64 fmt_addr;
 	char *fmt;
@@ -7472,7 +7473,7 @@ static int check_bpf_snprintf_call(struc
 	/* We are also guaranteed that fmt+fmt_map_off is NULL terminated, we
 	 * can focus on validating the format specifiers.
 	 */
-	err = bpf_bprintf_prepare(fmt, UINT_MAX, NULL, NULL, num_args);
+	err = bpf_bprintf_prepare(fmt, UINT_MAX, NULL, num_args, &data);
 	if (err < 0)
 		verbose(env, "Invalid format string\n");
 
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -377,18 +377,20 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt
 	   u64, arg2, u64, arg3)
 {
 	u64 args[MAX_TRACE_PRINTK_VARARGS] = { arg1, arg2, arg3 };
-	u32 *bin_args;
+	struct bpf_bprintf_data data = {
+		.get_bin_args	= true,
+	};
 	static char buf[BPF_TRACE_PRINTK_SIZE];
 	unsigned long flags;
 	int ret;
 
-	ret = bpf_bprintf_prepare(fmt, fmt_size, args, &bin_args,
-				  MAX_TRACE_PRINTK_VARARGS);
+	ret = bpf_bprintf_prepare(fmt, fmt_size, args,
+				  MAX_TRACE_PRINTK_VARARGS, &data);
 	if (ret < 0)
 		return ret;
 
 	raw_spin_lock_irqsave(&trace_printk_lock, flags);
-	ret = bstr_printf(buf, sizeof(buf), fmt, bin_args);
+	ret = bstr_printf(buf, sizeof(buf), fmt, data.bin_args);
 
 	trace_bpf_trace_printk(buf);
 	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
@@ -426,25 +428,27 @@ const struct bpf_func_proto *bpf_get_tra
 	return &bpf_trace_printk_proto;
 }
 
-BPF_CALL_4(bpf_trace_vprintk, char *, fmt, u32, fmt_size, const void *, data,
+BPF_CALL_4(bpf_trace_vprintk, char *, fmt, u32, fmt_size, const void *, args,
 	   u32, data_len)
 {
+	struct bpf_bprintf_data data = {
+		.get_bin_args	= true,
+	};
 	static char buf[BPF_TRACE_PRINTK_SIZE];
 	unsigned long flags;
 	int ret, num_args;
-	u32 *bin_args;
 
 	if (data_len & 7 || data_len > MAX_BPRINTF_VARARGS * 8 ||
-	    (data_len && !data))
+	    (data_len && !args))
 		return -EINVAL;
 	num_args = data_len / 8;
 
-	ret = bpf_bprintf_prepare(fmt, fmt_size, data, &bin_args, num_args);
+	ret = bpf_bprintf_prepare(fmt, fmt_size, args, num_args, &data);
 	if (ret < 0)
 		return ret;
 
 	raw_spin_lock_irqsave(&trace_printk_lock, flags);
-	ret = bstr_printf(buf, sizeof(buf), fmt, bin_args);
+	ret = bstr_printf(buf, sizeof(buf), fmt, data.bin_args);
 
 	trace_bpf_trace_printk(buf);
 	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
@@ -471,21 +475,23 @@ const struct bpf_func_proto *bpf_get_tra
 }
 
 BPF_CALL_5(bpf_seq_printf, struct seq_file *, m, char *, fmt, u32, fmt_size,
-	   const void *, data, u32, data_len)
+	   const void *, args, u32, data_len)
 {
+	struct bpf_bprintf_data data = {
+		.get_bin_args	= true,
+	};
 	int err, num_args;
-	u32 *bin_args;
 
 	if (data_len & 7 || data_len > MAX_BPRINTF_VARARGS * 8 ||
-	    (data_len && !data))
+	    (data_len && !args))
 		return -EINVAL;
 	num_args = data_len / 8;
 
-	err = bpf_bprintf_prepare(fmt, fmt_size, data, &bin_args, num_args);
+	err = bpf_bprintf_prepare(fmt, fmt_size, args, num_args, &data);
 	if (err < 0)
 		return err;
 
-	seq_bprintf(m, fmt, bin_args);
+	seq_bprintf(m, fmt, data.bin_args);
 
 	bpf_bprintf_cleanup();
 


