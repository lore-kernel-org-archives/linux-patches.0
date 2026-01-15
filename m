Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5B02D9494;
	Thu, 15 Jan 2026 17:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498238; cv=none; b=XkuiTpwlpL7t2aMVfeza1ydfACABkBvNNbawDG/3/Tb/1/uHfwNSB+kbXer1o6n3OOc+sxmIgxPQirhyrc2eYhGIzO4WWiYZffhlvpBkPcKCho8qS0bbutIsz7G9YLJNLPzyp1n5knN+abn0Ka9Xf+wUh0KubQ4PA8gnJ8Y5NjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498238; c=relaxed/simple;
	bh=SoaIHgQDPin8BpuGPFCdhF5OFWVpW+zleeHigZbPWQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3CLUQQ7ksoW/U3uKgCCAccxygpV9Qj/q+v6UT3JPCDtsw+0BdIvdqiUZ9hjCR5hFJZeVFe55was7GfDzvC7sIxpMH8B8dv6zTl/TCD0F4NXhjP2324zu0LkrmbfULR8Ha9tDkcYT0YVJce8Zose9J7z5OhVp6FzLbHt0TumNPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltefft7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltefft7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD269C16AAE;
	Thu, 15 Jan 2026 17:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498238;
	bh=SoaIHgQDPin8BpuGPFCdhF5OFWVpW+zleeHigZbPWQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltefft7QWIAIVMc7fal0WykQ2Crl4yDTnPwFeHrrB6r/sBhNqiM2VbzioXgg61Rc7
	 /9Fxarg2yxKYzuvlZw7cxY02ANxj0SAPVedgbwAkz0GwpmLCuVImfs0q8duvYPAtoF
	 3xE6F8dnTluNa9r0WUnqIMJ7S2zcOwwElr+L5V/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jang Ingyu <ingyujang25@korea.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 362/554] RDMA/core: Fix logic error in ib_get_gids_from_rdma_hdr()
Date: Thu, 15 Jan 2026 17:47:08 +0100
Message-ID: <20260115164259.330596431@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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
index bdc9564f0ff8..53552559917c 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -740,7 +740,7 @@ int ib_get_gids_from_rdma_hdr(const union rdma_network_hdr *hdr,
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



