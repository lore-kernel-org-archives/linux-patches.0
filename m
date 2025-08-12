Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1FE2F5E;
	Tue, 12 Aug 2025 18:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022408; cv=none; b=E1eFoMvDBKMQfdzOKkPR80dmyuFohBLdyTBFiSmPJ2yPEFtlVWGlRpQRcJb5Epun4LND4PJxd2rdSON04bvQAEWbUbhF80phREf6JZFfFY0hd0huT2X/ejSw3OgNqug+jGWCnG6mmqhuVxVS82NDjoTbhB++8uSa0Z2vZ47zXIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022408; c=relaxed/simple;
	bh=1j/jHx+lscc47wRACWLwPFsWXSfB3RbPi+og7U7Srig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GkiaWPNvzOmCZmPNMcEZY+O20Dz5MPC72CaxFmLklnhI/bnzilMT4uMEmF+134r2+l31fkwLlVzkH4D1A69zL/dCp8QNf9B9Ot6Dnviq+ZIYActfIwi1RhWQ5ZutXSQOuHMKzvfmLn5aivXYwTpCQbGm5GJ4S5494kSc/6wDh1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sao1t3Hq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sao1t3Hq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BCE4C4CEF1;
	Tue, 12 Aug 2025 18:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022407;
	bh=1j/jHx+lscc47wRACWLwPFsWXSfB3RbPi+og7U7Srig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sao1t3Hq6fHcPj0k26QMzHoAQ2cWd8th9sUiPRmP3PcOREI86CJzIEZ9In52Iylh/
	 SSfbRkT6H+UIc7CE0dgDwkvcH2z1AO1qWHMIGTUVfSftSF2zhJ/fi0V8lg3T6PqgNX
	 pWR6cob6//PStZREQ75/ZY7nG6m3ARc28dBkwuRg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/369] ipv6: fix possible infinite loop in fib6_info_uses_dev()
Date: Tue, 12 Aug 2025 19:27:24 +0200
Message-ID: <20250812173020.314858838@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f8d8ce1b515a0a6af72b30502670a406cfb75073 ]

fib6_info_uses_dev() seems to rely on RCU without an explicit
protection.

Like the prior fix in rt6_nlmsg_size(),
we need to make sure fib6_del_route() or fib6_add_rt2node()
have not removed the anchor from the list, or we risk an infinite loop.

Fixes: d9ccb18f83ea ("ipv6: Fix soft lockups in fib6_select_path under high next hop churn")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250725140725.3626540-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index f1e64c1cc49b..8b84ed926cd1 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5875,16 +5875,21 @@ static bool fib6_info_uses_dev(const struct fib6_info *f6i,
 	if (f6i->fib6_nh->fib_nh_dev == dev)
 		return true;
 
-	if (f6i->fib6_nsiblings) {
-		struct fib6_info *sibling, *next_sibling;
+	if (READ_ONCE(f6i->fib6_nsiblings)) {
+		const struct fib6_info *sibling;
 
-		list_for_each_entry_safe(sibling, next_sibling,
-					 &f6i->fib6_siblings, fib6_siblings) {
-			if (sibling->fib6_nh->fib_nh_dev == dev)
+		rcu_read_lock();
+		list_for_each_entry_rcu(sibling, &f6i->fib6_siblings,
+					fib6_siblings) {
+			if (sibling->fib6_nh->fib_nh_dev == dev) {
+				rcu_read_unlock();
 				return true;
+			}
+			if (!READ_ONCE(f6i->fib6_nsiblings))
+				break;
 		}
+		rcu_read_unlock();
 	}
-
 	return false;
 }
 
-- 
2.39.5



