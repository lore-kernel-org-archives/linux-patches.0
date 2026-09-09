Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96EF337F303;
	Fri, 11 Sep 2026 18:48:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789152500; cv=none; b=TBoityTg4rJGwxqsu7quX6cYTwCzX89VljwST1n36fEXB9nGwYXVMiuXvoFMMHCLF0RpyXcPtfxmTfxdsipXFfDi0TvwicjFwlNypq1UsviXTCSoLSl/NStb0oW4BpK0vQdVSH3oyPrqRKrezhryZlhu8tJHUlICnGkrp3biQRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789152500; c=relaxed/simple;
	bh=ry4LAoz76/KhXYS+j2KYHfIIT5mZtZGsPRRBJwSX9cM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pECPEn7f04X8rhey7HxwI7Ww4F2s5gmmjbH531Ek4bsJm1lGdGQTn7r4h6Ni8e5HMZIxzBZ6hM988FJEvt23VyEjGmTF5iObcKxBjCUeFcADU0FvW4edgTmX0/BjgnGBxuJVVAkaSalRsbVc6BmBgCC2ZjskGeULOYl2E/nsiHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EakbNgI+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EakbNgI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31601F000FF;
	Fri, 11 Sep 2026 18:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789152497;
	bh=B0XtFXhhYqLoBp41xXkYUfHoBldSPn8N12PyAWfLPJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EakbNgI+BJ8yk3v/wS/uif41UY5RMmfsopoqg2wZfNWEUZhiBepZ9E8sy3r+qyCHj
	 UdAXShbCKimGE5yxHXKVtPB027lFZsLgnWeO3Glj8I1YavrwA6BuQa9XMsypx6FqES
	 9Sh60+/Q36RSyztQ6cXYHIOK+tVymcI45EZIu6yY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 6.18 581/583] pidfs: protect PIDFD_GET_* ioctls() via ifdef
Date: Wed,  9 Sep 2026 15:44:26 +0200
Message-ID: <20260909134257.924318028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 75ddaa4ddc86d31edb15e50152adf4ddee77a6ba upstream.

We originally protected PIDFD_GET_<ns-type>_NAMESPACE ioctls() through
ifdefs and recent rework made it possible to drop them. There was an
oversight though. When the relevant namespace is turned off ns->ops will
be NULL so even though opening a file descriptor is perfectly legitimate
it would fail during inode eviction when the file was closed.

The simple fix would be to check ns->ops for NULL and continue allow to
retrieve namespace fds from pidfds but we don't allow retrieving them
when the relevant namespace type is turned off. So keep the
simplification but add the ifdefs back in.

Link: https://lore.kernel.org/20251222214907.GA189632@quark
Link: https://patch.msgid.link/20251224-ununterbrochen-gagen-ea949b83f8f2@brauner
Fixes: a71e4f103aed ("pidfs: simplify PIDFD_GET_<type>_NAMESPACE ioctls")
Tested-by: Brendan Jackman <jackmanb@kernel.org>
Tested-by: Eric Biggers <ebiggers@kernel.org>
Reported-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pidfs.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/pidfs.c
+++ b/fs/pidfs.c
@@ -511,14 +511,18 @@ static long pidfd_ioctl(struct file *fil
 	switch (cmd) {
 	/* Namespaces that hang of nsproxy. */
 	case PIDFD_GET_CGROUP_NAMESPACE:
+#ifdef CONFIG_CGROUPS
 		if (!ns_ref_get(nsp->cgroup_ns))
 			break;
 		ns_common = to_ns_common(nsp->cgroup_ns);
+#endif
 		break;
 	case PIDFD_GET_IPC_NAMESPACE:
+#ifdef CONFIG_IPC_NS
 		if (!ns_ref_get(nsp->ipc_ns))
 			break;
 		ns_common = to_ns_common(nsp->ipc_ns);
+#endif
 		break;
 	case PIDFD_GET_MNT_NAMESPACE:
 		if (!ns_ref_get(nsp->mnt_ns))
@@ -526,32 +530,43 @@ static long pidfd_ioctl(struct file *fil
 		ns_common = to_ns_common(nsp->mnt_ns);
 		break;
 	case PIDFD_GET_NET_NAMESPACE:
+#ifdef CONFIG_NET_NS
 		if (!ns_ref_get(nsp->net_ns))
 			break;
 		ns_common = to_ns_common(nsp->net_ns);
+#endif
 		break;
 	case PIDFD_GET_PID_FOR_CHILDREN_NAMESPACE:
+#ifdef CONFIG_PID_NS
 		if (!ns_ref_get(nsp->pid_ns_for_children))
 			break;
 		ns_common = to_ns_common(nsp->pid_ns_for_children);
+#endif
 		break;
 	case PIDFD_GET_TIME_NAMESPACE:
+#ifdef CONFIG_TIME_NS
 		if (!ns_ref_get(nsp->time_ns))
 			break;
 		ns_common = to_ns_common(nsp->time_ns);
+#endif
 		break;
 	case PIDFD_GET_TIME_FOR_CHILDREN_NAMESPACE:
+#ifdef CONFIG_TIME_NS
 		if (!ns_ref_get(nsp->time_ns_for_children))
 			break;
 		ns_common = to_ns_common(nsp->time_ns_for_children);
+#endif
 		break;
 	case PIDFD_GET_UTS_NAMESPACE:
+#ifdef CONFIG_UTS_NS
 		if (!ns_ref_get(nsp->uts_ns))
 			break;
 		ns_common = to_ns_common(nsp->uts_ns);
+#endif
 		break;
 	/* Namespaces that don't hang of nsproxy. */
 	case PIDFD_GET_USER_NAMESPACE:
+#ifdef CONFIG_USER_NS
 		scoped_guard(rcu) {
 			struct user_namespace *user_ns;
 
@@ -560,8 +575,10 @@ static long pidfd_ioctl(struct file *fil
 				break;
 			ns_common = to_ns_common(user_ns);
 		}
+#endif
 		break;
 	case PIDFD_GET_PID_NAMESPACE:
+#ifdef CONFIG_PID_NS
 		scoped_guard(rcu) {
 			struct pid_namespace *pid_ns;
 
@@ -570,6 +587,7 @@ static long pidfd_ioctl(struct file *fil
 				break;
 			ns_common = to_ns_common(pid_ns);
 		}
+#endif
 		break;
 	default:
 		error = -ENOIOCTLCMD;


