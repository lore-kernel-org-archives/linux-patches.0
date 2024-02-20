Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6921D14AD15;
	Tue, 20 Feb 2024 21:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463293; cv=none; b=Pk9R8Jo4yVzjtqoFAFrGIrgmOv+OFIOWDYNwxTjKGz/Mbgfi0wRt+5pCgCG1Yf79zZlHLAR1jdcBfxefi9NxtT9ZWAW/y8JSLe+9LtllGg+Q4k+Zbt2THt5WzDxbJq2z+dQ2ziOzKhfWnTbXQEuDemsHnAkMv0RZFHawbBKcCX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463293; c=relaxed/simple;
	bh=CXMLcyQ1/qU0iN1SjesfNj7eWz4l2dz9zLT2t3Tz4TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUS3Brpn+YszbaYBoEWQJh+e6dIt6dQLyhtPuty9k4z76doma0hJMvn2evjB4/1pa6E74l0sTT+eIPvONq7muMWaAwKs2S7LYrciAm3eD1z5D9Kdp/pEr2+bb2oKl4gLGuZF+Nm5qK+3728pbO5kQALvtrRK5ycl+s33bScgyWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vq8zXO0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vq8zXO0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA7ABC433F1;
	Tue, 20 Feb 2024 21:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463293;
	bh=CXMLcyQ1/qU0iN1SjesfNj7eWz4l2dz9zLT2t3Tz4TM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vq8zXO0LnPJ/cGNDjp2rRrNzEReer/xa6JVhWjb8Eh9NEa5zcWvqFFl9jeNO81n8h
	 uTlIX5ucRj7+U5Ig1kplxRT+T+hrljgM0D5ntGsBrl8MIHreV7yKEZSF2ixtrtIa3W
	 gn8MOi4Rx0osyaHzvqC0VA66YSE+8CILaiRN4Bds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yhs@fb.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 195/197] bpf: Do cleanup in bpf_bprintf_cleanup only when needed
Date: Tue, 20 Feb 2024 21:52:34 +0100
Message-ID: <20240220204846.914755458@linuxfoundation.org>
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

commit f19a4050455aad847fb93f18dc1fe502eb60f989 upstream.

Currently we always cleanup/decrement bpf_bprintf_nest_level variable
in bpf_bprintf_cleanup if it's > 0.

There's possible scenario where this could cause a problem, when
bpf_bprintf_prepare does not get bin_args buffer (because num_args is 0)
and following bpf_bprintf_cleanup call decrements bpf_bprintf_nest_level
variable, like:

  in task context:
    bpf_bprintf_prepare(num_args != 0) increments 'bpf_bprintf_nest_level = 1'
    -> first irq :
       bpf_bprintf_prepare(num_args == 0)
       bpf_bprintf_cleanup decrements 'bpf_bprintf_nest_level = 0'
    -> second irq:
       bpf_bprintf_prepare(num_args != 0) bpf_bprintf_nest_level = 1
       gets same buffer as task context above

Adding check to bpf_bprintf_cleanup and doing the real cleanup only if we
got bin_args data in the first place.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20221215214430.1336195-3-jolsa@kernel.org
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h      |    2 +-
 kernel/bpf/helpers.c     |   16 +++++++++-------
 kernel/trace/bpf_trace.c |    6 +++---
 3 files changed, 13 insertions(+), 11 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2747,7 +2747,7 @@ struct bpf_bprintf_data {
 
 int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 			u32 num_args, struct bpf_bprintf_data *data);
-void bpf_bprintf_cleanup(void);
+void bpf_bprintf_cleanup(struct bpf_bprintf_data *data);
 
 /* the implementation of the opaque uapi struct bpf_dynptr */
 struct bpf_dynptr_kern {
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -781,12 +781,14 @@ static int try_get_fmt_tmp_buf(char **tm
 	return 0;
 }
 
-void bpf_bprintf_cleanup(void)
+void bpf_bprintf_cleanup(struct bpf_bprintf_data *data)
 {
-	if (this_cpu_read(bpf_bprintf_nest_level)) {
-		this_cpu_dec(bpf_bprintf_nest_level);
-		preempt_enable();
-	}
+	if (!data->bin_args)
+		return;
+	if (WARN_ON_ONCE(this_cpu_read(bpf_bprintf_nest_level) == 0))
+		return;
+	this_cpu_dec(bpf_bprintf_nest_level);
+	preempt_enable();
 }
 
 /*
@@ -1018,7 +1020,7 @@ nocopy_fmt:
 	err = 0;
 out:
 	if (err)
-		bpf_bprintf_cleanup();
+		bpf_bprintf_cleanup(data);
 	return err;
 }
 
@@ -1044,7 +1046,7 @@ BPF_CALL_5(bpf_snprintf, char *, str, u3
 
 	err = bstr_printf(str, str_size, fmt, data.bin_args);
 
-	bpf_bprintf_cleanup();
+	bpf_bprintf_cleanup(&data);
 
 	return err + 1;
 }
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -395,7 +395,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt
 	trace_bpf_trace_printk(buf);
 	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
 
-	bpf_bprintf_cleanup();
+	bpf_bprintf_cleanup(&data);
 
 	return ret;
 }
@@ -453,7 +453,7 @@ BPF_CALL_4(bpf_trace_vprintk, char *, fm
 	trace_bpf_trace_printk(buf);
 	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
 
-	bpf_bprintf_cleanup();
+	bpf_bprintf_cleanup(&data);
 
 	return ret;
 }
@@ -493,7 +493,7 @@ BPF_CALL_5(bpf_seq_printf, struct seq_fi
 
 	seq_bprintf(m, fmt, data.bin_args);
 
-	bpf_bprintf_cleanup();
+	bpf_bprintf_cleanup(&data);
 
 	return seq_has_overflowed(m) ? -EOVERFLOW : 0;
 }


