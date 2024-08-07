Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A74E27448;
	Wed,  7 Aug 2024 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043162; cv=none; b=SRDEt0q7ihRCrqMpGMlY1pAQd5fB3MXVM26nqV+XsDgI9TcqvoDaCgm4F/gAqRMXvtKRgxAe/2aMrZJx2WcQiCm6evzfmH22JawZ368sXcGMQmFkYV7uu6yQcoOoZqy1/YmSGSUSy9r/dCk1VRxha8JjkLVIVJbysm/5iSCDGZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043162; c=relaxed/simple;
	bh=F2Rdhv22yw+EAKaSrzlv8mQu3KbY+NWCC4aMdmn4bS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozdkbA/NuERL/eQQvEEoHUJ76X3A0caiYsMLALZemtHmAhwxWDcL2IF6u8gJGzXemvnFF0ffctAn+JFcZ8gdsuVx7Ye9JsDwNiJvq7wlJovoHxT66e2FBgNz4DaXiXkIjVW1cRgxquAcBohRq3rhKhDtmCnJlrs2+Qvjm7jzVtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGD7zfGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGD7zfGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFA45C32781;
	Wed,  7 Aug 2024 15:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043162;
	bh=F2Rdhv22yw+EAKaSrzlv8mQu3KbY+NWCC4aMdmn4bS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGD7zfGjotDTlP7wVIlt9fWLPQ4+E/grD9W8aHkn7DI8qpzfqO0eKy97l9+EdP/OL
	 0KL9IsnTA9afCs1bL0qjSQLdR97nSKljgAj+XlUjiHjGdHwZofHF9YacRMDV13Pd1B
	 cCPtTmekM4XFxl+ZL3SfTfqa6IIKkiVeNe7sNwn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.10 114/123] mptcp: fix NL PM announced address accounting
Date: Wed,  7 Aug 2024 17:00:33 +0200
Message-ID: <20240807150024.560812670@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_netlink.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1401,6 +1401,7 @@ static bool mptcp_pm_remove_anno_addr(st
 	ret = remove_anno_list_by_saddr(msk, addr);
 	if (ret || force) {
 		spin_lock_bh(&msk->pm.lock);
+		msk->pm.add_addr_signaled -= ret;
 		mptcp_pm_remove_addr(msk, &list);
 		spin_unlock_bh(&msk->pm.lock);
 	}
@@ -1565,17 +1566,18 @@ static void mptcp_pm_remove_addrs_and_su
 	struct mptcp_pm_addr_entry *entry;
 
 	list_for_each_entry(entry, rm_list, list) {
-		if (lookup_subflow_by_saddr(&msk->conn_list, &entry->addr) &&
-		    slist.nr < MPTCP_RM_IDS_MAX)
+		if (slist.nr < MPTCP_RM_IDS_MAX &&
+		    lookup_subflow_by_saddr(&msk->conn_list, &entry->addr))
 			slist.ids[slist.nr++] = entry->addr.id;
 
-		if (remove_anno_list_by_saddr(msk, &entry->addr) &&
-		    alist.nr < MPTCP_RM_IDS_MAX)
+		if (alist.nr < MPTCP_RM_IDS_MAX &&
+		    remove_anno_list_by_saddr(msk, &entry->addr))
 			alist.ids[alist.nr++] = entry->addr.id;
 	}
 
 	if (alist.nr) {
 		spin_lock_bh(&msk->pm.lock);
+		msk->pm.add_addr_signaled -= alist.nr;
 		mptcp_pm_remove_addr(msk, &alist);
 		spin_unlock_bh(&msk->pm.lock);
 	}


