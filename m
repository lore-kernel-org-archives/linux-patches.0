Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5CF199E9D;
	Tue, 10 Sep 2024 10:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963611; cv=none; b=X42q4J+3X4hKjiTpIZEyYdnDzyEJN5yufUVCXrKD6D/Fs1vsuwexrQH4gS/F3eYxtuwjlhL2gLRrnN6MaSIKHGER5V/PP//dBfs8a1uKeS+wEoHMd4E6282iEiARCNWiWaW1P452NvRoc/qPJQKGEpTNqU2olS6DdiRx/OjiMsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963611; c=relaxed/simple;
	bh=GmnpjMZG0sEZBtUa2WTY5Mc7iGfyq6vjdzqWJEQVRuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ib9GkEj5+L61TYsdi1t/7OE37vEeDMQ5VwPrmdDxLa02ZtWuUmJrotgy7CY+zUD5wdatsmwIu5hzBncNk4vKnO4PB8MO68serBXbGG1h7GhqfuAv8EU9PXsjHvj/6SBcGdbLWhY87f3sF9se0k7NmJd82OGavdANJ7tw91qoZXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySSGpziO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySSGpziO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09F82C4CEC3;
	Tue, 10 Sep 2024 10:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963611;
	bh=GmnpjMZG0sEZBtUa2WTY5Mc7iGfyq6vjdzqWJEQVRuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySSGpziOPxuFR73/OzeP+p2Q/txmihJcUH1xT1gXJnGge76fWnx4EWzYqhfhGlNZ6
	 IpLNUmcyjgmcYuq1JQ4r/c8ZBhXliRuhq3hIpO1KnxGN45Hypv6lWFO29LvAaVCm/6
	 v0ctSwHTVdKE414Kb48s8O8IuaCMkQF0mIrbMFng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 090/214] mptcp: pm: re-using ID of unused flushed subflows
Date: Tue, 10 Sep 2024 11:31:52 +0200
Message-ID: <20240910092602.438938052@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>

commit ef34a6ea0cab1800f4b3c9c3c2cefd5091e03379 upstream.

If no subflows are attached to the 'subflow' endpoints that are being
flushed, the corresponding addr IDs will not be marked as available
again.

Mark all ID as being available when flushing all the 'subflow'
endpoints, and reset local_addr_used counter to cover these cases.

Note that mptcp_pm_remove_addrs_and_subflows() helper is only called for
flushing operations, not to remove a specific set of addresses and
subflows.

Fixes: 06faa2271034 ("mptcp: remove multi addresses and subflows in PM")
Cc: stable@vger.kernel.org
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20240819-net-mptcp-pm-reusing-id-v1-5-38035d40de5b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ No conflicts, but the line modifying msk->pm.id_avail_bitmap has been
  removed, as it is not in this version, introduced later in commit
  86e39e04482b ("mptcp: keep track of local endpoint still available for
  each msk") and depending on other ones. The best we can do in this
  version is to reset local_addr_used counter, better than nothing. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1498,8 +1498,14 @@ static void mptcp_pm_remove_addrs_and_su
 		mptcp_pm_remove_addr(msk, &alist);
 		spin_unlock_bh(&msk->pm.lock);
 	}
+
 	if (slist.nr)
 		mptcp_pm_remove_subflow(msk, &slist);
+
+	/* Reset counters: maybe some subflows have been removed before */
+	spin_lock_bh(&msk->pm.lock);
+	msk->pm.local_addr_used = 0;
+	spin_unlock_bh(&msk->pm.lock);
 }
 
 static void mptcp_nl_remove_addrs_list(struct net *net,


