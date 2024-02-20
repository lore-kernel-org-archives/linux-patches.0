Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765571509BF;
	Tue, 20 Feb 2024 21:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463790; cv=none; b=vAEjQbNyrahVOdSXC+L3tlpUU0Khm03DLhEWqVAZQbI+wE6itdli6PPepHcZkzhjDlgqgLrCXRJE4kshc3zKsBd0wt2oflKtjzR5e2hLLMCZPyoYfxvmPGgkhbUz24FnkJD9sOJaIQii1NX7CxLhAQDBOMzoPxplHt9sR5KbjvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463790; c=relaxed/simple;
	bh=w5wC6cZSzMLLRDqKsjEDA8aXdNc5P6Dm/lXlbBYCP5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Skmr9iet4S5sbqnDzmHgUxS/E/GPfDT7GGFv9jJABt93ODiGpoL7vw9LOAROYv9w0BPui1geHHRVvA3DerQAOFgikwrZQwRz9lW/u47fJg4/AEnYsocCHK2CmJtkjFUMPFnjvbrIcSl5J0auGNOFuLPvKkKSVp/aARemRJ7i/JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmAtoA0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmAtoA0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7970C433F1;
	Tue, 20 Feb 2024 21:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463790;
	bh=w5wC6cZSzMLLRDqKsjEDA8aXdNc5P6Dm/lXlbBYCP5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VmAtoA0q2SCd7LrN8yRAbulymNVnMJ0SLNvfOt2W1yDgrDadmM4o1pwridu98Zsr7
	 +cyAXgknaQtkvD7/cpWI3Z3Gsk8LtZ5KFD8RM0a5h0jIS/MWVN8026FIiLMcYlollt
	 cZcTwUhvnIpkj1FkvgnAfre9lRhuL6YLG9NU4tQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <geliang.tang@linux.dev>,
	Mat Martineau <martineau@kernel.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 114/331] mptcp: check addrs list in userspace_pm_get_local_id
Date: Tue, 20 Feb 2024 21:53:50 +0100
Message-ID: <20240220205641.202746482@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


