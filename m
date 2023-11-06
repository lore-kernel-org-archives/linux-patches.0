Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D07241FC
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qr3CkSAN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8377CC433C9;
	Mon,  6 Nov 2023 13:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699277216;
	bh=d6/FvLc5okqEnf0b/KTxRMqC4lmacV//kf7L86MXQvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qr3CkSANJem8ZfnwjNlaB8AsIc2ISv97+HPH+rliN34XMVeU77MdxNNX44MkbzCzV
	 CVYRWvu/v15LjTH3/7MjW3BarfpUidywTWvgVXe1twmHDGwJlvJcj3fmSHIhSuaJ5B
	 HCzPNNaPZ3fFuVrbbC71sNlex0cYjAg0ZF5WLtpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catherine Sullivan <csully@google.com>,
	David Awogbemila <awogbemila@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/128] gve: Fix GFP flags when allocing pages
Date: Mon,  6 Nov 2023 14:03:40 +0100
Message-ID: <20231106130311.816390951@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
References: <20231106130309.112650042@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shailend Chand <shailend@google.com>

[ Upstream commit a92f7a6feeb3884c69c1c7c1f13bccecb2228ad0 ]

Use GFP_ATOMIC when allocating pages out of the hotpath,
continue to use GFP_KERNEL when allocating pages during setup.

GFP_KERNEL will allow blocking which allows it to succeed
more often in a low memory enviornment but in the hotpath we do
not want to allow the allocation to block.

Fixes: f5cedc84a30d2 ("gve: Add transmit and receive support")
Signed-off-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
Link: https://lore.kernel.org/r/20220126003843.3584521-1-awogbemila@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/google/gve/gve_rx_dqo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_rx_dqo.c b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
index 7b18b4fd9e548..d947c2c334128 100644
--- a/drivers/net/ethernet/google/gve/gve_rx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_rx_dqo.c
@@ -157,7 +157,7 @@ static int gve_alloc_page_dqo(struct gve_priv *priv,
 	int err;
 
 	err = gve_alloc_page(priv, &priv->pdev->dev, &buf_state->page_info.page,
-			     &buf_state->addr, DMA_FROM_DEVICE, GFP_KERNEL);
+			     &buf_state->addr, DMA_FROM_DEVICE, GFP_ATOMIC);
 	if (err)
 		return err;
 
-- 
2.42.0



