Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436842D8364;
	Sat, 12 Sep 2026 16:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229465; cv=none; b=i9FJirv2ySM1fiR02MDB0g/bex18K2YT4S8MPLhAPnVMixD5MCuSS5mNte0fdq/9zeNOxtXzgB9CvRnoUBGFHNo1aONGj37W98wxpOEd+pCEN9mm+YiN2FKtTcGQuJ4CsOfUXG5zO+dbSzhu3gzWn/QvEps639+DOZr+pxVmpLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229465; c=relaxed/simple;
	bh=jMSgQ5FykM4lcTKZnMV6HHY6v5afm2mhrdIGmYTyXxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PT9UtRMiRpcbEmu6NVbfrtJAuWo9268qJ2S1ta6MUNcPWgcBfZlCR6TSjEDFHWsYwqU+YntvMUqZ7xVmkYin03Mr/5kBTLZbFMygeZGo8UsQuLAD9aHVQsW6qL4lNab6XTdyAnxjA8VWBEfSsxnkTZragWy104OM6lg/tORkjLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqzGLTlB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqzGLTlB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13501F000FF;
	Sat, 12 Sep 2026 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229464;
	bh=AjQTzxfDVxpjbfBQHOR8TUloA5429mRXi4qJIpFhmNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LqzGLTlBoRkjrIO1ORpQVZwx1ue5ztdbFktMHG46B/a0lsraCfFk1wOuSHy0WvTw4
	 klLVlZjARpNuM5XBFzpTqtzTthlerqY4QGEtpVNzufeZN2LxKWhnFwpkzwhmwnWvla
	 sUzcfwCck7jWetqQahrWfVMkXEYNrl4Q85WZZzvg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0593/1191] RDMA/core: Wait for RCU callbacks before unloading ib_core
Date: Sat, 12 Sep 2026 08:55:21 +0200
Message-ID: <20260912065601.565754903@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 7d75592114d1664623c8cf191a12b38052c04483 ]

put_gid_ndev() is queued with call_rcu() and implemented in ib_core.
Stopping the workqueues does not drain callbacks already queued, so RCU
could invoke it after the module code has been unloaded.

synchronize_rcu() does not wait for callbacks. Wait for them after all
producers have stopped.

Fixes: 943bd984b108 ("RDMA/core: Allow detaching gid attribute netdevice for RoCE")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/linux-rdma/20260708092316.Qb39F_B0@linutronix.de/
Link: https://patch.msgid.link/20260709-unload-rcu-v1-1-fccd27211e5a@nvidia.com
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 6572741c12bb0..ec391287d61d4 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2918,6 +2918,7 @@ static void __exit ib_core_cleanup(void)
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
 	destroy_workqueue(ib_unreg_wq);
+	rcu_barrier();
 	WARN_ON(!xa_empty(&clients));
 	WARN_ON(!xa_empty(&devices));
 }
-- 
2.53.0



