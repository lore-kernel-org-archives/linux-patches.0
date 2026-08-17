Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A237E21CC5C;
	Mon, 17 Aug 2026 14:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978729; cv=none; b=r7UXX6U0+XB/jTkk3rEiJzVksbV49B4nDIQcBAxrTxWGbXkLhhNcynBw/VIOdmA6PC91ql7kb5+HD41gwaxzjHHzgvchflbYeEP1vMa/899XEiSRv7g28imNQnn+hot4tPfpikFmx0sXl9bo8L1D4KhVraK7jWBzXpiCbP1c4YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978729; c=relaxed/simple;
	bh=yS9OpaxkgFCkuTGCSPgCKLQX9CDWYEyiBkf/1kaAlfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lt85TVnEeSVVgMc1MP4IdgApwmlIqY/ho3HPNpn4c8QWPVm4LS3KWOTwzx0TsQx0Go2afe6r86PVjwVJwUIq0UCvKqkFbcLcZXmO0Uj5Ss6ZGKXgPXFCK+JjcNbOTexhgoMmikoFALC51+Vv+tkPEODO/Pf5LKPvbj5bTKfUU8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERZXxjCI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERZXxjCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0685D1F000E9;
	Mon, 17 Aug 2026 14:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978728;
	bh=tHg6WDulGkgMJZvMQ2dzFTtZhNMbiHrnxBHfggOOJtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERZXxjCIkQ5tym1ddQcwCz29FbISJ/NOmtLlHDJ68ZhTitocFy1hkpeK8H9+G9BNR
	 htJeyNIgq1tZl+gUetLQXbSP5mII9Z/tGyxrPzyFGns+Cz0TKysq4gqFWEbVt6vXUm
	 xdcl2GT3BLw1kMmzK0KHtseNLKrjpt0yTlcQnipA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuangpeng Bai <shuangpeng.kernel@gmail.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 138/156] eventfs: Fix use-after-free in eventfs_remove_rec()
Date: Mon, 17 Aug 2026 15:34:32 +0200
Message-ID: <20260817132540.104126938@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -922,7 +922,7 @@ struct eventfs_inode *eventfs_create_eve
  */
 static void eventfs_remove_rec(struct eventfs_inode *ei, int level)
 {
-	struct eventfs_inode *ei_child;
+	struct eventfs_inode *ei_child, *tmp;
 
 	/*
 	 * Check recursion depth. It should never be greater than 3:
@@ -935,7 +935,7 @@ static void eventfs_remove_rec(struct ev
 		return;
 
 	/* search for nested folders or files */
-	list_for_each_entry(ei_child, &ei->children, list)
+	list_for_each_entry_safe(ei_child, tmp, &ei->children, list)
 		eventfs_remove_rec(ei_child, level + 1);
 
 	list_del_rcu(&ei->list);


