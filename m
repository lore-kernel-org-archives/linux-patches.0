Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D54192581;
	Tue, 10 Sep 2024 10:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962699; cv=none; b=Hs22GLaL+gpeenLIhKFpT97CarxyjMkEsJiwBGBGXxiE08bFUQFS7ZSSQRw4VcKNeTWuZrKeKiRxHhZsk6AM02Vl60pl8zqNYDKBdl5OaqGRRD3Ug5soXn4r0H1VfcEjj4RuKUarj6fRUMKzxAX6FiQbw58l1D0fGERDwP8843U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962699; c=relaxed/simple;
	bh=tAPfoqS4TtI5qJjxu/6jrIfOZzIvcfKjxWD5mx/T//M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOvEp9uujZkde0FuwrMYQaHjfkGiaWDCzhyPkT5BIAKkCbPS+oIfXPF7V2WTXlYF812duaBFzYaUpw1RyeP6GcGMGBE4uI05KE0UjGAyijUCvFiES0/BdytXTehdFHX1TINJitplX1ILTt1IBnIlj/83KdXeJQGR2Y0N0sjTHdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qjv/Y84v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qjv/Y84v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2BCEC4CEC3;
	Tue, 10 Sep 2024 10:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962699;
	bh=tAPfoqS4TtI5qJjxu/6jrIfOZzIvcfKjxWD5mx/T//M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qjv/Y84v3lLnYJCKZ8xw5dVTuZVlY08dYZbpVu2qvzSl3wl6yj3yLiTytD2CXKZJ5
	 nhH2BYQ+XqlM4DMr+jpFJUvzKYzH2jEKTpnKFae6ZRTfXKgQw0RfKwMq1ZBlPzk4xJ
	 8lzkHMoFdHKOm9Fo/PPHIqNhvSDiNmAlvynB3cGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/121] NFSv4: Add missing rescheduling points in nfs_client_return_marked_delegations
Date: Tue, 10 Sep 2024 11:32:49 +0200
Message-ID: <20240910092550.312265443@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index c7ca8cdc8801..98fbd2c5d7b7 100644
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
@@ -454,6 +455,7 @@ static int __nfs_list_for_each_server(struct list_head *head,
 		ret = fn(server, data);
 		if (ret)
 			goto out;
+		cond_resched();
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.43.0



