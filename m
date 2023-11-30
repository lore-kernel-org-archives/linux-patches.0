Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E9B495C2;
	Thu, 30 Nov 2023 16:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRrUWL1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C80C433C8;
	Thu, 30 Nov 2023 16:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361486;
	bh=WLLTOS11P4/pAefPXYGiksEe2Jgu/wxOZivXQeX0Ajw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRrUWL1F+0dNlP8WZjjqnqUQqeNxyRzWxBniA+phrQbLcKc15T16VeZw6kn9ic0Xw
	 i1kzflfHPHnGVuI2gPSEPf19i14pPcokRQ2bv6x51Wrofml5bzNU7o7LbSEfjDnyiZ
	 ccb1paoVIlXJaHEKgh+Bs5uWYSomLusHzi36pWIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/112] net: veth: fix ethtool stats reporting
Date: Thu, 30 Nov 2023 16:21:29 +0000
Message-ID: <20231130162141.649037414@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 818ad9cc90d4a7165caaee7e32800c50d0564ec3 ]

Fix a possible misalignment between page_pool stats and tx xdp_stats
reported in veth_get_ethtool_stats routine.
The issue can be reproduced configuring the veth pair with the
following tx/rx queues:

$ip link add v0 numtxqueues 2 numrxqueues 4 type veth peer name v1 \
 numtxqueues 1 numrxqueues 1

and loading a simple XDP program on v0 that just returns XDP_PASS.
In this case on v0 the page_pool stats overwrites tx xdp_stats for queue 1.
Fix the issue incrementing pp_idx of dev->real_num_tx_queues * VETH_TQ_STATS_LEN
since we always report xdp_stats for all tx queues in ethtool.

Fixes: 4fc418053ec7 ("net: veth: add page_pool stats")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/c5b5d0485016836448453f12846c7c4ab75b094a.1700593593.git.lorenzo@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/veth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 0ee5d1e0759fb..af326b91506eb 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -236,8 +236,8 @@ static void veth_get_ethtool_stats(struct net_device *dev,
 				data[tx_idx + j] += *(u64 *)(base + offset);
 			}
 		} while (u64_stats_fetch_retry(&rq_stats->syncp, start));
-		pp_idx = tx_idx + VETH_TQ_STATS_LEN;
 	}
+	pp_idx = idx + dev->real_num_tx_queues * VETH_TQ_STATS_LEN;
 
 page_pool_stats:
 	veth_get_page_pool_stats(dev, &data[pp_idx]);
-- 
2.42.0



