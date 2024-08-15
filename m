Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6901A76CC;
	Thu, 15 Aug 2024 14:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730582; cv=none; b=MFZV48HhhIDO6bkml/62WTpYRrFwap8EmasovTrMHuC8imlrxcM9w54CHMXm9UZ8DDol20an+QOezTDEuMQFxqUn7YZRx4G9Fq4/hli3644xo4EOtsAQsHUUA8p/aYuFzp5Q7SHGX22Xi7+lSE1F+6X+e63kE1bQ3Oit4ES0uFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730582; c=relaxed/simple;
	bh=ff/h5LCscXKw0ZfY4iYARPeuLnoeVXmlHdhlUGCRE4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBncq9PBUbJ3ALuzK1V4PjmC5VnOyqQQmxtzqsgZRSEwbRRIfJO16ra87IylM3uYTB7xun4l5yi4sFegyq7PqUEhAyxkvuRJmAH126562SJWDVr0k++tRUNBfxjzT5KrNt6xb9nSXO8x0hksTS+/EmulI0fz3/713MXOLYmPFd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ynlbf5XC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ynlbf5XC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB05DC32786;
	Thu, 15 Aug 2024 14:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730582;
	bh=ff/h5LCscXKw0ZfY4iYARPeuLnoeVXmlHdhlUGCRE4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ynlbf5XC95dwTYZnK1XzevRJW4ga4hn07s0NKAsjr8hB1uJCD50JnDjuXUsUOsQX3
	 W9jM7ukh9FERqPVIpHZ0aNwfvS2Liu6ssvZL1GCHa+M4/ngms6IHosByFQilh68R4N
	 ttALihA/96ITVWEhL9oH46eP3AuHWXp/G1jRmQ9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 453/484] mptcp: fix NL PM announced address accounting
Date: Thu, 15 Aug 2024 15:25:11 +0200
Message-ID: <20240815131958.961645217@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Paolo Abeni <pabeni@redhat.com>

commit 4b317e0eb287bd30a1b329513531157c25e8b692 upstream.

Currently the per connection announced address counter is never
decreased. As a consequence, after connection establishment, if
the NL PM deletes an endpoint and adds a new/different one, no
additional subflow is created for the new endpoint even if the
current limits allow that.

Address the issue properly updating the signaled address counter
every time the NL PM removes such addresses.

Fixes: 01cacb00b35c ("mptcp: add netlink-based PM")
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
[ Conflicts in pm_netlink.c, because the commit 6fa0174a7c86 ("mptcp:
  more careful RM_ADDR generation") is not in this version. The
  conditions are slightly different, but the same fix can be applied:
  first checking the IDs, then removing the address. ]
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1323,6 +1323,7 @@ static bool mptcp_pm_remove_anno_addr(st
 	ret = remove_anno_list_by_saddr(msk, addr);
 	if (ret || force) {
 		spin_lock_bh(&msk->pm.lock);
+		msk->pm.add_addr_signaled -= ret;
 		mptcp_pm_remove_addr(msk, &list);
 		spin_unlock_bh(&msk->pm.lock);
 	}
@@ -1462,19 +1463,20 @@ static void mptcp_pm_remove_addrs_and_su
 	struct mptcp_pm_addr_entry *entry;
 
 	list_for_each_entry(entry, rm_list, list) {
-		if (lookup_subflow_by_saddr(&msk->conn_list, &entry->addr) &&
-		    alist.nr < MPTCP_RM_IDS_MAX &&
-		    slist.nr < MPTCP_RM_IDS_MAX) {
+		if (alist.nr < MPTCP_RM_IDS_MAX &&
+		    slist.nr < MPTCP_RM_IDS_MAX &&
+		    lookup_subflow_by_saddr(&msk->conn_list, &entry->addr)) {
 			alist.ids[alist.nr++] = entry->addr.id;
 			slist.ids[slist.nr++] = entry->addr.id;
-		} else if (remove_anno_list_by_saddr(msk, &entry->addr) &&
-			 alist.nr < MPTCP_RM_IDS_MAX) {
+		} else if (alist.nr < MPTCP_RM_IDS_MAX &&
+			   remove_anno_list_by_saddr(msk, &entry->addr)) {
 			alist.ids[alist.nr++] = entry->addr.id;
 		}
 	}
 
 	if (alist.nr) {
 		spin_lock_bh(&msk->pm.lock);
+		msk->pm.add_addr_signaled -= alist.nr;
 		mptcp_pm_remove_addr(msk, &alist);
 		spin_unlock_bh(&msk->pm.lock);
 	}


