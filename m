Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1113D1CAA;
	Thu, 15 Jan 2026 17:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499625; cv=none; b=hLJAEB5uB7WHAR1lxsBZ3+zt3SCq+JOfm8pyc8tGpkyfEz00nbh3wP6ENV0OnWdAAiin/vGZfVDbFyZ/cW/Uyscq9K0uYx4XB9bcOx2Y0n5/IAr1BKMwidDXy2nA9K0aDdbVN2t957zbt5xvCOpvm/pgauopu9jKZ7Fma+XxOmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499625; c=relaxed/simple;
	bh=vV0TSHGiG5WVdUt+WqIYPWwjpFefm6oIHmlG9s5/HXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aICIJGOdSgzd2ibSbxmz8jrDg8a/0nv6eNUmf88SolbiPZIk/KlEXHWbJLfXel3AlpLXvrz9eG5iztGV0adqpz/cjmLL2FhPhO5lwHy3L/6CDMFgO0w/jLwwm27EfmCJtlS69qw7Zy/+z6s04q24M3TGAudBwrWeEn+TvtEDfS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JUbmnh2Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JUbmnh2Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7AAC116D0;
	Thu, 15 Jan 2026 17:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499625;
	bh=vV0TSHGiG5WVdUt+WqIYPWwjpFefm6oIHmlG9s5/HXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JUbmnh2Qauc0vA3cZJEDQJdcasEXjRXFmH6mQAlOvPPujDO6gKn76vnMpmIHfEWS+
	 /pGKOE6P3HqJwEjxsEVPBrcd7r734L3AtlL4oqnFsIAFSeytcdAmOvCdBOy6OIBlui
	 gouHra/Gqpq1HlJSez/8JQtDsJB+LwcC+iEyzurw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jang Ingyu <ingyujang25@korea.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 292/451] RDMA/core: Fix logic error in ib_get_gids_from_rdma_hdr()
Date: Thu, 15 Jan 2026 17:48:13 +0100
Message-ID: <20260115164241.444579258@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jang Ingyu <ingyujang25@korea.ac.kr>

[ Upstream commit 8aaa848eaddd9ef8680fc6aafbd3a0646da5df40 ]

Fix missing comparison operator for RDMA_NETWORK_ROCE_V1 in the
conditional statement. The constant was used directly instead of
being compared with net_type, causing the condition to always
evaluate to true.

Fixes: 1c15b4f2a42f ("RDMA/core: Modify enum ib_gid_type and enum rdma_network_type")
Signed-off-by: Jang Ingyu <ingyujang25@korea.ac.kr>
Link: https://patch.msgid.link/20251219041508.1725947-1-ingyujang25@korea.ac.kr
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 4fcabe5a84be..4a28f30c39f1 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -735,7 +735,7 @@ int ib_get_gids_from_rdma_hdr(const union rdma_network_hdr *hdr,
 				       (struct in6_addr *)dgid);
 		return 0;
 	} else if (net_type == RDMA_NETWORK_IPV6 ||
-		   net_type == RDMA_NETWORK_IB || RDMA_NETWORK_ROCE_V1) {
+		   net_type == RDMA_NETWORK_IB || net_type == RDMA_NETWORK_ROCE_V1) {
 		*dgid = hdr->ibgrh.dgid;
 		*sgid = hdr->ibgrh.sgid;
 		return 0;
-- 
2.51.0



