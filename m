Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB4BA2DF9F;
	Tue, 20 Feb 2024 21:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464194; cv=none; b=TtySYTOc8xo1Z2OJDOAwDnPvniEH6+J7dcUX1vBo+tIdjvFZitIfQOcWdDvYz3Ob7NO+hsuYvkztmp8e0e5kKT6P+Y03gVOGw+bSN/AqPz6Z6jyF4EwLYjdJlWLjaH2H6PjY37h4fPD++50sjdLjHErbMaYVdiSPdQbImCkNFUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464194; c=relaxed/simple;
	bh=zYaSaEVlG9x04Ev/loNmJ4xP+ZaXXxIDHPDVnrkW5YQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LJL5HdoOq+f7QpwjpzTT35gt+bBwfc4uQ2biP/Bzl1IEY03TVMJhvCEpGddOkK5Ht8lK6xxjYoSfpBJf1B90vENhs3JmpFgofuJuI/JEmjYMUxvOB78Nxm6aow4Qem+bmKZZTKDRJ4eqRux7zd9sfSYn+rUDCLfbreG5xJmoPXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gNh4UPup; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gNh4UPup"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4265BC433C7;
	Tue, 20 Feb 2024 21:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464194;
	bh=zYaSaEVlG9x04Ev/loNmJ4xP+ZaXXxIDHPDVnrkW5YQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNh4UPupbyrS68INIzY4+7djawSw377dD9sd1vQ53Rtvzt2c+sazNXhU3UToTBh3R
	 fc7zjBNZwDsBR4bdLLXGTY8lS600GrwETmmKDF11bT5NqI24QY5VtthKLNZCfRDeOr
	 cZ9gNVdRQ7sAng9hveIvsbzdfesFWO24+1HcTJkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Rutland <mark.rutland@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 281/331] eventfs: Remove expectation that ei->is_freed means ei->dentry == NULL
Date: Tue, 20 Feb 2024 21:56:37 +0100
Message-ID: <20240220205646.765058109@linuxfoundation.org>
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

commit 88903daecacf03b1e5636e1b5f18bda5b07030fc upstream.

The logic to free the eventfs_inode (ei) use to set is_freed and clear the
"dentry" field under the eventfs_mutex. But that changed when a race was
found where the ei->dentry needed to be cleared when the last dput() was
called on it. But there was still logic that checked if ei->dentry was not
NULL and is_freed is set, and would warn if it was.

But since that situation was changed and the ei->dentry isn't cleared
until the last dput() is called on it while the ei->is_freed is set, do
not test for that condition anymore, and change the comments to reflect
that.

Link: https://lkml.kernel.org/r/20231120235154.265826243@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Fixes: 020010fbfa20 ("eventfs: Delete eventfs_inode when the last dentry is freed")
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -27,16 +27,16 @@
 /*
  * eventfs_mutex protects the eventfs_inode (ei) dentry. Any access
  * to the ei->dentry must be done under this mutex and after checking
- * if ei->is_freed is not set. The ei->dentry is released under the
- * mutex at the same time ei->is_freed is set. If ei->is_freed is set
- * then the ei->dentry is invalid.
+ * if ei->is_freed is not set. When ei->is_freed is set, the dentry
+ * is on its way to being freed after the last dput() is made on it.
  */
 static DEFINE_MUTEX(eventfs_mutex);
 
 /*
  * The eventfs_inode (ei) itself is protected by SRCU. It is released from
  * its parent's list and will have is_freed set (under eventfs_mutex).
- * After the SRCU grace period is over, the ei may be freed.
+ * After the SRCU grace period is over and the last dput() is called
+ * the ei is freed.
  */
 DEFINE_STATIC_SRCU(eventfs_srcu);
 
@@ -365,12 +365,14 @@ create_file_dentry(struct eventfs_inode
 		 * created the dentry for this e_dentry. In which case
 		 * use that one.
 		 *
-		 * Note, with the mutex held, the e_dentry cannot have content
-		 * and the ei->is_freed be true at the same time.
+		 * If ei->is_freed is set, the e_dentry is currently on its
+		 * way to being freed, don't return it. If e_dentry is NULL
+		 * it means it was already freed.
 		 */
-		dentry = *e_dentry;
-		if (WARN_ON_ONCE(dentry && ei->is_freed))
+		if (ei->is_freed)
 			dentry = NULL;
+		else
+			dentry = *e_dentry;
 		/* The lookup does not need to up the dentry refcount */
 		if (dentry && !lookup)
 			dget(dentry);
@@ -473,8 +475,8 @@ create_dir_dentry(struct eventfs_inode *
 		 * created the dentry for this e_dentry. In which case
 		 * use that one.
 		 *
-		 * Note, with the mutex held, the e_dentry cannot have content
-		 * and the ei->is_freed be true at the same time.
+		 * If ei->is_freed is set, the e_dentry is currently on its
+		 * way to being freed.
 		 */
 		dentry = ei->dentry;
 		if (dentry && !lookup)


