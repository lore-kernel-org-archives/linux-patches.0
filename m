Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767CF46D559;
	Wed, 30 Sep 2026 16:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787426; cv=none; b=gBED32rJAMnwFTmrdVUqywrSzGEzLK/8kJ9wDODAbHKnzdYtT2CWhkMUvPkCu/Sm+AG77oiw/ssWrzUx8dnFWy9PyJZpkQ2B+LrexUg2p9aK5tDQMLccnFeffZj0UMxmyc6vIFdMnxVLiTnXfhScwAnRPNAUEfFIdG37j2Yz/mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787426; c=relaxed/simple;
	bh=5/i861kyHWlZzxq8+ZI0QNUvh3sDHRd88OrU6sEyOFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LmnuZH+h+Lh2GJtQ+7a7FFp1RYGApM99TPXuh20obym7oyzTBxU0KiU8mFqwA+l2bkfL38Mnj79okuqDW9y5dcyWl/T/JiIgfgwYxz1zHBdBGkb6oaGs7dUUVgUTbz1D42qUJGbwPSawJidD5Xg3W00FapF9Cauk1jzCj7jbN2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hRYbbya7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hRYbbya7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCAE1F000FF;
	Wed, 30 Sep 2026 16:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787425;
	bh=vXoWQVe+ydNSWLd6kcea/YNhjQn102evNK3irTe0bLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hRYbbya7QSBT+nPGnafM7xUf9k6mMSubcEYpitwvwB3aNm83dLM2Q+bN3KReQJtgW
	 ILgH+MRd/b9pwi/1hcYOn4zyXLFdmZgzBBGaYGVZDV9KJi+3R+9POnzRS+8Jby3X/T
	 V6khazEszM1Nscm35Tg3G3pu/48RRLWBUzVfN8tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ced26b784bf977d223dd@syzkaller.appspotmail.com,
	Amir Goldstein <amir73il@gmail.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 226/457] ovl: fix UAF in ovl_do_mkdir() debug print
Date: Wed, 30 Sep 2026 17:25:31 +0200
Message-ID: <20260930152350.926465293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit ae146bc1abdeb4607abf2975b858c053024e8ac1 ]

ovl_do_mkdir() prints the input dentry with %pd after vfs_mkdir().
Since commit fe497f0759e0 ("VFS: change vfs_mkdir() to unlock on
failure."), vfs_mkdir() calls end_creating() on the input dentry on
failure and may replace it on success, so the post-call %pd can
use-after-free the dentry when CONFIG_OVERLAY_FS_DEBUG is enabled.

Print the dentry before the call and only the result afterward.

Reported-by: syzbot+ced26b784bf977d223dd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ced26b784bf977d223dd
Fixes: fe497f0759e0 ("VFS: change vfs_mkdir() to unlock on failure.")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Link: https://patch.msgid.link/20260921104013.40475-1-amir73il@gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/overlayfs.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b75df37f70ac3..3fea90fe37c75 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -254,8 +254,10 @@ static inline struct dentry *ovl_do_mkdir(struct ovl_fs *ofs,
 {
 	struct dentry *ret;
 
+	/* vfs_mkdir() drops @dentry on failure and may replace it on success */
+	pr_debug("mkdir(%pd2, 0%o)\n", dentry, mode);
 	ret = vfs_mkdir(ovl_upper_mnt_idmap(ofs), dir, dentry, mode, NULL);
-	pr_debug("mkdir(%pd2, 0%o) = %i\n", dentry, mode, PTR_ERR_OR_ZERO(ret));
+	pr_debug("...mkdir = %i\n", PTR_ERR_OR_ZERO(ret));
 	return ret;
 }
 
-- 
2.53.0



