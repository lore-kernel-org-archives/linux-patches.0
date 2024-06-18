Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416C415A4AE;
	Tue, 18 Jun 2024 13:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716661; cv=none; b=eyKrxguqmaMVvnXG+VXGBa3wOKmakMr170EPGtHGkFFCH4xGDT68ni4IJQdMqa830ulGnHUPg8jjexPGoWWKWyUsklP+RxfrorAMNuZFbfREH7QLHgsL/ibtdyfoRmFhAb1TMQEBy9BY7Q6e74wghjIOkGPulLxturrGz9fGnEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716661; c=relaxed/simple;
	bh=jVY09KBWFYdpZrWI/pZkATGsX+ZVKGNLcErANXubP14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPsLFbIpVprG2su9sbgh/xdxOQpeVX8EVT1F9/fKXjL16ztf+1vdqxNQzi/BPuWNPhzwLemDTtychqlNwjaHadPEsB8yZ2scH9Lphee6F6A4qnDycbQL93z3g8nNr7k3Ir5flBdSgAIRfFcQw9XQRUFkc0fQyvGopdblcOTzYQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=siE2B8QG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="siE2B8QG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB49BC3277B;
	Tue, 18 Jun 2024 13:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716661;
	bh=jVY09KBWFYdpZrWI/pZkATGsX+ZVKGNLcErANXubP14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=siE2B8QGHgYup9WcUSJN6NcxGI1E6tFWw0qisRZF6kZLYu6y/pk8m3hVTF2OoNH3v
	 vGLD/DLbglN6jGY/DxW1whNy8qby/cPvmQn8nc6Br8LRbmLu94bR0qNmbQB/2zurkc
	 AyCjGK+J3OvrWsRLMTtd2ybB0BVj158FRj3qv8tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Disseldorp <ddiss@suse.de>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 689/770] exportfs: use pr_debug for unreachable debug statements
Date: Tue, 18 Jun 2024 14:39:02 +0200
Message-ID: <20240618123433.874315358@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exportfs/expfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 0106eba46d5af..8c28bd1c9ed94 100644
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
 	tmp = lookup_one_len_unlocked(nbuf, parent, strlen(nbuf));
 	if (IS_ERR(tmp)) {
-		dprintk("%s: lookup failed: %d\n", __func__, PTR_ERR(tmp));
+		dprintk("lookup failed: %ld\n", PTR_ERR(tmp));
 		err = PTR_ERR(tmp);
 		goto out_err;
 	}
-- 
2.43.0



