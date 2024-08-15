Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5063214;
	Thu, 15 Aug 2024 14:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732578; cv=none; b=KkAT9gaFgQO+gFjccCNWe9yMtrFpM5UV+oo/QYRYRhGALEJkQ2zNFaB6Z+uXq3LaJ5J/07ETw41O2YqSjt7W3m+c1vXJWr+dNH+jOJZ9NMN3aXjhRgbuwm5eaVDAPdDO8sK0LKUrEvmpwZefmpjnROj2Q8yhhcafJAe3VPMuaFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732578; c=relaxed/simple;
	bh=jefw/6TJwXntIrNQDTN/KfGl9WXs5Dki06Lo7+vJjcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rw7Bwituig1I+U+D9NSyVZp0kXIAZfnUYkpInNyM37DjnPNn6w+UiGV6xAswFSdiJQfrjy3Ah8BHSf/woJZCBQ5wcq972Y+HOgoQvxsycHJca3gYQMYIYS0O7ADKxkX0TvC0k8nRhsSwOrcsmqu+qq9KlVbtbMti03/WhB6EvO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M48AK3pm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M48AK3pm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C42CC32786;
	Thu, 15 Aug 2024 14:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732577;
	bh=jefw/6TJwXntIrNQDTN/KfGl9WXs5Dki06Lo7+vJjcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M48AK3pmO8z0pe+ROktS+eFm1he8P8g+1vT4Of0IXSv/sRQf7FkO2xSIVGbOKuN3P
	 pWMnvSDtW/t8Ne24sZq5HITi+yS2XQUkUSnSY2Y0tLw5bGJV9hm+KDy8kYLVdKK3Yc
	 qpw4BdoSxietKCPHco9NMMrlDV75b5n1Npbtnw+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	"Seth Forshee (DigitalOcean)" <sforshee@kernel.org>,
	Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 215/352] fs: dont allow non-init s_user_ns for filesystems without FS_USERNS_MOUNT
Date: Thu, 15 Aug 2024 15:24:41 +0200
Message-ID: <20240815131927.599035294@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee (DigitalOcean) <sforshee@kernel.org>

[ Upstream commit e1c5ae59c0f22f7fe5c07fb5513a29e4aad868c9 ]

Christian noticed that it is possible for a privileged user to mount
most filesystems with a non-initial user namespace in sb->s_user_ns.
When fsopen() is called in a non-init namespace the caller's namespace
is recorded in fs_context->user_ns. If the returned file descriptor is
then passed to a process priviliged in init_user_ns, that process can
call fsconfig(fd_fs, FSCONFIG_CMD_CREATE), creating a new superblock
with sb->s_user_ns set to the namespace of the process which called
fsopen().

This is problematic. We cannot assume that any filesystem which does not
set FS_USERNS_MOUNT has been written with a non-initial s_user_ns in
mind, increasing the risk for bugs and security issues.

Prevent this by returning EPERM from sget_fc() when FS_USERNS_MOUNT is
not set for the filesystem and a non-initial user namespace will be
used. sget() does not need to be updated as it always uses the user
namespace of the current context, or the initial user namespace if
SB_SUBMOUNT is set.

Fixes: cb50b348c71f ("convenience helpers: vfs_get_super() and sget_fc()")
Reported-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Seth Forshee (DigitalOcean) <sforshee@kernel.org>
Link: https://lore.kernel.org/r/20240724-s_user_ns-fix-v1-1-895d07c94701@kernel.org
Reviewed-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/super.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index f9795e72e3bf8..282aa36901eb1 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -518,6 +518,17 @@ struct super_block *sget_fc(struct fs_context *fc,
 	struct user_namespace *user_ns = fc->global ? &init_user_ns : fc->user_ns;
 	int err;
 
+	/*
+	 * Never allow s_user_ns != &init_user_ns when FS_USERNS_MOUNT is
+	 * not set, as the filesystem is likely unprepared to handle it.
+	 * This can happen when fsconfig() is called from init_user_ns with
+	 * an fs_fd opened in another user namespace.
+	 */
+	if (user_ns != &init_user_ns && !(fc->fs_type->fs_flags & FS_USERNS_MOUNT)) {
+		errorfc(fc, "VFS: Mounting from non-initial user namespace is not allowed");
+		return ERR_PTR(-EPERM);
+	}
+
 retry:
 	spin_lock(&sb_lock);
 	if (test) {
-- 
2.43.0



