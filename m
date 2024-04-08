Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E7C6EB72;
	Mon,  8 Apr 2024 13:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584550; cv=none; b=IQaPoz6R+O0VaFBi8tH3GNJ2mWcUpz/OCQjcde0yBBl6bSvHIRw7/V5BrkaerMYkWqy62xYrQPF8GQZkQSKupAZqLneiwy5Qe2suKPAmISZ0jgf1HyF0hbW4aIdT2Dsciq1x01ybkPkmyZegOHwZMmPvxWDbI19y70xilUYFseM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584550; c=relaxed/simple;
	bh=ReskZaQSD8d+PxKVBCMsnvmwAYa+Kg1Vdt/26vw47cc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAmlYKu4IqeljwI6uKvoQqCW4P9aTFfGjt108Sk0u98bTe0guYVzFq783P2SHeZB8iQVimXK1o1CT8nU6zSjN4AxV0i9DR2FN7unedrjIpTp58633U8JihCsTuxfzameoUejbSsnXyvA9YtQOqxSO3ne/VtDAehl+5troMaW19s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YzXyM9tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YzXyM9tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE77C433F1;
	Mon,  8 Apr 2024 13:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584550;
	bh=ReskZaQSD8d+PxKVBCMsnvmwAYa+Kg1Vdt/26vw47cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzXyM9tukPg/pDgVVe68DV9GkFwYZ4nlQ+KXdMOXYKlNTL7NJEav2lTJDb/t4e5E/
	 MDH67DPO7E2/gerVTEQiG1BjGSw09p3X8ckS8mj5azl4+JvaxybXUbWO3lZ4oyki9R
	 wOqu8jYSqwBEcnCjwdOlSqrDFTIV2lfNc/HyaNrc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 476/690] exportfs: use pr_debug for unreachable debug statements
Date: Mon,  8 Apr 2024 14:55:42 +0200
Message-ID: <20240408125416.857079085@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 427505ffeaa464f683faba945a88d3e3248f6979 ]

expfs.c has a bunch of dprintk statements which are unusable due to:
 #define dprintk(fmt, args...) do{}while(0)
Use pr_debug so that they can be enabled dynamically.
Also make some minor changes to the debug statements to fix some
incorrect types, and remove __func__ which can be handled by dynamic
debug separately.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/exportfs/expfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 3ef80d000e13d..584bdd912cdd4 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -18,7 +18,7 @@
 #include <linux/sched.h>
 #include <linux/cred.h>
 
-#define dprintk(fmt, args...) do{}while(0)
+#define dprintk(fmt, args...) pr_debug(fmt, ##args)
 
 
 static int get_name(const struct path *path, char *name, struct dentry *child);
@@ -132,8 +132,8 @@ static struct dentry *reconnect_one(struct vfsmount *mnt,
 	inode_unlock(dentry->d_inode);
 
 	if (IS_ERR(parent)) {
-		dprintk("%s: get_parent of %ld failed, err %d\n",
-			__func__, dentry->d_inode->i_ino, PTR_ERR(parent));
+		dprintk("get_parent of %lu failed, err %ld\n",
+			dentry->d_inode->i_ino, PTR_ERR(parent));
 		return parent;
 	}
 
@@ -147,7 +147,7 @@ static struct dentry *reconnect_one(struct vfsmount *mnt,
 	dprintk("%s: found name: %s\n", __func__, nbuf);
 	tmp = lookup_one_unlocked(mnt_user_ns(mnt), nbuf, parent, strlen(nbuf));
 	if (IS_ERR(tmp)) {
-		dprintk("%s: lookup failed: %d\n", __func__, PTR_ERR(tmp));
+		dprintk("lookup failed: %ld\n", PTR_ERR(tmp));
 		err = PTR_ERR(tmp);
 		goto out_err;
 	}
-- 
2.43.0



