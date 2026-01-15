Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E453C1FFF;
	Thu, 15 Jan 2026 17:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499616; cv=none; b=C8lFKab5rvtXZO7r6XfiwvQq1QYdSgrLcH7sz4zokfDz11s115dSt2wInu0vbEotSR7hDCb4nA+64LWCfaiwhUdTs6uuXt1JRuC8TMIUrMmGNffVS5TWlyJ2ZfdITuICzu3m+dxo1FOZAkOtz9E5QlJ0qhVDFT/axfPbpCRy0AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499616; c=relaxed/simple;
	bh=I2PZBRz+89nyP7c1xOzoaEFl4qV5BkhIIYWUftJWmuI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ppg/yAOP8fadfFExwAzrca01nvgsMLPoPJ9SUNnvMFNuzg6vy2huNAJ4hdOa4G0cmfT1n0VusE459q12y5W2A+4cUCw21cn4G9VjjUDZEJik9B5dOyMMUrPQPXc3nM/BW+iHQxDO93e45/XPm+XZuSG2fejURiEVSwhke0DpPew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o59XkT3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o59XkT3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39060C116D0;
	Thu, 15 Jan 2026 17:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499616;
	bh=I2PZBRz+89nyP7c1xOzoaEFl4qV5BkhIIYWUftJWmuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o59XkT3pnw6FTPpZ4xRkCBAJEITKhVeNGckmucVyjXPfaBmNynCtSdhpL5y0jRz5J
	 EgKzgxXO1lFiIHgAfbiLf0votsEkdelCGOAnPoGAve5xw/LvnpDJG999/DhiE8EQmi
	 pX4iZ6gXTK0eU138Ke2uaDL0dblSq+CxrdF9l3yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com,
	Ido Schimmel <idosch@nvidia.com>,
	David Ahern <dsahern@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 289/451] ipv4: Fix reference count leak when using error routes with nexthop objects
Date: Thu, 15 Jan 2026 17:48:10 +0100
Message-ID: <20260115164241.337395549@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit ac782f4e3bfcde145b8a7f8af31d9422d94d172a ]

When a nexthop object is deleted, it is marked as dead and then
fib_table_flush() is called to flush all the routes that are using the
dead nexthop.

The current logic in fib_table_flush() is to only flush error routes
(e.g., blackhole) when it is called as part of network namespace
dismantle (i.e., with flush_all=true). Therefore, error routes are not
flushed when their nexthop object is deleted:

 # ip link add name dummy1 up type dummy
 # ip nexthop add id 1 dev dummy1
 # ip route add 198.51.100.1/32 nhid 1
 # ip route add blackhole 198.51.100.2/32 nhid 1
 # ip nexthop del id 1
 # ip route show
 blackhole 198.51.100.2 nhid 1 dev dummy1

As such, they keep holding a reference on the nexthop object which in
turn holds a reference on the nexthop device, resulting in a reference
count leak:

 # ip link del dev dummy1
 [   70.516258] unregister_netdevice: waiting for dummy1 to become free. Usage count = 2

Fix by flushing error routes when their nexthop is marked as dead.

IPv6 does not suffer from this problem.

Fixes: 493ced1ac47c ("ipv4: Allow routes to use nexthop objects")
Reported-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Closes: https://lore.kernel.org/netdev/d943f806-4da6-4970-ac28-b9373b0e63ac@I-love.SAKURA.ne.jp/
Reported-by: syzbot+881d65229ca4f9ae8c84@syzkaller.appspotmail.com
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20251221144829.197694-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/fib_trie.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 6c53381fa36f..671178ed41d0 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2005,10 +2005,11 @@ int fib_table_flush(struct net *net, struct fib_table *tb, bool flush_all)
 				continue;
 			}
 
-			/* Do not flush error routes if network namespace is
-			 * not being dismantled
+			/* When not flushing the entire table, skip error
+			 * routes that are not marked for deletion.
 			 */
-			if (!flush_all && fib_props[fa->fa_type].error) {
+			if (!flush_all && fib_props[fa->fa_type].error &&
+			    !(fi->fib_flags & RTNH_F_DEAD)) {
 				slen = fa->fa_slen;
 				continue;
 			}
-- 
2.51.0



