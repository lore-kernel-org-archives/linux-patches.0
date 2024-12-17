Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4AD142E77;
	Tue, 17 Dec 2024 17:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456098; cv=none; b=oluNdMjuylq57P6J7PAlxrWXC66rQlVJ4xP7MPCo7rKo3Jh6fBsSDYphCZwuTYl0fAym5MIoW/1LNUfpXOzzN57vUZeku8MaQ8yOZ5L01VkJf6y6Du+K2HwWJN72npyHhUh7i5Ejt9Lp4KMqKZa7RHL2jnhplxz/f+SwSOWS//c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456098; c=relaxed/simple;
	bh=Y4F6B1jEAYT+0TquyFKFdlHIh5AzcHkz548gyUtMt1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bid6iWfCBAhTMWlJfpp4PNuZluky3rSu/BmqNOakDN96KxaL3Egh6W8Q6BkYqTMbvs/f+KKu6mCHmtJ5N8ZT+lFcfd5Z3me1y3FxK3D6cVQ5hrwdFDeJtaGoQFw/RhH3rZJvHj0B/K3tDOn1ZXVhapqNi9Lw5j/XiAlJcT5hBUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ngCwpaVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ngCwpaVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68536C4CED3;
	Tue, 17 Dec 2024 17:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456097;
	bh=Y4F6B1jEAYT+0TquyFKFdlHIh5AzcHkz548gyUtMt1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ngCwpaVRfm0NsGo23dmkttzwnXWx/ghsT1sDKvd6kT9uZpvHF+Jrx6LcxMyGwvvxW
	 PlBDj/GMhW+yhEGYK2dVsVRKe4PGV88uIkgWWQTH8m7vUEphZvaeAwVfXLsmUb9m6+
	 TCv5zD/C/iduGFVuHW0YZLG/nXPsDGFNAm1BBDYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 059/109] net: sparx5: fix FDMA performance issue
Date: Tue, 17 Dec 2024 18:07:43 +0100
Message-ID: <20241217170535.836831897@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit f004f2e535e2b66ccbf5ac35f8eaadeac70ad7b7 ]

The FDMA handler is responsible for scheduling a NAPI poll, which will
eventually fetch RX packets from the FDMA queue. Currently, the FDMA
handler is run in a threaded context. For some reason, this kills
performance.  Admittedly, I did not do a thorough investigation to see
exactly what causes the issue, however, I noticed that in the other
driver utilizing the same FDMA engine, we run the FDMA handler in hard
IRQ context.

Fix this performance issue, by  running the FDMA handler in hard IRQ
context, not deferring any work to a thread.

Prior to this change, the RX UDP performance was:

Interval           Transfer     Bitrate         Jitter
0.00-10.20  sec    44.6 MBytes  36.7 Mbits/sec  0.027 ms

After this change, the rx UDP performance is:

Interval           Transfer     Bitrate         Jitter
0.00-9.12   sec    1.01 GBytes  953 Mbits/sec   0.020 ms

Fixes: 10615907e9b5 ("net: sparx5: switchdev: adding frame DMA functionality")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 8f116982c08a..98bee953234b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -693,12 +693,11 @@ static int sparx5_start(struct sparx5 *sparx5)
 	err = -ENXIO;
 	if (sparx5->fdma_irq >= 0) {
 		if (GCB_CHIP_ID_REV_ID_GET(sparx5->chip_id) > 0)
-			err = devm_request_threaded_irq(sparx5->dev,
-							sparx5->fdma_irq,
-							NULL,
-							sparx5_fdma_handler,
-							IRQF_ONESHOT,
-							"sparx5-fdma", sparx5);
+			err = devm_request_irq(sparx5->dev,
+					       sparx5->fdma_irq,
+					       sparx5_fdma_handler,
+					       0,
+					       "sparx5-fdma", sparx5);
 		if (!err)
 			err = sparx5_fdma_start(sparx5);
 		if (err)
-- 
2.39.5



