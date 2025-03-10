Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5026817CA12;
	Mon, 10 Mar 2025 17:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628899; cv=none; b=GDPz0qAyQw5jN9ZVTag3HiUCdxIipv0BXZlPpP3AYl6GhiE/P2JCrjxCCBHWIkYZxmnIyYsQeSHmpQyT4rpIi4IgScj7RtDYs5Ix/axw3sZ+dux5bbZCy+0BYCFwTaEq39BLnIeLBMfq1DZu1U/2Jg/+ONuhyyOnIyDQYSGwZKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628899; c=relaxed/simple;
	bh=aYL4eIS2+Dxg90XK7kCyXKvZXSy3+egxZGyQwt36mTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdloNlrDLT2DRCNLoiQskI9aU/LXjw830OLDve9x6zITjIc+OllDPkuNQc6LhPSZ2HNA951OuHXIkv1RhO6OdQxgMTBWJ3EeNz+nmzIqmNq6ta4UZN/1y04fwXglBxJ9j7QISk7cXXndHnG7+pnYUhMSob8Noo2AR0rl1MelWEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfjh2g04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfjh2g04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1658C4CEE5;
	Mon, 10 Mar 2025 17:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628899;
	bh=aYL4eIS2+Dxg90XK7kCyXKvZXSy3+egxZGyQwt36mTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tfjh2g04p97rU+hoFQZC5FkrCKnMehp+AP9f9BghZ8G8eodE0IZuXylJAJ6i6WGUB
	 7svWHNCPmwa+cS3W6fkt4kfoswpcIGpu156Edujk5qbS8yXNoyZqWuc+1Au2xnUYGY
	 nqdZUYFNgvpuKqpl7Yv/fl/B5WJiKgEI3qA+MvzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 106/620] rdma/cxgb4: Prevent potential integer overflow on 32bit
Date: Mon, 10 Mar 2025 17:59:12 +0100
Message-ID: <20250310170549.789132695@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 541dbcf22d0eb..13e4b2c40d835 100644
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



