Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0730833B6FC;
	Thu, 28 May 2026 20:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000341; cv=none; b=FuipkeDuvJv645AB5E+CJmDkSt2mLFKR3BlwLqyXClbhr/v/4TobXWjmkRQfwp9qIaVW3z6U7uCthOCSw1seqgoonvTJVb7UirDySqiWuZEmwuHsuo9f+/pNDATZVJuh6qy1F88YyhYl8n5qGbCI7C4odAEbHEF6UGg2DsNuONQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000341; c=relaxed/simple;
	bh=oVZr7hYqtRI2g2Ib7/U8o1jCxCFs5qJUxX1Mlq5bYTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqKWCTE5Zlse9UCJ5hUmEu4Dk6YA5oAShE716UzNNAxPFAiwSiRzXuO0fSyh/pqaJVgOIU3S4I9yqxVFKse5dgAZP1GR47Y0xD+iiecnsFo+IqDcIbCzCTe89u5gAqSQHijNs3HODdIZHv92GzIyH2TC1Q/LHtF9lguo7CxG8qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKgW+buW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKgW+buW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B31A1F000E9;
	Thu, 28 May 2026 20:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000340;
	bh=jLikozwscvb5sup/aojaGS0vxKJorg0ztEpuLYzCwFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKgW+buWBSkMRDLyBoql8ekZ3jjEDcIM4MBsr7WIe92aDz2iLvtqwju3731Q/3CbK
	 11zQ+qdV8dChJB/gO1lNh/nmGWrM9zTb21nzG9efJ61m1g9ZEwwhiZvFf9UgNWvP+q
	 XK8sLAuU5JzlxTxnVMEcTyWSQH7yklr3zfC57rGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/272] mptcp: pm: ADD_ADDR rtx: always decrease sk refcount
Date: Thu, 28 May 2026 21:46:17 +0200
Message-ID: <20260528194629.479712627@linuxfoundation.org>
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

From: Matthieu Baerts (NGI0) <matttbe@kernel.org>

commit 9634cb35af17019baec21ca648516ce376fa10e6 upstream.

When an ADD_ADDR is retransmitted, the sk is held in sk_reset_timer().
It should then be released in all cases at the end.

Some (unlikely) checks were returning directly instead of calling
sock_put() to decrease the refcount. Jump to a new 'exit' label to call
__sock_put() (which will become sock_put() in the next commit) to fix
this potential leak.

While at it, drop the '!msk' check which cannot happen because it is
never reset, and explicitly mark the remaining one as "unlikely".

Fixes: 00cfd77b9063 ("mptcp: retransmit ADD_ADDR when timeout")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260505-net-mptcp-pm-fixes-7-1-rc3-v1-4-fca8091060a4@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ applied to net/mptcp/pm_netlink.c instead of upstream's pm_kernel.c ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_netlink.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 857e8db670a75..be531df02c371 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -298,11 +298,8 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 
 	pr_debug("msk=%p\n", msk);
 
-	if (!msk)
-		return;
-
-	if (inet_sk_state_load(sk) == TCP_CLOSE)
-		return;
+	if (unlikely(inet_sk_state_load(sk) == TCP_CLOSE))
+		goto exit;
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
@@ -340,6 +337,7 @@ static void mptcp_pm_add_timer(struct timer_list *timer)
 
 out:
 	bh_unlock_sock(sk);
+exit:
 	__sock_put(sk);
 }
 
-- 
2.53.0



