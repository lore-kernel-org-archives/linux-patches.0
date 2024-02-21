Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAC67BAFF;
	Wed, 21 Feb 2024 14:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524332; cv=none; b=gHf1w+XEBbUubc+PsnAyO61MAcIVzCqRSqzx27aVJRQV6OBDJPb/1/2WRrNlSRMVvVAvihasaWci5kVb/lEHk+Vphpcvaxb4gkr4hwooXkHnRdWDHDq+Z9OCcE/sHwaMYga+mJ6nspx5SH1oWwGEItLSyOKDd1DDY2XK/Bw0pa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524332; c=relaxed/simple;
	bh=9HZpis6lv8YmpC9Hc7qOPdw4K1fnXERP72Q9iUn06Eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbbYBVEFSCy6vrQ6TYnmG1AFTKbUEcPkHcVQkIjx8URkpkmKSOxUN2j+qo3OsEPnG03TsKA95jihiu4iLyrYDl2kz5sn8MhuJ+j/83VsoF65M+icMH9RWTYVeXxb1c7Of3uejYU7MRJn+JdG2od6R39j/Pr7hRw8d+BGFURS2e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPyFjSRC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPyFjSRC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF72C433F1;
	Wed, 21 Feb 2024 14:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524332;
	bh=9HZpis6lv8YmpC9Hc7qOPdw4K1fnXERP72Q9iUn06Eg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPyFjSRC2sOKyDcy8h8mvDTiif1mQsxLgATW8llWbdyooPtiKbFdJ40v4rSbUk2kK
	 o3c2UAIuVLEDhew/4T5eWKDqrpGNIHhAC3PJ1NNtf3AOR6Ood3zC6wy/vZ5PUmr9lJ
	 L6HNCqJFoOqab9R1kOFsPIqdN18PtkYnJt0Cw+vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/379] fs/kernfs/dir: obey S_ISGID
Date: Wed, 21 Feb 2024 14:06:30 +0100
Message-ID: <20240221130001.141936820@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 5133bee62f0ea5d4c316d503cc0040cac5637601 ]

Handling of S_ISGID is usually done by inode_init_owner() in all other
filesystems, but kernfs doesn't use that function.  In kernfs, struct
kernfs_node is the primary data structure, and struct inode is only
created from it on demand.  Therefore, inode_init_owner() can't be
used and we need to imitate its behavior.

S_ISGID support is useful for the cgroup filesystem; it allows
subtrees managed by an unprivileged process to retain a certain owner
gid, which then enables sharing access to the subtree with another
unprivileged process.

--
v1 -> v2: minor coding style fix (comment)

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20231208093310.297233-2-max.kellermann@ionos.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index c91ee05cce74..0ba056e06e48 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -696,6 +696,18 @@ struct kernfs_node *kernfs_new_node(struct kernfs_node *parent,
 {
 	struct kernfs_node *kn;
 
+	if (parent->mode & S_ISGID) {
+		/* this code block imitates inode_init_owner() for
+		 * kernfs
+		 */
+
+		if (parent->iattr)
+			gid = parent->iattr->ia_gid;
+
+		if (flags & KERNFS_DIR)
+			mode |= S_ISGID;
+	}
+
 	kn = __kernfs_new_node(kernfs_root(parent), parent,
 			       name, mode, uid, gid, flags);
 	if (kn) {
-- 
2.43.0



