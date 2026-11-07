Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063490;
	b=Geue89fZFELA5XYoXtMxKgBpVcJubFcVcYQpc/vXAk4dZ8hsmDyi12g0F0/oufNofSyf
	 +DRg3o5F7snoGtJaFItIDvdVu2x5liRtCw1K0MMdpfJeuiBaEW1aXlTqgAN8dkcKI2cLB
	 ZmkexTv9sT2sd3vIMeoi9SiAgO/fOlVRwZzN2kNdMczCbOE0e6HsZXfa+YvMHaAuSfDJN
	 FSuwpm2KnnQKX0iHOAtOaRtLd84//7tBKb1DuAdOeVeEnLuAi8KGTFYl+v58ITGe2CxuQ
	 TXEAwTHWNPKIG7VlPPOm/2m6hg+thp944UBX/NBr7lwdA4hUPuvkNR1T/Z8bi1ZHbWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XRK74jAsjY1uk/FkFZQagmPYV6uUkXdrZqlwDalTjwY=;
	b=qh3SDs5Y0FFfd/colQQaPYoqnE/MhB0cI6nTXIA5/Mgt+po9l1gSEZwUbjPttsyUQYXL
	 1voZCVqW30m7qbOIFl/9nGQGewVj0N0D+PGTsr7puTMuTqjUo+hI2uZUT+Au1cPew3PPh
	 9WRZj8FMgJShXuYFELa65y8IeYyjRaEd2OKrWReI6oHgXH2QJe9ESReGoqMDsx3ootw9W
	 KFlqnDehJ0khFeuTUC9bdgMWHU37528GthMx/IOLjyDfndQm3LMugdGknFJeywjZ+/C7h
	 TIKrdq+ys+9p9HjRr6RKNg8qA2KrYGt0YbTYyEx95kOIX7RRMM2T72+S27FmTwzSNaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eR7OVi0w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E13606B884;
	Sat,  7 Nov 2026 14:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eR7OVi0w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B541F008BC;
	Sat,  7 Nov 2026 14:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063490;
	bh=XRK74jAsjY1uk/FkFZQagmPYV6uUkXdrZqlwDalTjwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eR7OVi0whX678qBdLqvIbHcBzjd7lWXbdWt+ulxa7jkEXrNyXrOIgi/Hy41Hc0g8K
	 jTsW/XJ7nAdL4moLts0BRWHrsnkFKCvVRBjPpHMbUUcRh9S5zhsmu68nK6MsLCyIrh
	 88/h47sKpxCrnFWXseNzvW0bVoJboPi+vwmgm+Bo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weibin Liu <liuwb@xiaopeng.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 636/869] spi: ch341: handle transfers without a TX or RX buffer
Date: Sat,  7 Nov 2026 08:55:18 -0500
Message-ID: <20261107134914.507819745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Weibin Liu <liuwb@xiaopeng.com>

[ Upstream commit 84182c48999f856c3865e4a537c244f9569c9f6c ]

ch341_transfer_one() unconditionally copies from trans->tx_buf into the
TX packet and hands trans->rx_buf to usb_bulk_msg() for the readback.

The SPI core allows half-duplex transfers where either of the buffers
is NULL, so a transfer without TX data crashes the kernel on the memcpy
and a transfer without RX data makes usb_bulk_msg() store the received
data at address 0.

The CH341A clocks data in both directions on every transfer; there is
no mode to disable a direction. Set SPI_CONTROLLER_MUST_TX and
SPI_CONTROLLER_MUST_RX so the SPI core fills in dummy buffers for
half-duplex transfers.

Fixes: 8846739f52af ("spi: add ch341a usb2spi driver")
Cc: stable@vger.kernel.org # 6.11+
Signed-off-by: Weibin Liu <liuwb@xiaopeng.com>
Link: https://patch.msgid.link/20261013054339.77477-1-liuwb@xiaopeng.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-ch341.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-ch341.c b/drivers/spi/spi-ch341.c
index 3eaa8f176f63a..170240a0dde89 100644
--- a/drivers/spi/spi-ch341.c
+++ b/drivers/spi/spi-ch341.c
@@ -189,6 +189,12 @@ static int ch341_probe(struct usb_interface *intf,
 	ctrl->transfer_one = ch341_transfer_one;
 	ctrl->set_cs = ch341_set_cs;
 	ctrl->auto_runtime_pm = false;
+	/*
+	 * The CH341A SPI_STREAM command clocks data in both directions on
+	 * every transfer, so the driver always needs a TX and an RX buffer;
+	 * let the SPI core supply dummy buffers for half-duplex transfers.
+	 */
+	ctrl->flags = SPI_CONTROLLER_MUST_TX | SPI_CONTROLLER_MUST_RX;
 
 	usb_set_intfdata(intf, ch341);
 
-- 
2.53.0



