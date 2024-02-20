Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F4E1151CE3;
	Tue, 20 Feb 2024 21:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464279; cv=none; b=H4LPOiX1/CF4UqTD49iexoTJUYjz5Nk1KQPKtJhlrdvwQouq2SL1wtmQLcyCQzFWZMq6JY3yO3ypn0fIOneLIr4EV5uMft4cmOUp6R9zIVJXRlpx/yEkBuQtfChiaQOghcsNUaRblQbYVLoOnqpi2OXul8CDe33bNiErIu/QitE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464279; c=relaxed/simple;
	bh=fyQLqLyAUyMDLS/6H8wh7s8ufADci3LKDZ8atyog760=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/k+HrAFvfITBDI+N11ueIXZhDBmrjsIXKtARtfP+Zbk/hpCftIctL7cfluEAoE+B06BMJHz7eR8ZeOwUvZbYZn349JJaWFYmXfQfrEV9YvbD9pwh4UaumRQOrEn5J33w0oRxOtHxRqYcHre2h9wAdKaHF45ip6opZz50QWD1mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGAmC74f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGAmC74f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF982C43399;
	Tue, 20 Feb 2024 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464279;
	bh=fyQLqLyAUyMDLS/6H8wh7s8ufADci3LKDZ8atyog760=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGAmC74fH3skxXLGyDH317yDmpHWsWQ/L3OsSYu0AJy7qyRmCrP+UoR3lVNF4yTgb
	 R8mkLx+rB3abAE1Q9r9kYY0ieCRKUSE5YB4NvYefBtAwz/wg+nLpV87RgHTdkg3MlD
	 nXUrHRnbTgo9jxXuWZrhRlGHqdTnRJ/NLm6+FEKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ajay Kaher <akaher@vmware.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 279/331] eventfs: Remove special processing of dput() of events directory
Date: Tue, 20 Feb 2024 21:56:35 +0100
Message-ID: <20240220205646.694783238@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 62d65cac119d08d39f751b4e3e2063ed996edc05 upstream.

The top level events directory is no longer special with regards to how it
should be delete. Remove the extra processing for it in
eventfs_set_ei_status_free().

Link: https://lkml.kernel.org/r/20231101172650.340876747@goodmis.org

Cc: Ajay Kaher <akaher@vmware.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -274,28 +274,11 @@ static void free_ei(struct eventfs_inode
  */
 void eventfs_set_ei_status_free(struct tracefs_inode *ti, struct dentry *dentry)
 {
-	struct tracefs_inode *ti_parent;
 	struct eventfs_inode *ei;
 	int i;
 
-	/* The top level events directory may be freed by this */
-	if (unlikely(ti->flags & TRACEFS_EVENT_TOP_INODE)) {
-		mutex_lock(&eventfs_mutex);
-		ei = ti->private;
-		/* Nothing should access this, but just in case! */
-		ti->private = NULL;
-		mutex_unlock(&eventfs_mutex);
-
-		free_ei(ei);
-		return;
-	}
-
 	mutex_lock(&eventfs_mutex);
 
-	ti_parent = get_tracefs(dentry->d_parent->d_inode);
-	if (!ti_parent || !(ti_parent->flags & TRACEFS_EVENT_INODE))
-		goto out;
-
 	ei = dentry->d_fsdata;
 	if (!ei)
 		goto out;
@@ -920,6 +903,8 @@ struct eventfs_inode *eventfs_create_eve
 	inode->i_op = &eventfs_root_dir_inode_operations;
 	inode->i_fop = &eventfs_file_operations;
 
+	dentry->d_fsdata = ei;
+
 	/* directory inodes start off with i_nlink == 2 (for "." entry) */
 	inc_nlink(inode);
 	d_instantiate(dentry, inode);


