Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B4282F12AE;
	Tue, 16 Jun 2026 17:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632657; cv=none; b=Cjb1OYwBeGwO0N2qnaiQHjEagf2o0Brk2mBZCQcAFLV9gghlhpiq3P8bss0Eed0z9VUkPS/Or+9U2+qbhxCcXVfvJ7v9Z0YSNV4SGmJSYIlcOLJYeWmguRDA1JYq3LTeHgKGzLyDX3UbG7jPC+aEufQ16X+LgaFI2uAF6m5qqNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632657; c=relaxed/simple;
	bh=7neEAu3rX3wvdt1ryaO8rvFzPNem/x093KB1YbkpLzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jid9qNwK2P6SK5mYXbDHMw4NpnRNWL42u8ZAnWGM2Itbi9jXcijLP9HtOQDR+J0THvjbaqjs5v9yDr8WFGB0xwiHGjE/bd11VVGYvrHvfylXsbkqg7/F64RUSUvnIdZ+HfRp6J8v6ZNv7A9646PymdWoOYRuJyvnZJl/tN7g1u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTmEq9Ae; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTmEq9Ae"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 404231F000E9;
	Tue, 16 Jun 2026 17:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632656;
	bh=KJMqCWsV+hTwkzLtHKzzyEpkztCWtJs59nxQ9w9lBWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UTmEq9Ae23eRMcGHwzc7wT6UN9iGCM48VVXG8EqGR/ABbbWIlChcsp8qA1aisy09f
	 ZoxZI8SqMv3Ti8Y1RYcYhmMm0ERYLKSvAWLTmSf0rSMHuFl04gc4xTvbpqnrUo93BX
	 6EJNQ+8do1b3YOe8WKkgjt4p0ZhiCk4Sbp1fS8/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 453/522] spi: qup: fix error pointer deref after DMA setup failure
Date: Tue, 16 Jun 2026 20:30:00 +0530
Message-ID: <20260616145147.103785309@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

[ Upstream commit a7e8f3efd50a165ba0189f6dc57f7e51a7d149db ]

The driver falls back to PIO mode if DMA setup fails during probe.

Make sure to the clear the DMA channel pointers on setup failure to
avoid dereferencing an error pointer (or attempting to release a channel
a second time) on later probe errors or driver unbind.

This issue was flagged by Sashiko when reviewing a devres allocation
conversion patch.

Fixes: 612762e82ae6 ("spi: qup: Add DMA capabilities")
Link: https://sashiko.dev/#/patchset/20260505072909.618363-1-johan%40kernel.org?part=4
Cc: stable@vger.kernel.org	# 4.1
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260512074334.914735-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-qup.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -968,8 +968,11 @@ static int spi_qup_init_dma(struct spi_c
 
 err:
 	dma_release_channel(host->dma_tx);
+	host->dma_tx = NULL;
 err_tx:
 	dma_release_channel(host->dma_rx);
+	host->dma_rx = NULL;
+
 	return ret;
 }
 


