Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723793DBD51;
	Wed, 30 Sep 2026 19:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795945; cv=none; b=WNmMew0jC1OFWUf+nmovRPcoyy6IdRMhkCu325O76BE2jA04h0J8qM+ehMpdQ0A9fql5uPp1aULPB/Fv9p0TC99VkON3/ntWDDBRq0HtT46w5rE3GKRr/IN1NGKMCyobgRZiETJhMWUFtpXOoL4kLQOX1p/qqxSy2dJl1QxDVLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795945; c=relaxed/simple;
	bh=h7nvinLczE9ZoAakTW+bs9KzhfM0pft4Ijeiml+tbNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ephC23xQObpQ7C3R9H99Y2tcdU5I8dxAyzQI0TKAvodCr9kZ0tMtt1mphXzU/gIQ0ayTUJdsaSIH2PRp+MLLXbDxMoigJ9KCtMiWB8dx0+xPWe+XYSy0ND01w8PqRN/bKW68lRvmaP5Rk/1S3/cUDWDiUyZZVMVZsZUWly9XQOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRX9n7Rz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRX9n7Rz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6E61F000FF;
	Wed, 30 Sep 2026 19:19:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795944;
	bh=tncJ0FfX/wEIPW2ctKhys1e7XxHRxJfNpWtXPhSWjJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JRX9n7RzPaTCKr8lr+15x4WPZ5+d/lQ0xpLcfPV8nQV27XYZOMxd8t2f5uV2yJkCO
	 jauXYUGJLuo2VqijH60z5GJN1DRvKrACs0sLUPv49GiV3nWXuhEc9t15d7bmrHkRoN
	 iSodYhdxANbIzEGHPxDAn3YTnACRtA10uHL2poKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0738/1193] RDMA/irdma: Enforce local fence for IB_WR_REG_MR
Date: Wed, 30 Sep 2026 17:23:42 +0200
Message-ID: <20260930152450.648666311@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 136e367b40d87..c732dfefe7e33 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3570,7 +3570,7 @@ static int irdma_post_send(struct ib_qp *ibqp,
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



