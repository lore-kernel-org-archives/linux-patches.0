Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C093F76C9C;
	Tue, 20 Feb 2024 21:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463321; cv=none; b=UnrabSSCUoKD7j+TqtR0IksPkzTiIZGSrgNOEVmv6p022msaXuLhJnyPL/fuNIbZOtCTwxc0aKHbQMO94kPAPt6959JxT8f1PL2TMvwpSox1aV/qQSlQueU4QLEpGu8QFR21UYsUlO/F1060ZZF5DSsl3OKV4SjOtWOHtGuBdes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463321; c=relaxed/simple;
	bh=j3HSBBS/9a8i5dacxEjT6BuI3GHfeJz8KiMLdyRkQXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ST2hGE0R4EC+z6TWduPwuNwD6wXg5GL80qVriHTE1Fk9GWTuaIm5/3IcVTRaZblKBMWwT8Y5sMGfnaNN6x7SUThLtJkmxZYlHsAYYatr13ap2cTMN0oKSgnMgkFGjoYiNd2c0jifl3mgYxi6X1u5AlIB6zH1hdD/he8MPliOOw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbHuZOaJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbHuZOaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303CCC433C7;
	Tue, 20 Feb 2024 21:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463321;
	bh=j3HSBBS/9a8i5dacxEjT6BuI3GHfeJz8KiMLdyRkQXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HbHuZOaJw0emyqtvCT00g87+yG/CWKG3oRukogIob8OLiz5UAqWkkISsDVsnnvFmG
	 GdlqT4i30AVbZJ3oB9/QYdyhjvV1JndpLdf2eVIsjzfJ/Kt6HrMkx1i6QE3yn5xxdq
	 FoOvDwKDxvHLVF+cpIXsggk0dUEjnFbE88/hrD9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Sun <sunhao.th@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yhs@fb.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 196/197] bpf: Remove trace_printk_lock
Date: Tue, 20 Feb 2024 21:52:35 +0100
Message-ID: <20240220204846.943702948@linuxfoundation.org>
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

commit e2bb9e01d589f7fa82573aedd2765ff9b277816a upstream.

Both bpf_trace_printk and bpf_trace_vprintk helpers use static buffer guarded
with trace_printk_lock spin lock.

The spin lock contention causes issues with bpf programs attached to
contention_begin tracepoint [1][2].

Andrii suggested we could get rid of the contention by using trylock, but we
could actually get rid of the spinlock completely by using percpu buffers the
same way as for bin_args in bpf_bprintf_prepare function.

Adding new return 'buf' argument to struct bpf_bprintf_data and making
bpf_bprintf_prepare to return also the buffer for printk helpers.

  [1] https://lore.kernel.org/bpf/CACkBjsakT_yWxnSWr4r-0TpPvbKm9-OBmVUhJb7hV3hY8fdCkw@mail.gmail.com/
  [2] https://lore.kernel.org/bpf/CACkBjsaCsTovQHFfkqJKto6S4Z8d02ud1D7MPESrHa1cVNNTrw@mail.gmail.com/

Reported-by: Hao Sun <sunhao.th@gmail.com>
Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20221215214430.1336195-4-jolsa@kernel.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h      |    3 +++
 kernel/bpf/helpers.c     |   31 +++++++++++++++++++------------
 kernel/trace/bpf_trace.c |   20 ++++++--------------
 3 files changed, 28 insertions(+), 26 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2739,10 +2739,13 @@ struct btf_id_set;
 bool btf_id_set_contains(const struct btf_id_set *set, u32 id);
 
 #define MAX_BPRINTF_VARARGS		12
