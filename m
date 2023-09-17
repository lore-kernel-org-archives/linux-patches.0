Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94566FCC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B049C433C8;
	Sun, 17 Sep 2023 19:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980357;
	bh=FvVFEPxVxowNq4euWBmGYAZuJ3bwrFBoC2aNwkBeP5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tC9wuPMvAhdDirjovBHV85qXdWlcF6mIb5Og0ksjmcBcH65VJX5jBWjZ/pp6BUwE7
	 beCDRgZDHQZE6ZTmDHqrqY/gw5yPZ6R7lsk6PnnC2Jj1XO8JcdM5iFIubacA2tlc0/
	 hqQ6q5RmwGLv4PaQ9vUH8bLt9f8UaeZxZH2BRcN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 140/285] octeontx2-af: Fix truncation of smq in CN10K NIX AQ enqueue mbox handler
Date: Sun, 17 Sep 2023 21:12:20 +0200
Message-ID: <20230917191056.522203106@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 29fe7a1b62717d58f033009874554d99d71f7d37 ]

The smq value used in the CN10K NIX AQ instruction enqueue mailbox
handler was truncated to 9-bit value from 10-bit value because of
typecasting the CN10K mbox request structure to the CN9K structure.
Though this hasn't caused any problems when programming the NIX SQ
context to the HW because the context structure is the same size.
However, this causes a problem when accessing the structure parameters.
This patch reads the right smq value for each platform.

Fixes: 30077d210c83 ("octeontx2-af: cn10k: Update NIX/NPA context structure")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index c2f68678e947e..23c2f2ed2fb83 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -846,6 +846,21 @@ static int nix_aq_enqueue_wait(struct rvu *rvu, struct rvu_block *block,
 	return 0;
 }
 
+static void nix_get_aq_req_smq(struct rvu *rvu, struct nix_aq_enq_req *req,
+			       u16 *smq, u16 *smq_mask)
+{
+	struct nix_cn10k_aq_enq_req *aq_req;
+
+	if (!is_rvu_otx2(rvu)) {
+		aq_req = (struct nix_cn10k_aq_enq_req *)req;
+		*smq = aq_req->sq.smq;
+		*smq_mask = aq_req->sq_mask.smq;
+	} else {
+		*smq = req->sq.smq;
+		*smq_mask = req->sq_mask.smq;
+	}
+}
+
 static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 				   struct nix_aq_enq_req *req,
 				   struct nix_aq_enq_rsp *rsp)
@@ -857,6 +872,7 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 	struct rvu_block *block;
 	struct admin_queue *aq;
 	struct rvu_pfvf *pfvf;
+	u16 smq, smq_mask;
 	void *ctx, *mask;
 	bool ena;
 	u64 cfg;
@@ -928,13 +944,14 @@ static int rvu_nix_blk_aq_enq_inst(struct rvu *rvu, struct nix_hw *nix_hw,
 	if (rc)
 		return rc;
 
+	nix_get_aq_req_smq(rvu, req, &smq, &smq_mask);
 	/* Check if SQ pointed SMQ belongs to this PF/VF or not */
 	if (req->ctype == NIX_AQ_CTYPE_SQ &&
 	    ((req->op == NIX_AQ_INSTOP_INIT && req->sq.ena) ||
 	     (req->op == NIX_AQ_INSTOP_WRITE &&
-	      req->sq_mask.ena && req->sq_mask.smq && req->sq.ena))) {
+	      req->sq_mask.ena && req->sq.ena && smq_mask))) {
 		if (!is_valid_txschq(rvu, blkaddr, NIX_TXSCH_LVL_SMQ,
-				     pcifunc, req->sq.smq))
+				     pcifunc, smq))
 			return NIX_AF_ERR_AQ_ENQUEUE;
 	}
 
-- 
2.40.1



