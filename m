Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625D6449B1E;
	Thu, 30 Jul 2026 16:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427881; cv=none; b=k6/7l8hT1JwSYznAODcXukeHW4peyoUR4XOVJ+2+aSuMvvXbQRqg9XnzF73KwxfuHuAdlxfhtLNKNTF0ZUMrpIzHRUJlUmec6GuzDXIJ0By7RuXHkrNafohbn3IY28Zq114YqFM3b5nX+0tyq1IQ8nSCLiNoBx9Yxz6IElxoC8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427881; c=relaxed/simple;
	bh=r9BEogHDnWFJWiPMj4ZIYT+tZJj01TtIly3KADkupAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkkHXb7rzebJMRiuYb1uVlnguuDCOzm6wwlSdU1WB/+OoWSQFsZWmUt9/vIwFPbOHGlzQXfUOagHa94U8/Ima8pAYCtPCJJnsxLvt4qSrgrnFbCW5IMAp59qIsK10YoLzwnxA5+uT9HSo5SvOOY19IB2gHi09I4mqOqKtiDc/78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zprApd/D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zprApd/D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3E31F00A3A;
	Thu, 30 Jul 2026 16:11:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427880;
	bh=lEZqxzl4bqA6zgKVCesQxlUd84Xi8YtwBT6veg9goig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zprApd/Dz6KyXyNgFJDgkbPZOJ1u6K69uJFuXejhUnHLHxc6whtDKR6SfUk7OD0rM
	 JZXxr/r3455tEh9S9H5f0i3EC6KTGnqLiNDd5rzD8NEHGh7YR7LVQyZwA/DQFsEMkd
	 4YBd1nHFaFLEgcqNnPSiapilRhCjKF0R1Fo5OV0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.6 281/484] binfmt_misc: set have_execfd only once the interpreter is opened
Date: Thu, 30 Jul 2026 16:12:58 +0200
Message-ID: <20260730141429.596640344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
@@ -199,9 +199,6 @@ static int load_misc_binary(struct linux
 			goto ret;
 	}
 
-	if (fmt->flags & MISC_FMT_OPEN_BINARY)
-		bprm->have_execfd = 1;
-
 	/* make argv[1] be the path to the binary */
 	retval = copy_string_kernel(bprm->interp, bprm);
 	if (retval < 0)
@@ -231,6 +228,8 @@ static int load_misc_binary(struct linux
 		goto ret;
 
 	bprm->interpreter = interp_file;
+	if (fmt->flags & MISC_FMT_OPEN_BINARY)
+		bprm->have_execfd = 1;
 	if (fmt->flags & MISC_FMT_CREDENTIALS)
 		bprm->execfd_creds = 1;
 


