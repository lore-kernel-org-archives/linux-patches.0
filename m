Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB8F214409;
	Tue, 12 Nov 2024 10:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408461; cv=none; b=ZNH3u7wD7cn46BE0o5HFordw/93+Crs0Scp4OPmtGCQZgOJMSFunjkn/CPUP1sl20TsyvD6AZY8hT2Kmq/9EMY+mJrhzYjk7FA2ucBMcsKqBwwaq7OubK7zhhZw69c4DT7eqnvDZ1u82KI8zNCeJkVW/Ri/79VrsVdhxxB/t7oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408461; c=relaxed/simple;
	bh=OfOFZTRqIL/Hz/w01aOETAsyGNkFpfCpmN6a21sYzYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdWYpFwHOgCygvwwr4MAbA/5U/4G5Yl4tcOqtx8TbU8/AmHEoMhQxYpexm2sqSIrwyaGt16zN7bIPDQQorAYdxEGtgTIIvyVyYKg63XbMPJJU8QzA/lTq6bI/MP82GsrqcaHKPBjrorh3pCuVOxZYR/lU4GJj5oGsh0xt8pbzaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PeTGFKCc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeTGFKCc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF62C4CECD;
	Tue, 12 Nov 2024 10:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408461;
	bh=OfOFZTRqIL/Hz/w01aOETAsyGNkFpfCpmN6a21sYzYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeTGFKCc0DXLDunAFMC1WH4p1QEpXW1bkGWzPuD8d/7qYfzK1ceBs3EbQW8GGGtpl
	 aN6lzvuBKlXJtvwKlNX9Vz+1zs1u1G5exTiv41HL+59Cq7fDp/RzSe0m05hYmKJ6pc
	 aX4nz9xp8pNShz7NoXapilqWggTKqZKmNZrWVb4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.11 128/184] mptcp: use sock_kfree_s instead of kfree
Date: Tue, 12 Nov 2024 11:21:26 +0100
Message-ID: <20241112101905.778647701@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geliang Tang <tanggeliang@kylinos.cn>

commit 99635c91fb8b860a6404b9bc8b769df7bdaa2ae3 upstream.

The local address entries on userspace_pm_local_addr_list are allocated
by sock_kmalloc().

It's then required to use sock_kfree_s() instead of kfree() to free
these entries in order to adjust the allocated size on the sk side.

Fixes: 24430f8bf516 ("mptcp: add address into userspace pm list")
Cc: stable@vger.kernel.org
Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20241104-net-mptcp-misc-6-12-v1-2-c13f2ff1656f@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mptcp/pm_userspace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -91,6 +91,7 @@ static int mptcp_userspace_pm_delete_loc
 						struct mptcp_pm_addr_entry *addr)
 {
 	struct mptcp_pm_addr_entry *entry, *tmp;
+	struct sock *sk = (struct sock *)msk;
 
 	list_for_each_entry_safe(entry, tmp, &msk->pm.userspace_pm_local_addr_list, list) {
 		if (mptcp_addresses_equal(&entry->addr, &addr->addr, false)) {
@@ -98,7 +99,7 @@ static int mptcp_userspace_pm_delete_loc
 			 * be used multiple times (e.g. fullmesh mode).
 			 */
 			list_del_rcu(&entry->list);
-			kfree(entry);
+			sock_kfree_s(sk, entry, sizeof(*entry));
 			msk->pm.local_addr_used--;
 			return 0;
 		}


