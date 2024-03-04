Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5A578B4C;
	Mon,  4 Mar 2024 21:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589008; cv=none; b=fQFrpu9bUgWoBRvhHCnm5eEeMr3qu3sWKJZNJNXgyG8ZJ03M3jvJp1Sblis7baWgnZswb5GuqnSJC814kgkSrIB3Z9AeQiZcu+kVCLATGj3P97t+8q6c6H/mzNNLGflc4fll9oSBI3LaS/LLC/yqsG8GDr89dccfcs7pEhRdS7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589008; c=relaxed/simple;
	bh=MO3PA0xrieTV6UE1Bz2PgbEsocb1iAaR+2lj9PPhDg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcUtWV9Ouj/fybUsDH2ShV3fW8ODWg7rDCw6Jccs86eLwkRYzD04/VF1qHopSS1osjhGOCxPO9RJWBcCdTnxfpJkAwmnmuzD32p8DEERcKP1Wqoc1atTvHkcrNZARtdFSuxRe5xmvcmTnKwca3b7cx8xnkTl1bWpn+QCFqD8/Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjaJSImG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjaJSImG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71481C43390;
	Mon,  4 Mar 2024 21:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589007;
	bh=MO3PA0xrieTV6UE1Bz2PgbEsocb1iAaR+2lj9PPhDg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjaJSImGkP5zd+aJqd2paL/Hixriq6Eve+bhUT3+luPsq8BpHB1tWj4mzdQ5QIe0f
	 mEWvqruTjuLp/y9GJjYB5aj4H+KvK9RjKE6bP3vkwwIsjsAQxt0ypz8ht0tEcSxVfR
	 8CGV1N15Oo6QZr4KbF2q6T3jha6NScHHIhKXjVE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.1 148/215] exportfs: use pr_debug for unreachable debug statements
Date: Mon,  4 Mar 2024 21:23:31 +0000
Message-ID: <20240304211601.724370408@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exportfs/expfs.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -18,7 +18,7 @@
 #include <linux/sched.h>
 #include <linux/cred.h>
 
-#define dprintk(fmt, args...) do{}while(0)
+#define dprintk(fmt, args...) pr_debug(fmt, ##args)
 
 
 static int get_name(const struct path *path, char *name, struct dentry *child);
@@ -132,8 +132,8 @@ static struct dentry *reconnect_one(stru
 	inode_unlock(dentry->d_inode);
 
 	if (IS_ERR(parent)) {
-		dprintk("%s: get_parent of %ld failed, err %d\n",
-			__func__, dentry->d_inode->i_ino, PTR_ERR(parent));
+		dprintk("get_parent of %lu failed, err %ld\n",
+			dentry->d_inode->i_ino, PTR_ERR(parent));
 		return parent;
 	}
 
@@ -147,7 +147,7 @@ static struct dentry *reconnect_one(stru
 	dprintk("%s: found name: %s\n", __func__, nbuf);
 	tmp = lookup_one_unlocked(mnt_user_ns(mnt), nbuf, parent, strlen(nbuf));
 	if (IS_ERR(tmp)) {
-		dprintk("%s: lookup failed: %d\n", __func__, PTR_ERR(tmp));
+		dprintk("lookup failed: %ld\n", PTR_ERR(tmp));
 		err = PTR_ERR(tmp);
 		goto out_err;
 	}


