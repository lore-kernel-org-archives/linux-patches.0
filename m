Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012A579C6
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B766C433C8;
	Mon, 19 Jun 2023 10:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171737;
	bh=xV/vVn+zaHl4NmWcakdrziwPiLp+l6vwCV1yF6ZQkbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZXhGzQbNBQsh5z49F19FkJP+YI6Yd1My34RR0YBP7ZuTuuIrhmzlVRVDHjeiI/NS
	 f4bLOcqyCi1VxNmRCIbw/GdkDdp3/ILUCAoenHOYh8MHyGUWJeQmEbzRyNcYkuEKlr
	 yl+zE5hEOLJJnpafdx6KCbr+jumw3vhANkTgHJeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satha Rao <skoteshwar@marvell.com>,
	Sunil Kovvuri Goutham <sgoutham@marvell.com>,
	Naveen Mamindlapalli <naveenm@marvell.com>,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 114/166] octeontx2-af: fixed resource availability check
Date: Mon, 19 Jun 2023 12:29:51 +0200
Message-ID: <20230619102200.372377373@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Satha Rao <skoteshwar@marvell.com>

[ Upstream commit 4e635f9d86165e47f5440196f2ebdb258efb8341 ]

txschq_alloc response have two different arrays to store continuous
and non-continuous schedulers of each level. Requested count should
be checked for each array separately.

Fixes: 5d9b976d4480 ("octeontx2-af: Support fixed transmit scheduler topology")
Signed-off-by: Satha Rao <skoteshwar@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 84f2ba53b8b68..506c67dd6cd40 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -1878,7 +1878,8 @@ static int nix_check_txschq_alloc_req(struct rvu *rvu, int lvl, u16 pcifunc,
 		free_cnt = rvu_rsrc_free_count(&txsch->schq);
 	}
 
-	if (free_cnt < req_schq || req_schq > MAX_TXSCHQ_PER_FUNC)
+	if (free_cnt < req_schq || req->schq[lvl] > MAX_TXSCHQ_PER_FUNC ||
+	    req->schq_contig[lvl] > MAX_TXSCHQ_PER_FUNC)
 		return NIX_AF_ERR_TLX_ALLOC_FAIL;
 
 	/* If contiguous queues are needed, check for availability */
-- 
2.39.2



