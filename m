Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F062338DC7B;
	Sat, 12 Sep 2026 19:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242642; cv=none; b=gjZBP8/uipbVxQha39vE+DamL7p27nzUYfHjNrsEGK7x4e6uaROGRcjskOGnrEUgyazqrsxwgK2ZQRexOKCmLS0YUzDN7XyTCebo+n4r0hGkDeqZs1Me5El3x/yR9INpcYDA/RPbegNmT6Uvk3HqHujFcNHckFpI/YaAskHIPI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242642; c=relaxed/simple;
	bh=/JFSEzbGZMU8OBmJ9zuGds8roTh39oUN+mQP9REVCYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIn/qWCn4EbNkdPWDx3AweTtgh+lFVm19zc0yEF4g/TS2K4iySwjY5JboFPP+p9cskpnqbYI4RqnWaKzUsVG8Rp1QRgmhfamlYPDGopKH7uS/SxJzwmIdEknZHZXCQWB3Ls8DRyvn0x1PjhNDbRHGV90qeJBsaRcvZSNA+0NJAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jhVxQORD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jhVxQORD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD401F000FF;
	Sat, 12 Sep 2026 19:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242640;
	bh=ezv8ei1EdofVOcIsyiQzfdjdVmpzUjbfhBF/UeK8A5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jhVxQORDYoVJX73pp/bMQcNnRxZmukf1ZOcnVr2qaKLDpT/IqoaFJCrDsb+yWf15S
	 M4PEfpf8oP1S9EjwlGYZfcfW16q9IJTEAa3tOQHS2+OZZerxvJIgXhOGF1reWxjj8G
	 fynFP4NZq7S0kIadSknTMIFdLmaiCqpLGHSPcN/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 422/798] RDMA/core: Wait for RCU callbacks before unloading ib_core
Date: Sat, 12 Sep 2026 09:00:50 +0200
Message-ID: <20260912065526.820814247@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
index fdc1c09931a38..4d9ac21c8e4cc 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -2866,6 +2866,7 @@ static void __exit ib_core_cleanup(void)
 	/* Make sure that any pending umem accounting work is done. */
 	destroy_workqueue(ib_wq);
 	destroy_workqueue(ib_unreg_wq);
+	rcu_barrier();
 	WARN_ON(!xa_empty(&clients));
 	WARN_ON(!xa_empty(&devices));
 }
-- 
2.53.0



