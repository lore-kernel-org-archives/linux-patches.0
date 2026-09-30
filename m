Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606BF37A825;
	Wed, 30 Sep 2026 17:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790274; cv=none; b=ae8b7Jz4CyoJ7P0oTM7ACf+tydvbWuhKp5Bhg7CBMaqtMgcejGsskPZPqziMbGFFYbU2AijuLZ5vjeanjmzucbJueMm2MiDWREqCjWnrfbVRQJdW7c/mmOaCCQfZH2MrPoMmtQQxYIN8eLHZh/VMt3HIzWra05vWO8vsBvmXdIU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790274; c=relaxed/simple;
	bh=bqa1yNiGyXTqE8OkF5P46ymDVlNMR/dmA1Bmt5mCdjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CV8XQMmv7y1zv0+urGbUiYvSfPDJctgIApPdbpt/ikb5peaTbood9m3ytwDVg+TnSDhKwn9XIJGf9YlCZ6ndtQztkEj4H3PwjI6m5HO5RfAy5ebJZG7ZfRfsQFuYCARrobD+5KknTfbqMH6pe0t9CsaFFl9PEDWAi44TRVRNPGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4N3Fwd0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4N3Fwd0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10071F00899;
	Wed, 30 Sep 2026 17:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790273;
	bh=Q6hrhWrd5zmOAXvqHJaQFcIolzegGl0jwW/LsXU0VPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h4N3Fwd0y1b9xgP5ItfogtuL9csiBiZ7yMO2AX9QMaPNjzH//nymUyuforLK+OJVh
	 QsiEp2lyVmKDLYNzlqR4TURPTQ96MWacnY8lhv+BBl3f87OhSUstYLn5XkPIHWdy9F
	 L06bwhpC1cFBBKruaLHECDnmSZuaGYH89tMBArOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+55c2a5c871441261ed14@syzkaller.appspotmail.com,
	Tao Cui <cuitao@kylinos.cn>,
	Kalpan Jani <kalpan.jani@mpiricsoftware.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 770/877] mptcp: pm: kernel: drop pending ADD_ADDR when removing ID0
Date: Wed, 30 Sep 2026 17:28:01 +0200
Message-ID: <20260930152431.327205480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Kalpan Jani <kalpan.jani@mpiricsoftware.com>

[ Upstream commit 2ac7d6e620764f1fc79eb4edd3610a7a661981ca ]

The in-kernel MPTCP path manager can leave a stale ADD_ADDR announcement
entry alive when removing the id 0 endpoint. This happens because the id 0
removal path does not tear down pending announcements, unlike the non-zero
id path.

When the PM later reselects id 0 after adding another signal endpoint, it
finds the stale anno_list entry and hits WARN_ON_ONCE(mptcp_pm_is_kernel())
in mptcp_pm_announced_alloc().

Root cause: asymmetry between removal paths.
- Non-zero id path: mptcp_nl_remove_subflow_and_signal_addr() calls
  mptcp_pm_remove_announced() to clean up.
- Id 0 path: mptcp_nl_remove_id_zero_address() skips cleanup entirely.

Fix by making the id 0 path symmetric: call mptcp_pm_announced_remove()
and decrement add_addr_signaled before queuing the RM_ADDR.

Subtle detail: signal endpoints are stored in anno_list with port 0, but
msk_local carries the connection's local port. In other words, entries
linked to ID0 paths should have port == 0. A follow-up patch will ensure
that. mptcp_pm_announced_remove() uses use_port=true for comparison. So
clear the port before the lookup.

Fixes: 740d798e8767 ("mptcp: remove id 0 address")
Cc: stable@vger.kernel.org
Reported-by: syzbot+55c2a5c871441261ed14@syzkaller.appspotmail.com
Closes: https://github.com/multipath-tcp/mptcp_net-next/issues/620
Suggested-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Kalpan Jani <kalpan.jani@mpiricsoftware.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260908-net-mptcp-misc-fixes-7-3-rc1-v2-4-df1de70348b6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_kernel.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -1677,6 +1677,8 @@ static int mptcp_nl_remove_id_zero_addre
 	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
 		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info msk_local;
+		struct mptcp_addr_info anno_addr;
+		bool announced;
 
 		if (list_empty(&msk->conn_list) || mptcp_pm_is_userspace(msk))
 			goto next;
@@ -1686,7 +1688,13 @@ static int mptcp_nl_remove_id_zero_addre
 			goto next;
 
 		lock_sock(sk);
+		/* Drop a possibly pending ADD_ADDR for this address. */
+		anno_addr = msk_local;
+		anno_addr.port = 0;
+		announced = mptcp_pm_announced_remove(msk, &anno_addr);
 		spin_lock_bh(&msk->pm.lock);
+		if (announced)
+			msk->pm.add_addr_signaled--;
 		mptcp_pm_remove_addr(msk, &list);
 		mptcp_pm_rm_subflow(msk, &list);
 		__mark_subflow_endp_available(msk, 0);


