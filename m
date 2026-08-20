Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F42B484226;
	Thu, 20 Aug 2026 17:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787248370; cv=none; b=M5GKjpBDF/gf2rCytFJtvQScdMdL5Y5BzErgYhOUyl1vpLJc7S30lTV99SvpGeYHvGsputmjuloZt4nVdsxE/mtYP9Tua4mYIVXmtlU97BC8xszhy6XgjU6alfvDz+I1Icfm4R3PPFJ9K+L4dED7pz4SOLsoLvfdI4GyaX0lHHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787248370; c=relaxed/simple;
	bh=peDJPA01hoMlOT1havBNCAcTP0+wx2d7z0t0UoT9Ies=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOBiu51I31eTd5hTSBHYhSOjnE99xynE/q6SvIf/+CbiWu7HQf8npjZQZmxLpc/bm8V/sQ0YM/ZdH7Q1znBTESnznuQ/VI1SdGLT2XaYG/VgQdTS8F16Rxbn9nEL5NJfQ0HG59GEHRTuZbkW3lsXs3xwT2XatnIBjp1TfzDdbSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=apRCRocc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="apRCRocc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB10E1F000E9;
	Thu, 20 Aug 2026 17:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787248369;
	bh=BU+qtB86zEvY9PBtFZXRojvNHfqZDpFKBhtIMd+/uQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=apRCRoccfhxvJekbt+wx/h8li6r4oXiZGkjF3NEKMQH7aXKXlA4PoKuRBUGWZ3exH
	 bYHjEfqysiIvNa+l9YSOMbjet/JvSXM7R1KnalS0Smqtn9NcAq9a1ALut+QvOhXpFz
	 bVz6T3t7EhKyvw4EelDWf+MiuIZFQfU9Q07SBIuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Geliang Tang <tanggeliang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/303] mptcp: pm: avoid code duplication to lookup endp
Date: Thu, 20 Aug 2026 16:55:41 +0200
Message-ID: <20260820145259.550906149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1266,17 +1266,13 @@ int mptcp_pm_nl_get_local_id(struct mptc
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
@@ -1303,15 +1299,11 @@ bool mptcp_pm_nl_is_backup(struct mptcp_
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


