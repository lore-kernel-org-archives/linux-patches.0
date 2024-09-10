Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418E4181B8D;
	Tue, 10 Sep 2024 10:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964505; cv=none; b=aWNQNYsop+n1Aqk6ZaAVX6buW0jCNiwjnhlmSC15Ln1KP0C0U/ZZ3hS/OuGZCdr/k50KRpywrMmpvLaVRLQsH57vL/+Mn6hgDN5wz6FDUuPG2LYUySc3/GUOkrOTH3fKeJ4fhqUVRkL4J0t0eocQ8yCeweyHSCj4x4s2wkA0S7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964505; c=relaxed/simple;
	bh=Z48hiQQ2F++eGdQnURVCSE6ptIW9YZBk4FBN5rkPl9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPe7hVJb9GnVPW9EO/AnW8Jof624BeFm34+pGJcvZzHCogt4eGvQmpPTJ72wTjBaBy0tx3CQUQlilBXRE63CbeWcHYtx2d7IKvolsrlXDXcdudA5Ks5lYKWFMuu5dnaC8fJ3qGCGwUDEfkAn+UVDxr75oIKpI37bslPeqEVBqyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e05Msoxx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e05Msoxx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC0F1C4CEC3;
	Tue, 10 Sep 2024 10:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964505;
	bh=Z48hiQQ2F++eGdQnURVCSE6ptIW9YZBk4FBN5rkPl9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e05MsoxxKxmsh1bpoIb/cxt2HEhAEy5GrdEumLsqkpRyN6SP47fWhbs5GuU4bKkyM
	 tcr4r9FxF7jaJ0Y91JEqAHHOAE45ptU69Ilf+AJarXLst+BjmftnVe7M2y3mxCZrM0
	 fNRji/LTPZnmnk4EUbArTYUb9+qt970N3mwH4NxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 178/269] i3c: master: svc: resend target address when get NACK
Date: Tue, 10 Sep 2024 11:32:45 +0200
Message-ID: <20240910092614.508405105@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ccd0c4680be2..acc937275c18 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -1037,29 +1037,59 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
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



