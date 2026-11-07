Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060717;
	b=YIfk6e7onRGY4zQ3wkM8sG4fnQAoc3U5vZGhim8El21uk0D7Cl6Ovssm8btMG8ZbJGVO
	 UAW90Cm86YBURyrJedvMSHf/6QwVoX9ZKIPm6Oy24LaAXrvvGG0DtR4j3Dxzq9MEH/ZK8
	 eT4trJIC2YllvM3n+3ePl91vMpCZK06qrJPwouyRbFd45xh5ZeuWgRQbOl5/nwQhmlvzz
	 L0ufFzQAcI5EF75aqQZmLY9kd6izuHSzb1Rmi6lvs8tZTh/vHJsCAk4PxEKtZk6AcOmH9
	 8Khpm3csZZbCoVvw1YiLS5m+cZraRZ7oCjj6LTyjEcg4jUFmxPMMFAVxIKUZMZ4BZoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GL+fyiMbOb9RDN8yGyGavzx0wOiBAL5EntdjUDwNoxI=;
	b=asqgHE6lb4LwFYZKjhPaOFLRnHVt7VU8pm/qvcaB7XNZmOSvQX1KnsNDFTha78wLqPsL
	 yeXWutcVwLA/uMpSR7PPhuqz+9EaxmfssZYfEb8m2NwEaGlWljqV+7IDJblRKEtOkq7ok
	 L/r7FlqP3yemxdfeJYMG2b21KWGv/w5CDzzcwiPZmyVouZa3dOuVvFPMS6QP4ieKw0g1p
	 te0sKtNBJQiXShIepRxrPhNlrqPFOGGZyi4JEAnHWURf2k0zSiwjRD5S8clbxyCmQC8Va
	 Wk3weZVpwdEDad0OfHBisOuojUGBqoXhoVJcYzx94cKmmT/joJu4ol+ONWr7RCGIILQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oVycShhX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3FA8606A326;
	Sat,  7 Nov 2026 14:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oVycShhX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537631F0089F;
	Sat,  7 Nov 2026 14:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060716;
	bh=GL+fyiMbOb9RDN8yGyGavzx0wOiBAL5EntdjUDwNoxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oVycShhXUKnG5x0kSMO7s1ibci0Z0o9hkAToSTQ8cOX8Ph0pllG8ECL2DPHmO8qVD
	 SW/EDq59KUYtMHOSSKwBMunlNkAcboX6gkOHNVFrThxeiG4E+ZJQHpFTZC72ijGORs
	 7xy3qeRJoQs4fmAAd1ZS3+RWlCMvW/8LxY+B6S6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Martins Alves <lucas.alves@lumal21.com.br>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0140/1536] usb: musb: host: clear stale RX interrupt on three-strikes error
Date: Sat,  7 Nov 2026 08:35:56 -0500
Message-ID: <20261107135001.620010399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bc45077811679..96fbd7baf8e84 100644
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



