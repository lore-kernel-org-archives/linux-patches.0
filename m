Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051219;
	b=oYa/uk0e7g70nxs7rzhzbNsssLeP3a1M6+osZ8cJg6ElXqZsAFBRlCoPcqt/VY+JKQNq
	 2AmjOIGp6sIIazBCxHEmjhEoF3vyKfB1VHJ/yYzqrmAAWveYEgmdU6D7jSDduaARXIxJd
	 qYwW/EXD5aRu4p7fO51AVDU08leg6HXIDmN/InWpTm1ABnJPWl2AD2nzGDxbEHGE6Du3u
	 A3i95dZA6gXPNJRqYUvp6g9riqcSiCxYTfUFSPMrTX/JuzF9Jpm5gJX6kvrPJlFYehKwb
	 Q/LUIAjaVbUCiZBNjatIvwi4qm95cDKEG3vjVmllYIN2GKstEtpJDLJp+g0LDbR+VEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051219;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eYdTsZ23tyFdzHIohoxblOoknQQsv0Tadr1dkXF0eKk=;
	b=lsIaflgoWzATtwCTWZry2+suljQTWWj5tanXa+u8CZMx9Vl0amqaV5dquHdawMEjUby4
	 GbvnVDYyXCvnlfE6zuvTVI9BJJE2f3VMXNl1qrVdVjtOOKOReZxikjlurmNMQmeRczoyx
	 rx/sF/BVkVV5twvMvdMDjqDB0nH/K/uHb3UJn7xVRaVZo7EJLG+9kpym6guhDOTY9MXd/
	 VCKgb5pNfzMYh64Vmo9U669lpNAUZeJjd1pCnPp7bOI8f5cFqUEF5JAeIgCyxG8iStge9
	 wG3DfXG150Ik07Bl9EMZjjHodmd7wXJwQCWLS/snwhcCQhvhhNzFqBxBPFmNk66z03A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASW0uihd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107CE606A325;
	Thu, 19 Nov 2026 01:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ASW0uihd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534731F000C4;
	Thu, 19 Nov 2026 01:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051218;
	bh=eYdTsZ23tyFdzHIohoxblOoknQQsv0Tadr1dkXF0eKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASW0uihdT5QhJIrTAmmZQtw3bzAK24xT+YJli/dGqYA9CP5K0dELRtIqDIGTRiEGB
	 cVv51z/Fg6IIhgsPekOcdWW/FdinBvPqVdQDjYZwLm6t28rKAvrnFYcjiKwnMeZDs1
	 paQjia+pnk8jlnrJW+3QYwgnaKB41AEkN2MsNgcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Martins Alves <lucas.alves@lumal21.com.br>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0090/2214] usb: musb: host: clear stale RX interrupt on three-strikes error
Date: Wed, 18 Nov 2026 15:29:26 +0100
Message-ID: <20261118150013.577026442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Martins Alves <lucas.alves@lumal21.com.br>

[ Upstream commit 3a3a48487344a653f46a4aadc9ba296386eb3541 ]

Unplugging a busy USB Ethernet adapter can leave a stale RX interrupt
pending while the host handles MUSB_RXCSR_H_ERROR. On AM335x/DSPS
platforms this can retrigger the same three-strikes error before the
disconnect path completes, flooding the log and potentially leaving the
host port stuck until reboot.

Clear the pending endpoint RX interrupt when aborting the transfer so
the error storm is broken, and rate limit the error message to avoid
spamming the log while the fault path completes.

Signed-off-by: Lucas Martins Alves <lucas.alves@lumal21.com.br>
Link: https://patch.msgid.link/20260714134941.18508-1-lucas.alves@lumal21.com.br
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/musb/musb_host.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_host.c b/drivers/usb/musb/musb_host.c
index 08c73e9f75d0f..732fe78aa7985 100644
--- a/drivers/usb/musb/musb_host.c
+++ b/drivers/usb/musb/musb_host.c
@@ -1774,7 +1774,8 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 		status = -EPIPE;
 
 	} else if (rx_csr & MUSB_RXCSR_H_ERROR) {
-		dev_err(musb->controller, "ep%d RX three-strikes error", epnum);
+		dev_err_ratelimited(musb->controller,
+				    "ep%d RX three-strikes error\n", epnum);
 
 		/*
 		 * The three-strikes error could only happen when the USB
@@ -1788,6 +1789,17 @@ void musb_host_rx(struct musb *musb, u8 epnum)
 		rx_csr &= ~MUSB_RXCSR_H_ERROR;
 		musb_writew(epio, MUSB_RXCSR, rx_csr);
 
+		/*
+		 * Unplugging a USB-Ethernet adapter while it is busy can make
+		 * the controller keep re-asserting the three-strikes error for
+		 * this endpoint before the disconnect is processed. That floods
+		 * the log and can wedge the host port until reboot. Drop the
+		 * stale pending RX interrupt on platforms that support it (e.g.
+		 * AM335x/DSPS) to break the storm; the transfer is still
+		 * aborted below via the fault path.
+		 */
+		musb_platform_clear_ep_rxintr(musb, epnum);
+
 	} else if (rx_csr & MUSB_RXCSR_DATAERROR) {
 
 		if (USB_ENDPOINT_XFER_ISOC != qh->type) {
-- 
2.53.0



