Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7CFE22259F;
	Mon,  2 Jun 2025 15:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877547; cv=none; b=uAK3WQ/m5TIEux8dYkYC/q99+1Bm/mk4+Jt74qekkZLM9WbCu83lT2h5ehlECTfa+5mL/YBvTHoZp1FxYcLdJ45zoIRe8cwPiKy+eIfAn4YxYOfcQo4OP57s6z9NF9YjPR0gezi+keCSyTEaThz0i2STkitF568Vj0tHRZuWBOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877547; c=relaxed/simple;
	bh=mzglAR3bDNMNASRzIE54JjRdb6FQw1BpZ+Cp6ZvqplA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A7lT/AM5IC/6R6coPDhzyJHzLgQNhU6UBACjME7Vfw1sxzrzeMsQJtxMVoyVwk5RzYnT+75Ns1BaYHpsZJoIbzmCaFMi7rBIiCPJcgd75Wj9fGr2xaHHvB1XJggb+eP8Y8rNfX+PU01yw9N471nzApMZkT++dIBTyJi4G4ioy3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wC+eNLTI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wC+eNLTI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEE6EC4CEEB;
	Mon,  2 Jun 2025 15:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877547;
	bh=mzglAR3bDNMNASRzIE54JjRdb6FQw1BpZ+Cp6ZvqplA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wC+eNLTIJ9tDnjhoHSu5fQcWP0JBs+kgb0vZhf9yJ5LU+urnM5GYsvTR5CwfyvT1Y
	 nKfqVOXBRnYp3UHXqwsPlAtmKifFcY9Gl+0SSFf1L4sAyVGuCuH4ehMHMin6g58hxU
	 /xlfz25ASu6X5b124A1TSXJ5CTfu0lxcSwvI7d2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Boccassi <luca.boccassi@gmail.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.1 312/325] coredump: fix error handling for replace_fd()
Date: Mon,  2 Jun 2025 15:49:48 +0200
Message-ID: <20250602134332.612394149@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -493,7 +493,9 @@ static int umh_pipe_setup(struct subproc
 {
 	struct file *files[2];
 	struct coredump_params *cp = (struct coredump_params *)info->data;
-	int err = create_pipe_files(files, 0);
+	int err;
+
+	err = create_pipe_files(files, 0);
 	if (err)
 		return err;
 
@@ -501,10 +503,13 @@ static int umh_pipe_setup(struct subproc
 
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


