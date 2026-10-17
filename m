Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980173AFCF4;
	Sat, 17 Oct 2026 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255690; cv=none; b=Q1QaipkbdRXV8fm1Dqqb3RhWhxWaVGGkmxKU8CvZrsnOtZIvyEfJbJm22y5ShZcVSw2zqgeDRZkmv787wwWYtdIqIcMVEPxX7ylAVCOofjCN7k7JIKJJN04jp1dE8821nD4WQHtfM7r4h9Uvove5FEdYjMq+I2lAVEyEqvBsteA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255690; c=relaxed/simple;
	bh=se3hFAdJL40R9BVVoDf6VATartNgF4fmnR/K6pAF38o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5buORg97cgLPhk5apfMlElyJaS1wT30rJwaWOxuWUfWrT0j/QtRALTIRSrqEhKXcsvY1lN6fyBtr/87oUAgzrkJIToWCW3DBFb7p09tbyaTY4VqIzxO1HxQ6ZPepZYz3PkTjlPmHCTSK4065jGZaZo1tT/bPJS7tM7HK/twNYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgBjKR7e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgBjKR7e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EE71F000C4;
	Sat, 17 Oct 2026 16:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255689;
	bh=+nYNjQMjAJwNM9YkAF2XFTK8a9tvTdAL02LCeGpIGdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zgBjKR7eu5r7UimYnRidiEMixLaCYMFBv8KiY2Bce9/Vwa1rahAWZ8qCt4DMXrsqn
	 6mIiaRc3vIXCgp8FxVvIlIEfs0T/43u9fZY9rapj8+XSWOAgmRwwl5/rhTAjIx23oN
	 ey85VHHgeFNwnrAvjf/Ic7PAErG+t7Cl/Yy045ZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 859/869] i3c: master: svc: Fix npcm845 FIFO_EMPTY quirk
Date: Sat, 17 Oct 2026 18:01:40 +0200
Message-ID: <20261017160058.882462456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit bc4a09d8e79cadccdd505f47b01903a80bc666e7 ]

In a private write transfer, the driver pre-fills the FIFO to work around
the FIFO_EMPTY quirk. However, if an IBIWON event occurs, the hardware
emits a NACK and the driver initiates a retry. During the retry, driver
attempts to pre-fill the FIFO again if there is remaining data, but since
the FIFO is already full, this leads to data loss.

Check available space in FIFO to prevent overflow.

Fixes: 4008a74e0f9b ("i3c: master: svc: Fix npcm845 FIFO empty issue")
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Link: https://lore.kernel.org/r/20250730003719.1825593-1-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 25cdb77973c09..26e53717b8292 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -103,6 +103,7 @@
 #define   SVC_I3C_MDATACTRL_TXTRIG_FIFO_NOT_FULL GENMASK(5, 4)
 #define   SVC_I3C_MDATACTRL_RXTRIG_FIFO_NOT_EMPTY 0
 #define   SVC_I3C_MDATACTRL_RXCOUNT(x) FIELD_GET(GENMASK(28, 24), (x))
+#define   SVC_I3C_MDATACTRL_TXCOUNT(x) FIELD_GET(GENMASK(20, 16), (x))
 #define   SVC_I3C_MDATACTRL_TXFULL BIT(30)
 #define   SVC_I3C_MDATACTRL_RXEMPTY BIT(31)
 
@@ -1285,14 +1286,19 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 		 * FIFO start filling as soon as possible after EmitStartAddr.
 		 */
 		if (svc_has_quirk(master, SVC_I3C_QUIRK_FIFO_EMPTY) && !rnw && xfer_len) {
-			u32 end = xfer_len > SVC_I3C_FIFO_SIZE ? 0 : SVC_I3C_MWDATAB_END;
-			u32 len = min_t(u32, xfer_len, SVC_I3C_FIFO_SIZE);
-
-			writesb(master->regs + SVC_I3C_MWDATAB1, out, len - 1);
-			/* Mark END bit if this is the last byte */
-			writel(out[len - 1] | end, master->regs + SVC_I3C_MWDATAB);
-			xfer_len -= len;
-			out += len;
+			u32 space, end, len;
+
+			reg = readl(master->regs + SVC_I3C_MDATACTRL);
+			space = SVC_I3C_FIFO_SIZE - SVC_I3C_MDATACTRL_TXCOUNT(reg);
+			if (space) {
+				end = xfer_len > space ? 0 : SVC_I3C_MWDATAB_END;
+				len = min_t(u32, xfer_len, space);
+				writesb(master->regs + SVC_I3C_MWDATAB1, out, len - 1);
+				/* Mark END bit if this is the last byte */
+				writel(out[len - 1] | end, master->regs + SVC_I3C_MWDATAB);
+				xfer_len -= len;
+				out += len;
+			}
 		}
 
 		ret = readl_poll_timeout(master->regs + SVC_I3C_MSTATUS, reg,
-- 
2.53.0



