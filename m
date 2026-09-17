Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9F538C42A;
	Thu, 17 Sep 2026 17:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666552; cv=none; b=oeYEe2NV9ELbOVzeATsTpPGJRNg+VSxLAQW7UxTSyKxAwGICu19+7p68q/kttmSNZjhZ/9mcgL/Tbfeq/Voy8l7B+2m6QWKazVhmI9yQwjDoLaqrNp+8Tq5aDU71INKC4vY+dgyqVCP0qEchjqLwQOuRl3dXEpMmC83mdTdMRcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666552; c=relaxed/simple;
	bh=DucrYibikEb4Q5hMF+pkbPd+qBJqaQBdJ5fUVYqLw0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=upLeKGWF2fR/1ulzpW++e9qCx2zm5uvMGTHdoAzGROZsGRScTsrqmLBqHx/oDRmhd8y2bCK/MGgtE3lD4Wxzb7Rv6bqJOkPvoT66XAJZAZZB/kaWObKJqpi5BshoHAjiqL6bo3SoZ183npKpGMTZ0i9+CstnWG9jZ3alpHjXn/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/5AkLS/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/5AkLS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A540B1F00893;
	Thu, 17 Sep 2026 17:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666551;
	bh=joIirOIhi7Z/ZutaVQVp6gCKcVS4MvpEAJ8CI2CX5Ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/5AkLS/x/snsBNIewvh+NOGlj4jGf/KZVqlbkQb5dxn1ER2RS3K0dIPp1LoAl4se
	 sensOaGumW2E95KtmdK9lGW8Yuk7R2G5WFMtLb3dgHMLAz/kN2KYqBzwSxj1/KC8WT
	 yF5eRs13OGy01faXgdcdBzFYHk3/5gs4xDyrYxVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+55c2a5c871441261ed14@syzkaller.appspotmail.com,
	Tao Cui <cuitao@kylinos.cn>,
	Kalpan Jani <kalpan.jani@mpiricsoftware.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1076/1250] mptcp: pm: kernel: drop pending ADD_ADDR when removing ID0
Date: Thu, 17 Sep 2026 16:14:31 +0100
Message-ID: <20260917151621.303063052@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalpan Jani <kalpan.jani@mpiricsoftware.com>

commit 2ac7d6e620764f1fc79eb4edd3610a7a661981ca upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_kernel.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/mptcp/pm_kernel.c
+++ b/net/mptcp/pm_kernel.c
@@ -1113,6 +1113,8 @@ static int mptcp_nl_remove_id_zero_addre
 	while ((msk = mptcp_token_iter_next(net, &s_slot, &s_num)) != NULL) {
 		struct sock *sk = (struct sock *)msk;
 		struct mptcp_addr_info msk_local;
+		struct mptcp_addr_info anno_addr;
+		bool announced;
 
 		if (list_empty(&msk->conn_list) || mptcp_pm_is_userspace(msk))
 			goto next;
@@ -1122,7 +1124,13 @@ static int mptcp_nl_remove_id_zero_addre
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


