Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 503995381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC38FC433CC;
	Mon, 19 Jun 2023 10:46:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171609;
	bh=83rw+pcpfln0desEQ7PngDJJgQedTNe2tIna+kndp0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmFywQu1yJwCjMweMgMm9TPjb4s6VVUHoGxWWkwPl2V91WRYbjJK+TdSSYloDQcmK
	 Ikmtz60QhDaJOq0b9JUVoSCYwKRuESwwYDP5Ayr17L9NGEseTk6nVVM3vh+CgSyhEk
	 2Tf4SWUmLgsGS3byADsnypIlvwsBCu2DxBBn/YY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/166] RDMA/rxe: Fix ref count error in check_rkey()
Date: Mon, 19 Jun 2023 12:29:30 +0200
Message-ID: <20230619102159.313337812@linuxfoundation.org>
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

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit b00683422fd79dd07c9b75efdce1660e5e19150e ]

There is a reference count error in error path code and a potential race
in check_rkey() in rxe_resp.c. When looking up the rkey for a memory
window the reference to the mw from rxe_lookup_mw() is dropped before a
reference is taken on the mr referenced by the mw. If the mr is destroyed
immediately after the call to rxe_put(mw) the mr pointer is unprotected
and may end up pointing at freed memory. The rxe_get(mr) call should take
place before the rxe_put(mw) call.

All errors in check_rkey() call rxe_put(mw) if mw is not NULL but it was
already called after the above. The mw pointer should be set to NULL after
the rxe_put(mw) call to prevent this from happening.

Fixes: cdd0b85675ae ("RDMA/rxe: Implement memory access through MWs")
Link: https://lore.kernel.org/r/20230517211509.1819998-1-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 693081e813ec0..9f65c346d8432 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -466,8 +466,9 @@ static enum resp_states check_rkey(struct rxe_qp *qp,
 		if (mw->access & IB_ZERO_BASED)
 			qp->resp.offset = mw->addr;
 
-		rxe_put(mw);
 		rxe_get(mr);
+		rxe_put(mw);
+		mw = NULL;
 	} else {
 		mr = lookup_mr(qp->pd, access, rkey, RXE_LOOKUP_REMOTE);
 		if (!mr) {
-- 
2.39.2



