Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648951F4165;
	Mon,  2 Jun 2025 13:58:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748872707; cv=none; b=ni6GpYNa1OgereCar9DeocWq7Boo3jGt/Bn2n2JWueeWjxZvoUQPkGbyoHo0X8FAJ6Kr8YoMbzUVfYhmI2H1TU9Zff5Vo38mJc5ArpKrSJlHO1TLkZsRghgTcGDksn7z+xP5VBCNI65LyPjnxnEtKTm1JrL+Gl87PHOTpPatMgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748872707; c=relaxed/simple;
	bh=YAn0GnnlYFcY9AQ9oIeS6JH5a9wCOe0BJyhm3Xw4T8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFSwE1r+ZomZuZABM0crq9SFBLsg8TTLP4EzKFQU0GUD4Kzx7tI0cYBXSFhDim9v0K/3mv93VseaAhKbo2pQ1osiAE1qAFUDavYf3R0NYVj9uq3XenO3vs6ZLz+dL8dCOZEBMXIqv6nVtrflLFg1YxONGwyT+xalYWCPCVL8EDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzwd5/DD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzwd5/DD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23105C4CEEB;
	Mon,  2 Jun 2025 13:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748872706;
	bh=YAn0GnnlYFcY9AQ9oIeS6JH5a9wCOe0BJyhm3Xw4T8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzwd5/DDrqPF7t9ey9uCmK3IAzOiEpX1/bOWBr+7slZHcePyKg+OOt5cTyL6fAza/
	 dyUtXnnnVU2aXfEI49YYKnfCTwRuDiFM+uTZSsFKGisbDLZ0MyS7k+j5N3cankU+hS
	 G448CEMk0z2HEdHmh1+LjYKnmv02vhtDRhwivGEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.14 46/73] coredump: fix error handling for replace_fd()
Date: Mon,  2 Jun 2025 15:47:32 +0200
Message-ID: <20250602134243.502592658@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
References: <20250602134241.673490006@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


