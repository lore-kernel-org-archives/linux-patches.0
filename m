Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DE9B13D896;
	Tue, 23 Jul 2024 18:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760199; cv=none; b=AoNStOKGzuyBxIQourtCc4hDNTzg2uiU/VeMnY46JoaOKlxRcwsoHTe5S92ODuYUgln2sAcrAURQhNv5u3KIvhlbC2Q/vBGo50v1HqoN4YjcMHbfoVy6u++V9+e0g+LrmdTR2uJrO7cZJiKHDOF9n2L5vH6K9QMMB2VwyihT+q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760199; c=relaxed/simple;
	bh=srLQwZ8iV59k4UgLhl0v7iVY32mAETWZ4nym1D/LgVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBlM2gQong2cj2jx4wKXbMcXZQu/06WnTO+Gx2bfP/pYCxK5dG3ivyvt5weEdkwGY4+v1xClbWQDRJkXuzCn9bxCQMAwVe6HjE9D11oDx3FOpNT5tEuCY/vttY/unfHNNKZuGU37V7d8ZjSWyzE7FkXTv6wLTCTgx1zwJnJRo2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ift4vosh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ift4vosh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A543C4AF09;
	Tue, 23 Jul 2024 18:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760198;
	bh=srLQwZ8iV59k4UgLhl0v7iVY32mAETWZ4nym1D/LgVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ift4voshyJ0qJZvbWRB6LmLcAiln2NUiy/nUYw+4mBQ/HEHQSbaL9LU+wy7TP5c0z
	 sH/CN10KLx1cY8cD2ovJHYIGvC7ctf+wrwZBn8zcMcOY+zQ+yKAX0/w/g9Hund1jVX
	 QNFWk+P9S8rD3XeTqSesipE7bb4BB11LHaLGt2hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 105/163] net: mvpp2: fill-in dev_port attribute
Date: Tue, 23 Jul 2024 20:23:54 +0200
Message-ID: <20240723180147.532353889@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>

[ Upstream commit 00418d5530ca1f42d8721fe0a3e73d1ae477c223 ]

Fill this in so user-space can identify multiple ports on the same CP
unit.

Signed-off-by: Aryan Srivastava <aryan.srivastava@alliedtelesis.co.nz>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index cebc79a710ec2..6340e5e61a7da 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6906,6 +6906,7 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	/* 9704 == 9728 - 20 and rounding to 8 */
 	dev->max_mtu = MVPP2_BM_JUMBO_PKT_SIZE;
 	device_set_node(&dev->dev, port_fwnode);
+	dev->dev_port = port->id;
 
 	port->pcs_gmac.ops = &mvpp2_phylink_gmac_pcs_ops;
 	port->pcs_gmac.neg_mode = true;
-- 
2.43.0



