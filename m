Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC19D1E1C09;
	Wed, 19 Feb 2025 09:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956323; cv=none; b=FDDZryq0zSjorkAR6aUeTGSqCtjhzklwagf3bOYsdRotR7v07fPFWdowVDKEndpqY/K82IcrlFoJ7Ay6A2fwPOn5z1K9gw42JH+yVstmVFYhCibGEjhoi0atXa8wEqvo2M8yV7dAHP8Ew/C2xml5J59vD5JDXbgAiWc+sbnssCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956323; c=relaxed/simple;
	bh=ByJNAcfTh9a5oZXEc9xL9tdEZu5Vj+AgZTvss4mj69g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJ6ejr41sgdcPOjetLDHdG4bXNgtPqCxC/hfpybwHNGInSPImql193eZOgMHsY8ceZPAI6SckpfahTLo9Z3mlKMHC8hWFJTo18KPs8OPy6sH522/ZIQ1H24RMKC+JeNLasR3enyVDilDyEF59Fx4hFLwXn96J+M+qbEdEbxovrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KoenKkNH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KoenKkNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348B4C4CED1;
	Wed, 19 Feb 2025 09:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956323;
	bh=ByJNAcfTh9a5oZXEc9xL9tdEZu5Vj+AgZTvss4mj69g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KoenKkNH+q4LTaQhP8X5v6oy82OqCwGp7Ba3G2PY7PbCZadF4noGQedeK3emnQ7Jy
	 dlGnVoozInqBYHTPOCPaBrBocLDqAR9QbM4XND/4JMjoQ8hfTXGDtyP5sEAwH9CRa2
	 3lPcP2eUVnCM7D10KuRDCFYGhRwuNIemew182Afo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 140/578] rdma/cxgb4: Prevent potential integer overflow on 32bit
Date: Wed, 19 Feb 2025 09:22:24 +0100
Message-ID: <20250219082658.493167574@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit bd96a3935e89486304461a21752f824fc25e0f0b ]

The "gl->tot_len" variable is controlled by the user.  It comes from
process_responses().  On 32bit systems, the "gl->tot_len + sizeof(struct
cpl_pass_accept_req) + sizeof(struct rss_header)" addition could have an
integer wrapping bug.  Use size_add() to prevent this.

Fixes: 1cab775c3e75 ("RDMA/cxgb4: Fix LE hash collision bug for passive open connection")
Link: https://patch.msgid.link/r/86b404e1-4a75-4a35-a34e-e3054fa554c7@stanley.mountain
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 80970a1738f8a..034b85c422555 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -1114,8 +1114,10 @@ static inline struct sk_buff *copy_gl_to_skb_pkt(const struct pkt_gl *gl,
 	 * The math here assumes sizeof cpl_pass_accept_req >= sizeof
 	 * cpl_rx_pkt.
 	 */
-	skb = alloc_skb(gl->tot_len + sizeof(struct cpl_pass_accept_req) +
-			sizeof(struct rss_header) - pktshift, GFP_ATOMIC);
+	skb = alloc_skb(size_add(gl->tot_len,
+				 sizeof(struct cpl_pass_accept_req) +
+				 sizeof(struct rss_header)) - pktshift,
+			GFP_ATOMIC);
 	if (unlikely(!skb))
 		return NULL;
 
-- 
2.39.5



