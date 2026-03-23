Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1153AF643;
	Mon, 23 Mar 2026 14:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774276917; cv=none; b=eELjKZ56X/DFFM7WSGRTIilPppsg9XfaIRlmZTXqrL325/suj7mFYsxcmbaE0NUcQ8VZ1mUaeGieMHO6ndvVvrIPjJ3xl9hIXHklpo9kHhPJiSRFm1mJMhMERF4+LplRf3YTq7amokUfQCm7vOs8MrQqUjgymY6NEl+UNYpJNVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774276917; c=relaxed/simple;
	bh=jDv6B06yz0N5a5Ai/+sup7QjxswdEGAp63mWgGdcH7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J/hkmNPjbxYMejXl1oYCAX+fNatECnMRXfBuUNWKxrq71UdnGfjhuH7XgWf6vlBlqu8qhCpHuGLWOzvMa8qVCjtgL/N0DcpwGNxlJRvirI/F+YVf6wlwcq5ikSWDHDagwYhv3bpNXKYHQjiit5KX8x8gHqti0nM15NroKgv+oUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FVKQT5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FVKQT5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A947C4CEF7;
	Mon, 23 Mar 2026 14:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774276916;
	bh=jDv6B06yz0N5a5Ai/+sup7QjxswdEGAp63mWgGdcH7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FVKQT5DivTFGgy0YKd4P0IIdFcJ9obmT829E6EB5V1sJUVR4bLudo1/rMEnRfqJS
	 cv+H/jR28sZX+u9tSGohlrPl0Bjdj/wTzGih7yrL2Cilk/K8MU46kkUEL2D0Jyjn6D
	 Vhr5ld4gNTblmUJc7m4KcY9HERZoZVPUgMIfKYAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@kernel.org
Subject: [PATCH 6.12 254/460] nsfs: tighten permission checks for ns iteration ioctls
Date: Mon, 23 Mar 2026 14:44:10 +0100
Message-ID: <20260323134532.730734784@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ Different file names ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nsfs.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

--- a/fs/nsfs.c
+++ b/fs/nsfs.c
@@ -12,6 +12,7 @@
 #include <linux/user_namespace.h>
 #include <linux/nsfs.h>
 #include <linux/uaccess.h>
+#include <linux/capability.h>
 #include <linux/mnt_namespace.h>
 
 #include "mount.h"
@@ -152,6 +153,23 @@ static int copy_ns_info_to_user(const st
 	return 0;
 }
 
+static bool may_see_all_namespaces(void)
+{
+	return (task_active_pid_ns(current) == &init_pid_ns) &&
+	       ns_capable_noaudit(init_pid_ns.user_ns, CAP_SYS_ADMIN);
+}
+
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
@@ -165,6 +183,9 @@ static long ns_ioctl(struct file *filp,
 	uid_t uid;
 	int ret;
 
+	if (!may_use_nsfs_ioctl(ioctl))
+		return -EPERM;
+
 	switch (ioctl) {
 	case NS_GET_USERNS:
 		return open_related_ns(ns, ns_get_owner);


