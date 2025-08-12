Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CB01474CC;
	Tue, 12 Aug 2025 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024734; cv=none; b=T2yhoMv5wf1RL8R/M+jwx5NL2XIdWbQoo6w8qA9AHdaISfOlShcoQG8fWcq7ZBlV8NgeG9SrwIrSiihNWnr2kzuQUCkNhBT+6gHA+o/JsP+eomG/jVgOdE2E3VB6Hf4FAWOC/GrQfK9k0Z8txiZJDJesBBYlI/hoCbTYXln/kPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024734; c=relaxed/simple;
	bh=0IokeVgNMoUn1DNxw+1rt3mKXIQ9Qjn7x30rlOCj9Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DOCMz2ChTVQnWMBLolEF0EycXDsR+4PnhpkAGPbdEP59c/EVLAzf3oEKpiklbn3YdcF41orSiTSBMlNTkWm5M86A8htcXA2EHtMcOjlddmB03Wvc5ToQ7kOtqT6QadTXZsbAjLbL5DMSmgamk5WJiN2DIuQi6G/SoO9bBkBs7og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tySQVlRA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tySQVlRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A78C4CEF0;
	Tue, 12 Aug 2025 18:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024734;
	bh=0IokeVgNMoUn1DNxw+1rt3mKXIQ9Qjn7x30rlOCj9Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tySQVlRA3OcnhXJQ3id5CWYFK3QfHLzuPDffx+Q7Jv9T7Iy/bZ6vUpVK+HF7huvat
	 EraLkw3do5vCNlKhuix1S+MmcAQfrGum1+xv6O0mbsS9ru7YyxBD9d/doWfcSGdByW
	 +CDdH604wyVpF/mLAnnhBgfgRwjUDeWoV/6VCbQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stanley Chu <yschu@nuvoton.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 462/627] i3c: master: svc: Fix npcm845 FIFO_EMPTY quirk
Date: Tue, 12 Aug 2025 19:32:37 +0200
Message-ID: <20250812173439.401028636@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 7e1a7cb94b43..ece563353895 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -104,6 +104,7 @@
 #define   SVC_I3C_MDATACTRL_TXTRIG_FIFO_NOT_FULL GENMASK(5, 4)
 #define   SVC_I3C_MDATACTRL_RXTRIG_FIFO_NOT_EMPTY 0
 #define   SVC_I3C_MDATACTRL_RXCOUNT(x) FIELD_GET(GENMASK(28, 24), (x))
+#define   SVC_I3C_MDATACTRL_TXCOUNT(x) FIELD_GET(GENMASK(20, 16), (x))
 #define   SVC_I3C_MDATACTRL_TXFULL BIT(30)
 #define   SVC_I3C_MDATACTRL_RXEMPTY BIT(31)
 
@@ -1304,14 +1305,19 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
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
2.39.5



