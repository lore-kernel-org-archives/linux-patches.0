Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B2A2210FB;
	Thu, 12 Dec 2024 15:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018604; cv=none; b=u4B+fSYR3l6ybek30Yx0wss87j61xGV5U+QZQZ4OlBbIaWsJ78L/zldTTZyNL7sFZ9PY4sv+a3/cOS5xw1FNq2HBTVhaylgs8XkfhEb0HXgystxL8Mj7Fz8Gmfneg1CPUuTDGtT5H1NbJz5zDGGh9CseDoKL0qkOVk5pP7ULLqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018604; c=relaxed/simple;
	bh=Swk5Oe0srqZl8Fo/vHZ2nHRwJ7WOc2jLWRJ1esbIwrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kbe/lXS7ZXRwpgyLhKXbnUBMmwcQkL6DNVF5O4yd8x9iasnFXoCVVjkLcjadNcdZrmGv+2dio7fD6faPi0Rz4ey/Wuv5UFYnaenU2QW4Spi4NZbXHy9UOIAOs7Eg4p/S2UmL1TZgGZWjRmKK5uB+DQhaFRE94cSg/JLxmObVxss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRrEKxmS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRrEKxmS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AD4C4CECE;
	Thu, 12 Dec 2024 15:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018604;
	bh=Swk5Oe0srqZl8Fo/vHZ2nHRwJ7WOc2jLWRJ1esbIwrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRrEKxmSzQxYacgyS1VQ2X2bu8C6YKjVvCKKZBl4KKt1MHrXtP38GTdck3lvoFVGy
	 uW+yV+KCwu76Qt8YembfamAY/cnwJXatEVK9wVejQsE1PFT3Yh3N45W8c41Zgd0vQt
	 IBi0oErOjhG6uiiUSuAocMaSvnfO8+2AVINJQ7Fs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Hari Bathini <hbathini@linux.ibm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 338/356] selftests/ftrace: adjust offset for kprobe syntax error test
Date: Thu, 12 Dec 2024 16:00:57 +0100
Message-ID: <20241212144257.921564055@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit 777f290ab328de333b85558bb6807a69a59b36ba ]

In 'NOFENTRY_ARGS' test case for syntax check, any offset X of
`vfs_read+X` except function entry offset (0) fits the criterion,
even if that offset is not at instruction boundary, as the parser
comes before probing. But with "ENDBR64" instruction on x86, offset
4 is treated as function entry. So, X can't be 4 as well. Thus, 8
was used as offset for the test case. On 64-bit powerpc though, any
offset <= 16 can be considered function entry depending on build
configuration (see arch_kprobe_on_func_entry() for implementation
details). So, use `vfs_read+20` to accommodate that scenario too.

Link: https://lore.kernel.org/r/20241129202621.721159-1-hbathini@linux.ibm.com
Fixes: 4231f30fcc34a ("selftests/ftrace: Add BTF arguments test cases")
Suggested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_syntax_errors.tc
@@ -111,7 +111,7 @@ check_error 'p vfs_read $arg* ^$arg*'		#
 if !grep -q 'kernel return probes support:' README; then
 check_error 'r vfs_read ^$arg*'			# NOFENTRY_ARGS
 fi
-check_error 'p vfs_read+8 ^$arg*'		# NOFENTRY_ARGS
+check_error 'p vfs_read+20 ^$arg*'		# NOFENTRY_ARGS
 check_error 'p vfs_read ^hoge'			# NO_BTFARG
 check_error 'p kfree ^$arg10'			# NO_BTFARG (exceed the number of parameters)
 check_error 'r kfree ^$retval'			# NO_RETVAL


