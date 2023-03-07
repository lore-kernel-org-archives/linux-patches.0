Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31728BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:36:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D0E6C433EF;
	Tue,  7 Mar 2023 17:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210561;
	bh=lwtDCNOB1P1C3uDyD3rizenKAw16yquVBJUkXGwWKKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s5Enlu/ho1DX/mQXvEI2zabxGdu4BNKM/6JqeBelY3sdVaLuk8UGZoiCrgReVQo8V
	 DmF66Xz+343QT3cjbEE8DnOmIWpWUS5BYkTOkXngu9jSjCfIh55IlCsYzJnJ/hGTks
	 yaMyedNbR6TcVScJBLUy136BB+mLUnxk2JZT0TNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brendan Cunningham <bcunningham@cornelisnetworks.com>,
	Patrick Kelsey <pat.kelsey@cornelisnetworks.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0580/1001] IB/hfi1: Fix sdma.h tx->num_descs off-by-one errors
Date: Tue,  7 Mar 2023 17:55:52 +0100
Message-Id: <20230307170046.635773142@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Patrick Kelsey <pat.kelsey@cornelisnetworks.com>

[ Upstream commit fd8958efe8779d3db19c9124fce593ce681ac709 ]

Fix three sources of error involving struct sdma_txreq.num_descs.

When _extend_sdma_tx_descs() extends the descriptor array, it uses the
value of tx->num_descs to determine how many existing entries from the
tx's original, internal descriptor array to copy to the newly allocated
one.  As this value was incremented before the call, the copy loop will
access one entry past the internal descriptor array, copying its contents
into the corresponding slot in the new array.

If the call to _extend_sdma_tx_descs() fails, _pad_smda_tx_descs() then
invokes __sdma_tx_clean() which uses the value of tx->num_desc to drive a
loop that unmaps all descriptor entries in use.  As this value was
incremented before the call, the unmap loop will invoke sdma_unmap_desc()
on a descriptor entry whose contents consist of whatever random data was
copied into it during (1), leading to cascading further calls into the
kernel and driver using arbitrary data.

_sdma_close_tx() was using tx->num_descs instead of tx->num_descs - 1.

Fix all of the above by:
- Only increment .num_descs after .descp is extended.
- Use .num_descs - 1 instead of .num_descs for last .descp entry.

Fixes: f4d26d81ad7f ("staging/rdma/hfi1: Add coalescing support for SDMA TX descriptors")
Link: https://lore.kernel.org/r/167656658879.2223096.10026561343022570690.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Brendan Cunningham <bcunningham@cornelisnetworks.com>
Signed-off-by: Patrick Kelsey <pat.kelsey@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/sdma.c |  4 ++--
 drivers/infiniband/hw/hfi1/sdma.h | 15 +++++++--------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index a95b654f52540..8ed20392e9f0d 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -3160,8 +3160,7 @@ int _pad_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 {
 	int rval = 0;
 
-	tx->num_desc++;
-	if ((unlikely(tx->num_desc == tx->desc_limit))) {
+	if ((unlikely(tx->num_desc + 1 == tx->desc_limit))) {
 		rval = _extend_sdma_tx_descs(dd, tx);
 		if (rval) {
 			__sdma_txclean(dd, tx);
@@ -3174,6 +3173,7 @@ int _pad_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 		SDMA_MAP_NONE,
 		dd->sdma_pad_phys,
 		sizeof(u32) - (tx->packet_len & (sizeof(u32) - 1)));
+	tx->num_desc++;
 	_sdma_close_tx(dd, tx);
 	return rval;
 }
diff --git a/drivers/infiniband/hw/hfi1/sdma.h b/drivers/infiniband/hw/hfi1/sdma.h
index d8170fcbfbdd5..b023fc461bd51 100644
--- a/drivers/infiniband/hw/hfi1/sdma.h
+++ b/drivers/infiniband/hw/hfi1/sdma.h
@@ -631,14 +631,13 @@ static inline void sdma_txclean(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 static inline void _sdma_close_tx(struct hfi1_devdata *dd,
 				  struct sdma_txreq *tx)
 {
-	tx->descp[tx->num_desc].qw[0] |=
-		SDMA_DESC0_LAST_DESC_FLAG;
-	tx->descp[tx->num_desc].qw[1] |=
-		dd->default_desc1;
+	u16 last_desc = tx->num_desc - 1;
+
+	tx->descp[last_desc].qw[0] |= SDMA_DESC0_LAST_DESC_FLAG;
+	tx->descp[last_desc].qw[1] |= dd->default_desc1;
 	if (tx->flags & SDMA_TXREQ_F_URGENT)
-		tx->descp[tx->num_desc].qw[1] |=
-			(SDMA_DESC1_HEAD_TO_HOST_FLAG |
-			 SDMA_DESC1_INT_REQ_FLAG);
+		tx->descp[last_desc].qw[1] |= (SDMA_DESC1_HEAD_TO_HOST_FLAG |
+					       SDMA_DESC1_INT_REQ_FLAG);
 }
 
 static inline int _sdma_txadd_daddr(
@@ -655,6 +654,7 @@ static inline int _sdma_txadd_daddr(
 		type,
 		addr, len);
 	WARN_ON(len > tx->tlen);
+	tx->num_desc++;
 	tx->tlen -= len;
 	/* special cases for last */
 	if (!tx->tlen) {
@@ -666,7 +666,6 @@ static inline int _sdma_txadd_daddr(
 			_sdma_close_tx(dd, tx);
 		}
 	}
-	tx->num_desc++;
 	return rval;
 }
 
-- 
2.39.2



