Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0891FCFE2;
	Mon,  2 Jun 2025 14:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874978; cv=none; b=LOJR2IhlpwIcjfBVvOg9ckyMNOwMEzCf5GN90zTv6BTcF6YYR+L3T/R1ANw1dbR5PJPEc+C8jTX07EWlGcw9uTAkxTIv93RhB0TxqhHji/0m6nnoZ9GDtdZXnWp7+tbManEs/Q+TqGNtQAsuUTYSR+1aOURy9STDqU0l0FwJ6pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874978; c=relaxed/simple;
	bh=xDoFjpA07zXzEqPHLFhz85N/BnSZTJF4q9dGVCOAgY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t22lXUOPGsVvrDu+Njb4gv7e/20MqzyJm1SktB3EnBa0tBYKe1H+0yFX94w1V1Ui5QUKgDH9U3BZ5TlpbZwchVEa06ZHKHg+ERyjS1xZySniYq8p937LdqedACNEbysOYW9Z4iYvvr7OsPjso2sIrK2qCnDqONIAGNdxEhf1zkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngpxd5ia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngpxd5ia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CF7C4CEEB;
	Mon,  2 Jun 2025 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874978;
	bh=xDoFjpA07zXzEqPHLFhz85N/BnSZTJF4q9dGVCOAgY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngpxd5iaw1C2u7aZWA92hswJUin7k9f1h8oaiCy/DonB93umGHpRfGZwPj7MvPhY8
	 zdbGbl2pntbVaPbCk5k66s1VTMhYst6Ixfw2IG3S39Rvhwa40xEcpC6kIatDrEfW2s
	 x73njEey2+eYxsNSpdLdamqMtwovgCuvgoEkyC0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.4 194/204] pid: add pidfd_prepare()
Date: Mon,  2 Jun 2025 15:48:47 +0200
Message-ID: <20250602134303.298376621@linuxfoundation.org>
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

commit 6ae930d9dbf2d093157be33428538c91966d8a9f upstream.

Add a new helper that allows to reserve a pidfd and allocates a new
pidfd file that stashes the provided struct pid. This will allow us to
remove places that either open code this function or that call
pidfd_create() but then have to call close_fd() because there are still
failure points after pidfd_create() has been called.

Reviewed-by: Jan Kara <jack@suse.cz>
Message-Id: <20230327-pidfd-file-api-v1-1-5c0e9a3158e4@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/pid.h |    1 
 kernel/fork.c       |   85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 86 insertions(+)

--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -75,6 +75,7 @@ extern const struct file_operations pidf
 struct file;
 
 extern struct pid *pidfd_pid(const struct file *file);
+int pidfd_prepare(struct pid *pid, unsigned int flags, struct file **ret);
 
 static inline struct pid *get_pid(struct pid *pid)
 {
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1750,6 +1750,91 @@ const struct file_operations pidfd_fops
 #endif
 };
 
+/**
+ * __pidfd_prepare - allocate a new pidfd_file and reserve a pidfd
+ * @pid:   the struct pid for which to create a pidfd
+ * @flags: flags of the new @pidfd
+ * @pidfd: the pidfd to return
+ *
+ * Allocate a new file that stashes @pid and reserve a new pidfd number in the
+ * caller's file descriptor table. The pidfd is reserved but not installed yet.
+
+ * The helper doesn't perform checks on @pid which makes it useful for pidfds
+ * created via CLONE_PIDFD where @pid has no task attached when the pidfd and
+ * pidfd file are prepared.
+ *
+ * If this function returns successfully the caller is responsible to either
+ * call fd_install() passing the returned pidfd and pidfd file as arguments in
+ * order to install the pidfd into its file descriptor table or they must use
+ * put_unused_fd() and fput() on the returned pidfd and pidfd file
+ * respectively.
+ *
+ * This function is useful when a pidfd must already be reserved but there
+ * might still be points of failure afterwards and the caller wants to ensure
+ * that no pidfd is leaked into its file descriptor table.
+ *
+ * Return: On success, a reserved pidfd is returned from the function and a new
+ *         pidfd file is returned in the last argument to the function. On
+ *         error, a negative error code is returned from the function and the
+ *         last argument remains unchanged.
+ */
+static int __pidfd_prepare(struct pid *pid, unsigned int flags, struct file **ret)
+{
+	int pidfd;
+	struct file *pidfd_file;
+
+	if (flags & ~(O_NONBLOCK | O_RDWR | O_CLOEXEC))
+		return -EINVAL;
+
+	pidfd = get_unused_fd_flags(O_RDWR | O_CLOEXEC);
+	if (pidfd < 0)
+		return pidfd;
+
+	pidfd_file = anon_inode_getfile("[pidfd]", &pidfd_fops, pid,
+					flags | O_RDWR | O_CLOEXEC);
+	if (IS_ERR(pidfd_file)) {
+		put_unused_fd(pidfd);
+		return PTR_ERR(pidfd_file);
+	}
+	get_pid(pid); /* held by pidfd_file now */
+	*ret = pidfd_file;
+	return pidfd;
+}
+
+/**
+ * pidfd_prepare - allocate a new pidfd_file and reserve a pidfd
+ * @pid:   the struct pid for which to create a pidfd
+ * @flags: flags of the new @pidfd
+ * @pidfd: the pidfd to return
+ *
+ * Allocate a new file that stashes @pid and reserve a new pidfd number in the
+ * caller's file descriptor table. The pidfd is reserved but not installed yet.
+ *
+ * The helper verifies that @pid is used as a thread group leader.
+ *
+ * If this function returns successfully the caller is responsible to either
+ * call fd_install() passing the returned pidfd and pidfd file as arguments in
+ * order to install the pidfd into its file descriptor table or they must use
+ * put_unused_fd() and fput() on the returned pidfd and pidfd file
+ * respectively.
+ *
+ * This function is useful when a pidfd must already be reserved but there
+ * might still be points of failure afterwards and the caller wants to ensure
+ * that no pidfd is leaked into its file descriptor table.
+ *
+ * Return: On success, a reserved pidfd is returned from the function and a new
+ *         pidfd file is returned in the last argument to the function. On
+ *         error, a negative error code is returned from the function and the
+ *         last argument remains unchanged.
+ */
+int pidfd_prepare(struct pid *pid, unsigned int flags, struct file **ret)
+{
+	if (!pid || !pid_has_task(pid, PIDTYPE_TGID))
+		return -EINVAL;
+
+	return __pidfd_prepare(pid, flags, ret);
+}
+
 static void __delayed_free_task(struct rcu_head *rhp)
 {
 	struct task_struct *tsk = container_of(rhp, struct task_struct, rcu);


