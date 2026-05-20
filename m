Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2EA3F9296;
	Wed, 20 May 2026 18:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301690; cv=none; b=FcNHZQ0CHrSEaSzNPOM0Kn/+58qKtzG6IkpVa+ctCo0Dwm0qR/avzjMpGlhsts9Z3ztC4Rf4XwVWn00mk9oVgKozIHd42wwjkcZYIPYmcqTs3119rpzb9XbW1k5nxN8p5hpQl/Mwzxe0k2uuIqhripnwBZvph9dyki6cP3hYtAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301690; c=relaxed/simple;
	bh=DOgq8LAGXoCAHC2pazeppOKBdS0ONM+oj3gmcqoVzKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/295JYyv+Cwi2VzCxR1Xz0Mlrzz9BSJb3AlUwylI+BC1zzZBwAgKj9y0N8bdngYLtfR16IX1n/IgDI3A8AX9P5j8eRjK5lrT4vyvsgbKTmjGsvYMQAk47pM3ZYGhKdO+7lz2mWMaQZaOEPkSUO0rYDxz7txw6Rd71soEwVApXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrBPdi0s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrBPdi0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952D01F000E9;
	Wed, 20 May 2026 18:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301689;
	bh=4BG8ZE2Iof+yvTRddJgGxZLroh3mJIOeIrinxDNE6IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UrBPdi0s407Ly43ETibPLnXH7MQUwgZEGIx6rXsOBzp6+xrVmvlEkC45YYrkIYhFQ
	 IHv7U7BoR6a9JaI3cPFz4nEX6A58JdnV9zyyPgo7sjg44P/RU1oA9EQ+Eujl4qGe84
	 fKr7knF/ik/8kGVljem5Tozw2VEhi3gckYhnlKSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 648/666] eventfs: Use list_add_tail_rcu() for SRCU-protected children list
Date: Wed, 20 May 2026 18:24:19 +0200
Message-ID: <20260520162125.327460473@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

[ Upstream commit f67950b2887fa10df50c4317a1fe98a65bc6875b ]

Commit d2603279c7d6 ("eventfs: Use list_del_rcu() for SRCU protected
list variable") converted the removal side to pair with the
list_for_each_entry_srcu() walker in eventfs_iterate(). The insertion
in eventfs_create_dir() was left as a plain list_add_tail(), which on
weakly-ordered architectures can expose a new entry to the SRCU reader
before its list pointers and fields are observable.

Use list_add_tail_rcu() so the publication pairs with the existing
list_del_rcu() and list_for_each_entry_srcu().

Fixes: 43aa6f97c2d0 ("eventfs: Get rid of dentry pointers without refcounts")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260418152251.199343-1-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ adapted scoped_guard(mutex, &eventfs_mutex) block to explicit mutex_lock()/mutex_unlock() pair ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -732,7 +732,7 @@ struct eventfs_inode *eventfs_create_dir
 
 	mutex_lock(&eventfs_mutex);
 	if (!parent->is_freed)
-		list_add_tail(&ei->list, &parent->children);
+		list_add_tail_rcu(&ei->list, &parent->children);
 	mutex_unlock(&eventfs_mutex);
 
 	/* Was the parent freed? */


