Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDBF3DC857;
	Mon, 17 Aug 2026 14:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975792; cv=none; b=uIS43+9MvRWqGUpmch1cVhsLPm+RZX6p23v7Njc5pFEmYsIzV69Rc6y9AvDws76mjF3te15C8g9HuIVuucXO8vEx747uzfKnIlINnlZOJ1d9KVw1bxV1SNC53thhZXu2OAot0PdRLvQpe2fDSvX4WSKdqesH3WUoKHCeci8sUbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975792; c=relaxed/simple;
	bh=OeAvRhFASImTlw2sV0uT3DEu+XXWroth0Qur9zjpJVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B53j5+M2HTDfIvnvgw7a8wFY2k3wjWFUWo6aj1I0QfyTyqSzEQQmUtwIsvoYAN/l5pXQQhxhyOZyvR5WKo2gMNzIgGwU+cHJP3MXucHrDnWsI8/7tRB++r8xHQXhzYOcTNcMX/EmvpDlG0V3PCXFH85TsjQygVYy89SNNBVh6l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTALFNda; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTALFNda"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54211F00A3A;
	Mon, 17 Aug 2026 14:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975791;
	bh=l88977laILEh8c9wjnYhcFOsnJH01bCzyIV8ZN1Eo/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTALFNdaAyo03Hy3cIpSKMBR81SdKv+Ltbr32dF7HpN+X+2ubyMzSTyeBk8RiO7Pa
	 oRbRPI6JLe/VY0lGQlZDCASonJSUJA4Uvq3L64QKNqnjWK4eIm9iSLR74btH6YL0eN
	 VE5cIPUj56lFVmWHU5/xi4/NfV3Oh47sOooGK0iE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 148/389] binfmt_misc: set have_execfd only once the interpreter is opened
Date: Mon, 17 Aug 2026 15:29:47 +0200
Message-ID: <20260817132544.945521860@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 


