Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A722313AD09;
	Tue, 10 Sep 2024 09:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961993; cv=none; b=G1DJwKNsXp9JzuXnSHa8zhBUjO++uGPGMFfJPudl8En1a4inIaBqo1Pz/FqLLNkkAQRndNeShmFfP5+x0BX8Bho6B6HQk4WtZMxgl7Y0Cv00tlx8vmYRRDng3RbRf7XcbrGje+QMXcQwzCa5ystNKRx/mOC/iCFUu6C/4yPv5PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961993; c=relaxed/simple;
	bh=nfYF1v0MIz7EnpjpMpsfYyrPp4XEFFkrIgGesKHSb5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JxEb1QlXFAeRRQCk7P3oGGREuWfu+9EEEqioW3W8o8mIVVIbxbsOZ9g58eRfqVAbX3dSeQ3FNpO/C3brLlNyoSBTjVwP3+P2xm5P1rKMoRdfOCstTq03YwNwe9C8DP4rHPGf7OFcsbYWS+MDxtzQs6UXWyeOEy1H4dT4Jd7tpuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=feLG6CCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="feLG6CCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ECF9C4CEC3;
	Tue, 10 Sep 2024 09:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961993;
	bh=nfYF1v0MIz7EnpjpMpsfYyrPp4XEFFkrIgGesKHSb5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=feLG6CCsBh8GuF+QtB2vgThaf8rmObePNFV7TVFronKsfrfTLr0Wb98QAlFWSv7Qe
	 85oJD6mGUCshyP7/VqcgtPXokVzvtOCVUBEbChC2fus1gteC1+pWwT+9EPTpKMHu46
	 UVZJGzJ2XGrgHSMqnvsRFHaZshTVZNIg5eEvEQE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 259/375] i3c: master: svc: resend target address when get NACK
Date: Tue, 10 Sep 2024 11:30:56 +0200
Message-ID: <20240910092631.268864424@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 9bc7501b0b90f4d0c34b97c14ff1f708ce7ad8f3 ]

According to I3C Spec 1.1.1, 11-Jun-2021, section: 5.1.2.2.3:

If the Controller chooses to start an I3C Message with an I3C Dynamic
Address, then special provisions shall be made because that same I3C Target
may be initiating an IBI or a Controller Role Request. So, one of three
things may happen: (skip 1, 2)

3. The Addresses match and the RnW bits also match, and so neither
Controller nor Target will ACK since both are expecting the other side to
provide ACK. As a result, each side might think it had "won" arbitration,
but neither side would continue, as each would subsequently see that the
other did not provide ACK.
...
For either value of RnW: Due to the NACK, the Controller shall defer the
Private Write or Private Read, and should typically transmit the Target
						    ^^^^^^^^^^^^^^^^^^^
Address again after a Repeated START (i.e., the next one or any one prior
^^^^^^^^^^^^^
to a STOP in the Frame). Since the Address Header following a Repeated
START is not arbitrated, the Controller will always win (see Section
5.1.2.2.4).

Resend target address again if address is not 7E and controller get NACK.

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 58 ++++++++++++++++++++++-------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index bb299ce02ccc..f0362509319e 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1052,29 +1052,59 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 			       u8 *in, const u8 *out, unsigned int xfer_len,
 			       unsigned int *actual_len, bool continued)
 {
+	int retry = 2;
 	u32 reg;
 	int ret;
 
 	/* clean SVC_I3C_MINT_IBIWON w1c bits */
 	writel(SVC_I3C_MINT_IBIWON, master->regs + SVC_I3C_MSTATUS);
 
-	writel(SVC_I3C_MCTRL_REQUEST_START_ADDR |
-	       xfer_type |
-	       SVC_I3C_MCTRL_IBIRESP_NACK |
-	       SVC_I3C_MCTRL_DIR(rnw) |
-	       SVC_I3C_MCTRL_ADDR(addr) |
-	       SVC_I3C_MCTRL_RDTERM(*actual_len),
-	       master->regs + SVC_I3C_MCTRL);
 
-	ret = readl_poll_timeout(master->regs + SVC_I3C_MSTATUS, reg,
+	while (retry--) {
+		writel(SVC_I3C_MCTRL_REQUEST_START_ADDR |
+		       xfer_type |
+		       SVC_I3C_MCTRL_IBIRESP_NACK |
+		       SVC_I3C_MCTRL_DIR(rnw) |
+		       SVC_I3C_MCTRL_ADDR(addr) |
+		       SVC_I3C_MCTRL_RDTERM(*actual_len),
+		       master->regs + SVC_I3C_MCTRL);
+
+		ret = readl_poll_timeout(master->regs + SVC_I3C_MSTATUS, reg,
 				 SVC_I3C_MSTATUS_MCTRLDONE(reg), 0, 1000);
-	if (ret)
-		goto emit_stop;
+		if (ret)
+			goto emit_stop;
 
-	if (readl(master->regs + SVC_I3C_MERRWARN) & SVC_I3C_MERRWARN_NACK) {
-		ret = -ENXIO;
-		*actual_len = 0;
-		goto emit_stop;
+		if (readl(master->regs + SVC_I3C_MERRWARN) & SVC_I3C_MERRWARN_NACK) {
+			/*
+			 * According to I3C Spec 1.1.1, 11-Jun-2021, section: 5.1.2.2.3.
+			 * If the Controller chooses to start an I3C Message with an I3C Dynamic
+			 * Address, then special provisions shall be made because that same I3C
+			 * Target may be initiating an IBI or a Controller Role Request. So, one of
+			 * three things may happen: (skip 1, 2)
+			 *
+			 * 3. The Addresses match and the RnW bits also match, and so neither
+			 * Controller nor Target will ACK since both are expecting the other side to
+			 * provide ACK. As a result, each side might think it had "won" arbitration,
+			 * but neither side would continue, as each would subsequently see that the
+			 * other did not provide ACK.
+			 * ...
+			 * For either value of RnW: Due to the NACK, the Controller shall defer the
+			 * Private Write or Private Read, and should typically transmit the Target
+			 * Address again after a Repeated START (i.e., the next one or any one prior
+			 * to a STOP in the Frame). Since the Address Header following a Repeated
+			 * START is not arbitrated, the Controller will always win (see Section
+			 * 5.1.2.2.4).
+			 */
+			if (retry && addr != 0x7e) {
+				writel(SVC_I3C_MERRWARN_NACK, master->regs + SVC_I3C_MERRWARN);
+			} else {
+				ret = -ENXIO;
+				*actual_len = 0;
+				goto emit_stop;
+			}
+		} else {
+			break;
+		}
 	}
 
 	/*
-- 
2.43.0



