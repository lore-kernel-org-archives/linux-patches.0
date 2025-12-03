Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E7B39A255;
	Wed,  3 Dec 2025 16:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780796; cv=none; b=GsQoe4PP7D93tGl+EYoQ0DoGJU55/vOwMV4Z/nHiGqAIuT4qnMpJfaQvkGy0o+mHrvN1QDYjpx7c2YnuuFJF8eorf3N21fJ5Rms1JImEmw93TmECOUfv0dSKgOemoLxvEiv1IZ17L9Vp/dDSpU8PZTMO4dK5xW1nhyXT5P699Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780796; c=relaxed/simple;
	bh=27b24KjNTv6DwWYWHMA6b86kIhT+1t75PK+kqVg7FaQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cLA0YuH3JU1miVr3MAx6S77GK42J95OTGYGRKYdv7+ojW9a7aj2pUrrwMNuEyG+teRcnO+y/wSLPUZcc0mqAdO3BfHSvmRZ5kRGTsXynb9u862rDDJtP8ZaHY5tUkmRcWwPeZ4ZjvSfn9JY3+xA0PFIWOf/OIAy8uFtimivHox0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PAhlvCzD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PAhlvCzD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BE91C4CEF5;
	Wed,  3 Dec 2025 16:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780796;
	bh=27b24KjNTv6DwWYWHMA6b86kIhT+1t75PK+kqVg7FaQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAhlvCzDZAREH5Pk5CPxxVM2fLYHKOFEkSQ13UUXLqSMkLQRc1AqUFFyg2+1I19if
	 0H59/B8UtcBr06cqRdznu2QYHdA+0/hWACTyiSvPuLqeZIg9jVCo7n50seejO0IAi3
	 ClPuuyTzRzazY4sDsLzcfGOgxpokOYKaHWGWgHdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a72c325b042aae6403c7@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 065/132] tracing: Fix WARN_ON in tracing_buffers_mmap_close for split VMAs
Date: Wed,  3 Dec 2025 16:29:04 +0100
Message-ID: <20251203152345.706019338@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit b042fdf18e89a347177a49e795d8e5184778b5b6 upstream.

When a VMA is split (e.g., by partial munmap or MAP_FIXED), the kernel
calls vm_ops->close on each portion. For trace buffer mappings, this
results in ring_buffer_unmap() being called multiple times while
ring_buffer_map() was only called once.

This causes ring_buffer_unmap() to return -ENODEV on subsequent calls
because user_mapped is already 0, triggering a WARN_ON.

Trace buffer mappings cannot support partial mappings because the ring
buffer structure requires the complete buffer including the meta page.

Fix this by adding a may_split callback that returns -EINVAL to prevent
VMA splits entirely.

Cc: stable@vger.kernel.org
Fixes: cf9f0f7c4c5bb ("tracing: Allow user-space mapping of the ring-buffer")
Link: https://patch.msgid.link/20251119064019.25904-1-kartikey406@gmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a72c325b042aae6403c7
Tested-by: syzbot+a72c325b042aae6403c7@syzkaller.appspotmail.com
Reported-by: syzbot+a72c325b042aae6403c7@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8283,8 +8283,18 @@ static void tracing_buffers_mmap_close(s
 	put_snapshot_map(iter->tr);
 }
 
+static int tracing_buffers_may_split(struct vm_area_struct *vma, unsigned long addr)
+{
+	/*
+	 * Trace buffer mappings require the complete buffer including
+	 * the meta page. Partial mappings are not supported.
+	 */
+	return -EINVAL;
+}
+
 static const struct vm_operations_struct tracing_buffers_vmops = {
 	.close		= tracing_buffers_mmap_close,
+	.may_split      = tracing_buffers_may_split,
 };
 
 static int tracing_buffers_mmap(struct file *filp, struct vm_area_struct *vma)


