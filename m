Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD342B9A5;
	Tue, 22 Jul 2025 13:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192428; cv=none; b=oLxiUkjutzcjRGC09RqoTbOaT4rIMReAOV/SUEUpBbtpbHdF/rrk05s9f29UYtkX4Sjk5EGZ0HNSry/CcenZFVi/kt5ZnOot5F+sd4vdQRs06Q2AnXXnv8fNeseozOENO4XZLiQt760a2nUGpd7P6VAOLz/NyP34YNEjME28J0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192428; c=relaxed/simple;
	bh=J58qexSGMwEWgqb4Nb3YztUHy+iFN+T9UpMxfN9cDUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cylw/WwRAXaPS8MNY/yCB8IqsRKg97D6hoeoOgfFvFnBnS7pzqPrrcLNEcqSySbVFgNPL0pzR0v13Wp/Sx78MZT2OiAoeIqG8JhGUrQIf+jUJLZgjTVL9t1nst4wyscLx3zx7KpRhWXnllkTc025/C0gGr+23WO3DhNg9Dq+4c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bM0oXuYX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bM0oXuYX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3B2C4CEEB;
	Tue, 22 Jul 2025 13:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192427;
	bh=J58qexSGMwEWgqb4Nb3YztUHy+iFN+T9UpMxfN9cDUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bM0oXuYXTSGuSqOzNQJaqUkY5KchyxI4rbcKhbc9zLi20q0wnZHFVLd0eM/iePJcV
	 b0rKmCMINq7mJIQHFuKSqCF5Sumiebr+7pxehoEW375gU951l0G03Q51uPYtiDAy7h
	 MPg1xPk/KDeMIpB56zwEbcfZxuHNd8Yowv0NWrWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e2c932aec5c8a6e1d31c@syzkaller.appspotmail.com,
	Yonghong Song <yonghong.song@linux.dev>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/111] bpf: Reject %p% format string in bprintf-like helpers
Date: Tue, 22 Jul 2025 15:44:36 +0200
Message-ID: <20250722134335.660004740@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit f8242745871f81a3ac37f9f51853d12854fd0b58 ]

static const char fmt[] = "%p%";
    bpf_trace_printk(fmt, sizeof(fmt));

The above BPF program isn't rejected and causes a kernel warning at
runtime:

    Please remove unsupported %\x00 in format string
    WARNING: CPU: 1 PID: 7244 at lib/vsprintf.c:2680 format_decode+0x49c/0x5d0

This happens because bpf_bprintf_prepare skips over the second %,
detected as punctuation, while processing %p. This patch fixes it by
not skipping over punctuation. %\x00 is then processed in the next
iteration and rejected.

Reported-by: syzbot+e2c932aec5c8a6e1d31c@syzkaller.appspotmail.com
Fixes: 48cac3f4a96d ("bpf: Implement formatted output helpers with bstr_printf")
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/a0e06cc479faec9e802ae51ba5d66420523251ee.1751395489.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 8f0b62b04deeb..4b20a72ab8cff 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -885,6 +885,13 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 		if (fmt[i] == 'p') {
 			sizeof_cur_arg = sizeof(long);
 
+			if (fmt[i + 1] == 0 || isspace(fmt[i + 1]) ||
+			    ispunct(fmt[i + 1])) {
+				if (tmp_buf)
+					cur_arg = raw_args[num_spec];
+				goto nocopy_fmt;
+			}
+
 			if ((fmt[i + 1] == 'k' || fmt[i + 1] == 'u') &&
 			    fmt[i + 2] == 's') {
 				fmt_ptype = fmt[i + 1];
@@ -892,11 +899,9 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 				goto fmt_str;
 			}
 
-			if (fmt[i + 1] == 0 || isspace(fmt[i + 1]) ||
-			    ispunct(fmt[i + 1]) || fmt[i + 1] == 'K' ||
+			if (fmt[i + 1] == 'K' ||
 			    fmt[i + 1] == 'x' || fmt[i + 1] == 's' ||
 			    fmt[i + 1] == 'S') {
-				/* just kernel pointers */
 				if (tmp_buf)
 					cur_arg = raw_args[num_spec];
 				i++;
-- 
2.39.5



