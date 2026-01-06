Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F6935FF65;
	Tue,  6 Jan 2026 17:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721769; cv=none; b=qCxZqda21QYbgqs0I29TzXTIskKpPTGmwLYd94tsLSD2VpxGdevs2vSJtSIQaKAmWuFIl8xlwMXNLIPABgmIxGFBYK98KjZseNWT3/oTfsi/3CqhRk+tAsB7kk7K1jCvwXUuTm8BRVv+CGQkHRSwMgv5WYgmiNT7QRXgFjgM+hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721769; c=relaxed/simple;
	bh=n2aQuoJ3TiQmYdpCZzsAT3WQCRuvjVdVGg9o66k+xCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1574oXSuCbbhhCqi2c398VqVnUkf93D4cFQcu/+6hyFL9kTZpjVdQeQpZU92QniS8hrnsZ65SiDdr0hAL96Mvgkb912zf+who+vuZoHJQ9gjHrd6tyLu4xQWUbxQo4rgF31xZg273WqJ/BNgzkchDo6VoTPDkhdCTVFWplgRMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EVixW+ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EVixW+ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6648C116C6;
	Tue,  6 Jan 2026 17:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721769;
	bh=n2aQuoJ3TiQmYdpCZzsAT3WQCRuvjVdVGg9o66k+xCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EVixW+ryPY7ik/TdZ7oTYIaYCe1xW4ujYpnBHQ45oOmVSIJzApRYYbgFic5pCxXRN
	 b1+Asu5i6W8Grv0Ry3bNhpx2jPYEy8XUOxZxuKoAZ/8mHTcURp6JaXg8tmE00JjLXZ
	 QSngPL1UXPdAS4hFCSj417izbH9Gts5ToglIEcj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Taranov <kotaranov@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/312] RDMA/mana_ib: check cqe length for kernel CQs
Date: Tue,  6 Jan 2026 18:02:21 +0100
Message-ID: <20260106170550.274104681@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Taranov <kotaranov@microsoft.com>

[ Upstream commit 887bfe5986396aca908b7afd2d214471ba7d5544 ]

Check queue size during kernel CQ creation to prevent overflow of u32.

Fixes: bec127e45d9f ("RDMA/mana_ib: create kernel-level CQs")
Link: https://patch.msgid.link/r/1761213780-5457-1-git-send-email-kotaranov@linux.microsoft.com
Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/cq.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/mana/cq.c b/drivers/infiniband/hw/mana/cq.c
index 1becc8779123..7600412b0739 100644
--- a/drivers/infiniband/hw/mana/cq.c
+++ b/drivers/infiniband/hw/mana/cq.c
@@ -56,6 +56,10 @@ int mana_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		doorbell = mana_ucontext->doorbell;
 	} else {
 		is_rnic_cq = true;
+		if (attr->cqe > U32_MAX / COMP_ENTRY_SIZE / 2 + 1) {
+			ibdev_dbg(ibdev, "CQE %d exceeding limit\n", attr->cqe);
+			return -EINVAL;
+		}
 		buf_size = MANA_PAGE_ALIGN(roundup_pow_of_two(attr->cqe * COMP_ENTRY_SIZE));
 		cq->cqe = buf_size / COMP_ENTRY_SIZE;
 		err = mana_ib_create_kernel_queue(mdev, buf_size, GDMA_CQ, &cq->queue);
-- 
2.51.0



