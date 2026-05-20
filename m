Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751D443E4B9;
	Wed, 20 May 2026 18:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779303017; cv=none; b=C4Bj2mOb70AyfDOgpMFZWCuxh3TaIIErctEOK30jhnrlXkoqFcT3jfG118O0tf2FakjsVpW7+GTi8mAr/YeVt+dZj6A2Gt+kHZv7E+z15FzTny9/3qN1H9VJEODkLmqXJ9GRFTFN6TqYsbaEoxTjPVlQBIfDpIMyfj+eOIvRm9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779303017; c=relaxed/simple;
	bh=A2Ztm+I4Z9svfG+ptIIrJs7Z1pJCTdXrrrLPliz/h9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZuCWW1cqgxl4QHmITrf3svHbUUz0pJUAO2FHoWvKuxfxCmAeSxRUXmFzTsTScHgLY3Dm8IEDdx+JytM9PrMiGrQ0YcMm4yBuvsgrOAxwGyxWl1ucfLgZbdKjL4RyHdBFUIpzYM2it73peaZtSNToN8IhpTdsLRSd65m8td7D0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bKPiEaxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bKPiEaxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8ED71F00894;
	Wed, 20 May 2026 18:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779303014;
	bh=01Gw3JbmjDN86QMhug/KSik0ipSg4s22Syqt7L+ShOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKPiEaxgqoDGFzalDisLUiOs7oa385BOpauO/90+RPCRVysgvBHSIlKfF7XpVIE2I
	 tZgQg3A4jYzi+FJBcq+Gb1mk550FLDF/fq75LmA5NkSgUnugNUDkf/dIAO3Aw4daIq
	 75Z9BM8uMPiBg1rWxPaWYojILxQ6ruCKmp0sJmIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 487/508] eventfs: Use list_add_tail_rcu() for SRCU-protected children list
Date: Wed, 20 May 2026 18:25:10 +0200
Message-ID: <20260520162109.146990176@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
@@ -802,7 +802,7 @@ struct eventfs_inode *eventfs_create_dir
 
 	mutex_lock(&eventfs_mutex);
 	if (!parent->is_freed)
-		list_add_tail(&ei->list, &parent->children);
+		list_add_tail_rcu(&ei->list, &parent->children);
 	mutex_unlock(&eventfs_mutex);
 
 	/* Was the parent freed? */


