Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A181D0492;
	Tue, 15 Oct 2024 11:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993386; cv=none; b=tTeTWkbXtLxkUCRbgrT+XvQwuvRaRev2ANgwjN6ynj+k6CjNkfL9xGWQO7pbm4HiS1/AvcAkfY3hoP0FBk+j0iqNXGoPTTqieDakUwYMPyKbNS9KDw2VakcgPEVUNB1xoRXfCgggejumWjarGH0RkqQTg2aW/gJgZQ48oY+pz5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993386; c=relaxed/simple;
	bh=wHiOIXpx5bzS4L+gwWQrxzgwSZjTdxKzgUevH/yEhpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S5IlXp9DDoD4bWrpl3BmWlfQXogMsF5Eyz2+hqYRMFSWCuR9vA1tRtczbn/s+qKuCLChCns4IPK59m5fAiKQuZrPh4ZP/2fmaDYXEcOW0eTp1TzOJXp6ynuUwYyZ6Q041WOXVHN1BDh9xHzJY4/jthE+kl2UmonMnVahtXaaN0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqI3/RjE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqI3/RjE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B048C4CEC6;
	Tue, 15 Oct 2024 11:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993385;
	bh=wHiOIXpx5bzS4L+gwWQrxzgwSZjTdxKzgUevH/yEhpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tqI3/RjEJBz6hNlvvDnsM7hv0TJqsoDt4ZcvkriFGOxrdjVsqgZivekJjRCWGQDK4
	 i8IVc9Ur7vwjJETWXzIS/4rSyp5HKWSlfV4LmmNmc+fsQKUbEqKHNdGY3fVUND8n50
	 Gqv/4fKvDI9a7abd1Hi2+38Em+SZUTOJ38elFPCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Michal Simek <michal.simek@xilinx.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 396/691] i2c: xiic: Fix RX IRQ busy check
Date: Tue, 15 Oct 2024 13:25:44 +0200
Message-ID: <20241015112456.056582404@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 294b29f15469e90893c2b72a738a962ee02a12eb ]

In case the XIIC does TX/RX transfer, make sure no other kernel thread
can start another TX transfer at the same time. This could happen since
the driver only checks tx_msg for being non-NULL and returns -EBUSY in
that case, however it is necessary to check also rx_msg for the same.

Signed-off-by: Marek Vasut <marex@denx.de>
Acked-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 1d4a1adbed25 ("i2c: xiic: Try re-initialization on bus busy timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index b5368d11b5240..3444e4d017f7f 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -545,7 +545,7 @@ static int xiic_busy(struct xiic_i2c *i2c)
 	int tries = 3;
 	int err;
 
-	if (i2c->tx_msg)
+	if (i2c->tx_msg || i2c->rx_msg)
 		return -EBUSY;
 
 	/* In single master mode bus can only be busy, when in use by this
-- 
2.43.0



