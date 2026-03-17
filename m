Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE6C3F54C4;
	Tue, 17 Mar 2026 16:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766294; cv=none; b=l4rEUMzTHJJtjhlH8mmVfrwLtmVEivXTgu+EjlXyg2HB4sfa6pd3haErC0LZbGrQy1Jynhlcy07oSLXOfL/nK6axVGlrkwHz6qZyMLRhvlXXkTF3GxUijaL3zgHS6Si+hF7/mgPBPLKyeQYP7CMCP3vq7iJVdBBijlycgFM3JRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766294; c=relaxed/simple;
	bh=ZzOA64W1bTFuUKkz1MUv0k8hU6pQm6gr3mqqtMKFdQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tgPmQAQZGhJQfbcvkRGC5A8NTiYDnsHwzyn28dJlRjjXyLae5A8PgD1RMcRZ/Ksj2w1kf01lxaYRpqYHRuuAapFB8RwLdmuuEjr6rkM6V9S04f2J7KA1fAEmpqKad6uVvysg+fFSaz/q0VA5IHyMHlqG3mqeXQo8m/hr/wb+VNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ajm8Um7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ajm8Um7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD65C4CEF7;
	Tue, 17 Mar 2026 16:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766294;
	bh=ZzOA64W1bTFuUKkz1MUv0k8hU6pQm6gr3mqqtMKFdQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ajm8Um7oHLwvU9NGFqZ/o9mOaP5vhQCOol9Lh45gesXP2Ru+mlDClouxtcZjydjz5
	 mOZsaolMX2uHvOX9YLdyyB7Orut3C2EtMU6pqyAUqnfWvApMj/8KLu6nLrr5aWXZwf
	 vmm2/4BSNsqOgLkP3TUw7kpN+PTL0z+WkBb3fL50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.19 213/378] nsfs: tighten permission checks for ns iteration ioctls
Date: Tue, 17 Mar 2026 17:32:50 +0100
Message-ID: <20260317163014.844304463@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit e6b899f08066e744f89df16ceb782e06868bd148 upstream.

Even privileged services should not necessarily be able to see other
privileged service's namespaces so they can't leak information to each
other. Use may_see_all_namespaces() helper that centralizes this policy
until the nstree adapts.

Link: https://patch.msgid.link/20260226-work-visibility-fixes-v1-1-d2c2853313bd@kernel.org
Fixes: a1d220d9dafa ("nsfs: iterate through mount namespaces")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@kernel.org # v6.12+
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nsfs.c                 |   13 +++++++++++++
 include/linux/ns_common.h |    2 ++
 kernel/nscommon.c         |    6 ++++++
 3 files changed, 21 insertions(+)

--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -186,6 +186,17 @@ static bool nsfs_ioctl_valid(unsigned in
 	return false;
 }
 
+static bool may_use_nsfs_ioctl(unsigned int cmd)
+{
+	switch (_IOC_NR(cmd)) {
+	case _IOC_NR(NS_MNT_GET_NEXT):
+		fallthrough;
+	case _IOC_NR(NS_MNT_GET_PREV):
+		return may_see_all_namespaces();
+	}
+	return true;
+}
+
 static long ns_ioctl(struct file *filp, unsigned int ioctl,
 			unsigned long arg)
 {
@@ -201,6 +212,8 @@ static long ns_ioctl(struct file *filp,
 
 	if (!nsfs_ioctl_valid(ioctl))
 		return -ENOIOCTLCMD;
+	if (!may_use_nsfs_ioctl(ioctl))
+		return -EPERM;
 
 	ns = get_proc_ns(file_inode(filp));
 	switch (ioctl) {
--- a/include/linux/ns_common.h
+++ b/include/linux/ns_common.h
@@ -55,6 +55,8 @@ static __always_inline bool is_ns_init_i
 
 #define ns_common_free(__ns) __ns_common_free(to_ns_common((__ns)))
 
+bool may_see_all_namespaces(void);
+
 static __always_inline __must_check int __ns_ref_active_read(const struct ns_common *ns)
 {
 	return atomic_read(&ns->__ns_ref_active);
--- a/kernel/nscommon.c
+++ b/kernel/nscommon.c
@@ -309,3 +309,9 @@ void __ns_ref_active_get(struct ns_commo
 			return;
 	}
 }
+
+bool may_see_all_namespaces(void)
+{
+	return (task_active_pid_ns(current) == &init_pid_ns) &&
+	       ns_capable_noaudit(init_pid_ns.user_ns, CAP_SYS_ADMIN);
+}


