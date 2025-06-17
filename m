Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739B82FA655;
	Tue, 17 Jun 2025 16:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178522; cv=none; b=j/y8zqHNKvr8ArnOnRB8MKXRQefIQmy3V5Prlb2JbztRdFvP6QcAvHfW+Vsbx3HDyQX5X/EDEEhDhBvyUbLbyoYXEV+xG+siNwtTfv+ozA4HOY1z9OJiOXapfETjDAQZCnZBTf71cGPtP1Hij1dRRHg4scAPka1IFek2fVKJu6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178522; c=relaxed/simple;
	bh=3HVV/aMG40/m7EvLVgJ4f++qTmykmAxteumHbkYnlIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCHQEwjN7NaAflDCuuwzl1zLjwt1quCF6EeGb8QJYkwYm80xuWCWdBrlG8lqgm1whs98F1euXGNe8poXl/lzoGf2m4vYfAvAxJCN01Kfbxoo8A4Pb4/RrYPSjqHF0xJnq+M88FuJQ2Xv1n9lOvIk2egFRzAh08Ed2cC7OvHsask=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gWRxOux+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gWRxOux+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C05C4CEE3;
	Tue, 17 Jun 2025 16:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178522;
	bh=3HVV/aMG40/m7EvLVgJ4f++qTmykmAxteumHbkYnlIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWRxOux+OheA2c9dhuHgEw7ZrQiHJyL+swJ1JwOpvgPAxsDUztPh6MDDU/1cPReE1
	 L7aR4RUYMyYdIOcQAo99rvj77wCxE6rQwODE7wzFXnPK1txWlNamMbYu+e5wKiM3sU
	 HY6Rgr99JWpIFX7WkUWXd4o+LBsgp+ufCRkVV8+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b12826218502df019f9d@syzkaller.appspotmail.com,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.12 511/512] gfs2: Dont clear sb->s_fs_info in gfs2_sys_fs_add
Date: Tue, 17 Jun 2025 17:27:57 +0200
Message-ID: <20250617152440.319949904@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Price <anprice@redhat.com>

commit 9126d2754c5e5d1818765811a10af0a14cf1fa0a upstream.

When gfs2_sys_fs_add() fails, it sets sb->s_fs_info to NULL on its error
path (see commit 0d515210b696 ("GFS2: Add kobject release method")).
The intention seems to be to prevent dereferencing sb->s_fs_info once
the object pointed to has been deallocated, but that would be better
achieved by setting the pointer to NULL in free_sbd().

As a consequence, when the call to gfs2_sys_fs_add() fails in
gfs2_fill_super(), sdp = GFS2_SB(inode) will evaluate to NULL in iput()
-> gfs2_drop_inode(), and accessing sdp->sd_flags will be a NULL pointer
dereference.

Fix that by only setting sb->s_fs_info to NULL when actually freeing the
object pointed to in free_sbd().

Fixes: ae9f3bd8259a ("gfs2: replace sd_aspace with sd_inode")
Reported-by: syzbot+b12826218502df019f9d@syzkaller.appspotmail.com
Signed-off-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/gfs2/ops_fstype.c |    4 +++-
 fs/gfs2/sys.c        |    1 -
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -64,8 +64,11 @@ static void gfs2_tune_init(struct gfs2_t
 
 void free_sbd(struct gfs2_sbd *sdp)
 {
+	struct super_block *sb = sdp->sd_vfs;
+
 	if (sdp->sd_lkstats)
 		free_percpu(sdp->sd_lkstats);
+	sb->s_fs_info = NULL;
 	kfree(sdp);
 }
 
@@ -1316,7 +1319,6 @@ fail_iput:
 	iput(sdp->sd_inode);
 fail_free:
 	free_sbd(sdp);
-	sb->s_fs_info = NULL;
 	return error;
 }
 
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -764,7 +764,6 @@ fail_reg:
 	fs_err(sdp, "error %d adding sysfs files\n", error);
 	kobject_put(&sdp->sd_kobj);
 	wait_for_completion(&sdp->sd_kobj_unregister);
-	sb->s_fs_info = NULL;
 	return error;
 }
 


