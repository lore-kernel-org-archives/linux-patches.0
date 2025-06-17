Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62362FA627;
	Tue, 17 Jun 2025 16:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179549; cv=none; b=ROXCKq5APbShPCVsc0zTlkI0S6vdTqGz24MX9GOUuPbnKGolSaqYe05xr8aWcT2RzXpPb3fJyg4tIT4uIjCUSRKIc7spSXoOWGl7DQ9SU78YmR/6bR8AvnDB+0NUtGvaNl9BNyrop0RTi9q7xWwfWFITWrVn3vefKhbEFdhobjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179549; c=relaxed/simple;
	bh=JOUFPt+hAjgJ/nsAam7OawmuyIsuJD1R4PZP/iTNM6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCrJKUPhOGSo651Mwa/MX7GwwmdEgmxCCpELe9g/Y4Prl1NjISkUCKJVtScqZQfZQUrIv3oulRPVer1VIPMoLKCZQM/KhM0XD9x+pU0KErGctlSwgiyzMwnBVCkncXasIKJsomZ8NkaOgpK7GM2w710IigkmwiA22xdF4Dk8p8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fvfPKUQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fvfPKUQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58614C4CEE3;
	Tue, 17 Jun 2025 16:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179548;
	bh=JOUFPt+hAjgJ/nsAam7OawmuyIsuJD1R4PZP/iTNM6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fvfPKUQW9yW1a1TjH6XAFYEPtSlIvLLBE3uzpPMPzVCB/C2HdOiwiItb3hwA1E2oD
	 ypxnLfpUvsYy/z8KG67t3mqqN98Zh6Pz4UF5AknPO49lnvC5Ov4JRknFbMYcqntqPP
	 cdi0YnaIVBimu+hazC8KFZkDOG72bLs1RFSaGqwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b12826218502df019f9d@syzkaller.appspotmail.com,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 6.15 780/780] gfs2: Dont clear sb->s_fs_info in gfs2_sys_fs_add
Date: Tue, 17 Jun 2025 17:28:08 +0200
Message-ID: <20250617152523.268400317@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
 


