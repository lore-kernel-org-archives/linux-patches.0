Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A400837BE64;
	Thu, 30 Jul 2026 15:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424644; cv=none; b=iYerfJK+66Saqdq7nXclZM/4KcuWAhnj9gn/GICa/LKlrZw296xrBAP2nwe8iWIbH8ubxXNNOZ4AL17OYGyRBYkTqD7fGIiEVkxjgkzhU3OWPdokh5s08kmgpBKSYHRQ34U7AQ6lJawfriV0kuPrDn6wvJT7McFmcfMdPREQ4Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424644; c=relaxed/simple;
	bh=ELWFlE45nT9KKSDyGB8T0OzhPM1idxfKnuuH0PNCVts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfB3TqorRK6vfSWQy4iG2heZ7UvNNlca9CAtb9kkL/VhJ9+KlnO4vP6TcnLPNnDfLkGqEosaVX0zNXqAGzQaQXI8zzbJy23/P2CHFsLXL0WEh7cG3dV6xf7xmZkFxWqNRqHWGQsCrSPlpX0C3fkEZfxGz+lQRE9H5P3wmK8Bor0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WFqInpLz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WFqInpLz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5CA1F000E9;
	Thu, 30 Jul 2026 15:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424643;
	bh=awf0mDXOOgD/5XQq/N63tEjKhy7HD6VXh7Lq5YRC6z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WFqInpLzk2UcnrN/ZJzO9lJhgcVvMaU6KLy6jtC5eU+xQi7OcBriIdkEWA0IOHOD1
	 jBJYuR1KbCSQWvAgtQxOT73eWbzLXA1Scrww7vszB+SP98hoJIy9+Ac9pFm0b/FtMF
	 r7Ca36U4fK14gCsOzSlFAwsoB/pqYA2IUENjjVJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 467/675] binfmt_misc: set have_execfd only once the interpreter is opened
Date: Thu, 30 Jul 2026 16:13:17 +0200
Message-ID: <20260730141455.056169077@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit bbf5f639918dc011aaf60aab8480218758ee68c5 upstream.

load_misc_binary() raises bprm->have_execfd as soon as it sees the 'O'
(or 'C') flag. This happens well before it opens the interpreter. If
that open fails the flag stays set on the bprm. binfmt_misc is at the
head of the format list so an interpreter open failure that returns
-ENOEXEC lets the search fall through to a later format. This means it
runs the matched binary directly having never staged an interpreter. So
bprm->executable is NULL while have_execfd falsely claims a descriptor
is present.

Consequently, begin_new_exec() dereferences the missing executable:

  would_dump(bprm, bprm->executable);

and NULL derefs. Had it not, the hand-off later in the same function
would have failed anyway. FD_ADD(0, bprm->executable) rejects a NULL
file with -ENOMEM. Both sites are past the point of no return so the
exec cannot be unwound either way.

This can be reached by unprivileged users as binfmt_misc can be mounted
in user namespaces. So a user can register an 'O' entry whose
interpreter lives on a FUSE mount, have the FUSE server fail the open
with -ENOEXEC and execute a native ELF file that matches the entry.

have_execfd only means anything alongside the executable it describes
which is not set until the interpreter has been opened and staged.
So lets raise it there, next to execfd_creds, which is already set at
that point. An open failure now leaves it clear, so the fallback format
derives credentials from the binary and emits no AT_EXECFD, as it would
for any native exec. The argv rewrite load_misc_binary() performs before
the open is still not undone. This means the binary sees the interpreter
path in argv[0] and its own path in argv[1] but that predates this
change and only became observable once the exec stopped faulting.

Link: https://patch.msgid.link/20260720-beglichen-kognitiv-organismus-5e1e55326c56@brauner
Fixes: bc2bf338d54b ("exec: Remove recursion from search_binary_handler")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/binfmt_misc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -227,9 +227,6 @@ static int load_misc_binary(struct linux
 			goto ret;
 	}
 
-	if (fmt->flags & MISC_FMT_OPEN_BINARY)
-		bprm->have_execfd = 1;
-
 	/* make argv[1] be the path to the binary */
 	retval = copy_string_kernel(bprm->interp, bprm);
 	if (retval < 0)
@@ -259,6 +256,8 @@ static int load_misc_binary(struct linux
 		goto ret;
 
 	bprm->interpreter = interp_file;
+	if (fmt->flags & MISC_FMT_OPEN_BINARY)
+		bprm->have_execfd = 1;
 	if (fmt->flags & MISC_FMT_CREDENTIALS)
 		bprm->execfd_creds = 1;
 


