Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3601D168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B38C433EF;
	Mon,  8 May 2023 10:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540724;
	bh=FW0MD4duk7G0ZQQxdSx03KTE3SPBbXr9x06v/eNL08M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxPAMY2lxRLIuSqGfSLzQxiqNMlI5pD4jqK9CqL3zxzlLVsKDeEIymIV4Iu7ba9Ez
	 rVl6YYmKI5+tvuhCCrZMLo1I1CVD4i667cIABhti8fbdgQewTpqIOgA3IN2HqAZDs1
	 yJcUytrNuZBBOW+1Ewj40DSACcJPgOMxcXUKz5H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniil Dulov <d.dulov@aladdin.ru>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 473/611] RDMA/siw: Fix potential page_array out of range access
Date: Mon,  8 May 2023 11:45:15 +0200
Message-Id: <20230508094437.478003079@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniil Dulov <d.dulov@aladdin.ru>

[ Upstream commit 271bfcfb83a9f77cbae3d6e1a16e3c14132922f0 ]

When seg is equal to MAX_ARRAY, the loop should break, otherwise
it will result in out of range access.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: b9be6f18cf9e ("rdma/siw: transmit path")
Signed-off-by: Daniil Dulov <d.dulov@aladdin.ru>
Link: https://lore.kernel.org/r/20230227091751.589612-1-d.dulov@aladdin.ru
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_qp_tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/siw/siw_qp_tx.c b/drivers/infiniband/sw/siw/siw_qp_tx.c
index 05052b49107f2..6bb9e9e81ff4c 100644
--- a/drivers/infiniband/sw/siw/siw_qp_tx.c
+++ b/drivers/infiniband/sw/siw/siw_qp_tx.c
@@ -558,7 +558,7 @@ static int siw_tx_hdt(struct siw_iwarp_tx *c_tx, struct socket *s)
 			data_len -= plen;
 			fp_off = 0;
 
-			if (++seg > (int)MAX_ARRAY) {
+			if (++seg >= (int)MAX_ARRAY) {
 				siw_dbg_qp(tx_qp(c_tx), "to many fragments\n");
 				siw_unmap_pages(iov, kmap_mask, seg-1);
 				wqe->processed -= c_tx->bytes_unsent;
-- 
2.39.2



