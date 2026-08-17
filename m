Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FDD13790B;
	Mon, 17 Aug 2026 14:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976650; cv=none; b=ZI0S71aTgzJQGAzzHdv4/iS+H+ITARUQlS0SgCWnzCptiZ/AMrRH1kyhEpwMwoHAgKEl473cUVn05RU6r53ZmkPKgnOXIXgXypnEePLoNo0WPybkvHSGptAB/hkKXGDtm68bfpUANIbVHAoq+g8Ay/6b8+oNOg9CiJZF15yvuXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976650; c=relaxed/simple;
	bh=+fPtFalQvYcAd2DsdUrzTjnO1UOyl1jarHydkvgOh0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n9b2sZvZFadIKJeuzeU3+wkTrb2mA0NhgCG5SihKY1ZvCpl5GLUTKYA88oVQkDBS1nC2cKoRp+ElizQrgfbk9zgZDDaPgvN6nm9Ip169ljQ5XQeNWsiT17FALbh0cSCCoIXXH889M1AgMB56F3ZvkxHoPAcub3wUnijA/y/Vcoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpry+rk0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpry+rk0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187551F000E9;
	Mon, 17 Aug 2026 14:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976648;
	bh=KDq1cwvXq23Ffky+dscKbBaNyoPMmnEFAobSW/7l7rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpry+rk0ECBcZn8NFWTc2i1Oqpxbp/vvZFJ4wJRZfWLe1hCXmIshgu8/QymQ1qA6y
	 g1pULBagVTAMuoNjINUt4HIncMLQvcaxEHopr6Qz411yl+tlqWFqCj9L4TDH+mJBvp
	 4CbuvW+g8PgD6r2dW8m9F8bIuBUPH4IJ9pzGxWEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Metzler <bmt@zurich.ibm.com>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/456] RDMA/siw: Only check attrs->cap.max_send_wr in siw_create_qp
Date: Mon, 17 Aug 2026 15:26:49 +0200
Message-ID: <20260817132540.680613129@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoqing Jiang <guoqing.jiang@linux.dev>

[ Upstream commit 788bbf4c2fc6e0c35bae9ed5068f484272539d3e ]

We can just check max_send_wr here given both max_send_wr and
max_recv_wr are defined as u32 type, and we also need to ensure
num_sqe (derived from max_send_wr) shouldn't be zero.

Acked-by: Bernard Metzler <bmt@zurich.ibm.com>
Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Link: https://lore.kernel.org/r/20231113115726.12762-16-guoqing.jiang@linux.dev
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: bb27fcc67c42 ("RDMA/siw: publish QP after initialization")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/siw/siw_verbs.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/sw/siw/siw_verbs.c b/drivers/infiniband/sw/siw/siw_verbs.c
index c83701d04c9558..55a1357a636dcd 100644
--- a/drivers/infiniband/sw/siw/siw_verbs.c
+++ b/drivers/infiniband/sw/siw/siw_verbs.c
@@ -334,11 +334,10 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 		goto err_atomic;
 	}
 	/*
-	 * NOTE: we allow for zero element SQ and RQ WQE's SGL's
-	 * but not for a QP unable to hold any WQE (SQ + RQ)
+	 * NOTE: we don't allow for a QP unable to hold any SQ WQE
 	 */
-	if (attrs->cap.max_send_wr + attrs->cap.max_recv_wr == 0) {
-		siw_dbg(base_dev, "QP must have send or receive queue\n");
+	if (attrs->cap.max_send_wr == 0) {
+		siw_dbg(base_dev, "QP must have send queue\n");
 		rv = -EINVAL;
 		goto err_atomic;
 	}
@@ -358,21 +357,14 @@ int siw_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 	if (rv)
 		goto err_atomic;
 
-	num_sqe = attrs->cap.max_send_wr;
-	num_rqe = attrs->cap.max_recv_wr;
 
 	/* All queue indices are derived from modulo operations
 	 * on a free running 'get' (consumer) and 'put' (producer)
 	 * unsigned counter. Having queue sizes at power of two
 	 * avoids handling counter wrap around.
 	 */
-	if (num_sqe)
-		num_sqe = roundup_pow_of_two(num_sqe);
-	else {
-		/* Zero sized SQ is not supported */
-		rv = -EINVAL;
-		goto err_out_xa;
-	}
+	num_sqe = roundup_pow_of_two(attrs->cap.max_send_wr);
+	num_rqe = attrs->cap.max_recv_wr;
 	if (num_rqe)
 		num_rqe = roundup_pow_of_two(num_rqe);
 
-- 
2.53.0



