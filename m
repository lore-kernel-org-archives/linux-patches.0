Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B38F13792B;
	Thu, 12 Dec 2024 17:02:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022957; cv=none; b=cef2tNqOxOLfskXnx3DhycL4y+30b1FDPuds/eMugYRcjqZIW4o2KfE6payH7dikGMZcEAgiKdZaw/3ypaSuciMAzihZp8f3qYVougbnJmwGKybT6FxPVw3H9nxA+mqRl0iLLqtmrzTYLbV66K5xCFkYnjZ6nxexyopolTdLy/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022957; c=relaxed/simple;
	bh=l3o+5BO4M/vML0IHN6VX+Juprc7RntmRwtDMoQ9ZDiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hKUDmBehEa3bJeyDA/+Ec4euS2Vttlvj8D870Uck0WTJheSPOqykXWnBhUcHc5UrxteHrgHcTRTnH/yiAom+eKw72ZIsXNuvZEgzwvNEPKxg1H+ENSxbjgSsV5cxokDJiySarXMwkKx80p+ycwKR1ie/sRD85fDkKlOMSBHwr8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAe+valL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAe+valL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6677C4CECE;
	Thu, 12 Dec 2024 17:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022957;
	bh=l3o+5BO4M/vML0IHN6VX+Juprc7RntmRwtDMoQ9ZDiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAe+valLYUJ+Gb4q+Iz5vN/3AnkpjKGHR2bBoTVwAJTxeJr7GgVHBJcjgQrB4FsPD
	 m4ZCfHpprLH+/sAs711qARsRb0QrnooX6uM3g4AK2YKgNXDtBz6e6H+hiWnYLHXLOi
	 ztC0y+aKcjjXTwBwKWQv3ClE/y6PpILw2hH8D7oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Erkun <yangerkun@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 352/565] SUNRPC: make sure cache entry active before cache_show
Date: Thu, 12 Dec 2024 15:59:07 +0100
Message-ID: <20241212144325.515118252@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Erkun <yangerkun@huawei.com>

commit 2862eee078a4d2d1f584e7f24fa50dddfa5f3471 upstream.

The function `c_show` was called with protection from RCU. This only
ensures that `cp` will not be freed. Therefore, the reference count for
`cp` can drop to zero, which will trigger a refcount use-after-free
warning when `cache_get` is called. To resolve this issue, use
`cache_get_rcu` to ensure that `cp` remains active.

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: CPU: 7 PID: 822 at lib/refcount.c:25
refcount_warn_saturate+0xb1/0x120
CPU: 7 UID: 0 PID: 822 Comm: cat Not tainted 6.12.0-rc3+ #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
1.16.1-2.fc37 04/01/2014
RIP: 0010:refcount_warn_saturate+0xb1/0x120

Call Trace:
 <TASK>
 c_show+0x2fc/0x380 [sunrpc]
 seq_read_iter+0x589/0x770
 seq_read+0x1e5/0x270
 proc_reg_read+0xe1/0x140
 vfs_read+0x125/0x530
 ksys_read+0xc1/0x160
 do_syscall_64+0x5f/0x170
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Cc: stable@vger.kernel.org # v4.20+
Signed-off-by: Yang Erkun <yangerkun@huawei.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/cache.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1415,7 +1415,9 @@ static int c_show(struct seq_file *m, vo
 		seq_printf(m, "# expiry=%lld refcnt=%d flags=%lx\n",
 			   convert_to_wallclock(cp->expiry_time),
 			   kref_read(&cp->ref), cp->flags);
-	cache_get(cp);
+	if (!cache_get_rcu(cp))
+		return 0;
+
 	if (cache_check(cd, cp, NULL))
 		/* cache_check does a cache_put on failure */
 		seq_puts(m, "# ");


