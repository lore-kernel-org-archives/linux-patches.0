Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1881FCFE2;
	Mon,  2 Jun 2025 14:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874972; cv=none; b=WqqjjyI289Tmr3oWSRKSLnIAf5NjxIVqL3IMq1RxomgsrnYKeg9AJin4zig1hDPYIwFWvGTBbqBCOs6j4dQn8kNenFIwPdVN0FZcb3/efsXpV6x6yG7Piq+lU8FXhFeCe71rcvDUw7/zWE/oNufMHP/9No9OSe832W8cOU3UOb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874972; c=relaxed/simple;
	bh=02ue9IlPTATr3g+TEN+2gzIZDDymCbI3tjW+wwfKFCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PE4IYi8sXOgoK4fjeRiVMfEF5ZKs848WfK6KfKm0vDXSslr/c48Nvwe5Qf26eqCWkcz7XIi/k4WsR8SHDs41fq+9Jz27jx7jXDUdWfqepAub40gatts3wb3xQkbr810SuGC2AYKqi6VrP4kNGC0ZlH+5a1yG+r88tywpZv2FPco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boYR35oH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boYR35oH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96533C4CEEB;
	Mon,  2 Jun 2025 14:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874972;
	bh=02ue9IlPTATr3g+TEN+2gzIZDDymCbI3tjW+wwfKFCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boYR35oH+QB2bSoqiswaXVRIKk0fOL0oqWRiisSPnfJx5H40S8oK76H3WHFxpsjAY
	 S3gkneLYi+AlBO8hytk9G9O6S1BsyEhxbcwttctldi1shpupZulAsoKuGd1aa9GfA4
	 8MqD2ip+bdsfK/4aA8uTtpXgK8CpYrjStD8rdDn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.4 192/204] coredump: fix error handling for replace_fd()
Date: Mon,  2 Jun 2025 15:48:45 +0200
Message-ID: <20250602134303.222592387@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -551,7 +551,9 @@ static int umh_pipe_setup(struct subproc
 {
 	struct file *files[2];
 	struct coredump_params *cp = (struct coredump_params *)info->data;
-	int err = create_pipe_files(files, 0);
+	int err;
+
+	err = create_pipe_files(files, 0);
 	if (err)
 		return err;
 
@@ -559,10 +561,13 @@ static int umh_pipe_setup(struct subproc
 
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


