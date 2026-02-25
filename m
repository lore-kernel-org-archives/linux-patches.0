Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13E118DB2A;
	Wed, 25 Feb 2026 01:32:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983156; cv=none; b=Bkhjzv6dBTfD7glPi5kTh+/m+kurackmaFs8izjmnOitLeAS+TnB/vPTqW6pniNuvt3ys+GJASX0cFxBpSWAqipAsajdWlixtcdkgUMLnrOnnZGjLKuzqWDLbhFog1TXREbfm/QuQqymFfwhfPK+XkyzDYvivqWZOFZXnyZY9rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983156; c=relaxed/simple;
	bh=GJt8d8L/G48U4rztjkVbhUlqlHApYELHflXTrc57/1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WmrXzUUNiom2HLjhSaP11MmDGH6vpW/CbXCG3RujSWyUbR4LVlT3+x8SR5mU3486EhgZovw/g+TZRfm/qopBJ7COx/sr2OUkbapHxMtQ8SlUlOKI/tgXUutLMX25iPVxUI70bRdyJmynJ7VqfbKxJZTc+oOJUK2dfYXoEvngWGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbuurRo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbuurRo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC0BC116D0;
	Wed, 25 Feb 2026 01:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983156;
	bh=GJt8d8L/G48U4rztjkVbhUlqlHApYELHflXTrc57/1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbuurRo6cErhqnQqNmhjcqrTqfE245T+8fJx+Hg8GXr5t9lm4xYjXwPHDdPtG8ive
	 PfCjKB2qwEp+4fO8Rv8vh02C1nNhK6mcyZ5dZB6XA2xeB94edQvfZbA1q1YdrhdB0f
	 BCmZgkYW30n+IuuqAZzUQQuwU6FYUOnEd8JFTc+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Petr Mladek <pmladek@suse.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 310/781] vsnprintf: drop __printf() attributes on binary printing functions
Date: Tue, 24 Feb 2026 17:16:59 -0800
Message-ID: <20260225012407.308527998@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b07829d546c83134629591f02c5348d57cea0c1e ]

The printf() format attributes are applied inconsistently for the binary
printf helpers, which causes warnings for the bpf_trace code using
them from functions that pass down format strings:

    kernel/trace/bpf_trace.c: In function '____bpf_trace_printk':
    kernel/trace/bpf_trace.c:377:9: error: function '____bpf_trace_printk' might be a candidate for 'gnu_printf' format attribute [-Werror=suggest-attribute=format]
      377 |         ret = bstr_printf(data.buf, MAX_BPRINTF_BUF, fmt, data.bin_args);
          |         ^~~

This can be addressed either by annotating all five callers in bpf code,
or by removing the annotations on the callees that were added by Andy
Shevchenko last year.

As Alexei Starovoitov points out, there are no callers in C code that
would benefit from the __printf attributes, the only users are in BPF
code or in the do_trace_printk() helper that already checks the arguments.

Drop all three of these annotations, reverting the earlierl commits that
added these, in order to get a clean build with -Wsuggest-attribute=format.

Fixes: 6b2c1e30ad68 ("seq_file: Mark binary printing functions with __printf() attribute")
Fixes: 7bf819aa992f ("vsnprintf: Mark binary printing functions with __printf() attribute")
Link: https://lore.kernel.org/all/CAADnVQK3eZp3yp35OUx8j1UBsQFhgsn5-4VReqAJ=68PaaKYmg@mail.gmail.com/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202512061640.9hKTnB8p-lkp@intel.com/
Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Acked-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Petr Mladek <pmladek@suse.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260204132643.1302967-1-arnd@kernel.org
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/seq_file.h | 1 -
 include/linux/string.h   | 4 ++--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index d6ebf0596510c..2fb266ea69fa4 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -181,7 +181,6 @@ int seq_open_private(struct file *, const struct seq_operations *, int);
 int seq_release_private(struct inode *, struct file *);
 
 #ifdef CONFIG_BINARY_PRINTF
-__printf(2, 0)
 void seq_bprintf(struct seq_file *m, const char *f, const u32 *binary);
 #endif
 
diff --git a/include/linux/string.h b/include/linux/string.h
index 1b564c36d721b..b850bd91b3d88 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -336,8 +336,8 @@ int __sysfs_match_string(const char * const *array, size_t n, const char *s);
 #define sysfs_match_string(_a, _s) __sysfs_match_string(_a, ARRAY_SIZE(_a), _s)
 
 #ifdef CONFIG_BINARY_PRINTF
-__printf(3, 0) int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
-__printf(3, 0) int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
+int vbin_printf(u32 *bin_buf, size_t size, const char *fmt, va_list args);
+int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf);
 #endif
 
 extern ssize_t memory_read_from_buffer(void *to, size_t count, loff_t *ppos,
-- 
2.51.0



