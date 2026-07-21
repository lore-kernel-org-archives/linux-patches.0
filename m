Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CD02DF3EA;
	Tue, 21 Jul 2026 18:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659975; cv=none; b=tAfF5gyypfTZbk1+t4j1/6lwmNppu91zyipfv5f8YjnhcwIbK9YnWBRXCtHmAalJNJ0SjOL8z7tJunm7WvC5+q42cpXiAycklC+TjbTEGpBdDSL8i+AYzaSGnm6yTefPquYhXN6DDwxmLd1ONEGYGTofptAJSUNpukaCA539jyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659975; c=relaxed/simple;
	bh=3SKuHoN0jvpmwx6NAVoAUvYx1J01z3UecL2aihhl2QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IfSLCfO9PaytkLMAlXb9aofrv1teGiNzYGfk0ej5BYInw3F8t1FkqQ9ExzmbJ90jVs3gPVfr/eUdqfTkMR4j7QwUJAxy9zRHXClVF84FFdDLtDQBCgZIh+frq0lLzdoVl7qLDWujNHdGAcmVGr2iVd52IJSJhj1NXx270J+tWUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFykf6Sj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFykf6Sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CEB1F00A3A;
	Tue, 21 Jul 2026 18:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659974;
	bh=PfXQGP82Lj47HWeTK2FY6GbbizKruluYvhAszD1wKxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BFykf6SjukT9LPMrVhuK3rLD8ShT8E8ay7xfelscjPBxkPjK0XAFMujWUATHi18dy
	 3X5DF7xiW3hWMMeINk4QhlvBLl8myx00IrysX2cNxTl4M7pH8sMs179E/mCHEcefVp
	 4KG/QVGrEJ623QC9Luly/xbqjPSCWdFrpvG8V46s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0804/2077] RDMA/bnxt_re: Free SRQ toggle page after firmware teardown
Date: Tue, 21 Jul 2026 17:07:57 +0200
Message-ID: <20260721152611.755977294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit 131e2918b9b0529687e67e2e58047304027f095a ]

Free the toggle page only after firmware teardown completes so that
an NQ interrupt arriving during bnxt_qplib_destroy_srq() won't write
the toggle values to an already-freed page. Move free_page() after
bnxt_qplib_destroy_srq().

Fixes: 181028a0d84c ("RDMA/bnxt_re: Share a page to expose per SRQ info with userspace")
Link: https://patch.msgid.link/r/20260615224751.232802-3-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 365ec2767d2535..822484f3b95979 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -2029,11 +2029,11 @@ int bnxt_re_destroy_srq(struct ib_srq *ib_srq, struct ib_udata *udata)
 	if (ret)
 		return ret;
 
-	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT) {
-		free_page((unsigned long)srq->uctx_srq_page);
+	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT)
 		hash_del(&srq->hash_entry);
-	}
 	bnxt_qplib_destroy_srq(&rdev->qplib_res, qplib_srq);
+	if (rdev->chip_ctx->modes.toggle_bits & BNXT_QPLIB_SRQ_TOGGLE_BIT)
+		free_page((unsigned long)srq->uctx_srq_page);
 	ib_umem_release(srq->umem);
 	atomic_dec(&rdev->stats.res.srq_count);
 	return ib_respond_empty_udata(udata);
-- 
2.53.0



