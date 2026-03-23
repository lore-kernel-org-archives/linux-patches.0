Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7323B27D4;
	Mon, 23 Mar 2026 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274584; cv=none; b=URHrZXHJYsazzWCj/DEuCeOumGvpHHcoAQqKYbNMiF6JU4FLLrCaigmWOsvhKQi/NgacN/xcbogM8g8YhymxHzrLIl3khixHXCIHdiAy4jS+EX2MtP+n5QcxzMaY8hh8pg+THRZU9nb7IRjmXcCPBs81xFDJQqU7o9hjCjOJqBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274584; c=relaxed/simple;
	bh=NHW1td60Obg8bmTUhrgdQncsGfE5ctadAI1aS/DvIKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sDQsbrjyXzasiFap5CwIte5O3Sc9oQy/KVPyWscrMDzPTYyr7g5RdNjj4o4DJ35W/AHTo4hEWsdh8S2ltiEOcozrsn7Hx/Bn7dcBFZxdYZUx6mSMz+alR7oG1uRgpCWt8bP33YEfc3AyUQM9TLeHXVgm1IpS743PVaa4eEy2k5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTpnUCCU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTpnUCCU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA4DC4CEF7;
	Mon, 23 Mar 2026 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274584;
	bh=NHW1td60Obg8bmTUhrgdQncsGfE5ctadAI1aS/DvIKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iTpnUCCUqOz4hlh1I/851M9vkmu484s6U5ht09ccdUSSqi6y+57vvb877Jm7qtwIq
	 zVVcsvG8nr9PewW1RBJSlQLE27mNvvfmGjP0Av9bNVfhsnfY5i9P3RpQNvARFQbjik
	 NGLqB61jEBNEYPz9k2818kp+m/l5fjw2v0AgYPw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.18 044/212] nsfs: tighten permission checks for ns iteration ioctls
Date: Mon, 23 Mar 2026 14:44:25 +0100
Message-ID: <20260323134505.158619792@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

[ Upstream commit e6b899f08066e744f89df16ceb782e06868bd148 ]

Even privileged services should not necessarily be able to see other
privileged service's namespaces so they can't leak information to each
other. Use may_see_all_namespaces() helper that centralizes this policy
until the nstree adapts.

Link: https://patch.msgid.link/20260226-work-visibility-fixes-v1-1-d2c2853313bd@kernel.org
Fixes: a1d220d9dafa ("nsfs: iterate through mount namespaces")
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Cc: stable@kernel.org # v6.12+
Signed-off-by: Christian Brauner <brauner@kernel.org>
[ context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nsfs.c                 |   13 +++++++++++++
 include/linux/ns_common.h |    2 ++
 kernel/nscommon.c         |    6 ++++++
 3 files changed, 21 insertions(+)

--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -194,6 +194,17 @@ static bool nsfs_ioctl_valid(unsigned in
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
@@ -209,6 +220,8 @@ static long ns_ioctl(struct file *filp,
 
 	if (!nsfs_ioctl_valid(ioctl))
 		return -ENOIOCTLCMD;
+	if (!may_use_nsfs_ioctl(ioctl))
+		return -EPERM;
 
 	ns = get_proc_ns(file_inode(filp));
 	switch (ioctl) {
--- a/include/linux/ns_common.h
+++ b/include/linux/ns_common.h
@@ -144,6 +144,8 @@ void __ns_common_free(struct ns_common *
 
 #define ns_common_free(__ns) __ns_common_free(to_ns_common((__ns)))
 
+bool may_see_all_namespaces(void);
+
 static __always_inline __must_check bool __ns_ref_put(struct ns_common *ns)
 {
 	return refcount_dec_and_test(&ns->__ns_ref);
--- a/kernel/nscommon.c
+++ b/kernel/nscommon.c
@@ -75,3 +75,9 @@ void __ns_common_free(struct ns_common *
 {
 	proc_free_inum(ns->inum);
 }
+
+bool may_see_all_namespaces(void)
+{
+	return (task_active_pid_ns(current) == &init_pid_ns) &&
+	       ns_capable_noaudit(init_pid_ns.user_ns, CAP_SYS_ADMIN);
+}


