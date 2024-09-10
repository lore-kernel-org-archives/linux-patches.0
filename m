Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFED18EFF9;
	Tue, 10 Sep 2024 09:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962052; cv=none; b=gc9PQqHuj5rzLJFZOsa06AEA1l/jSHlkVvaJpPXNOfsAQaSeBUybsUeE5XOAD0r71zUViedijHeUIBolQ0i2+gT6PncZKSX2WGDXoIzPNxLvK1Fn5nGlzivzpbVTGb/YeGb5lf9Z9Nbtom5NUeqkTQt60X5GrONgZ2ArSYxlDXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962052; c=relaxed/simple;
	bh=dtp3Xo1p3wUy/eE+p1AsOIITrQ44uD2BFwQJk0qA334=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGvKjr+pjrA5w75o0ybaw5lJwd3Nt5oUZY9cjWVR1TzRu5+x6ANF3qCoBtJ0oTg6WH4+wpzygTxsm2EgiaCLmksiH3dnThLPLUGUacKPewukGj0m3XWjEEAoTDNiRuUi7iZr6KwjEtMna6FERtQ9q/XtfHpfil/aYp0ycg1YgWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uAeczxi4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uAeczxi4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5D6C4CED4;
	Tue, 10 Sep 2024 09:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962052;
	bh=dtp3Xo1p3wUy/eE+p1AsOIITrQ44uD2BFwQJk0qA334=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uAeczxi4g+IuTT8yY6dDX5afcp2YWYCTno0kW3OK+cgfXEG2QYwqSb0fvZZiv822w
	 R1c5cF2Qcscwc0/0maBX8u6v6f6ZcPi7Wd1wAMfbiDjT2SvchCx/aW2bRl6IyaxJgr
	 IZKE7rYlTBK1OreypYVvXnf3TVycR8vH7oao9Mw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 278/375] NFSv4: Add missing rescheduling points in nfs_client_return_marked_delegations
Date: Tue, 10 Sep 2024 11:31:15 +0200
Message-ID: <20240910092631.896985071@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit a017ad1313fc91bdf235097fd0a02f673fc7bb11 ]

We're seeing reports of soft lockups when iterating through the loops,
so let's add rescheduling points.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index cbbd4866b0b7..97b386032b71 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -47,6 +47,7 @@
 #include <linux/vfs.h>
 #include <linux/inet.h>
 #include <linux/in6.h>
+#include <linux/sched.h>
 #include <linux/slab.h>
 #include <net/ipv6.h>
 #include <linux/netdevice.h>
@@ -228,6 +229,7 @@ static int __nfs_list_for_each_server(struct list_head *head,
 		ret = fn(server, data);
 		if (ret)
 			goto out;
+		cond_resched();
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.43.0



