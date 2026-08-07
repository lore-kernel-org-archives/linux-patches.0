Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BEB3BCD38;
	Fri,  7 Aug 2026 15:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116500; cv=none; b=a1Uj/RP94JWNIQ8uqyIE3RSmtiwHISq+RBe0DglOu3flBcgBNtvh3h5HOBvn8xEAHHrle4XFDcIO3bQLBXJ9b4jJptm2PjdnjQ5HjzqkQlvKduxqgPxmQCq+p2JJU7BtKj8jm0db5gczscw5iLZbDFf3jPaoyjc9wcTYUMS6270=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116500; c=relaxed/simple;
	bh=T5EdaU2hCcDiETtGK4fm8pvybf0vasGzLxMtXPhOKLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ddv1xET4ZAA0kqEsPKIn808O25mcpBSvm7cocKFOF6fLrN3vC1C7CmMGav1Gt/iPqgnBRawia/RbDA/+sMKhwWWc41BXnLFFdq2YFXl6DqptsV5w57oKFqxOHWzVHn5790bDvuxYpNk/ls4l1jSp4p/r7RkxOF1/CJgG7uJMDuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXQxRDOf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXQxRDOf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A441F00A3A;
	Fri,  7 Aug 2026 15:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116499;
	bh=NM/54djLQC5GHFE3Ko902POlw73SUig4otv2Zeo4T88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tXQxRDOfS29TPCNwPUBFxqkYI5g/8fdJYaNMkk03z17F8PlFfaz6o1r9bY9zLZfeZ
	 UQg5SDtBOjpBc7kYUjJVkgwM0U4/2y+Bbr0heCyeQpbbQIxClN4M8IyqqLsBkziUNp
	 Rnxko+C/9nKAqohVJTnAb6CEmuBZOeLzyyFE+Hhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/261] mptcp: add mptcp_userspace_pm_lookup_addr helper
Date: Fri,  7 Aug 2026 16:40:07 +0200
Message-ID: <20260807143420.812022570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit e7b4083b90b7213902124d13fd1ed808360e32b1 ]

Like __lookup_addr() helper in pm_netlink.c, a new helper
mptcp_userspace_pm_lookup_addr() is also defined in pm_userspace.c.
It looks up the corresponding mptcp_pm_addr_entry address in
userspace_pm_local_addr_list through the passed "addr" parameter
and returns the found address entry.

This helper can be used in mptcp_userspace_pm_delete_local_addr(),
mptcp_userspace_pm_set_flags(), mptcp_userspace_pm_get_local_id()
and mptcp_userspace_pm_is_backup() to simplify the code.

Please note that with this change now list_for_each_entry() is used in
mptcp_userspace_pm_append_new_local_addr(), not list_for_each_entry_safe(),
but that's OK to do so because mptcp_userspace_pm_lookup_addr() only
returns an entry from the list, the list hasn't been modified here.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241213-net-next-mptcp-pm-misc-cleanup-v1-1-ddb6d00109a8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9bc6d5e4ca9f ("mptcp: pm: userspace: fix use-after-free in get_local_id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |   71 +++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 35 deletions(-)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -25,6 +25,19 @@ void mptcp_free_local_addr_list(struct m
 	}
 }
 
+static struct mptcp_pm_addr_entry *
+mptcp_userspace_pm_lookup_addr(struct mptcp_sock *msk,
+			       const struct mptcp_addr_info *addr)
+{
+	struct mptcp_pm_addr_entry *entry;
+
+	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
+		if (mptcp_addresses_equal(&entry->addr, addr, false))
+			return entry;
+	}
+	return NULL;
+}
+
 static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 						    struct mptcp_pm_addr_entry *entry,
 						    bool needs_id)
@@ -89,22 +102,20 @@ append_err:
 static int mptcp_userspace_pm_delete_local_addr(struct mptcp_sock *msk,
 						struct mptcp_pm_addr_entry *addr)
 {
-	struct mptcp_pm_addr_entry *entry, *tmp;
 	struct sock *sk = (struct sock *)msk;
+	struct mptcp_pm_addr_entry *entry;
 
-	list_for_each_entry_safe(entry, tmp, &msk->pm.userspace_pm_local_addr_list, list) {
-		if (mptcp_addresses_equal(&entry->addr, &addr->addr, false)) {
-			/* TODO: a refcount is needed because the entry can
-			 * be used multiple times (e.g. fullmesh mode).
-			 */
-			list_del_rcu(&entry->list);
-			sock_kfree_s(sk, entry, sizeof(*entry));
-			msk->pm.local_addr_used--;
-			return 0;
-		}
-	}
-
-	return -EINVAL;
+	entry = mptcp_userspace_pm_lookup_addr(msk, &addr->addr);
+	if (!entry)
+		return -EINVAL;
+
+	/* TODO: a refcount is needed because the entry can
+	 * be used multiple times (e.g. fullmesh mode).
+	 */
+	list_del_rcu(&entry->list);
+	sock_kfree_s(sk, entry, sizeof(*entry));
+	msk->pm.local_addr_used--;
+	return 0;
 }
 
 static struct mptcp_pm_addr_entry *
@@ -139,17 +150,12 @@ int mptcp_userspace_pm_get_flags_and_ifi
 int mptcp_userspace_pm_get_local_id(struct mptcp_sock *msk,
 				    struct mptcp_addr_info *skc)
 {
-	struct mptcp_pm_addr_entry *entry = NULL, *e, new_entry;
+	struct mptcp_pm_addr_entry *entry = NULL, new_entry;
 	__be16 msk_sport =  ((struct inet_sock *)
 			     inet_sk((struct sock *)msk))->inet_sport;
 
 	spin_lock_bh(&msk->pm.lock);
-	list_for_each_entry(e, &msk->pm.userspace_pm_local_addr_list, list) {
-		if (mptcp_addresses_equal(&e->addr, skc, false)) {
-			entry = e;
-			break;
-		}
-	}
+	entry = mptcp_userspace_pm_lookup_addr(msk, skc);
 	spin_unlock_bh(&msk->pm.lock);
 	if (entry)
 		return entry->addr.id;
@@ -169,15 +175,11 @@ bool mptcp_userspace_pm_is_backup(struct
 				  struct mptcp_addr_info *skc)
 {
 	struct mptcp_pm_addr_entry *entry;
-	bool backup = false;
+	bool backup;
 
 	spin_lock_bh(&msk->pm.lock);
-	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
-		if (mptcp_addresses_equal(&entry->addr, skc, false)) {
-			backup = !!(entry->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
-			break;
-		}
-	}
+	entry = mptcp_userspace_pm_lookup_addr(msk, skc);
+	backup = entry && !!(entry->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
 	spin_unlock_bh(&msk->pm.lock);
 
 	return backup;
@@ -591,13 +593,12 @@ int mptcp_userspace_pm_set_flags(struct
 		goto set_flags_err;
 
 	spin_lock_bh(&msk->pm.lock);
-	list_for_each_entry(entry, &msk->pm.userspace_pm_local_addr_list, list) {
-		if (mptcp_addresses_equal(&entry->addr, &loc->addr, false)) {
-			if (bkup)
-				entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
-			else
-				entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
-		}
+	entry = mptcp_userspace_pm_lookup_addr(msk, &loc->addr);
+	if (entry) {
+		if (bkup)
+			entry->flags |= MPTCP_PM_ADDR_FLAG_BACKUP;
+		else
+			entry->flags &= ~MPTCP_PM_ADDR_FLAG_BACKUP;
 	}
 	spin_unlock_bh(&msk->pm.lock);
 


