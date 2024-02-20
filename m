Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5E1446C9;
	Tue, 20 Feb 2024 21:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464774; cv=none; b=qL/F/9v7OzKTal+REobw6uHkb0VvcUGUN8scRI1xO4EPRzDzNqC9XS9bVoSTmE/JLW+EKbwDYXvR+nPoLMx70uxwx+sTuTnDw8hEIDsefVTqFwlrE6Czn4X7wDq6ZZ+ijl1bqkSVOattDK8xJuZW0Dmavhoe1Ato4v8m+xLi7+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464774; c=relaxed/simple;
	bh=Hg3Qy0dOIHrTi4uSKKYv5afAMJPMAEgiByiXF5J6Y4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fYp0rFPOzcpksZchRY/hN+zWcdaWhniXc3ndpoLkuafaJ3SRrPPCQVVmxeBN45WXY605QcDnkrMOSGGimWMW/UOxIB1Q2IfEsIEsW6QK/6i1rnX0CqFpB3lZq12rVfEbz3O9899IyyW9/3NTdJkFM3atb5Kzr73UurIfuvbbXdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=on+ueFQo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="on+ueFQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1485C433C7;
	Tue, 20 Feb 2024 21:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464774;
	bh=Hg3Qy0dOIHrTi4uSKKYv5afAMJPMAEgiByiXF5J6Y4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=on+ueFQoKWNUid8dY8zG6IIPOQLQ1oKqAupZBquigotiGrYPDwvXtIRg8zjau2Kxj
	 b7epBmJLp0wazRwGZfvx5pD+YwjbRhtw4GwK1sZHCzIKPor0+nUv5CcpBzoTbEB45b
	 /Tb5vpm/b0l1kvu53QvjuZEiTHTZpNcoq02oK6E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@linux.dev>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.7 125/309] mptcp: check addrs list in userspace_pm_get_local_id
Date: Tue, 20 Feb 2024 21:54:44 +0100
Message-ID: <20240220205637.073373863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <geliang@kernel.org>

commit f012d796a6de662692159c539689e47e662853a8 upstream.

Before adding a new entry in mptcp_userspace_pm_get_local_id(), it's
better to check whether this address is already in userspace pm local
address list. If it's in the list, no need to add a new entry, just
return it's address ID and use this address.

Fixes: 8b20137012d9 ("mptcp: read attributes of addr entries managed by userspace PMs")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <geliang.tang@linux.dev>
Reviewed-by: Mat Martineau <martineau@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -130,10 +130,21 @@ int mptcp_userspace_pm_get_flags_and_ifi
 int mptcp_userspace_pm_get_local_id(struct mptcp_sock *msk,
 				    struct mptcp_addr_info *skc)
 {
-	struct mptcp_pm_addr_entry new_entry;
+	struct mptcp_pm_addr_entry *entry = NULL, *e, new_entry;
 	__be16 msk_sport =  ((struct inet_sock *)
 			     inet_sk((struct sock *)msk))->inet_sport;
 
+	spin_lock_bh(&msk->pm.lock);
+	list_for_each_entry(e, &msk->pm.userspace_pm_local_addr_list, list) {
+		if (mptcp_addresses_equal(&e->addr, skc, false)) {
+			entry = e;
+			break;
+		}
+	}
+	spin_unlock_bh(&msk->pm.lock);
+	if (entry)
+		return entry->addr.id;
+
 	memset(&new_entry, 0, sizeof(struct mptcp_pm_addr_entry));
 	new_entry.addr = *skc;
 	new_entry.addr.id = 0;


