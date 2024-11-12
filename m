Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067F3214415;
	Tue, 12 Nov 2024 10:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407430; cv=none; b=K84KyPEcdEiCRffamPZyKksGCB0yG+H93CAA2T1B3d9VXinSEwiBuMMjGQ5fA712oNBgu4Yd56/x+wIRdoSPgT57kUm+4xH46S2K5YGGQZ1HHRxOjODjL4uzM2LPJ3V25d8m8WECb30NijTIv8YTtWiTxa+4A9I4zUYnTiwV0ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407430; c=relaxed/simple;
	bh=0M5fTNfhzjJ98wYkcBuzoKyKIGyT514qjGeMcoLqzKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WHo1RnojZlRmZw8+TEk8Z48Fr7ocXiFQUC3GcSTGWEjHRv6J/MCO6SG1hDnxIjtzTVU+AN09rroYjGPq8wkNJjMyccjjZvOnOe0HG8whZXb7LCWqrhop8R9V4DV/CLIs6MLApM+0lvIPsekYdGDtGUXgLV+desLnzAGkWOKHTx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dpgSmZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dpgSmZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6402BC4CECD;
	Tue, 12 Nov 2024 10:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407429;
	bh=0M5fTNfhzjJ98wYkcBuzoKyKIGyT514qjGeMcoLqzKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1dpgSmZbNG6w0fP1lxAtMZnHnoN9w7FkFolkg2JuegonrCaCLrZY3Zo187ITPTgOv
	 WVQCrbnOeivYocFN1kgfF0cYMXLweZ93gEWUY8lGqj/AIUHiLIt80S9ZP85exCH0GJ
	 9Lz8VTZkHqCfofdDbDjFl7d3gDW917kd4lFr7pJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 72/98] mptcp: use sock_kfree_s instead of kfree
Date: Tue, 12 Nov 2024 11:21:27 +0100
Message-ID: <20241112101846.999266605@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -89,6 +89,7 @@ static int mptcp_userspace_pm_delete_loc
 						struct mptcp_pm_addr_entry *addr)
 {
 	struct mptcp_pm_addr_entry *entry, *tmp;
+	struct sock *sk = (struct sock *)msk;
 
 	list_for_each_entry_safe(entry, tmp, &msk->pm.userspace_pm_local_addr_list, list) {
 		if (mptcp_addresses_equal(&entry->addr, &addr->addr, false)) {
@@ -96,7 +97,7 @@ static int mptcp_userspace_pm_delete_loc
 			 * be used multiple times (e.g. fullmesh mode).
 			 */
 			list_del_rcu(&entry->list);
-			kfree(entry);
+			sock_kfree_s(sk, entry, sizeof(*entry));
 			msk->pm.local_addr_used--;
 			return 0;
 		}


