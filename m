Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B0E326939;
	Fri, 15 May 2026 16:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862619; cv=none; b=gpXaUwggeJO757vpte5MTabi9r89sMPWnIomDmfBcPJBm5IsEkuZ0F12Q3ePcEOSbf9hbTvskc+3Ft/53+SNq69n/HAPI9H3b0Ezuy0t0F9CW07+Fdmqpkcnb9r0YiEKrBuwnJn6XSvT1PuAng4vIxEE1Qi29sHMFKnLdEU+9zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862619; c=relaxed/simple;
	bh=8IB3d82gOp3/ivAZiAWp9PnRI3/JnvrTQA70YiLS+nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip0GPmdt20VPbBKn7MCeJpLfbKjH07kL2VuKQZhL6o7GBAtcd9AXIiZ3Rk/Qsa2MCAvsULKlanWbokVg0uTOALfXx5gOeLcp2rGQO3g68AA26+Yf1CpVp+bVnJL2FFAwUhtvXpZgKwmjvA99vyMEpZkICriZctKecyaIySyOnyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZNQ0rxA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZNQ0rxA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36994C2BCB3;
	Fri, 15 May 2026 16:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862619;
	bh=8IB3d82gOp3/ivAZiAWp9PnRI3/JnvrTQA70YiLS+nA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZNQ0rxAz67Cs+Ik9bBYviftM6aV0HACQha3S+692XtZYOrppHxgI9gQK2G9OXTqY
	 rSRjDHCEoJRxAyAYQsxAvJew5rXfv6JUgqF1h54PUv8XFqNDZtbpi4jjYDe2nSXJOm
	 K5XxyNkNgGTkjIdk6FGpYDKgoSLl3LGr2+iIrA7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khairul Anuar Romli <khairul.anuar.romli@altera.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 117/201] spi: cadence-quadspi: fix controller deregistration
Date: Fri, 15 May 2026 17:48:55 +0200
Message-ID: <20260515154701.090409722@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 964ee9793760e825b5c011741b4e3cfe06c87efc upstream.

Make sure to deregister the controller before dropping the reference
count that allows new operations to start to allow SPI drivers to do I/O
during deregistration.

Fixes: 7446284023e8 ("spi: cadence-quadspi: Implement refcount to handle unbind during busy")
Cc: stable@vger.kernel.org	# 6.17
Cc: Khairul Anuar Romli <khairul.anuar.romli@altera.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-cadence-quadspi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-cadence-quadspi.c
+++ b/drivers/spi/spi-cadence-quadspi.c
@@ -2020,13 +2020,13 @@ static void cqspi_remove(struct platform
 
 	ddata = of_device_get_match_data(dev);
 
+	spi_unregister_controller(cqspi->host);
+
 	refcount_set(&cqspi->refcount, 0);
 
 	if (!refcount_dec_and_test(&cqspi->inflight_ops))
 		cqspi_wait_idle(cqspi);
 
-	spi_unregister_controller(cqspi->host);
-
 	if (cqspi->rx_chan)
 		dma_release_channel(cqspi->rx_chan);
 


