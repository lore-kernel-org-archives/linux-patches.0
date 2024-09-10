Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B25218B462;
	Tue, 10 Sep 2024 10:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964476; cv=none; b=H9cazLvPAxKQQLgrAzpwE41kCLfF3b7SgT4tfF2sa1zVv6pOral11vsy8vXZi0/uQNUQ4F6uqODoFXLhokJz1q/0XD7oGMB6fJwJ/CYALRELpjM9bj+8GWdR7FGs5Q1jKcMC6D9ZRm9LlnlrIHH+QmERQSHPGKIDVOlrtMzQ/38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964476; c=relaxed/simple;
	bh=tLXxtWgc1TYnMrOhG+UfGo9ZGYmbrR80MIqWX/kFuoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nIL0CqRT9LJXIidmt6hIq4/o2K9zCehC6JmROuwgRwHaNzCTthJHJDRAgEYNUN60DtiFLUgnHwpmzr06CrHpBQd5pgLyp5Y1Zt54kuM6h9rWSRfMqNinhAomGgqZQC4xgQRMr+4Ryllvzqa6l9iZTuDr0DY4z2diADKva4+MZgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cUIFxP1J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cUIFxP1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DC8C4CEC3;
	Tue, 10 Sep 2024 10:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964475;
	bh=tLXxtWgc1TYnMrOhG+UfGo9ZGYmbrR80MIqWX/kFuoU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cUIFxP1JrRMT8fL2ZEY8ZIoUIGPF39mGcMX6zipYcuW+y5ThGcK8PQBoej1K/HeSF
	 EZFAT/X64lf8njSzBWbBKB+D51+tHGmVbi6FYF6+Hd5H1iyi4c/39e8fVWlmKZK75f
	 0stwVzT1QNSC88hLuiFnYW0Kxo/xWlq+wXeYj/h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/269] NFSv4: Add missing rescheduling points in nfs_client_return_marked_delegations
Date: Tue, 10 Sep 2024 11:33:02 +0200
Message-ID: <20240910092615.060678437@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0d6473cb00cb..f63513e477c5 100644
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
@@ -223,6 +224,7 @@ static int __nfs_list_for_each_server(struct list_head *head,
 		ret = fn(server, data);
 		if (ret)
 			goto out;
+		cond_resched();
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-- 
2.43.0



