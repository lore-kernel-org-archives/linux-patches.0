Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C815113B798;
	Tue, 27 Feb 2024 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043585; cv=none; b=j6hPEU0cioLOwdL/dkBqyipgOxhpufdrzRReasoHtIMBIZgAGMkdJnoVMyjhkNlHowntQ/IP8dh7z64hvhhfaGuUtVCoWY/pU46O4Uzcc7Qe5QIsP1yGvFOQ8s0EnPRaqCi6mj+FuAUuZ64VE7jM5WdKK2SYrk1rs8irr2E9iXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043585; c=relaxed/simple;
	bh=pn6fR5qx7hMW56bGs9vT0EUFKebTMCC+VT7GsSaL92M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RtB5IClnWmdn5mSOT62XAbYdOJcXQkMyy5TyR765FhruTXtq+9BlV7hbiJkUiToN3QbJ0+TouQQr7K4PKlAgqlgAMsdp/qgs7efwjqVWU97O9+1+0bLfLHTdFmhZkBIn6Sih95Z5d2W839ohJIzBx4VllZTqEvapySlJs6PIiZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/Bff0FD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/Bff0FD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A70EC433F1;
	Tue, 27 Feb 2024 14:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043585;
	bh=pn6fR5qx7hMW56bGs9vT0EUFKebTMCC+VT7GsSaL92M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/Bff0FDHnjI9aXLKQdFcYVpURc03YF2koSISBNvtr4YHX8j6sjJLcC9t+iRfH/sQ
	 DBzqXssK/tjVTUAgswJdlEf+EQJkoIiPdcBZVtVphfq2sSe0VzupmjYhfIktKgIuLu
	 dEhnsBuRVNOmBw1Gt1PGrJWPpvq5aBSw/myV2xno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shiraz Saleem <shiraz.saleem@intel.com>,
	Sindhu Devale <sindhu.devale@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 133/195] RDMA/irdma: Validate max_send_wr and max_recv_wr
Date: Tue, 27 Feb 2024 14:26:34 +0100
Message-ID: <20240227131614.831300554@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131610.391465389@linuxfoundation.org>
References: <20240227131610.391465389@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shiraz Saleem <shiraz.saleem@intel.com>

[ Upstream commit ee107186bcfd25d7873258f3f75440e20f5e6416 ]

Validate that max_send_wr and max_recv_wr is within the
supported range.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Change-Id: I2fc8b10292b641fddd20b36986a9dae90a93f4be
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Sindhu Devale <sindhu.devale@intel.com>
Link: https://lore.kernel.org/r/20240131233849.400285-3-sindhu.devale@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 01faec6ea5285..0fbc39df1e7d4 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -762,7 +762,9 @@ static int irdma_validate_qp_attrs(struct ib_qp_init_attr *init_attr,
 
 	if (init_attr->cap.max_inline_data > uk_attrs->max_hw_inline ||
 	    init_attr->cap.max_send_sge > uk_attrs->max_hw_wq_frags ||
-	    init_attr->cap.max_recv_sge > uk_attrs->max_hw_wq_frags)
+	    init_attr->cap.max_recv_sge > uk_attrs->max_hw_wq_frags ||
+	    init_attr->cap.max_send_wr > uk_attrs->max_hw_wq_quanta ||
+	    init_attr->cap.max_recv_wr > uk_attrs->max_hw_rq_quanta)
 		return -EINVAL;
 
 	if (rdma_protocol_roce(&iwdev->ibdev, 1)) {
-- 
2.43.0



