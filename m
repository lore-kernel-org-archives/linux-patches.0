Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAC16FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9824C433F0;
	Tue, 10 Jan 2023 18:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374678;
	bh=+MmWXyScwihFAttHuGDWqF/Q9yULNVEkh5ChxsCHQXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UuSIFIr8BkrKgU9TmNrqmUJtTNVOiIMYSjXTT9ZijtMwtpiP5945JNDfaGTrATdl+
	 85CLTOJuetYP+NAg/uhwLJTIydHX2A3w82ngZ/J2zf81i/299APUn7xI7Os6OuzCDF
	 efZqDFqYuHgQTTuY31Shpf9pcsCyfxLziA0ykJhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Agroskin <shayagr@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/159] net: ena: Account for the number of processed bytes in XDP
Date: Tue, 10 Jan 2023 19:03:37 +0100
Message-Id: <20230110180020.497068448@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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
index e313bb45319c..69f2364b8468 100644
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



