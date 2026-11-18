Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049722;
	b=O/K+NRAWlTt/7dh1xspMKmpPSVP1GvjKfRMMa+agnjWWBI0+SFbQWyvLotQS71Z2MxiU
	 XicCFZB5IzOf1FE8cVa4mtR+cijxJdQdxzJY/Zg3apwqmH9xnJuHdgZH0cd3OO81r30uJ
	 7pzTrZyg0rbLauQHKH6mWaFVlGy+3qnwB877frVF8geAq5fcDujQBAhIKIFwddnSs45xV
	 ziJcTI2e5hUpbfibvbTm0X6MTfe1QPyrsEUqFjudZThHbEp1kcFB91rPrLw68J6heulYr
	 xPCiN9JiSjW1NXTXLSzDXPMmR1C7nMJPGT3pwSNCc2ccFe+UAgSy6bFCEOUSPI1D3Yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049722;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0Q9PBgitwfuKZvmuXqinIlxG4ythi1S+sVpJcXcVWUU=;
	b=49TtIpNGdKolfQIriejY90F27zgh9by64Z02glpDjsmp/QMrz/OPzWM+/2xS1NkK2LXp
	 e3xRJqogTqLss9jsP3ReH8hLo7Oxm5V9Yc/er+lMqd0c2kv/A1aaZJ1ETgekMpGWhWRhL
	 VUGrYgw9AiJCbJlyA0iEFx19/BcyTDj6J1x0Rbd82AioB5OwUQMXoJo0OCttIQDjKFibJ
	 DqqsyZtxJzyQqUd9Arlg3F+/hnGj/s0BqkwMeSXiQbW5jLGVl7OoDbBsk19WPqO1v5a3k
	 blRnRie2b6KBwU/VKWGFVfbPZngkBVesw1bk4zgNgD/faOSFLh+jmKuG7i9mc8O9iMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hubPLcDa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08249606A32C;
	Thu, 19 Nov 2026 00:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hubPLcDa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504C91F000C6;
	Thu, 19 Nov 2026 00:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049721;
	bh=0Q9PBgitwfuKZvmuXqinIlxG4ythi1S+sVpJcXcVWUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hubPLcDakqtYjKXDB1qdopkcInKMLIlu2fKLKmabo1hCc79PgRCnqff50RyXRGAyo
	 cQmer9v98Tdf4oUz2+NJ/XFXV0LRkK1Y+RH/m9WYLl03Aa5OqZcD0lZ4IFppq8jzp4
	 Lt5gdE+BEvFf4u3x80B44FMUgHFyNQbbf6bra2EY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2412/2857] net: alacritech: fix dma_free_coherent() in error path
Date: Wed, 18 Nov 2026 15:57:26 +0100
Message-ID: <20261118150328.391540338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 05b5019b01fb9443b09ae4ed34af1135a80a84c8 ]

In slic_init_stat_queue(), a series of coherent buffers is allocated
with the length size. The size is then stored in stq->mem_size for
normal deallocation. However, in the error path, stq->mem_size is also
used but is not initialized. This error may leave the freed buffers
mapped, leaking a resource and allowing the device to access freed
memory.

Change the length in error path to size.

Fixes: 60c140df15db ("net: ethernet: slicoss: add slicoss gigabit ethernet driver")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261006140912.50828-2-fourier.thomas@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/alacritech/slicoss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index a30d0f172986b..d40469f7077ff 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -813,7 +813,7 @@ static int slic_init_stat_queue(struct slic_device *sdev)
 
 free_descs:
 	while (i--) {
-		dma_free_coherent(&sdev->pdev->dev, stq->mem_size,
+		dma_free_coherent(&sdev->pdev->dev, size,
 				  stq->descs[i] - stq->addr_offset[i],
 				  stq->paddr[i] - stq->addr_offset[i]);
 	}
-- 
2.53.0



