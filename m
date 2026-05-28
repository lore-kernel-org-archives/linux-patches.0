Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C233290B0;
	Thu, 28 May 2026 19:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998139; cv=none; b=Bz7x+HGHADQ4TpwbT9hE7x9goalENlpjJGSzuGREnOkZW0WpJyZwNb/jblDvEbr05AV2Jdh5t/vomxgzJ3sJEWXaRDHRGQSIA7KvkpwuGV8GoRyXDLJzhFND1sOMgRmJoPTjKG3T11UYf1aY/ccB9766qlSVMjapLQ9tJMDTkYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998139; c=relaxed/simple;
	bh=naBXAwCc8OLmHMlpKnVtnKz6tmFVD/GcmShII6KVKVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X64M3wJzrnhaJT7IRtCOUb3FPYTW9LmtoHXPCt4cpwMlWSpawF1mTifhDW+qN6mWNSJhwoNyvEOvCv8pGLEXKqGjafCXLqte34lww5fMU2+fUsMoPpXZ2ZhfWdvipZDIGOTBmmTg0Im34tehMAohiKyU4LCrRSHq574xj9wP5Pg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpBujxB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpBujxB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D26971F00A3A;
	Thu, 28 May 2026 19:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998138;
	bh=ywUe7k2syKnPKJhThR1x6UhIIUAdhW4AdpPdqlhtx/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KpBujxB+vnIlIodI8CHk6GzpNdkKgduBJNL97CV5MqQYN3jVjTsDb/j/W050+Ikmb
	 ROicm/OaUKWMdUMTx2v4pH+TD7jb34Bhn7G5ljyHpnjDScXLj19UlOtK5x3GZ59riz
	 BseY5fUuGa+Vf4rqaR1oJKJtJOtTxLmg/TcpJVhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 066/461] l2tp: use list_del_rcu in l2tp_session_unhash
Date: Thu, 28 May 2026 21:43:15 +0200
Message-ID: <20260528194648.831176338@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Bommarito <michael.bommarito@gmail.com>

commit 979c017803c40829b03acd9e5236e354b7622360 upstream.

An unprivileged local user can pin a host CPU indefinitely in
l2tp_session_get_by_ifname() by issuing L2TP_CMD_SESSION_GET on
L2TP_ATTR_IFNAME concurrently with L2TP_CMD_SESSION_CREATE and
L2TP_CMD_SESSION_DELETE on the same tunnel. All three commands take
GENL_UNS_ADMIN_PERM, so CAP_NET_ADMIN in the netns user namespace
suffices; on any host that has l2tp_core loaded the trigger is
reachable from a standard `unshare -Urn` sandbox.

l2tp_session_unhash() removes a session from tunnel->session_list
with list_del_init(), but that list is walked by
l2tp_session_get_by_ifname() with list_for_each_entry_rcu() under
rcu_read_lock_bh(). list_del_init() leaves the deleted entry's
next/prev self-pointing; a reader that has loaded the entry and
then advances pos->list.next reads &session->list, container_of()s
back to the same session, and list_for_each_entry_rcu() never
reaches the list head. The CPU stays in strcmp() inside the
walker, with BH and preemption disabled, so RCU grace periods on
the host stall behind it and the wedged thread cannot be killed
(SIGKILL is delivered on syscall return).

Use list_del_rcu() to match the existing list_add_rcu() in
l2tp_session_register(); the deleted session remains visible to
in-flight walkers with consistent next/prev pointers until
kfree_rcu() in l2tp_session_free() releases it. tunnel->session_list
has exactly one list_del_init() call site; the list_del_init
(&session->clist) at l2tp_core.c:533 operates on the per-collision
list, which is not walked under RCU. list_empty(&session->list) is
not used anywhere in net/l2tp/ after the unhash point, so dropping
the post-delete self-init is safe; the fix has no userspace-visible
behavior change.

Fixes: 89b768ec2dfef ("l2tp: use rcu list add/del when updating lists")
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260518183447.64078-1-michael.bommarito@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/l2tp/l2tp_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1360,7 +1360,7 @@ static void l2tp_session_unhash(struct l
 		spin_lock_bh(&pn->l2tp_session_idr_lock);
 
 		/* Remove from the per-tunnel list */
-		list_del_init(&session->list);
+		list_del_rcu(&session->list);
 
 		/* Remove from per-net IDR */
 		if (tunnel->version == L2TP_HDR_VER_3) {


