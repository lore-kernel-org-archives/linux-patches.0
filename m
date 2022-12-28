Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B711863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9955EC433D2;
	Wed, 28 Dec 2022 15:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242515;
	bh=TCMoROXGKoCTP8SYU5/0uHkBdWIOXp8jn1WaNk2fkQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZrKq6dhxws6fB+c4hf//sfaWsxtSx5W8D257WeMy3sGckRfbjC+Fdff7GEQBwxzs
	 Ndk/TcuDweYZEs2RAVe0CqQKAQSAx2yaEBKnbTJdukVMsiK/9H2UTw8LEMTVA4DZBT
	 BsZL2np5ibKFSbnEOupnaPK+PS9IjDhj6Q/Sh7Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 612/731] myri10ge: Fix an error handling path in myri10ge_probe()
Date: Wed, 28 Dec 2022 15:41:59 +0100
Message-Id: <20221228144314.273400084@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d83b950d44d2982c0e62e3d81b0f35ab09431008 ]

Some memory allocated in myri10ge_probe_slices() is not released in the
error handling path of myri10ge_probe().

Add the corresponding kfree(), as already done in the remove function.

Fixes: 0dcffac1a329 ("myri10ge: add multislices support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 052696ce5096..97c2604df019 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3923,6 +3923,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	myri10ge_free_slices(mgp);
 
 abort_with_firmware:
+	kfree(mgp->msix_vectors);
 	myri10ge_dummy_rdma(mgp, 0);
 
 abort_with_ioremap:
-- 
2.35.1



