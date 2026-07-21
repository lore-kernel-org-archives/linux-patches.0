Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 098A8441035;
	Tue, 21 Jul 2026 22:48:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674104; cv=none; b=JSQKttWVRKJDye1Q425/YBDJQ354y17hwiN01usBv4d/r0KibUXafAHEllRs78/rYGvFQbdLph2VCS0c7yDaJNr7undXvZv9+Vzki66shPs/OU2LKi5ovAghBFzdNc9UrVzANpRmB3FVXojYNIg22oL0PtVKJVZCPMFSJSUjqAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674104; c=relaxed/simple;
	bh=xztZMgZmP4/nmxQK5XAA8hboz7XHZYxTNDQbAO7NkdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=osNbHXrJy5MjNS4DKAKfgMGw7d6271vWYpaNP1z5Ichwf+6woR8EtafA91hZkQR6HhlBB/JiIxn8n+JJoIgO/yaOSACbX7c6z1dGdQmvi5JivG48KtYnt/C1Pj9lvvpe1l+Ge5pHUvuPdHfs2I1YQ1ZEcmeRrYBwYgjUqxAEne8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jKzanXff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jKzanXff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAAF91F00A3D;
	Tue, 21 Jul 2026 22:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674091;
	bh=d4IT+TkvJRGQSCs72LoAK/xVomSocglZYeujaAB4Pow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKzanXffNsTVWI3l5RoHgpGBYzACIyVW61sRiQ0AP9u4/I0FMLZMA9QZDK+w87Ph6
	 DgR3pb2pvzAvu78kILKY4mntGkfXH2el38XtbnhkjgkPSP6sRDJThl6x9XnSlUdJ1l
	 xc7EhSSgFRvQ7pEYAUSZ6FHvFnBLq+g/DMkflqk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 357/699] ipv4: fib: Dont ignore error route in local/main tables.
Date: Tue, 21 Jul 2026 17:21:56 +0200
Message-ID: <20260721152403.745161537@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d3cb34c7abc5d..d01aa665512e55 100644
--- a/include/net/ip_fib.h
+++ b/include/net/ip_fib.h
@@ -365,7 +365,7 @@ static inline int fib_lookup(struct net *net, struct flowi4 *flp,
 			     struct fib_result *res, unsigned int flags)
 {
 	struct fib_table *tb;
-	int err = -ENETUNREACH;
+	int err = -EAGAIN;
 
 	flags |= FIB_LOOKUP_NOREF;
 	if (net->ipv4.fib_has_custom_rules)
@@ -379,17 +379,16 @@ static inline int fib_lookup(struct net *net, struct flowi4 *flp,
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



