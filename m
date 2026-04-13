Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7276723D297;
	Mon, 13 Apr 2026 16:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097981; cv=none; b=ExXwxEXbalu5hi8haFKD6Qv5WhpwSYm0Aq2p/8+g6MujDVLCUpRGhgF13Ik8agPXeK72Nb2miSTPLFnT98BjJB9horhcagaFsINqMHhbklWHwGQ64LdBsqxnEI3RZ4LQbGgfZrEwG8LDkKUGi+zkOPC/+lBeICetZxPj2/dldcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097981; c=relaxed/simple;
	bh=xa8m9/BkImIGZfHb5L6yPW7UHwuOUj6cBeJ2L1Qbs3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BW45IJZ6sqGuo3EBARodyuKn8TOgsfnRaXNp5N1z1cqSzdoAjUiJaDvZjIVyiZeeQ+C7WKvCozbalpK486qKKUbSHsnPdylU2EL/ArafnNWJlueXIqh+Ix+yVAkqMmI0SACAxsJV3Z6wNCIHEMTlaVGPnzo8dtdQGg1WBBd5e/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TzyaLhwU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TzyaLhwU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0925CC2BCAF;
	Mon, 13 Apr 2026 16:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097981;
	bh=xa8m9/BkImIGZfHb5L6yPW7UHwuOUj6cBeJ2L1Qbs3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TzyaLhwUp9bVjivyRhUd8ZbyxQnhfCY7iLI55aIKEkZjTYPO6VCR5i6XwziQ2SbuK
	 b9JOLA2LQDyPtgQUQI9Jt5fZmG53dmB2ikMHBJYVHbaa6i9X+Uj+RWK0BFI7C8ruvE
	 2kAVxigfF+X1GiX2d3aT9diFz3hzm2PwGs1zq/J4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 348/570] RDMA/irdma: Remove a NOP wait_event() in irdma_modify_qp_roce()
Date: Mon, 13 Apr 2026 17:57:59 +0200
Message-ID: <20260413155843.524898005@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>

[ Upstream commit 5e8f0239731a83753473b7aa91bda67bbdff5053 ]

Remove a NOP wait_event() in irdma_modify_qp_roce() which is relevant
for iWARP and likely a copy and paste artifact for RoCEv2. The wait event
is for sending a reset on a TCP connection, after the reset has been
requested in irdma_modify_qp(), which occurs only in iWarp mode.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index f1924e84d2568..b7186bb6a7bbc 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1275,8 +1275,6 @@ int irdma_modify_qp_roce(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 			roce_info->rd_en = true;
 	}
 
-	wait_event(iwqp->mod_qp_waitq, !atomic_read(&iwqp->hw_mod_qp_pend));
-
 	ibdev_dbg(&iwdev->ibdev,
 		  "VERBS: caller: %pS qp_id=%d to_ibqpstate=%d ibqpstate=%d irdma_qpstate=%d attr_mask=0x%x\n",
 		  __builtin_return_address(0), ibqp->qp_num, attr->qp_state,
-- 
2.53.0



