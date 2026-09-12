Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90A22F9D82;
	Sat, 12 Sep 2026 07:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198268; cv=none; b=Pw9lRQEaLF2a8nwply9OuTpEhVP//2rBi/1r7kXhiwdUE2HFm2KX6eWKElyg7jUuISIYlUYUeF1rG6GyszJfrLGu1mnD2ASQ3ldsaavrQAykOzfXVoQSrsO0XUnIFlSbVf5X0ZDDClh8SAUCPDoVBEnNoTV3Ym+4eCxom6V0K/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198268; c=relaxed/simple;
	bh=xKKvNMa2TasChE6SdE8PVEjNZ/mRiOmnMlepU5HXDng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2sfmbmehIrEZ21ET9609zycAU0g13wHvDl5aTvB3Nqb1H0CvECucFQOzRqK0YYzRZL9Hjt+xIMYJBOJLF/FuIxCCE4TK+ZZgaMAbFbxRwY6+SotL+ICgTBwNSWofpGv0DusDd2+EoI7HFqpXzQBpoj6fj8Br6/IswZmDYgc+k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9tRQYkh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9tRQYkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D811F000FF;
	Sat, 12 Sep 2026 07:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198267;
	bh=TfkTwYSjWi9iq+rOfeCHfclUHfZRgoSsW1hNkbGqX/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9tRQYkhKiDclmU5o6xziUy/0nw1QMVchaLzBA61z/CLAnb1HnJv9oxl+8OswFvfA
	 /sv4Syn03MTI0drm9YlnpCIyZ2LZ/V4aHLusb5nupiLZgS2vIOcTHNafpepBrElI/K
	 /joKebfBCVhaxL0/hzoSTp0mWvfOX9cSOM4hEBDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0345/1815] RDMA/core: Wait for RCU callbacks before unloading ib_core
Date: Sat, 12 Sep 2026 08:34:55 +0200
Message-ID: <20260912065657.011022581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index b8193e077a746..d954eda631349 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -3150,6 +3150,7 @@ static void __exit ib_core_cleanup(void)
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
 	destroy_workqueue(ib_unreg_wq);
+	rcu_barrier();
 	WARN_ON(!xa_empty(&clients));
 	WARN_ON(!xa_empty(&devices));
 }
-- 
2.53.0



