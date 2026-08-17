Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4078943B3E5;
	Mon, 17 Aug 2026 13:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974559; cv=none; b=WP21OsKX6ihCySMUQWGNedCl76sQAs8NqO1VDGEnI2TnKJ5q3rgb3SRq0SjhMvGxNhYBt2m8CHw2Cp5OC7s3Bvh19KJNdbHH8epdsK+ksYhttQWEqrAXBAwJdeB5l34XaQmWdoDTEhZ2T6OmuxxUPg0gsLwYmn7h2qXh+5Q8GRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974559; c=relaxed/simple;
	bh=Zvf9hQqHDC/dWXiOOqH9YtRxLopo85BFw/ZFl2C6P/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NUwyb1lz5Fz7XHgnMBMOMPJ8fnD/PSHmMzpmHGe/jjAS2/+09qWluk3za5a/bcA+/KLvoScqyLUjJpqtQuQTHTBPXBVIhNO7ij0C5s/6Gg38PHB5z1RNjRlqX/vUbH6i9nRG4lKcynsTSBWlOxNSCrJPTd6dDj1shQu3/E7cTsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkX69pkX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkX69pkX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E068D1F00A3A;
	Mon, 17 Aug 2026 13:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974552;
	bh=TIuohM5ZE1hnNTc/SDQRVUK0rqE2fOAec/QGhKjYzMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkX69pkXUzUC9+frBlLFeJSel/sb3R69lYXQRPdq23VLy8anleqODpSankSEvFjgj
	 +5mUnZelMh0qvq0Y/P79hmdncCyee3dD21BhtReqkz9ROAbd512mIvuNBxLkBYkDUc
	 +Fl2WNeGb49gk3pJIlpGgW+0/vPqty7Kra3iVXyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.1 244/271] eventfs: Fix use-after-free in eventfs_remove_rec()
Date: Mon, 17 Aug 2026 15:32:49 +0200
Message-ID: <20260817132546.783242205@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuangpeng Bai <shuangpeng.kernel@gmail.com>

commit fd73b691702170d37d66f4b0278530cea8ed419a upstream.

eventfs_remove_rec() recursively removes the child at the current loop
position. After the recursive call returns, list_for_each_entry() advances
by reading list.next from the removed child.

If free_ei() drops the final reference, release_ei() reuses the list/rcu
union to queue an SRCU callback. The child may be freed before that read.
The eventfs_mutex serializes list updates, but it does not keep the removed
child alive or prevent the SRCU callback from running.

Use list_for_each_entry_safe() to save the next sibling before recursively
removing the current child.

Cc: stable@vger.kernel.org
Fixes: 43aa6f97c2d0 ("eventfs: Get rid of dentry pointers without refcounts")
Link: https://patch.msgid.link/20260806022719.375354-1-shuangpeng.kernel@gmail.com
Signed-off-by: Shuangpeng Bai <shuangpeng.kernel@gmail.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -824,7 +824,7 @@ struct eventfs_inode *eventfs_create_eve
  */
 static void eventfs_remove_rec(struct eventfs_inode *ei, int level)
 {
-	struct eventfs_inode *ei_child;
+	struct eventfs_inode *ei_child, *tmp;
 
 	/*
 	 * Check recursion depth. It should never be greater than 3:
@@ -837,7 +837,7 @@ static void eventfs_remove_rec(struct ev
 		return;
 
 	/* search for nested folders or files */
-	list_for_each_entry(ei_child, &ei->children, list)
+	list_for_each_entry_safe(ei_child, tmp, &ei->children, list)
 		eventfs_remove_rec(ei_child, level + 1);
 
 	list_del_rcu(&ei->list);


