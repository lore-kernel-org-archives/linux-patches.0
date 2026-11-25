Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622853;
	b=o725Z05P+txrRcDHR9aHOFMn6Q2AnsQHJ9J8FOvyoTL+8XRsK4jQyLA7shwofchiKJUw
	 ruVPGN8qCVJkjUtpP3sfG1H+bwtMbb6hEiSGbxlKu22Zf1MgzW2TwzuObEAYDwP5a8Fr+
	 q8y1sE136E3Iy3wDmksoRkFOpel/0+XSRq9gEIyj90HkQNi1bR78IjE25xp/37rI4zbAo
	 ytEmgVtANgwC0u9AWgYYqMy7OMn72ePbLHxbxY8cxhHV1w36qxv7darx1Svfj2+6SNBz3
	 Pmtx86UrGTR0hOueB2ewF4Cz6g8wuDS/3opA+PPIm4eABYygIdZbkvE02MC5Oy6zECg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622853;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uJtw+pGcOfXmt/ZuVg77uV965rgSe+ngjlSZzOL2FwU=;
	b=GE4/dBUkSglhk4a7Vs8FaB+sv8sm6kKkSfWY0ZSm/6EB33NQjG4P1nyDp7c1r0hm7Pya
	 Tt7qIck36kkvhJZisC1XlND/MUpnHAh3yXe/C35m37s6Gl3/J7WR5V9woo4NMpybHhJtN
	 EeZ0U/zTvCHMyvLrIwTONU6DhumZuZTiOTOx31KE5ZhfbCpUsPhIc0yYoDwCnvXSQerf7
	 ZUeCrM2MuEBFex0aIA+LxlNfhpalqYJZLzC57SOTEslSHzXyVdOKnR+Gy8yo7RI19gjob
	 gehmb0CJItxwiL47IcrKRR0y12ZVfDykmEYa+URMrZUaibeag9JpeA17pkxx9SSRWhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rxCSpS7E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5C1606A31E;
	Wed, 25 Nov 2026 16:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rxCSpS7E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7281F000C4;
	Wed, 25 Nov 2026 16:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622853;
	bh=uJtw+pGcOfXmt/ZuVg77uV965rgSe+ngjlSZzOL2FwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rxCSpS7EvBA2eaX8zRX7u/+pV+AYICtwfx0vtD9TQhB9si2SXDrSh20UibCEzl+as
	 6mXO1/v6+JR1CXO3zBIZBz1+itsVSBYFimq0M8n8rkGw4cRVqIUxzw6zCxk8Up4Nz0
	 cO3FPXesGWDtCQz3MTtEl4Zxql48H+vNM3hmJ21w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 643/990] blk-mq-dma: initialize the dma state for P2P, too
Date: Wed, 25 Nov 2026 15:33:30 +0100
Message-ID: <20261125143837.152780514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 035236c9e135a2ce7d0f68cb56e63d4a3da2abe1 ]

blk_rq_dma_map_iter_start() promises that the caller need not initialize
the dma_iova_state, but the P2P bus address path returns before it does
so. The state then holds what the last request with that tag left, and
blk_rq_dma_map_coalesce() describes a transfer as one IOVA range that it
isn't. Clear it on that path too.

Fixes: 858299dc6160 ("block: add scatterlist-less DMA mapping helpers")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261028164415.1262013-33-axboe@kernel.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Kept the existing P2P request-flag code in the bus-address case and added the upstream memset of state after it, before the return. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-mq-dma.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index b7c26599f6b05..fef1448453f88 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -177,6 +177,8 @@ static bool blk_dma_map_iter_start(struct request *req, struct device *dma_dev,
 			bio_integrity(req->bio)->bip_flags |= BIP_P2P_DMA;
 		else
 			req->cmd_flags |= REQ_P2PDMA;
+		/* don't leave the state of an earlier mapping to the caller */
+		memset(state, 0, sizeof(*state));
 		return blk_dma_map_bus(iter, &vec);
 	case PCI_P2PDMA_MAP_THRU_HOST_BRIDGE:
 		/*
-- 
2.53.0



