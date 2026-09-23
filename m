Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1CD5372E9;
	Wed, 23 Sep 2026 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174300; cv=none; b=KDobJ2Wj0sMAD8YZp3rJcjG6rIDDGo/CpuRBF7UtvuEQtJRzYrL+dR6cjlsbxr3D4n8FeQFWZiYwzubekdQCz0LlI3plBHnLavH54Jdyl6RhL3AQGDIIz1SuAVX/WWcTgpkAyQet4P0cgvP57o6QQFch+7CQmRXzkpIraBpRI+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174300; c=relaxed/simple;
	bh=0WexW0tTo1peCiavKf/V82VRUiS+2yiPUEWl3DS1x6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2+Gfth4N8qW2LY8dSQJPkr0sgpnANNqrt8VDq3aDBnPh9O4GKmkk5ggRW50FssAjIqKZuZLzVJCkMBLBpf5rhOkICfGUMuwsWW7+51RgAODsrX4Wlok9cOOx+hruz7NdPX1uHk+JYPStaHrVuOlL1AsMJ143dukcz/gYmcSD0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMlrbvM1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMlrbvM1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B76F1F000FF;
	Wed, 23 Sep 2026 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174298;
	bh=BL9AXNNSXW2zfXkSb+pmR0Siif9N/mIwyMskECwesSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMlrbvM1wVbZ3gka0hVqJdTSt3fAay+ELp6f6VHG22cOKRYRDIAGLOqOTBMS0H5n1
	 eich2tCU5vDw4G8ZQZrSOOpnj67mSNgfPOBgEcUaaEIaihy77SoBVUH1YtAHdbI8Rs
	 NKQxeXycqQ9Ghb5e+z8ajlBk3mt+ozD8hl+VcSQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 041/398] RDMA/irdma: Enforce local fence for IB_WR_REG_MR
Date: Wed, 23 Sep 2026 16:01:55 +0200
Message-ID: <20260923140644.491269201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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
index 9ada0bc00bd07..40443d77365b4 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -4165,7 +4165,7 @@ static int irdma_post_send(struct ib_qp *ibqp,
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



