Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877AC13F016;
	Tue, 27 Feb 2024 14:01:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042479; cv=none; b=ClNPdRKeWuLsC1zViCqVfnN6NDbVW5jpKL2K0mAvRaGiIZYVXuK92UV6gPp/3+hjMUpnN9V/bbcywI7UFZmJ8L3V+rR3i08xCMnAJtJNn3bsAqeviQG5DSfpa5RslKAyFKC3Z5w/btf+0u8TLqW9YjMUG/Ao+oUI2uP8DXluBcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042479; c=relaxed/simple;
	bh=7A12yH7fCGPugFYFIfAV432yJRSRe8sKyklQ+vjXQ7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H3h8ZuB5IiCpV7RDiVhZ7tPhlnFlk96kcLythuX1Osvi5o+tw+Zh1FS3RbeTU/9ldbpvxZElH9ITLE7+18j+Z3h4EjvoUrFa83HAPVVUQRk48beahhzuvwhhbDnobG+1dY94Bkv8HE9EU9Kig+5AJjEoVKQSJseDvwYebwVxa0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h6zM9AKJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h6zM9AKJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146CEC433F1;
	Tue, 27 Feb 2024 14:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042479;
	bh=7A12yH7fCGPugFYFIfAV432yJRSRe8sKyklQ+vjXQ7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h6zM9AKJP9nIpoX7Dw1hz0aAh7k1NpjHcS7ofqfjFKvBAwiAv0Y+26ICtW5NVepC8
	 dW56ujfeTA+r6OIrzKl2VEbX4e1Jgr7nDQNKbhxSiW7WSPBbVyk8DkTE2nveK7gbtz
	 iYV8iEjsmc3pRb5muCcypqJ7e1u3SaLaZj7uY3o0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Yonghong Song <yhs@fb.com>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 011/245] bpf: Do cleanup in bpf_bprintf_cleanup only when needed
Date: Tue, 27 Feb 2024 14:23:19 +0100
Message-ID: <20240227131615.478080020@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[cascardo: there is no bpf_trace_vprintk in 5.15]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h      |    2 +-
 kernel/bpf/helpers.c     |   16 +++++++++-------
 kernel/trace/bpf_trace.c |    4 ++--
 3 files changed, 12 insertions(+), 10 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2299,6 +2299,6 @@ struct bpf_bprintf_data {
 
 int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 			u32 num_args, struct bpf_bprintf_data *data);
-void bpf_bprintf_cleanup(void);
+void bpf_bprintf_cleanup(struct bpf_bprintf_data *data);
 
 #endif /* _LINUX_BPF_H */
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -738,12 +738,14 @@ static int try_get_fmt_tmp_buf(char **tm
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
@@ -975,7 +977,7 @@ nocopy_fmt:
 	err = 0;
 out:
 	if (err)
-		bpf_bprintf_cleanup();
+		bpf_bprintf_cleanup(data);
 	return err;
 }
 
@@ -1001,7 +1003,7 @@ BPF_CALL_5(bpf_snprintf, char *, str, u3
 
 	err = bstr_printf(str, str_size, fmt, data.bin_args);
 
-	bpf_bprintf_cleanup();
+	bpf_bprintf_cleanup(&data);
 
 	return err + 1;
 }
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -387,7 +387,7 @@ BPF_CALL_5(bpf_trace_printk, char *, fmt
 	trace_bpf_trace_printk(buf);
 	raw_spin_unlock_irqrestore(&trace_printk_lock, flags);
 
-	bpf_bprintf_cleanup();
+	bpf_bprintf_cleanup(&data);
 
 	return ret;
 }
@@ -435,7 +435,7 @@ BPF_CALL_5(bpf_seq_printf, struct seq_fi
 
 	seq_bprintf(m, fmt, data.bin_args);
 
-	bpf_bprintf_cleanup();
+	bpf_bprintf_cleanup(&data);
 
 	return seq_has_overflowed(m) ? -EOVERFLOW : 0;
 }


