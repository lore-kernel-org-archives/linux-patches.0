Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1AF17BEAE;
	Tue, 10 Sep 2024 09:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962240; cv=none; b=p6tIlZ4uNH1cqLDL+TKKt76zo4IDEShKcpi70LUV3Fx5QixPMMBSWhzwZlJBwo5+nLRCxydU/64Yem2Lzm5BEx1WyREqisO6rDAOki+Pu+Jk7FMZy6vGoAJ8pmB7CzeILEPihgLLTSUIRObaE6ugCqnub5tvwk1n87JBLc15yLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962240; c=relaxed/simple;
	bh=MoKJ5zJfeIH6veKMXXnPIRhlot4wGdUf678A1ysqaeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eoiUvMBU3l7piAL3CY3rbQxC9+bYH4NnFbliHZie40q1Sr2nATloBR6Jz5KubRX2MV520eTZRVxbftJWFtMCdQkCOc/xbFE96WZkaRyWZzhr5gyAKuIGUpABv+ddLRW78rCKJEEt7eifjaS6O/HagsYl+OOY0hFKXbBBOs/ivAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7o8Xi2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7o8Xi2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D4FC4CEC3;
	Tue, 10 Sep 2024 09:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962240;
	bh=MoKJ5zJfeIH6veKMXXnPIRhlot4wGdUf678A1ysqaeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D7o8Xi2yQPug4PMgzMPY0ZQZ5WTprqJMsWnvwDUg9y6IAUB9WPbtrrwlJ7CWFc+Ur
	 tcu+2RG9GypEeGvDQuafLXdKP3TAnRubO/KzQm/GTg/6WU/x939NODbSFmTR8riaap
	 spA0mMwhCExABxppDCHvQFzNdPhYf3xmHx9W1PJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 315/375] fs: simplify error handling
Date: Tue, 10 Sep 2024 11:31:52 +0200
Message-ID: <20240910092633.141258702@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 17e70161281bb66316e94e63a15d1a8498bf6f01 ]

Rely on cleanup helper and simplify error handling

Link: https://lore.kernel.org/r/20240607-vfs-listmount-reverse-v1-3-7877a2bfa5e5@kernel.org
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: dd7cb142f467 ("fs: relax permissions for listmount()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1390e9e521d6..ef7b202f8e85 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -5051,7 +5051,7 @@ static struct mount *listmnt_next(struct mount *curr)
 static ssize_t do_listmount(u64 mnt_parent_id, u64 last_mnt_id, u64 *mnt_ids,
 			    size_t nr_mnt_ids)
 {
-	struct path root;
+	struct path root __free(path_put) = {};
 	struct mnt_namespace *ns = current->nsproxy->mnt_ns;
 	struct path orig;
 	struct mount *r, *first;
@@ -5064,10 +5064,8 @@ static ssize_t do_listmount(u64 mnt_parent_id, u64 last_mnt_id, u64 *mnt_ids,
 		orig = root;
 	} else {
 		orig.mnt = lookup_mnt_in_ns(mnt_parent_id, ns);
-		if (!orig.mnt) {
-			ret = -ENOENT;
-			goto err;
-		}
+		if (!orig.mnt)
+			return -ENOENT;
 		orig.dentry = orig.mnt->mnt_root;
 	}
 
@@ -5076,14 +5074,12 @@ static ssize_t do_listmount(u64 mnt_parent_id, u64 last_mnt_id, u64 *mnt_ids,
 	 * mounts to show users.
 	 */
 	if (!is_path_reachable(real_mount(orig.mnt), orig.dentry, &root) &&
-	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN)) {
-		ret = -EPERM;
-		goto err;
-	}
+	    !ns_capable_noaudit(&init_user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
 
 	ret = security_sb_statfs(orig.dentry);
 	if (ret)
-		goto err;
+		return ret;
 
 	if (!last_mnt_id)
 		first = node_to_mount(rb_first(&ns->mounts));
@@ -5100,8 +5096,6 @@ static ssize_t do_listmount(u64 mnt_parent_id, u64 last_mnt_id, u64 *mnt_ids,
 		nr_mnt_ids--;
 		ret++;
 	}
-err:
-	path_put(&root);
 	return ret;
 }
 
-- 
2.43.0



