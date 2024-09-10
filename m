Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85EAC8DF;
	Tue, 10 Sep 2024 10:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965240; cv=none; b=FjmZKv2EW9jaFWsgV+Oa8zlid0OR6b5lme5nBIHUeCPIv1ehlq6HZ7Syc5REzXXlS34tXGpnDQTZ+uRljdCm4DBeAvnLTqzgAFlzi9cSUJOSIL3zg2gBi2qA1TtU6VyG5MDN9OhePzn3xqy39Hj3/27u0XBARj7lrC0YynWPq0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965240; c=relaxed/simple;
	bh=G6bC1TpfODPWXQhJlG2Pnvg9lano0WFHx/jfWVgnR54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JZHAjRBkINBkGrpR7riG2wRXTQFWVFrLVnZcdXaFvy69ZZkuIVw0sxicp454jgkcidaH3WOGXcfPrD53MMi+zcuNUosAJQXVADhASBGd/84HEaNPH2GpXoYwljEI90DtAgtYXnPYJZKjhaCoxYqLiAB8wZHzyKVKI4yOP59RA90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yi8q5B7M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yi8q5B7M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC9CC4CEC3;
	Tue, 10 Sep 2024 10:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965240;
	bh=G6bC1TpfODPWXQhJlG2Pnvg9lano0WFHx/jfWVgnR54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yi8q5B7M8RGnimBOTRffXEJCdD8z/g8C3nqNnf8BOBiQMRbe3SLB0yIlXmrmMuzWL
	 6ezVLwiIgU3C0FmEoqiZoCnPtdu/GH7UVbwzViZ+txCFhzJ5aT6jSvjsbyCGFwYFTM
	 m840YYsp1Bi7dPKAbT/IQIKPN106Jb6Xv+YMDtSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 157/186] NFSv4: Add missing rescheduling points in nfs_client_return_marked_delegations
Date: Tue, 10 Sep 2024 11:34:12 +0200
Message-ID: <20240910092601.071737145@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1ffce9076060..2d2238548a6e 100644
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
@@ -219,6 +220,7 @@ static int __nfs_list_for_each_server(struct list_head *head,
 		ret = fn(server, data);
 		if (ret)
 			goto out;
+		cond_resched();
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.43.0



