Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D381F19DF4C;
	Wed, 23 Apr 2025 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420136; cv=none; b=MyOfBsrxyN3ZStxB7vp1xpZBqGnSg8/aOzv9dzzQC1zGSfXZKnIKdvYhzNafVRAP4SYcRYMHs6gWpnkpp9sni+r3dbpenoqkSNft/TpKkG6beaez+7UerRy3vzubDlbNo9Sy78RKxolNK5jdDgC2htpkAH0q7lrZmydpi3xN6e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420136; c=relaxed/simple;
	bh=dAHsnDrgZiIHGc6P+sJCk9p+7LN3otYIc29KptDq5G4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lq+6RgQjeABkH5Z22eV0vXlJohX3K/aC61EiKD+2vj4oFJG7xFsyeT9Ao82HSdRN1S5sGXzq1bMP/xjAu14Kr+RbNzVX9CBjwpiMJ94HPhEIsaowtkVMU+gOeklp9Zx6DXK+h04pn1qfYK9cy94Seqg8U+IfbL13nFjRr1dz02A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IX61t83e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IX61t83e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68802C4CEE2;
	Wed, 23 Apr 2025 14:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420136;
	bh=dAHsnDrgZiIHGc6P+sJCk9p+7LN3otYIc29KptDq5G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IX61t83ek6jycrdCwcygoI6jyNCR6mjwupw+IDW2IaSguqgkY/05SwUvvriRWmvM9
	 txefIAJloz4vnm1pD0I7O7g457MBjegz+19iZhOPc6g9y/HriT6xU42b8JPUeq63qN
	 fF5OyHRu95lvTIKsJNnUa9OoXlieB7mEeLCKAYEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/291] umount: Allow superblock owners to force umount
Date: Wed, 23 Apr 2025 16:40:09 +0200
Message-ID: <20250423142625.230055412@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit e1ff7aa34dec7e650159fd7ca8ec6af7cc428d9f ]

Loosen the permission check on forced umount to allow users holding
CAP_SYS_ADMIN privileges in namespaces that are privileged with respect
to the userns that originally mounted the filesystem.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Link: https://lore.kernel.org/r/12f212d4ef983714d065a6bb372fbb378753bf4c.1742315194.git.trond.myklebust@hammerspace.com
Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 59a9f877738b2..57166cc7e5117 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1777,6 +1777,7 @@ static void warn_mandlock(void)
 static int can_umount(const struct path *path, int flags)
 {
 	struct mount *mnt = real_mount(path->mnt);
+	struct super_block *sb = path->dentry->d_sb;
 
 	if (!may_mount())
 		return -EPERM;
@@ -1786,7 +1787,7 @@ static int can_umount(const struct path *path, int flags)
 		return -EINVAL;
 	if (mnt->mnt.mnt_flags & MNT_LOCKED) /* Check optimistically */
 		return -EINVAL;
-	if (flags & MNT_FORCE && !capable(CAP_SYS_ADMIN))
+	if (flags & MNT_FORCE && !ns_capable(sb->s_user_ns, CAP_SYS_ADMIN))
 		return -EPERM;
 	return 0;
 }
-- 
2.39.5



