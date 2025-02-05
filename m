Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8965D1891AA;
	Wed,  5 Feb 2025 14:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767404; cv=none; b=IH9tcyLEPke1alewZjgDMeDLLQhBbDhnBolEIgcm2g2bjz65lseSpTokdHbIUNTb5a4p5PTwhXbKlrU/mTecZRuacroDEqTLmFU1OkixpYj304eGTec1I9G/pCDZXHW+AlAaRYB1B4Y8bHSuHzZQAH4jnzr5RWZYax5Vuum7N0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767404; c=relaxed/simple;
	bh=Cq5tJb+9GA1wNIKdi1g7JjvjRAQ29Rh1kYhn4fFf7ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jlkBIf0kW2ieO6fdJvs4iPmsXayqRIQqPrbkWPKfzkKrffUdhKi9u15fwRTe/61CJnOKWbeOHlCdma2QO/KxCoGpG/vihOs1QuX6hmf9+qMaAu/V47c2T1kImmC1AeL+jPAQ5MunnhkLdj+L9qyjo+b4mbBAEXq0yCCwB/YK55M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8lxk18D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8lxk18D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB198C4CED1;
	Wed,  5 Feb 2025 14:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767404;
	bh=Cq5tJb+9GA1wNIKdi1g7JjvjRAQ29Rh1kYhn4fFf7ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8lxk18D8HCHyYg1hI5dwPguknU4nMcBlu15Lrbr0eAFz+iR5fo4WY252EQsoJ5qL
	 7QggoHxGuKHemtBDRCxqT1HMVL9ZJNXgnPRLAirtdfUd2XPib4meoN8Ir7mHImoh/n
	 qza0KudwQHgQ6t5Pxpa8v4ghPg8S02dFst6UUGp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinpu Wang <jinpu.wang@ionos.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 400/623] RDMA/rtrs: Add missing deinit() call
Date: Wed,  5 Feb 2025 14:42:22 +0100
Message-ID: <20250205134511.524788735@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 81468c4058a62e84e475433b83b3edc613294f5e ]

A warning is triggered when repeatedly connecting and disconnecting the
rnbd:
 list_add corruption. prev->next should be next (ffff88800b13e480), but was ffff88801ecd1338. (prev=ffff88801ecd1340).
 WARNING: CPU: 1 PID: 36562 at lib/list_debug.c:32 __list_add_valid_or_report+0x7f/0xa0
 Workqueue: ib_cm cm_work_handler [ib_cm]
 RIP: 0010:__list_add_valid_or_report+0x7f/0xa0
  ? __list_add_valid_or_report+0x7f/0xa0
  ib_register_event_handler+0x65/0x93 [ib_core]
  rtrs_srv_ib_dev_init+0x29/0x30 [rtrs_server]
  rtrs_ib_dev_find_or_add+0x124/0x1d0 [rtrs_core]
  __alloc_path+0x46c/0x680 [rtrs_server]
  ? rtrs_rdma_connect+0xa6/0x2d0 [rtrs_server]
  ? rcu_is_watching+0xd/0x40
  ? __mutex_lock+0x312/0xcf0
  ? get_or_create_srv+0xad/0x310 [rtrs_server]
  ? rtrs_rdma_connect+0xa6/0x2d0 [rtrs_server]
  rtrs_rdma_connect+0x23c/0x2d0 [rtrs_server]
  ? __lock_release+0x1b1/0x2d0
  cma_cm_event_handler+0x4a/0x1a0 [rdma_cm]
  cma_ib_req_handler+0x3a0/0x7e0 [rdma_cm]
  cm_process_work+0x28/0x1a0 [ib_cm]
  ? _raw_spin_unlock_irq+0x2f/0x50
  cm_req_handler+0x618/0xa60 [ib_cm]
  cm_work_handler+0x71/0x520 [ib_cm]

Commit 667db86bcbe8 ("RDMA/rtrs: Register ib event handler") introduced a
new element .deinit but never used it at all. Fix it by invoking the
`deinit()` to appropriately unregister the IB event handler.

Cc: Jinpu Wang <jinpu.wang@ionos.com>
Fixes: 667db86bcbe8 ("RDMA/rtrs: Register ib event handler")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Link: https://patch.msgid.link/20250106004516.16611-1-lizhijian@fujitsu.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/rtrs/rtrs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/rtrs/rtrs.c b/drivers/infiniband/ulp/rtrs/rtrs.c
index 4e17d546d4ccf..bf38ac6f87c47 100644
--- a/drivers/infiniband/ulp/rtrs/rtrs.c
+++ b/drivers/infiniband/ulp/rtrs/rtrs.c
@@ -584,6 +584,9 @@ static void dev_free(struct kref *ref)
 	list_del(&dev->entry);
 	mutex_unlock(&pool->mutex);
 
+	if (pool->ops && pool->ops->deinit)
+		pool->ops->deinit(dev);
+
 	ib_dealloc_pd(dev->ib_pd);
 	kfree(dev);
 }
-- 
2.39.5



