Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E045C27713;
	Tue,  9 Jul 2024 11:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524598; cv=none; b=Ec7+FUsrcBICZTX8qT+w+vlNJwPa9F/Q2441WP3qth0dBS5bha+4tl3uZEAPwxGT7n28qOSArq70QUboV2afyKF5dSLQ+NPeYdAZXikGBUZ3ptLTsOYdilZplaZB7zgr27aMvuKZaza8OmuoL0UCBrNb+fzqcxzff6KWYplQWBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524598; c=relaxed/simple;
	bh=zl9POF/y+KnZMRlFcQdjGVilot7LTgqV541w5StbgTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEAxJwWyrAME9FLu/5odRH4VUUUPCEM8VDEfMlzh5KXqrywOh2g7eG5ieb5n1oq/z+ldvWFbzUbhGPfqPD6Mr4WgT6xmVsD3Uko6kKiYaRvonVgQZTzbjo8oWa6SWCnVs5eeSps8bQw53Sq0Qco/P0c9hVhk99lzkLqtUfrkbQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eErUk1az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eErUk1az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6985AC3277B;
	Tue,  9 Jul 2024 11:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524597;
	bh=zl9POF/y+KnZMRlFcQdjGVilot7LTgqV541w5StbgTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eErUk1azGG+OPkreD/OkZn9+u2w9t9taoLmbIXYzc1S66Ldndp+Qo25U+9F2rZz07
	 KpUL9uNXyhEeDCZ4ZN67nhzi6e6wZKtGNRqvF+Req5W+301Qnkt8Wggtdntjzwirgh
	 eI7FwnSCqn6aeoRP0G7kznTz7/5xjJSgk4cUKNpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Krummsdorf <michael.krummsdorf@tq-group.com>,
	Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 037/102] serial: imx: Raise TX trigger level to 8
Date: Tue,  9 Jul 2024 13:10:00 +0200
Message-ID: <20240709110652.816142083@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
References: <20240709110651.353707001@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit a3d8728ab079951741efa11360df43dbfacba7ab ]

At the default TX trigger level of 2 in non-DMA mode (meaning that an
interrupt is generated when less than 2 characters are left in the
FIFO), we have observed frequent buffer underruns at 115200 Baud on an
i.MX8M Nano. This can cause communication issues if the receiving side
expects a continuous transfer.

Increasing the level to 8 makes the UART trigger an interrupt earlier,
giving the kernel enough time to refill the FIFO, at the cost of
triggering one interrupt per ~24 instead of ~30 bytes of transmitted
data (as the i.MX UART has a 32 byte FIFO).

Signed-off-by: Michael Krummsdorf <michael.krummsdorf@tq-group.com>
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Link: https://lore.kernel.org/r/20240508133744.35858-1-matthias.schiffer@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 40e59e72d5e9e..5acbab0512b82 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1303,7 +1303,7 @@ static void imx_uart_clear_rx_errors(struct imx_port *sport)
 
 }
 
-#define TXTL_DEFAULT 2 /* reset default */
+#define TXTL_DEFAULT 8
 #define RXTL_DEFAULT 8 /* 8 characters or aging timer */
 #define TXTL_DMA 8 /* DMA burst setting */
 #define RXTL_DMA 9 /* DMA burst setting */
-- 
2.43.0



