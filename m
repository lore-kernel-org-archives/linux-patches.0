Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC77933D511;
	Fri,  9 Jan 2026 12:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962629; cv=none; b=kKOnXSWfnv0Hf4rhaWRIdwH0wMyzjE7ZAotsmlDpSH/GLO0UWp87k0KqpApy0X2CpIOsn7PHe6eSS5LMgR/9PQbuiymlF/iD8tV+cM3dNGLMvXvRc5eLHvWc3yokm/gyjUfUSJMpybv0eESDwmKq8XdC2NI4YEN/yzKwDShV708=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962629; c=relaxed/simple;
	bh=85pUWt99SvTJIXHCGnIi+Sj/zFQWaz4KN1oFlNFutfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjO28fnWutZq5fYmma6pC8taclKMmbvc4R7C0LIjYByg+nIQOI+85ik1Ayp/yZUpF2NUcyM1boSMui6Mi9Kmk96+tdegEm8wcE/hGXn6jAjcvI8gD2Om4/9Sy3h4fcFkf/bNn+ZZnm3uDVdW1qPpMzXZJRJEZaTMjJPHLyObmWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E9yBAo3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E9yBAo3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781BDC4CEF1;
	Fri,  9 Jan 2026 12:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962628;
	bh=85pUWt99SvTJIXHCGnIi+Sj/zFQWaz4KN1oFlNFutfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E9yBAo3jFTMmnModQlnBeFt/ce8RuNbvtsAKrZ2xA0KThQSsCojYNcAgRu/5O5O/a
	 clyASK1ZcGVCzzmqTngRgK33/ZDCyPzK7I5zh4vMRNLdXztIyekRLnKTazr/afky99
	 KE1FxUIX0wy7EIlfsmC6wC6p7C5zI8gqepmYw3Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jang Ingyu <ingyujang25@korea.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 433/634] RDMA/core: Fix logic error in ib_get_gids_from_rdma_hdr()
Date: Fri,  9 Jan 2026 12:41:51 +0100
Message-ID: <20260109112133.837061133@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 97a116960f31..d0c8ad45f3c2 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -732,7 +732,7 @@ int ib_get_gids_from_rdma_hdr(const union rdma_network_hdr *hdr,
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



