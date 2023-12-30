Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5F5611A;
	Sat, 30 Dec 2023 12:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THdPko7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51DFC433C8;
	Sat, 30 Dec 2023 12:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703938036;
	bh=wEUwO6zxCWzEhWut5EkhdfkyAfc3Yq42zD0rbpD+gdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=THdPko7qPhRxbAypksg3l/FesnoiURu/CfFEGYnPRRrbunixtmaB5AmHbqW80OBzi
	 fwBPAK4CRoAVCqU0om7J7ZJQZQXBaPCbPa3awS+0xdRMdGcOau3/vuBFO0/aEPXnC7
	 ASFfaOIc5qnHgTUNGI0UD2RU6e+3pNw9z6oSHpdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronald Wahl <ronald.wahl@raritan.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 135/156] spi: atmel: Do not cancel a transfer upon any signal
Date: Sat, 30 Dec 2023 11:59:49 +0000
Message-ID: <20231230115816.762472003@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 1ca2761a7734928ffe0678f88789266cf3d05362 upstream.

The intended move from wait_for_completion_*() to
wait_for_completion_interruptible_*() was to allow (very) long spi memory
transfers to be stopped upon user request instead of freezing the
machine forever as the timeout value could now be significantly bigger.

However, depending on the user logic, applications can receive many
signals for their own "internal" purpose and have nothing to do with the
requested kernel operations, hence interrupting spi transfers upon any
signal is probably not a wise choice. Instead, let's switch to
wait_for_completion_killable_*() to only catch the "important"
signals. This was likely the intended behavior anyway.

Fixes: e0205d6203c2 ("spi: atmel: Prevent false timeouts on long transfers")
Cc: stable@vger.kernel.org
Reported-by: Ronald Wahl <ronald.wahl@raritan.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20231127095842.389631-1-miquel.raynal@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-atmel.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 6aa8adbe4170..2e8860865af9 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1336,8 +1336,8 @@ static int atmel_spi_one_transfer(struct spi_controller *host,
 		}
 
 		dma_timeout = msecs_to_jiffies(spi_controller_xfer_timeout(host, xfer));
-		ret_timeout = wait_for_completion_interruptible_timeout(&as->xfer_completion,
-									dma_timeout);
+		ret_timeout = wait_for_completion_killable_timeout(&as->xfer_completion,
+								   dma_timeout);
 		if (ret_timeout <= 0) {
 			dev_err(&spi->dev, "spi transfer %s\n",
 				!ret_timeout ? "timeout" : "canceled");
-- 
2.43.0



