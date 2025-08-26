Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2FE33469F3;
	Tue, 26 Aug 2025 11:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207893; cv=none; b=N30coHvgW9WfoQcu5HPqY2GC5cQtuI4PsiVviQ+thUxsxFDNaULB4lVpPe9kgghVwTtoFO42x+ImQbJqM2U4+H3aPNN+eMu5OONQuf6jHDMN+icre4Nkcxz9D3X6b1tkQjJ/3rj1CQmx3tGQZwuN8DgPTveKcOSNuPl51Ukyx5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207893; c=relaxed/simple;
	bh=51rFeIc63jbNIZ84rDCzmQi9XyVHuPeBzU2jFq9CuOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHoToIsXGwNdu+TSZU7MdSRmWntNZYWHk1GvfJyeMQgVdqi92ztwxru6r9PvETnvEIQb0CrNeUFeu/YZhgptV+76TYeigL2mbMojFYaL7IzS2hA95quo0rGrKWXx2mv+t0/wv8v7jDqfPuMBeI39CmydqWAgdG9xTRALrk9kqow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fn6gLArt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fn6gLArt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74163C4CEF1;
	Tue, 26 Aug 2025 11:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207892;
	bh=51rFeIc63jbNIZ84rDCzmQi9XyVHuPeBzU2jFq9CuOU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fn6gLArtmt8P5ai7fu8R7onMREh86sbN7E6yyXy7ZDXWa5mD35RFWAVyEdb3ECavn
	 nDdT3vwxRwQKXw9lKs4hnlXnAkYU5X3qfrEdrjLte7heWvq6m5L2IKs72WjP2CMJwx
	 V0DjsHPbBe+SEkqmfBvpj848Mg8f+SzqHu60M/10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Xu <chengyou@linux.alibaba.com>,
	Boshi Yu <boshiyu@linux.alibaba.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 358/457] RDMA/erdma: Fix ignored return value of init_kernel_qp
Date: Tue, 26 Aug 2025 13:10:42 +0200
Message-ID: <20250826110946.161572770@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index ec0ad4086066..c1b2b8c3cdcc 100644
--- a/drivers/infiniband/hw/erdma/erdma_verbs.c
+++ b/drivers/infiniband/hw/erdma/erdma_verbs.c
@@ -1031,7 +1031,9 @@ int erdma_create_qp(struct ib_qp *ibqp, struct ib_qp_init_attr *attrs,
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



