Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0725B2D5926;
	Tue,  6 Jan 2026 17:32:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720754; cv=none; b=o2w+FLiCHV7YVdaci6KW/0RVzIp+XZulNnRoPkl4A/B5D+9UzkfZ3TGnmwh7LH42h3RZp0H0n+F6hjxRCp3mt2LAIEGKg1Fnc2bkx/wY+IlMWOvJlTii9zRXLxUAQQGzigt6hz+vgapk0H2D2Yki6SgYHTN51Y+YCExBJ/33I4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720754; c=relaxed/simple;
	bh=nzdaOeZeHsy1wFs5Sczfg/+gHYa0I6QlVITwg5qPvS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnOJJKzEEX5iRTMv46LFvh8SwJlIxg2Z3miwcYhnw8bmO0RUhua/avPA9YMDIvu8yvrJ0PXBZGDxvemBM5acUWut+gM5394ko4jrqy2X+4cttpCYhpXA324t8xDAsBCtCh8kxjgL3sqom+LS/fBU4RJtEso7+VqU6i0i2wQlNYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jpW4CXub; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jpW4CXub"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521A2C116C6;
	Tue,  6 Jan 2026 17:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720753;
	bh=nzdaOeZeHsy1wFs5Sczfg/+gHYa0I6QlVITwg5qPvS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jpW4CXub/PUNDukwM9t2et9G/1hP5+YMb6bAWPYeqEY6g2efQ1FUd1k1N3RB9Z24p
	 GGAvMs2cAKSjkxHwBCdof7E15lecbbvhDUPCuU2YroS2F5jPaBf+nM92yQaNNZccIH
	 zyAu5ClwyGk/CnMfYdrfhy032BwL+PtxTq7s0hb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jang Ingyu <ingyujang25@korea.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 332/567] RDMA/core: Fix logic error in ib_get_gids_from_rdma_hdr()
Date: Tue,  6 Jan 2026 18:01:54 +0100
Message-ID: <20260106170503.613819903@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index dc40001072a5..8dd96dc98fd3 100644
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



