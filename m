Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6045B227EAC;
	Mon,  2 Jun 2025 14:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874315; cv=none; b=hSBbsUaS4Eyv6lnzoU7EYcUhD8Au7y8M9ys7ad6PjX2zc++uY3K0GkV4QTrK6eJ+jv3lnm76TInQ0v14Ki/K4c6OGdqnkVEaU8qint04hU7aYs2jNMCou7w6K9yx6dMEH4Mjye/lMHFV6QEMDAtTN8mlQFJ34Mx1DQ+N57XQIfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874315; c=relaxed/simple;
	bh=5tM/DkmY+unEo8OdpkyprjElyk0LPluSl6dAob2Eqc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzPmLGjC+lpcKTvSHmSeIX1tB/KPMAnhOe/B7AKMcj4/Vk1A6D3/p5EcATzMODkoIb6mq11IO/5nZhHs3lzRRL++geXS7gQNgRomPdwBnp0sNrvpH+hSz0kQEImOD+VzdBl3/7N1j4d7DKoQXtgK0nUUK/xDsgJSx6OH2Pq3q1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMHHT6/y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMHHT6/y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5A0C4CEEB;
	Mon,  2 Jun 2025 14:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874315;
	bh=5tM/DkmY+unEo8OdpkyprjElyk0LPluSl6dAob2Eqc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMHHT6/y/5jCRbJL8jz4Kw5ORmJWReoLiRc/zmywWUwSX61TxNI0NEvRm/wUUrGUN
	 OJHC038LE5AhUXIEG16OqW9zLpTTlChlVboDkSw73+K8LjQl8yv0lbbp9j0VQKXQAQ
	 HqSy2fIWOnFie2vJ3ilE4P/7RD3ZUWKd5REKJBDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.6 429/444] coredump: fix error handling for replace_fd()
Date: Mon,  2 Jun 2025 15:48:13 +0200
Message-ID: <20250602134358.352312860@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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
@@ -502,7 +502,9 @@ static int umh_pipe_setup(struct subproc
 {
 	struct file *files[2];
 	struct coredump_params *cp = (struct coredump_params *)info->data;
-	int err = create_pipe_files(files, 0);
+	int err;
+
+	err = create_pipe_files(files, 0);
 	if (err)
 		return err;
 
@@ -510,10 +512,13 @@ static int umh_pipe_setup(struct subproc
 
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


