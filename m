Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79A53750CF;
	Thu, 30 Jul 2026 14:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423470; cv=none; b=GaTlWtXjK4RFTrO+d4GyJIlQYfKZU3ubhdANmdCVmvOafh1uKXsICgE/pzgHNnm0xoKofl3P5Gnzo1zyPF2nNlktb+9gra//LUhV259MhShKiqjmJmp844KJqU5Ap6qXLvc2mS3zHW7hsmLCR1CHB5dXriA/11JJTjHhdpG5T/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423470; c=relaxed/simple;
	bh=Sub+596cAxm1IYeBzmKrkFr4sHTX40Ld+NmwPyPlvJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhJ+naMp6lKLJTSsoM44xiWAHroUVIssZldI8iJKGNRyMv0N8Td6A0V/Chev8Mr+XTMaYFJC9QwNJy0YhrMxG03Y7dfrPXVsg08VhiJldlm3p5YKASV7hT1HK+XXj5R/yvb0xL9v4BwAmFqgslGt6zg3aNjlWy604IReidAvgFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbIKdc8I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbIKdc8I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F9801F00A3A;
	Thu, 30 Jul 2026 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423469;
	bh=KXjK0XzlnT9PRSUzbdfaS4n8UJg0+pnyfzg0nk0MHkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XbIKdc8IxnwU+ZlrLK9iX5iOjdjypC4U6wUB8IMusoLA5xVv76KFPAAfLdw1GwkVb
	 ZaRHcho5y40VjWLsWTQpW1uzmzIDXsJPrttFH826Tdyezw0JUbs0hT8MINoEsVZJod
	 KKTaSmARDvmuqj6Zmj1aCJz3wa+jxZ0wIS9Lq+Dk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Long Li <longli@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/675] RDMA/mana_ib: initialize err for empty send WR lists
Date: Thu, 30 Jul 2026 16:06:25 +0200
Message-ID: <20260730141446.287060188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 155fd5ce2382b0ffbec0d7ee7b3a6818a27a5aed ]

mana_ib_post_send() returns err after walking the send work request list.
If the caller passes an empty list, the loop is skipped and err is not
assigned.

Initialize err to 0 so an empty send work request list returns success
instead of stack data.

Fixes: c8017f5b4856 ("RDMA/mana_ib: UD/GSI work requests")
Link: https://patch.msgid.link/r/20260618041752.481193-2-ruoyuw560@gmail.com
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Long Li <longli@microsoft.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/wr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/wr.c b/drivers/infiniband/hw/mana/wr.c
index 1813567d3b16c9..36a1d506f08f65 100644
--- a/drivers/infiniband/hw/mana/wr.c
+++ b/drivers/infiniband/hw/mana/wr.c
@@ -144,7 +144,7 @@ static int mana_ib_post_send_ud(struct mana_ib_qp *qp, const struct ib_ud_wr *wr
 int mana_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		      const struct ib_send_wr **bad_wr)
 {
-	int err;
+	int err = 0;
 	struct mana_ib_qp *qp = container_of(ibqp, struct mana_ib_qp, ibqp);
 
 	for (; wr; wr = wr->next) {
-- 
2.53.0



