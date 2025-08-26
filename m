Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD9721D3C0;
	Tue, 26 Aug 2025 11:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208840; cv=none; b=flYuLOKaCwU4aDu/+Ym0a/PbwS6Dyi7y3hYh0NDgPhtUzmOEJpGrtoP3gu3a5JUuxQUlBUv7hj2EsiDsAhxepSFA6qqOxEuHNOJiY6RELWyZDO0h5+E9YtWbvJnIUJrEJ+4RfMHqh8mUXkvkbkXh5cAxtcEjKYSuDMQgt5Z/mj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208840; c=relaxed/simple;
	bh=wJZw7lckm9X3ZevmmA9/N3zlyNgoAd+C6DgrbB5Mufs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNdmFf+oqEl1GZH+OniGAJgYfdbJKtfdaXDxE1kAWjlLU+LotcRP6SngjNbQ2NHfcqzfWDXGYm81fSmLL8DPiBbn8CTwo9ggol4crT/yhn+qvs/VUkNkNuhRd8kYCdgtrnIy9Y72nJupVx7iG2Iyh/lqFhl2UEwQdzSUAVOyz/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPc1Qk84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPc1Qk84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F001C4CEF1;
	Tue, 26 Aug 2025 11:47:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208840;
	bh=wJZw7lckm9X3ZevmmA9/N3zlyNgoAd+C6DgrbB5Mufs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPc1Qk84zOLVOclbzbmj0FtKNgLw5q1RhYqExOAcLpGRZuY6OopsYkKI0QPlY3LFA
	 FUY7nrRDb+5oH3q0dSxkQF5umjwYzZdWHaRjppj+GNQACi6fbyABG05lRhBgHb75JU
	 mIzLn0zUYYJznFvV0wFJSt4qzgdTQ8BLTNxv6WX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Boshi Yu <boshiyu@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/322] RDMA/erdma: Fix ignored return value of init_kernel_qp
Date: Tue, 26 Aug 2025 13:11:20 +0200
Message-ID: <20250826110922.476044508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boshi Yu <boshiyu@linux.alibaba.com>

[ Upstream commit d5c74713f0117d07f91eb48b10bc2ad44e23c9b9 ]

The init_kernel_qp interface may fail. Check its return value and free
related resources properly when it does.

Fixes: 155055771704 ("RDMA/erdma: Add verbs implementation")
Reviewed-by: Cheng Xu <chengyou@linux.alibaba.com>
Signed-off-by: Boshi Yu <boshiyu@linux.alibaba.com>
Link: https://patch.msgid.link/20250725055410.67520-3-boshiyu@linux.alibaba.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/erdma/erdma_verbs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/erdma/erdma_verbs.c b/drivers/infiniband/hw/erdma/erdma_verbs.c
index e56ba86d460e..a50fb03c9643 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -991,7 +991,9 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
 		if (ret)
 			goto err_out_cmd;
 	} else {
-		init_kernel_qp(dev, qp, attrs);
+		ret = init_kernel_qp(dev, qp, attrs);
+		if (ret)
+			goto err_out_xa;
 	}
 
 	qp->attrs.max_send_sge = attrs->cap.max_send_sge;
-- 
2.50.1



