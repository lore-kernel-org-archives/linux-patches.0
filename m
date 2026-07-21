Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205F144AB70;
	Tue, 21 Jul 2026 21:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669613; cv=none; b=TaPCOAuMqSaHB7kReStrDOv3YoDNipzVYTDAJjBl6Hg4JRZmZfTNvMBZV3GGu18TkOhWZn9+Po22tRa/avvHImjwULLW45kTYFC2PeTwy+zWy/6X+6RSEIbeLeQjquAUmN6cq8BlHAxE+7/mj9iimCuELEX3SFy7JH6BNOhg87g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669613; c=relaxed/simple;
	bh=VyKalTmDfQC58Vi8KSrD8rzRow6SXxWk9/RA6zF8hWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QqMEZcGYGnyadUJFicIILkzTVjhSx1mw1TWGJ/SU6aFTYNOkz7ms2mFLKCuupkXEokJiI+esEMfCgKgHCzCEvzANFnf/FxEwA23jKCAIoRuytYmaTYGR/d2X2xz8Lsww9vppK3o+pbx9p/zKCWU2qaxXGZ9c6f45MfnAdnKolUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yWzxg2IF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yWzxg2IF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DB81F000E9;
	Tue, 21 Jul 2026 21:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669610;
	bh=1GDZIhGZ5PsQp0Doz7oYGDcfot3g/zoa12DboKhW0Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yWzxg2IFljJ16rWaNMFBweF/Cs54Ab12ZN4a4OD3ztipbt8uHF9cZQvzbQ8BfklWH
	 kE3dixFSYpGOYQbWl1X9hHQxTBtTN52cvommIFHMqBBn0ha/C3wI5N8aLOZ3rE1xPh
	 kO/iLilMXJ6ZH/cglnqEwjHaf43GASIr1V5tjbdQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0621/1067] ipv4: fib: Dont ignore error route in local/main tables.
Date: Tue, 21 Jul 2026 17:20:22 +0200
Message-ID: <20260721152438.492060169@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit b72f0db64205d9ce462038ba995d5d31eff32dc1 ]

When CONFIG_IP_MULTIPLE_TABLES is enabled but no rule is added,
fib_lookup() performs route lookup directly on two tables.

Since the first lookup does not properly bail out, the result
of an error route in the merged local/main table could be
overwritten by another route in the default table:

  # unshare -n
  # ip link set lo up
  # ip route add 192.168.0.0/24 dev lo table 253
  # ip route add unreachable 192.168.0.0/24
  # ip route get 192.168.0.1
  192.168.0.1 dev lo table default uid 0
      cache <local>

Once a random rule is added, the error route is respected:

  # ip rule add table 0
  # ip rule del table 0
  # ip route get 192.168.0.1
  RTNETLINK answers: No route to host

Let's fix the inconsistent behaviour.

Fixes: f4530fa574df ("ipv4: Avoid overhead when no custom FIB rules are installed.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260619212753.3367244-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_fib.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/net/ip_fib.h b/include/net/ip_fib.h
index ca1700c2a5733b..b6fc9924ef7a0b 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -370,7 +370,7 @@ static inline int fib_lookup(struct net *net, struct flowi4 *flp,
 			     struct fib_result *res, unsigned int flags)
 {
 	struct fib_table *tb;
-	int err = -ENETUNREACH;
+	int err = -EAGAIN;
 
 	flags |= FIB_LOOKUP_NOREF;
 	if (net->ipv4.fib_has_custom_rules)
@@ -384,17 +384,16 @@ static inline int fib_lookup(struct net *net, struct flowi4 *flp,
 	if (tb)
 		err = fib_table_lookup(tb, flp, res, flags);
 
-	if (!err)
+	if (err != -EAGAIN)
 		goto out;
 
 	tb = rcu_dereference_rtnl(net->ipv4.fib_default);
 	if (tb)
 		err = fib_table_lookup(tb, flp, res, flags);
 
-out:
 	if (err == -EAGAIN)
 		err = -ENETUNREACH;
-
+out:
 	rcu_read_unlock();
 
 	return err;
-- 
2.53.0



