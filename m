Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F54355031;
	Tue,  6 Jan 2026 17:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721779; cv=none; b=rchheiJfIVaNbNPf1WGkb5zzK523xnEO8nEL9r3CRpNNJRRmWV0IeluynfXinKbW8Z+EJklHhwgLy+KEqfjGAr5btITWQIDqa4W+dd0S1fM+9Z6RrKfe8/N7iZxgGroRv74RQhVdupYWMEtD2k5zYAjs8zSXq5glPVydItKQcU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721779; c=relaxed/simple;
	bh=7kw9ys6Kph7AP3PekCvsuIBl7Zlmdv6kUvbIx96szDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E99X6WRQVp9NaZR3oxXV2aY9VeeWB8B1JhIOkmJr63TT4JW5SaRAcUfhdo5YkZw7ZYHQSTQ0xfXQh9ZbgUXIwJXUwklzxfzhgA68AudXTbD0SDEtaO+jglK0ZglHrKAso+/vh8TGd02rza348piRwTDi/5pLG1iciWjMjT9Dwcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IBjmUP8s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IBjmUP8s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717DEC116C6;
	Tue,  6 Jan 2026 17:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721778;
	bh=7kw9ys6Kph7AP3PekCvsuIBl7Zlmdv6kUvbIx96szDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IBjmUP8s98hDftTDA7QfBZGh//HiI+iQqfcul6Nul9nZnc6xTdHH+O1GN2sS6WU+T
	 wWba5HlYyA6y5SAXXrnrIFjrPz19vFDGG7ZjmxkRyPjpNv7vFlPMBouOzShS0rOu4h
	 I3q6lnxTC8TIIrDAv5YMXsaG3Fzsd7VwwWsi1y4Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jang Ingyu <ingyujang25@korea.ac.kr>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 070/312] RDMA/core: Fix logic error in ib_get_gids_from_rdma_hdr()
Date: Tue,  6 Jan 2026 18:02:24 +0100
Message-ID: <20260106170550.381534963@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
index 3a5f81402d2f..d279e301f5a1 100644
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



