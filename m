Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E42233712;
	Mon,  2 Jun 2025 15:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748876499; cv=none; b=UWe6uba9hkiHyKn1+RXJie9XIr1skP/P2KA05nZ2o+Xu9cpsI1ccQ4nLNZ2MxCpfa5GX14iO8wgZA5rPWX1t+1uMxpD8qSyaf0aZWi/f7ngA00G4etnc4pi/HMhZeFaCNfmkLZkJG6yPVEqRSdh7i+dvVM9cIcq67jl4AF6mjEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748876499; c=relaxed/simple;
	bh=+8vvHsGEHtrJ3/lIs4E8kaGnVXIHoBeK4daoXxOBeFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=om/saGKr92HYzQIIGEs7/FWRvuRHYDEMUrKXhwwJDRFAq285chBVqpNnbQd81O43Y/K8hlMclG5xeXkkl3TLUdAFsYVnX9KacqgTG9FE61Gp47juI24fRQKKg0YYbH0GLNJC3i/SEylsiqkgMbztcSYCY1CrZAGlj5EXc4DPohk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcNYz2Ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcNYz2Ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369A9C4CEEB;
	Mon,  2 Jun 2025 15:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748876498;
	bh=+8vvHsGEHtrJ3/lIs4E8kaGnVXIHoBeK4daoXxOBeFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WcNYz2Ibn9jfok3Zs+uOsz2sZl4BfbJbJt0PdIegocf7ROytGm8ZX9gHY70qz3MEB
	 8zm0zl+K1FTJWq7j3Ra56ngFQW8JUCO7w5JZaFCmYdmfBrK2FFHB3lrb4X8sPdXW0c
	 v7ajyD1+6LTxaDs0AbEjdPHhiWPeJrHv16t2MN6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 194/207] coredump: fix error handling for replace_fd()
Date: Mon,  2 Jun 2025 15:49:26 +0200
Message-ID: <20250602134306.372923932@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134258.769974467@linuxfoundation.org>
References: <20250602134258.769974467@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 95c5f43181fe9c1b5e5a4bd3281c857a5259991f upstream.

The replace_fd() helper returns the file descriptor number on success
and a negative error code on failure. The current error handling in
umh_pipe_setup() only works because the file descriptor that is replaced
is zero but that's pretty volatile. Explicitly check for a negative
error code.

Link: https://lore.kernel.org/20250414-work-coredump-v2-2-685bf231f828@kernel.org
Tested-by: Luca Boccassi <luca.boccassi@gmail.com>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/coredump.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -564,7 +564,9 @@ static int umh_pipe_setup(struct subproc
 {
 	struct file *files[2];
 	struct coredump_params *cp = (struct coredump_params *)info->data;
-	int err = create_pipe_files(files, 0);
+	int err;
+
+	err = create_pipe_files(files, 0);
 	if (err)
 		return err;
 
@@ -572,10 +574,13 @@ static int umh_pipe_setup(struct subproc
 
 	err = replace_fd(0, files[0], 0);
 	fput(files[0]);
+	if (err < 0)
+		return err;
+
 	/* and disallow core files too */
 	current->signal->rlim[RLIMIT_CORE] = (struct rlimit){1, 1};
 
-	return err;
+	return 0;
 }
 
 void do_coredump(const kernel_siginfo_t *siginfo)