+#define MAX_BPRINTF_BUF			1024
 
 struct bpf_bprintf_data {
 	u32 *bin_args;
+	char *buf;
 	bool get_bin_args;
+	bool get_buf;
 };
 
 int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -753,19 +753,20 @@ static int bpf_trace_copy_string(char *b
 /* Per-cpu temp buffers used by printf-like helpers to store the bprintf binary
  * arguments representation.
  */
-#define MAX_BPRINTF_BUF_LEN	512
+#define MAX_BPRINTF_BIN_ARGS	512
 
 /* Support executing three nested bprintf helper calls on a given CPU */
 #define MAX_BPRINTF_NEST_LEVEL	3
 struct bpf_bprintf_buffers {
-	char tmp_bufs[MAX_BPRINTF_NEST_LEVEL][MAX_BPRINTF_BUF_LEN];
+	char bin_args[MAX_BPRINTF_BIN_ARGS];
+	char buf[MAX_BPRINTF_BUF];
 };
-static DEFINE_PER_CPU(struct bpf_bprintf_buffers, bpf_bprintf_bufs);
+
+static DEFINE_PER_CPU(struct bpf_bprintf_buffers[MAX_BPRINTF_NEST_LEVEL], bpf_bprintf_bufs);
 static DEFINE_PER_CPU(int, bpf_bprintf_nest_level);
 
-static int try_get_fmt_tmp_buf(char **tmp_buf)
+static int try_get_buffers(struct bpf_bprintf_buffers **bufs)
 {
-	struct bpf_bprintf_buffers *bufs;
 	int nest_level;
 
 	preempt_disable();
@@ -775,15 +776,14 @@ static int try_get_fmt_tmp_buf(char **tm
 		preempt_enable();
 		return -EBUSY;
 	}
-	bufs = this_cpu_ptr(&bpf_bprintf_bufs);
-	*tmp_buf = bufs->tmp_bufs[nest_level - 1];
+	*bufs = this_cpu_ptr(&bpf_bprintf_bufs[nest_level - 1]);
 
 	return 0;
 }
 
 void bpf_bprintf_cleanup(struct bpf_bprintf_data *data)
 {
-	if (!data->bin_args)
+	if (!data->bin_args && !data->buf)
 		return;
 	if (WARN_ON_ONCE(this_cpu_read(bpf_bprintf_nest_level) == 0))
 		return;
@@ -808,7 +808,9 @@ void bpf_bprintf_cleanup(struct bpf_bpri
 int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 			u32 num_args, struct bpf_bprintf_data *data)
 {
+	bool get_buffers = (data->get_bin_args && num_args) || data->get_buf;
 	char *unsafe_ptr = NULL, *tmp_buf = NULL, *tmp_buf_end, *fmt_end;
+	struct bpf_bprintf_buffers *buffers = NULL;
 	size_t sizeof_cur_arg, sizeof_cur_ip;
 	int err, i, num_spec = 0;
 	u64 cur_arg;
@@ -819,14 +821,19 @@ int bpf_bprintf_prepare(char *fmt, u32 f
 		return -EINVAL;
 	fmt_size = fmt_end - fmt;
 
-	if (data->get_bin_args) {
-		if (num_args && try_get_fmt_tmp_buf(&tmp_buf))
-			return -EBUSY;
+	if (get_buffers && try_get_buffers(&buffers))
+		return -EBUSY;
 
-		tmp_buf_end = tmp_buf + MAX_BPRINTF_BUF_LEN;
+	if (data->get_bin_args) {
+		if (num_args)
+			tmp_buf = buffers->bin_args;
+		tmp_buf_end = tmp_buf + MAX_BPRINTF_BIN_ARGS;
 		data->bin_args = (u32 *)tmp_buf;
 	}
 
+	if (data->get_buf)
+		data->buf = buffers->buf;
+
 	for (i = 0; i < fmt_size; i++) {
 		if ((!isprint(fmt[i]) && !isspace(fmt[i])) || !isascii(fmt[i])) {
 			err = -EINVAL;
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -368,8 +368,6 @@ static const struct bpf_func_proto *bpf_
 	return &bpf_probe_write_user_proto;
 }
 
-static DEFINE_RAW_SPINLOCK(trace_printk_lock);
-
 #define MAX_TRACE_PRINTK_VARARGS	3
 #define BPF_TRACE_PRINTK_SIZE		1024
 
@@ -379,9 +377,8 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt
 	u64 args[MAX_TRACE_PRINTK_VARARGS] = { arg1, arg2, arg3 };
 	struct bpf_bprintf_data data = {
 		.get_bin_args	= true,
+		.get_buf	= true,
 	};
-	static char buf[BPF_TRACE_PRINTK_SIZE];
-	unsigned long flags;
 	int ret;
 
 	ret = bpf_bprintf_prepare(fmt, fmt_size, args,
@@ -389,11 +386,9 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt
 	if (ret < 0)
 		return ret;
 
-	raw_spin_lock_irqsave(&trace_printk_lock, flags);
-	ret = bstr_printf(buf, sizeof(buf), fmt, data.bin_args);
+	ret = bstr_printf(data.buf, MAX_BPRINTF_BUF, fmt, data.bin_args);
 
-	trace_bpf_trace_printk(buf);
-	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
+	trace_bpf_trace_printk(data.buf);
 
 	bpf_bprintf_cleanup(&data);
 
@@ -433,9 +428,8 @@ BPF_CALL_4(bpf_trace_vprintk, char *, fm
 {
 	struct bpf_bprintf_data data = {
 		.get_bin_args	= true,
+		.get_buf	= true,
 	};
-	static char buf[BPF_TRACE_PRINTK_SIZE];
-	unsigned long flags;
 	int ret, num_args;
 
 	if (data_len & 7 || data_len > MAX_BPRINTF_VARARGS * 8 ||
@@ -447,11 +441,9 @@ BPF_CALL_4(bpf_trace_vprintk, char *, fm
 	if (ret < 0)
 		return ret;
 
-	raw_spin_lock_irqsave(&trace_printk_lock, flags);
-	ret = bstr_printf(buf, sizeof(buf), fmt, data.bin_args);
+	ret = bstr_printf(data.buf, MAX_BPRINTF_BUF, fmt, data.bin_args);
 
-	trace_bpf_trace_printk(buf);
-	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
+	trace_bpf_trace_printk(data.buf);
 
 	bpf_bprintf_cleanup(&data);
 


