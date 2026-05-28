Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868362E92BA;
	Thu, 28 May 2026 20:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000544; cv=none; b=CRm9liRwCWRb0MOTHReqDIJWOKJeS4jaBvxSI7rHKumf1VYvdRFCzf9HtPxTv7CAksEE0lqxIAgn+ykGevNb/yywYGDKeVzwjCH3WXGU1uvDfSayBqlGjunkxISkKeGMq75HaySHisRZx67XX3UziNuNXV8oRnhaanmoqyXvkGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000544; c=relaxed/simple;
	bh=BZDq0la7P+/DitEo0jY4i49RECpmsYl3QYKLn+9yMoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tWa4R5iC1Ao/RU+RsywG5/fX6snJBRjOCt4LBTli/mMoLYxJtoOuklgY/V8Jt3saUHJ0643UaeHbkvmQR5Yiphii8OMW4ukJ9yyvIs+Z6nM763UnYeO26h53blObxAzCQbe0GOzu8QKu8HlSM+jClNVIap457xYTtLmYEGC8JgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUL8kPNL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUL8kPNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC431F000E9;
	Thu, 28 May 2026 20:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000543;
	bh=wgPrp/De50UFQ5DqX3ZRiQf03q99SKfyo74JmINJY4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uUL8kPNL9l8cWCIZpH6BOZ/ikqb+eEWqfNuJp4Yt+L+kgIx6iu1S/b/S/ZpJyJDKm
	 Kxa/5SSTcPWs1QsMY57ZfeMRMaVTRR0tKGh8/9dAT+Eo38R0PKkoe1LMjtzTgnceui
	 sRKLPP0gK9TgTfX9VdaE5utRhhfs2yHLu4lBqPGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 081/272] l2tp: use list_del_rcu in l2tp_session_unhash
Date: Thu, 28 May 2026 21:47:35 +0200
Message-ID: <20260528194631.647570280@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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


