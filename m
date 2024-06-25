Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AACB1465A8;
	Tue, 25 Jun 2024 09:54:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719309251; cv=none; b=gEj0eNjLvm41FO4nbrqvaK0kd+ATXwiHZ/+F4ib3mgzA+V6+1I11dTHguTwdIW8LdzW/M/T3miFdAM51vGOOVw6KZwC2xLwTK7ROl0/cKyAp8DK6YgMN6Vu36TP/0zz7RiwiMVzIIdewvHyhS5gIYKalPp9y2LBBiNH438fh83E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719309251; c=relaxed/simple;
	bh=i7zF0XPVb5aRNw4ZMC6pQ3Ew8kGWidYTOvHKRcPShXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOHo6TK2Dqb2iE7sZVGWPnQ8slyWExpXkZ0rPyz5WMZ2LcbivzevamZGowDmcoeIQUZFCxrBBTm9cEYg/ZAFDpt1Dx3LSMpmfRouR5KIqwrJE0fEmSo+psletKVp5zTcIXr5RiyshlIONIMgVJpConnGDRIR5g1xFZ71GeQVz0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bf/f4mQM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bf/f4mQM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C14C32781;
	Tue, 25 Jun 2024 09:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719309250;
	bh=i7zF0XPVb5aRNw4ZMC6pQ3Ew8kGWidYTOvHKRcPShXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bf/f4mQMTHR2vPkT8QR3nJQoIIwu8YQttBhhZmsFgXCWL3Ev0CSK9x4eyNRSQOgU7
	 oYa9APFbntbLQq2XpnfO3MQ8xObfySxjN+Pc3ECyrBE4hEnC6dB+d8xbeCTNgNR7Fh
	 BWxFNAw20/L3ZPWUGajqm5TK2Pl9vZ4BjQo+soK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Honggang LI <honggangli@163.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Li Zhijian <lizhijian@fujitsu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.6 145/192] RDMA/rxe: Fix data copy for IB_SEND_INLINE
Date: Tue, 25 Jun 2024 11:33:37 +0200
Message-ID: <20240625085542.724005835@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Honggang LI <honggangli@163.com>

commit 03fa18a992d5626fd7bf3557a52e826bf8b326b3 upstream.

For RDMA Send and Write with IB_SEND_INLINE, the memory buffers
specified in sge list will be placed inline in the Send Request.

The data should be copied by CPU from the virtual addresses of
corresponding sge list DMA addresses.

Cc: stable@kernel.org
Fixes: 8d7c7c0eeb74 ("RDMA: Add ib_virt_dma_to_page()")
Signed-off-by: Honggang LI <honggangli@163.com>
Link: https://lore.kernel.org/r/20240516095052.542767-1-honggangli@163.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/sw/rxe/rxe_verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index c7d4d8ab5a09..de6238ee4379 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -812,7 +812,7 @@ static void copy_inline_data_to_wqe(struct rxe_send_wqe *wqe,
 	int i;
 
 	for (i = 0; i < ibwr->num_sge; i++, sge++) {
-		memcpy(p, ib_virt_dma_to_page(sge->addr), sge->length);
+		memcpy(p, ib_virt_dma_to_ptr(sge->addr), sge->length);
 		p += sge->length;
 	}
 }
-- 
2.45.2



