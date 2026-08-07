Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAFE29D27A;
	Fri,  7 Aug 2026 14:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114554; cv=none; b=B4l9fkzRevu7VyA/ft2RJ7e5E6voxBNoqci2cOMZggMmeXeJpuz+1F9EH89uthahzqR/HoTFqpV30Es0vsuFvxVwFOPPfdPmyhlKmGo75Mt6IMc6QF/l5wdQmDvGhOXmy+GkKmDLNdxejhg4Y91q0LehbkZOqGHk56TxPq7a4L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114554; c=relaxed/simple;
	bh=/xi32Fz8nI6gfaa3UIPCuwYUEkuxFVQOiH+nlMVirEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvb4ucmQYx6UcpbzdHuM0A3HMX3/iQjnYHH/970+gbnrGS08yPfi8/hVYMSFpMxZwP5/s469aL+cGFUwPQRSn/tnWS04WBtrQc/PPNkS3YT4x04YM4OpOZsoAwGgec9y0IfEh3FdawFQOtzEow/v+96pnJVMYKbR/Z8F1AMGRDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MId2JEOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MId2JEOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0F1E1F00A3D;
	Fri,  7 Aug 2026 14:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114553;
	bh=tlfW58I/c9NFdEeH/r0To4higa6aiSEcBwLaIko1+nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MId2JEOkQ5DWYeH9+SelCSGsvieSKAuHufpfV+WHlB92TkxfCuGjy9EKgMkhRsozK
	 x5LtgwKXmgW+bRFWG76/0egB1tWHN6bYyohXt4CKwGF0gdT1rjlsK4dMNMk1mhQ7HT
	 Xm9CL9Q2yCs5+VVmO+pcO5LEViTeP5xmy+BD2mJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 303/337] mptcp: pm: avoid code duplication to lookup endp
Date: Fri,  7 Aug 2026 16:38:26 +0200
Message-ID: <20260807143425.096096372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 1d7fa6ceb91fddbe38cae3521d5d1075bce6a00e ]

The helper __lookup_addr() can be used in mptcp_pm_nl_get_local_id()
and mptcp_pm_nl_is_backup() to simplify the code, and avoid code
duplication.

Co-developed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241115-net-next-mptcp-pm-lockless-dump-v1-2-f4a1bcb4ca2c@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 9bc6d5e4ca9f ("mptcp: pm: userspace: fix use-after-free in get_local_id")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1278,17 +1278,13 @@ int mptcp_pm_nl_get_local_id(struct mptc
 {
 	struct mptcp_pm_addr_entry *entry;
 	struct pm_nl_pernet *pernet;
-	int ret = -1;
+	int ret;
 
 	pernet = pm_nl_get_pernet_from_msk(msk);
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
-		if (mptcp_addresses_equal(&entry->addr, skc, entry->addr.port)) {
-			ret = entry->addr.id;
-			break;
-		}
-	}
+	entry = __lookup_addr(pernet, skc);
+	ret = entry ? entry->addr.id : -1;
 	rcu_read_unlock();
 	if (ret >= 0)
 		return ret;
@@ -1315,15 +1311,11 @@ bool mptcp_pm_nl_is_backup(struct mptcp_
 {
 	struct pm_nl_pernet *pernet = pm_nl_get_pernet_from_msk(msk);
 	struct mptcp_pm_addr_entry *entry;
-	bool backup = false;
+	bool backup;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(entry, &pernet->local_addr_list, list) {
-		if (mptcp_addresses_equal(&entry->addr, skc, entry->addr.port)) {
-			backup = !!(entry->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
-			break;
-		}
-	}
+	entry = __lookup_addr(pernet, skc);
+	backup = entry && !!(entry->flags & MPTCP_PM_ADDR_FLAG_BACKUP);
 	rcu_read_unlock();
 
 	return backup;


