Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396A5514753;
	Wed, 30 Sep 2026 18:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793037; cv=none; b=I7tayucoB0GEgMwSOIvhiZWydlN+OzUbwpIpxdwnzxkLJmxOk2OhVBRslp4i8Q0E2cgdxrh1xBOj2MBHPcN1z4hPB1mL9vyzNb/qS5EKzyzVfpFYjixmiYAss1qIn42XQLyDQz2psXTMuJYw1yLR5diLJu8cKoHW7y63BrYDtHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793037; c=relaxed/simple;
	bh=RgGpsUYWf2/NJMFxL37VLF9RT5NrkKPed9Kbf0pewKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OmskoPh0CIkpUPFRLpgpmbW4CZ7FQlHQw/a1WrzUCL7X9IQ29HNPIFEo7ZN7gMI4kb3XAsutew+pftOTxM2DYBGGzPxGSwi2ABNxMN9++3cmqObk8Hw/68A1UdW+5EnhosW+JuGLC2XxVjlEgjoUSU7wpnAJ78ly7IKQ6STS+h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Botl992o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Botl992o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9184F1F000FF;
	Wed, 30 Sep 2026 18:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793036;
	bh=q8p3iUgevnD1RwPywUgO+KvJ8Y5Y99Epwnb3DGHnzVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Botl992ozbWeI1ssT0DtQkYQ5trINBvQr1pJR23KjcqFqNcMJPSgydO9FaU2l2bYY
	 Vom5H0uLHSTRy8H7Mi5594TLDRTBTEY05VabJ23w19+lPepSLyWiRoAfGy0z5cq5x6
	 zEzvY+FbqnBCWWSRMyaA6m1GbsI1x3O/IsCYWe5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 112/395] ipv6: Prevent rt6_insert_exception() for dying fib6_info.
Date: Wed, 30 Sep 2026 17:26:14 +0200
Message-ID: <20260930152343.069943569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 0346ec2f080b40d95ed05b853bb9226289e75212 ]

Before the cited commit, fib6_nh_flush_exceptions() always set
from->exception_bucket_flushed = 1 under rt6_exception_lock to
prevent rt6_insert_exception() from inserting a new exception
for a dying fib6_info.

The flag was replaced with the FIB6_EXCEPTION_BUCKET_FLUSHED
bit stored in nh->rt6i_exception_bucket.

The problem is that now the bit is only set when the bucket
is not NULL and fib6_nh_flush_exceptions() is called from
fib6_nh_release() after fib6_ref has already reached zero.

If rt6_insert_exception() is called while the target fib6_info
is being removed via fib6_purge_rt(), a new exception could be
created successfully because rt6_flush_exceptions() no longer
sets the bit.

This creates a reference cycle between the fib6_info and the
exception route, leaking the fib6_info, its nexthop device,
and all per-CPU routes in fib6_nh->rt6i_pcpu, which stalls netdev
unregistration.

[   34.680602] unregister_netdevice: waiting for gre6 to become free. Usage count = 68
[   44.920675] unregister_netdevice: waiting for gre6 to become free. Usage count = 68
[   55.176582] unregister_netdevice: waiting for gre6 to become free. Usage count = 68

Let's call fib6_drop_pcpu_from() before rt6_flush_exceptions(),
to set fib6_destroying before rt6_exception_lock, and check
f6i->fib6_destroying in rt6_insert_exception().

Note that FIB6_EXCEPTION_BUCKET_FLUSHED logic is dead and
we can clean it up in net-next.

Fixes: cc5c073a693f ("ipv6: Move exception bucket to fib6_nh")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260918082209.2853582-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 2 +-
 net/ipv6/route.c   | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 75875e4a1edea..9fc2d2677b747 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1033,8 +1033,8 @@ static void fib6_purge_rt(struct fib6_info *rt, struct fib6_node *fn,
 	struct fib6_table *table = rt->fib6_table;
 
 	/* Flush all cached dst in exception table */
-	rt6_flush_exceptions(rt);
 	fib6_drop_pcpu_from(rt);
+	rt6_flush_exceptions(rt);
 
 	if (rt->nh) {
 		spin_lock(&rt->nh->lock);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 71a38034f5ca8..c71e93e17017e 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1725,6 +1725,11 @@ static int rt6_insert_exception(struct rt6_info *nrt,
 
 	spin_lock_bh(&rt6_exception_lock);
 
+	if (f6i->fib6_destroying) {
+		err = -ENOENT;
+		goto out;
+	}
+
 	bucket = rcu_dereference_protected(nh->rt6i_exception_bucket,
 					  lockdep_is_held(&rt6_exception_lock));
 	if (!bucket) {
-- 
2.53.0



