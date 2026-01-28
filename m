Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3520A36B07E;
	Wed, 28 Jan 2026 15:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769613905; cv=none; b=Z9/OrfJmbNDor9JWBGAedLMzWIhcjDcbxIsX+pKzw7HIw7v8clWW2Ky4C/i1VqattUWpUliRAA5psxmjJ2GHGmmW8t1QHGD9SPQy7p7hfk+9661TxOtJE9QgRvVol/tHWKF1k7xWWZxX+iorWze8EsGwj7nUOZ6j9YGeeOMo8ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769613905; c=relaxed/simple;
	bh=BR+Wx4ao0wKj0e6YFWccv5eSM5WhwWPVYk6bOVfWUFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frg7OV6Jc7pgvhsbepHPpOgOyUBtLpsV8xiE0eEjnX6VOz6iETdpoIvbQ5jskS94+t32/6xreLXp0sRcvfZJHzcGKF6T3DLX/Zuj6vlrUR9OhHihZdLnGGslvZx599cJpVyMV8MOFDZpvVpJ9hwV5CyTOgPq+Exm42qlToBga4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yRXd/rki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRXd/rki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 609EEC4CEF1;
	Wed, 28 Jan 2026 15:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769613904;
	bh=BR+Wx4ao0wKj0e6YFWccv5eSM5WhwWPVYk6bOVfWUFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRXd/rkiRsMRPwo+OWtCxfGkKM22ut/D0O7viVEbecX9lQ3QT7CPc8wSR03aixAnS
	 mFy0iDJ+6RmQulF7Jwg7XaIbrHaD6BNfqgpygkx41qMUftE8+cqvxtjTQ6HayRbEbr
	 KSON81q9hlDLA3UyG0HMNPpO2daQf7GOsWlM/K/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Johannes Nixdorf <jnixdorf-oss@avm.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/254] net: bridge: Set BR_FDB_ADDED_BY_USER early in fdb_add_entry
Date: Wed, 28 Jan 2026 16:19:47 +0100
Message-ID: <20260128145345.112399934@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Nixdorf <jnixdorf-oss@avm.de>

[ Upstream commit cbf51acbc5d50341290c79c97bda8cf46f5c4f22 ]

In preparation of the following fdb limit for dynamically learned entries,
allow fdb_create to detect that the entry was added by the user. This
way it can skip applying the limit in this case.

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Johannes Nixdorf <jnixdorf-oss@avm.de>
Link: https://lore.kernel.org/r/20231016-fdb_limit-v5-1-32cddff87758@avm.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b25a0b4a2193 ("net: bridge: annotate data-races around fdb->{updated,used}")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_fdb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
index a6d8cd9a58078..91903076d30bd 100644
--- a/net/bridge/br_fdb.c
+++ b/net/bridge/br_fdb.c
@@ -1056,7 +1056,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 		if (!(flags & NLM_F_CREATE))
 			return -ENOENT;
 
-		fdb = fdb_create(br, source, addr, vid, 0);
+		fdb = fdb_create(br, source, addr, vid,
+				 BIT(BR_FDB_ADDED_BY_USER));
 		if (!fdb)
 			return -ENOMEM;
 
@@ -1069,6 +1070,8 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 			WRITE_ONCE(fdb->dst, source);
 			modified = true;
 		}
+
+		set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
 	}
 
 	if (fdb_to_nud(br, fdb) != state) {
@@ -1100,8 +1103,6 @@ static int fdb_add_entry(struct net_bridge *br, struct net_bridge_port *source,
 	if (fdb_handle_notify(fdb, notify))
 		modified = true;
 
-	set_bit(BR_FDB_ADDED_BY_USER, &fdb->flags);
-
 	fdb->used = jiffies;
 	if (modified) {
 		if (refresh)
-- 
2.51.0



