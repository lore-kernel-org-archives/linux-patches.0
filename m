Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C0A318EC5;
	Wed, 30 Sep 2026 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785723; cv=none; b=PiHmp9Qf7/v0E7D1GXo/4Iw8nFsemjIDowo/J0CIzleVp8xVQ7lYddd+tNhhADJBStrmUknAkyHvN+lhFzTdXDMROMidoPwYPhWYAkIIf77DCqs9VAz4dN1El59cU4ShNrqBKAAu6DCZrGKpwkFkfLwPmL+y3JsJoWX0Nr/99qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785723; c=relaxed/simple;
	bh=3DXRuv+P8Jx8Rio9fXBvQId5v71mJnGpOXNQg3i7tq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hFkUMNlNwEa3HcobUO8180LEslvs3PjQnW09dZdDOvQ/zELYCf0a+aeY/CTbbttPlQf2Yz0a7QG2itTM17SDDG0g/tBqTy9fyWSPAlpLTgMUM/PSDlg90x5OhlVknwwVXoKXs+lYb2Hsk9EafG4RFA35ZIrCdPenXKGyOHeBy8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufuJqDV4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufuJqDV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEDE1F000FF;
	Wed, 30 Sep 2026 16:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785721;
	bh=NMQaAYU+Unf6/D47oaZjaXoReKHbwDRdNAYftxRknDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ufuJqDV4agZ0i3h8fngxXHRGWx79Vo4yRsFtnDSUzUBOUJTNdxzU7T4u/5lORIXUt
	 RKiL5tiO+01adfs2hlJmRfmIDTy9Ydz0lVJiTGH6XM2O3fqrHMKB0wnpQWAtxypzwE
	 RXkbY5a+sDqYY0YYkQzNu08peTPqTtxnlOXVvA/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 609/982] RDMA/irdma: Enforce local fence for IB_WR_REG_MR
Date: Wed, 30 Sep 2026 17:22:25 +0200
Message-ID: <20260930152429.859606192@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 3fb905f07ea45b31c8f67ba6e4668de46f527e65 ]

Enforce local fence for IB_WR_REG_MR to avoid spurious
FASTREG_VALID_MKEY async events during heavy invalidation
and registration activity.

Commit 69e8e429bca2 ("RDMA/irdma: Enforce local fence for LOCAL_INV WRs")
was very similar, but was not sufficient to prevent all occurrences
of these async events.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260901160014.2026285-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 56e3103aa77f9..a8856a8613f45 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3282,7 +3282,7 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.total_len = iwmr->ibmr.length;
 			stag_info.reg_addr_pa = *palloc->level1.addr;
 			stag_info.first_pm_pbl_index = palloc->level1.idx;
-			stag_info.local_fence = ib_wr->send_flags & IB_SEND_FENCE;
+			stag_info.local_fence = true;
 			if (iwmr->npages > IRDMA_MIN_PAGES_PER_FMR)
 				stag_info.chunk_size = 1;
 			err = irdma_sc_mr_fast_register(&iwqp->sc_qp, &stag_info,
-- 
2.53.0



