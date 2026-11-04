Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829514;
	b=4ATBT/7c0XVd29TWjP4Xk+DaxIMfukGbDsOhvEjTzKJPWV2ps+ztrltl/bGRIx1Dlm+t
	 VxMIKDCVQxFOaTfZq8280Iu1fL05ceO4eaYOgX4JKdxN3yeeM6gqSkjC+g+1aIrlcgwPx
	 SMSY489YlyLpkLy8iwLYAHUj6eCw/Tv7eWzpjLAyuhE1fQKmbua3t0iLKGX4isTxkIPHQ
	 laERRGtql+o4HR/ucxrBW/QSKRzvoE/4hM7d3PMXljohwEUoh5PMXzzP/qlw9M/mvt01i
	 2AS14G9fpEzw5FWusBw+GEW/C1mhefhJw8c0rRL1zOzQAw6zm1+YmEOiQAkVu3GxthQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829514;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mfUpdgJ5QtWGsdFwKWqo41+bLrhiYsVRjVTF7l/TIPY=;
	b=Sqfoz5glv+qmNybSceXn7nWLA9t23uwpwFpSpJImRnZvJdRtxvegpjJnX3fyOUbc4c2D
	 tKKn0o8xEqtd6Mdj83jciVCyE4pzwdgS/+gRaS5vFB719ZpdSCe5ALugbkDUf3mpHwEJP
	 HUn2anuSd1gHlpToppO/NOy9jxm8wFtLp4dgvSAkpw3eBht4Ymvz3DWLKwu7GA+4BtZig
	 hgRJMBjPXmZT01rcVEusHFzEytZsWDv28/5/9n+7huq4rtBSztNEkVza9mSwx7NP2wg8j
	 Vdm+XjHtu85TfCZWriwKLAFQg/OGswI7DsRijn4mgUKgybNgsb5l51qKr/8WNH+nTqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8YXepF5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DC1606AB36;
	Wed,  4 Nov 2026 21:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n8YXepF5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 596561F000C1;
	Wed,  4 Nov 2026 21:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829513;
	bh=mfUpdgJ5QtWGsdFwKWqo41+bLrhiYsVRjVTF7l/TIPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8YXepF5ixNdYROGx0ydcQJ+dO2qYm8fSCzypQC6fCHf+tTBvjTSb2exyOEqMuwqg
	 jKqKIFFfsMv3voF7EjAaaZgXl7ynCQofy0P+j816r/r+4Su+ATiX2IiPFWM5rIMRsk
	 gF8wDo6LJqH/2oIIHbmxUR9CVkngohtfZ7NiPSbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Martins Alves <lucas.alves@lumal21.com.br>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0172/1005] usb: musb: host: clear stale RX interrupt on three-strikes error
Date: Wed,  4 Nov 2026 15:58:25 -0500
Message-ID: <20261104211048.591691000@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
index 6b4481a867c5e..40f51c388ef59 100644
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



