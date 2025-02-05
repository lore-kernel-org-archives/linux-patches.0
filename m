Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771631FCF66;
	Wed,  5 Feb 2025 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766895; cv=none; b=OWkjd8+B0EnV+z9ZF++Pif/zn/g0YUUTcdBUk2X73mW+mfIO85mu4AntQD/ird2cGkJrH4qEw/isS97p8TxcahHQuQdnH1yzoMiDbVWvZUsI0rN6HScVk08i6+c3wTXgT8MfeiUtWYt0QWn8W8Y/N65l2TcatFfsmbWe1p99ei4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766895; c=relaxed/simple;
	bh=dNMWNQZnxB+R0IqxhXPgKxsVYCG6R5aadGWleveu6rM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCNDmLnViXum3SI47gKG95pXHrBvYrPDdVL2SbT7JdPd1A8PcnbLUiLX+DWG47LR1azjfKPh8FrrB9qkas2sUWPu/1+evPxNTsjQDxbxKC4TZSm7ymdhHtPe8DxEN1n0IzBmF3OdWr4H7XB3te1z8Mp4Q7LnX7s0RiczXrQjZ9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R75MB3DO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R75MB3DO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FADAC4CED1;
	Wed,  5 Feb 2025 14:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766893;
	bh=dNMWNQZnxB+R0IqxhXPgKxsVYCG6R5aadGWleveu6rM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R75MB3DO/SeO3L8BgHseFPtJ1mvn4iI9w6z+cS1uvIwC9fXxWx/8Gm1HXD3iUz6xe
	 fqLyyfGTDEC9SOM+KzVAbPUhCD/2LSpGgDKd1nPA6GVHNm4SXtbaDyAelbHmwNf05R
	 /MWfktoYUlu3/d+Gi08L0Z2phE/3bPspJouzlEwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinpu Wang <jinpu.wang@ionos.com>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 368/590] RDMA/rtrs: Add missing deinit() call
Date: Wed,  5 Feb 2025 14:42:03 +0100
Message-ID: <20250205134509.350309349@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



