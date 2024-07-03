Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 739DB17277F;
	Wed,  3 Jul 2024 11:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004605; cv=none; b=laz9WDfI5lzI9n7djjzTv/qe/w4/B0BASYm4/RugUyBLerfmgxrEg4gkldGeAbYxxId5RRiC+SUOB4BwWOZ4VhcekVYH1/iNoMVaQdEwv2xWwBcBOiYVb6B4F7HNOACRxVxMYamkIVbz209U+Sb/Kv+TTeVF5nKFGN2QIAH+/0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004605; c=relaxed/simple;
	bh=N4IO3xpKbzuEHCFzVZmOJgJWJOuPUn+V6XLkrqqyRtk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NJxZiBrp1qECZstATHWpHLwelXcC2HU6K11YUQQ0FpLUpmufxtiSvUKoxy5zoowqKxZOmIOLRKjsz9EP1TRmb1w9MHTnrv/GNN/+FL88tfRf14pdfhh/r5leLD+3nvOrLKiztkutzhPHaIQXwBZKBmG8SMAsXl11P1cstaVdTe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ojYmpnPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ojYmpnPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA271C2BD10;
	Wed,  3 Jul 2024 11:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004605;
	bh=N4IO3xpKbzuEHCFzVZmOJgJWJOuPUn+V6XLkrqqyRtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ojYmpnPeNIl1hboQ1akYYNOP7SL0I7ZmzqUlWmddNECfUcGtSM/25KtKTiBS/MR1f
	 jPtQMpn4uME6KW+RvG2LbdDEyOHRT04upUUP7w8qQnTMAFTnEIFObiqEK4fO7XWgN+
	 7I7gmfSrGqs2mrPzjpJ+Kq1r/ngg8KgTgPkDUOpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	YonglongLi <liyonglong@chinatelecom.cn>,
	Mat Martineau <martineau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 098/290] mptcp: pm: update add_addr counters after connect
Date: Wed,  3 Jul 2024 12:37:59 +0200
Message-ID: <20240703102907.895371276@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YonglongLi <liyonglong@chinatelecom.cn>

commit 40eec1795cc27b076d49236649a29507c7ed8c2d upstream.

The creation of new subflows can fail for different reasons. If no
subflow have been created using the received ADD_ADDR, the related
counters should not be updated, otherwise they will never be decremented
for events related to this ID later on.

For the moment, the number of accepted ADD_ADDR is only decremented upon
the reception of a related RM_ADDR, and only if the remote address ID is
currently being used by at least one subflow. In other words, if no
subflow can be created with the received address, the counter will not
be decremented. In this case, it is then important not to increment
pm.add_addr_accepted counter, and not to modify pm.accept_addr bit.

Note that this patch does not modify the behaviour in case of failures
later on, e.g. if the MP Join is dropped or rejected.

The "remove invalid addresses" MP Join subtest has been modified to
validate this case. The broadcast IP address is added before the "valid"
address that will be used to successfully create a subflow, and the
limit is decreased by one: without this patch, it was not possible to
create the last subflow, because:

- the broadcast address would have been accepted even if it was not
  usable: the creation of a subflow to this address results in an error,

- the limit of 2 accepted ADD_ADDR would have then been reached.

Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Cc: stable@vger.kernel.org
Co-developed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: YonglongLi <liyonglong@chinatelecom.cn>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://lore.kernel.org/r/20240607-upstream-net-20240607-misc-fixes-v1-3-1ab9ddfa3d00@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Conflicts in pm_netlink.c because commit 1a0d6136c5f0 ("mptcp: local
  addresses fullmesh") is not present in this version (+ others changing
  the context). To resolve the conflicts, the same block is moved later,
  and under the condition that the call to __mptcp_subflow_connect()
  didn't fail.
  The selftest modification has been dropped, because the modified test
  is not in this version. That's fine, we can test with selftests from a
  newer version. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -371,15 +371,12 @@ void mptcp_pm_nl_add_addr_received(struc
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_addr_info remote;
 	struct mptcp_addr_info local;
+	int err;
 
 	pr_debug("accepted %d:%d remote family %d",
 		 msk->pm.add_addr_accepted, msk->pm.add_addr_accept_max,
 		 msk->pm.remote.family);
-	msk->pm.add_addr_accepted++;
 	msk->pm.subflows++;
-	if (msk->pm.add_addr_accepted >= msk->pm.add_addr_accept_max ||
-	    msk->pm.subflows >= msk->pm.subflows_max)
-		WRITE_ONCE(msk->pm.accept_addr, false);
 
 	/* connect to the specified remote address, using whatever
 	 * local address the routing configuration will pick.
@@ -391,9 +388,16 @@ void mptcp_pm_nl_add_addr_received(struc
 	local.family = remote.family;
 
 	spin_unlock_bh(&msk->pm.lock);
-	__mptcp_subflow_connect((struct sock *)msk, &local, &remote);
+	err = __mptcp_subflow_connect((struct sock *)msk, &local, &remote);
 	spin_lock_bh(&msk->pm.lock);
 
+	if (!err) {
+		msk->pm.add_addr_accepted++;
+		if (msk->pm.add_addr_accepted >= msk->pm.add_addr_accept_max ||
+		    msk->pm.subflows >= msk->pm.subflows_max)
+			WRITE_ONCE(msk->pm.accept_addr, false);
+	}
+
 	mptcp_pm_announce_addr(msk, &remote, true);
 }
 


