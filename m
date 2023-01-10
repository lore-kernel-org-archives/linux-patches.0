Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D37A93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:09:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57294C433EF;
	Tue, 10 Jan 2023 18:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374159;
	bh=FcAj2FarXm5gjArZUq0/nC/esaoT8AC8MIaAPulYAxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B99s3aDX/o3sDmi3j1ENyvCSfanvO4BzhDKqmsH+rgvqu74D/bMXkpg9YcWXgcCYr
	 +rExv5g6BMUJsCGa2Udg+0iHLvcD95R+WEJ+m53cYEtYgNly2B+ynXPf+dHCLonx00
	 SE9LSXciYhQ+pa/gTvjG+d7R2X/JfaaZJrvp2shk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Agroskin <shayagr@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 066/148] net: ena: Account for the number of processed bytes in XDP
Date: Tue, 10 Jan 2023 19:02:50 +0100
Message-Id: <20230110180019.319890345@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit c7f5e34d906320fdc996afa616676161c029cc02 ]

The size of packets that were forwarded or dropped by XDP wasn't added
to the total processed bytes statistic.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index f4ee8671b738..614f27f18164 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1719,6 +1719,7 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 			}
 			if (xdp_verdict != XDP_PASS) {
 				xdp_flags |= xdp_verdict;
+				total_len += ena_rx_ctx.ena_bufs[0].len;
 				res_budget--;
 				continue;
 			}
-- 
2.35.1



