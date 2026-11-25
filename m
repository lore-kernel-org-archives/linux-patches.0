Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621019;
	b=b59PaJ2/KZxeHLRHdkJMU6gnOmDPeUkjn+f6GtVOy/nmfx0lIAUbYHJbNVF9a0/HZi7I
	 ut9BdNxqUyA7VB+EgEWbY+YXfJgTBzu0GllRrbf9+0tKM0Ii/dWDmTO60mY6jsTAg2fSW
	 8QSF4X8+fYQl8yFnnCedVlvK0A6AQM4b/tUHqk8/Ntrh2oFG1v73KsImLKuqAX5TV28tm
	 88c/tK3+DgybgyMUaMcKmqTXRaNY7kwRZVpNoL8klfzwse9/yNvfUs6gmS7gY2hQ7NSik
	 VVna9jS8GXZwnTIG71Vp/x+h/8TlidXXLlNKQnKH81UMztdr+zsYtKV8lIxYmCnn4eQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621019;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q1w+moQGwqXzRsW/yKX+AFJ4m63WVy2OIwIz10Oim90=;
	b=KMuUObJ85M6LhsXAS5bfZEjVlRVpFk8pzY456wflYo+2H58PPTzZAoLiEnal9A52vNnj
	 KgJKq0ycv0zZa7POOdn82URJ+O7NT6i1/BwtLkay3p3zSQt/+RWQUJghes5569S/7BoEt
	 mrKsAzNcz1saZTk03Ik5KtZfPtoTcwA06BgUOK3/ZK4euGoLu89jTMFddHvqprmCQjwE/
	 CIGNMMnnNWYSSj20VhbZTHVkjUOxCLAd6WXWNyoJCAyfj2S/w4QlkQqR/TCzk9B5M7Ql1
	 td6mYBnjC9qNMT/U+B84d7zdvN3ak6dlyXZDaA8XKegpUA5BnwFRRvxRSP6thzUOM6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZljJWX4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F4B606A684;
	Wed, 25 Nov 2026 15:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EZljJWX4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 788711F000E6;
	Wed, 25 Nov 2026 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621019;
	bh=Q1w+moQGwqXzRsW/yKX+AFJ4m63WVy2OIwIz10Oim90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EZljJWX4D5cn8jnY2hHSF7/DarW9JjpD3L5iJdItwN4wX4rqs/iZUytpcG6pmGDot
	 sYdE4av1PnXe4EKXA0aZf/ukZZsi2CK9m5HVP6fq689UDnJzsrjaISIsBQdxKM9iCs
	 4uPqb3Nlek+i8TPSShNbG95IyuCQwxamnGF2iHR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 094/990] net: ethernet: mtk_wed: fix reset condition for rx wdma
Date: Wed, 25 Nov 2026 15:24:21 +0100
Message-ID: <20261125143824.291829606@linuxfoundation.org>
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

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit 7180a42d8e616f919dcff4b90a13b9a5ecea665b ]

In mtk_wdma_rx_reset, currently only resets the CPU index of the rings
that doesn't have a descriptor. This is wrong because no descriptor
means the ring is not configured.

Also mtk_wed_start makes sure that all rx_wdma rings are set up this
would lead to no ring getting their CPU index reset.

Fix this by inverting the reset condition so allocated rings will be
reset.

Fixes: 4c5de09eb0d0 ("net: ethernet: mtk_wed: add configure wed wo support")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260724172040.1653-1-hujy652%40gmail.com
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20261026-wedfix-v6-2-a52f6b15d2fc@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index 04a8da8cb3c51..202ab2f34d56a 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -257,7 +257,7 @@ mtk_wdma_rx_reset(struct mtk_wed_device *dev)
 	wdma_w32(dev, MTK_WDMA_RESET_IDX, 0);
 
 	for (i = 0; i < ARRAY_SIZE(dev->rx_wdma); i++) {
-		if (dev->rx_wdma[i].desc)
+		if (!dev->rx_wdma[i].desc)
 			continue;
 
 		wdma_w32(dev,
-- 
2.53.0



