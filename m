Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53067221703;
	Mon,  2 Jun 2025 13:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872187; cv=none; b=uMbKr6NABUDgyxtJy2LAYB8ubzyDP19FEiWQT7Jthmh6zOD9ln45uzuncM4zfkT0hYT6DkSmD0NtAfVN7a7fwgVK7GbOE3eRFioUKR6YJ5DM5CKTeFzPkpxHRtzeRGPWVdth4yIsTFypGncQy7RwndM7IRmEjUTjO1OP4WoxgkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872187; c=relaxed/simple;
	bh=+49BgIVsAaK60vS4R/p8hWgZmbygTJo9bsYDwgDNvBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXw0lBr1sdAOa+p9WxZWZHrXimBugWLPJscLZoPNIZNMtfmsQvnR8Ru5UXAe73sjLlZC35++wxbFiAzNTEdTqc1brTPqYMPSFmL2LkZtqKQ3OBqcVy3HnDa06SP7bgaANwMa4peQCslGxoJd7hcfjkobVGKU4/PloCfHIBXc7XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bpggZF7I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bpggZF7I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE116C4CEEB;
	Mon,  2 Jun 2025 13:49:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872187;
	bh=+49BgIVsAaK60vS4R/p8hWgZmbygTJo9bsYDwgDNvBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bpggZF7IKWHoIiMcF7+rLUZ0+Jpn6klbPD3oWnrm9rXDnLTYBz6zjJKWyLLoFtGtD
	 rx7T5k7oSUw2Y90M6JhRCeubDncdqrflsv/bbpue0i09JMiSX9fop/iUAXRbw8d4Fd
	 OgFF2yUeHfGys16GuzDk7CwkJwel7uegAYDoGjWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.15 46/49] coredump: fix error handling for replace_fd()
Date: Mon,  2 Jun 2025 15:47:38 +0200
Message-ID: <20250602134239.749802437@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
References: <20250602134237.940995114@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -507,7 +507,9 @@ static int umh_pipe_setup(struct subproc
 {
 	struct file *files[2];
 	struct coredump_params *cp = (struct coredump_params *)info->data;
-	int err = create_pipe_files(files, 0);
+	int err;
+
+	err = create_pipe_files(files, 0);
 	if (err)
 		return err;
 
@@ -515,10 +517,13 @@ static int umh_pipe_setup(struct subproc
 
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


