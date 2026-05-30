Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF06A3148DA;
	Sat, 30 May 2026 17:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161052; cv=none; b=OPGAXg1K3+hm+xl/lZEDLOc3khCGCbVQHRXsmN12T+Qqk2V8PeLA22ZD6SHyNiV63Uh/52PARTuNoyYQOrDg3Jcbf5l8uAdMuB27PN39ZS4ZRqZj5MYinBTnZ7qkpScJXmxxCB874gC1P9eb/3hC7B3YmHdkv7lr4FQh5gikTK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161052; c=relaxed/simple;
	bh=eA2LAAmzMx6RFyZEgkxp7f0H0ie/s7KnRMXdJK7tdt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OJH6lA86XyMrtKAZs3AqzB6eZtgpkGDOOxL2V4VmQ4LKJyEz1zVEN8CrjhDvScl7PnBDhz4kt/RRwAtFpr5CoOCYGmFCXpvEwxOCMagDfWXsSFKj6vwetzLov24GrUYGt2TsrQ51pxhlItdnWpVHxjhzVmyBj85P5fE4OZDhByM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rHZwTqLY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rHZwTqLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 269F31F00893;
	Sat, 30 May 2026 17:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161051;
	bh=Uiv9YqIhEdJrf335en/8i5kWcJ0zIWWxUa/Xqf+eOiI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rHZwTqLYuXBvjpezU54cVbOpoUspXdENhK3enn2t85oi8rbu2eU7+Pd1SM7q2JqRP
	 jQ6YiiVEQHYzajAFUIod4STrtdpkdkPBZBHpt+1qXRNdetLnU/5CFVU5JJq56gX70C
	 rhVY9qawXd4D6H9T2bVWNkM0Ibmm0+GGsF4oQFmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 512/969] spi: hisi-kunpeng: prevent infinite while() loop in hisi_spi_flush_fifo
Date: Sat, 30 May 2026 18:00:36 +0200
Message-ID: <20260530160314.475055739@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 9f61daf2c2debe9f5cf4e1a4471e56a89a6fe45a ]

The hisi_spi_flush_fifo()'s inner while loop that lacks any timeout
mechanism. Maybe the hardware never becomes empty, the loop will spin
forever, causing the CPU to hang.

Fix this by adding a inner_limit based on loops_per_jiffy. The inner loop
now exits after approximately one jiffy if the FIFO remains non-empty, logs
a ratelimited warning, and breaks out of the outer loop. Additionally, add
a cpu_relax() inside the busy loop to improve power efficiency.

Fixes: c770d8631e18 ("spi: Add HiSilicon SPI Controller Driver for Kunpeng SoCs")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://patch.msgid.link/d834ce28172886bfaeb9c8ca00cfd9bf1c65d5a1.1773889292.git.xiaopei01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-hisi-kunpeng.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-hisi-kunpeng.c b/drivers/spi/spi-hisi-kunpeng.c
index 54730e93fba45..06c8893243b7d 100644
--- a/drivers/spi/spi-hisi-kunpeng.c
+++ b/drivers/spi/spi-hisi-kunpeng.c
@@ -198,8 +198,18 @@ static void hisi_spi_flush_fifo(struct hisi_spi *hs)
 	unsigned long limit = loops_per_jiffy << 1;
 
 	do {
-		while (hisi_spi_rx_not_empty(hs))
+		unsigned long inner_limit = loops_per_jiffy;
+
+		while (hisi_spi_rx_not_empty(hs) && --inner_limit) {
 			readl(hs->regs + HISI_SPI_DOUT);
+			cpu_relax();
+		}
+
+		if (!inner_limit) {
+			dev_warn_ratelimited(hs->dev, "RX FIFO flush timeout\n");
+			break;
+		}
+
 	} while (hisi_spi_busy(hs) && limit--);
 }
 
-- 
2.53.0



