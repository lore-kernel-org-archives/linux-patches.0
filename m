Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2F515ADB4;
	Fri,  9 Jan 2026 12:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961460; cv=none; b=K94ODYr80cYVrWDhvHOsX56Wv/P4lYo9TJQTuj+Lc3Dnc9SU5AgNX2VNg598Rw7wXRuoHf20H8POFAOnMqjyVqlxx00CI/1zaaD3h5QNfiEwlagpUL3jBPzSaDHNnBHwFcDfZTT8w5w57ZsLtrr7zc+AuRdFmR7lpyYdh1G8p1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961460; c=relaxed/simple;
	bh=xeMQy65WlU8iZxGNCcdyA0YGBCxlenp2XA1MbcBh+Ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBDXgshJx9z1Cgm3V490C6BZyBr1dT8foo7+SmoFqYHMn1jZTNn9dFVEGtVpsKRPqocAaXFTCkXu2kJTHpnOYru8n/cxWCfHyY2QqxMMknj+cK0k7sg0PJ1qKJdtVW+lwpH/PzBmcW5lX1lT5Od3TBmKIVXv9QxXk0nUUjgOBcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLT5gSnl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLT5gSnl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36F9C4CEF1;
	Fri,  9 Jan 2026 12:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961460;
	bh=xeMQy65WlU8iZxGNCcdyA0YGBCxlenp2XA1MbcBh+Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLT5gSnllywQpPKPiZ0ayJHOj3OTEzK1zonKbxzk46gph1eZ8/lR8x+o9GYAHf57B
	 5VRSsHUe9R6WDcOH8OPwdBLV+QNhvAv94TBW/5moDo/rlkxCDmsoe8EtR4ansDpA9m
	 BR0mGtbWYM6F2s1jdvnQaJP13qAV6jb/KLeL1XBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvaro Gamez Machado <alvaro.gamez@hazent.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/634] spi: xilinx: increase number of retries before declaring stall
Date: Fri,  9 Jan 2026 12:35:00 +0100
Message-ID: <20260109112118.280195446@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Alvaro Gamez Machado <alvaro.gamez@hazent.com>

[ Upstream commit 939edfaa10f1d22e6af6a84bf4bd96dc49c67302 ]

SPI devices using a (relative) slow frequency need a larger time.

For instance, microblaze running at 83.25MHz and performing a
3 bytes transaction using a 10MHz/16 = 625kHz needed this stall
value increased to at least 20. The SPI device is quite slow, but
also is the microblaze, so set this value to 32 to give it even
more margin.

Signed-off-by: Alvaro Gamez Machado <alvaro.gamez@hazent.com>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20251106134545.31942-1-alvaro.gamez@hazent.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-xilinx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-xilinx.c b/drivers/spi/spi-xilinx.c
index 7377d3b813022..8e2ed8a068ca2 100644
--- a/drivers/spi/spi-xilinx.c
+++ b/drivers/spi/spi-xilinx.c
@@ -298,7 +298,7 @@ static int xilinx_spi_txrx_bufs(struct spi_device *spi, struct spi_transfer *t)
 
 		/* Read out all the data from the Rx FIFO */
 		rx_words = n_words;
-		stalled = 10;
+		stalled = 32;
 		while (rx_words) {
 			if (rx_words == n_words && !(stalled--) &&
 			    !(sr & XSPI_SR_TX_EMPTY_MASK) &&
-- 
2.51.0



