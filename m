Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353C61C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9E8C433D2;
	Wed, 28 Dec 2022 16:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245999;
	bh=iEnE92SLTgM8ZrAJ0JBLwuGFmy2fEuNEkWwiceKkZXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PwZebmZiRkK43TbyL/P2+8zBG8k1L1YT0CyRgNwG0eXThWbjmCOa4HFxIDEjGRHcA
	 PgmBU36fyjpqlp7sufJwz/Y9dvwRff+Gn+Oz+zGOYHltgb0lbo5knIjO4hQJ/1AT1W
	 2DxiQFR5TMT5RgDqASpVpDYSrUOCEaW9JEvrkOas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0929/1146] myri10ge: Fix an error handling path in myri10ge_probe()
Date: Wed, 28 Dec 2022 15:41:08 +0100
Message-Id: <20221228144355.515000010@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index 9063e2e22cd5..9a9341a348c0 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -3913,6 +3913,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	myri10ge_free_slices(mgp);
 
 abort_with_firmware:
+	kfree(mgp->msix_vectors);
 	myri10ge_dummy_rdma(mgp, 0);
 
 abort_with_ioremap:
-- 
2.35.1



