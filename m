Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C2214EC4D;
	Tue,  9 Jul 2024 11:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523871; cv=none; b=lRZYiV0un3L55zUuFo7RrmY0HzM4NH76D7d4gfDsPdx3w0Ztsyyeb5m8X5F5QVHIv+OhVreFPyvPNYyFVruG0knc6/aBmwYgXtVvXhoeHWir3Ery9NRUGR1jS2aVD2F4kr4lZqpN8MrxKRaS+qfMXO44e/xMgAgCxV9VsgI0pM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523871; c=relaxed/simple;
	bh=GvDSyb4zcaP/7gKqNu/P1cN6gUKyl6LQvCDAJu4Rt2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7G6fBcOLThb5X7Fw3KgKgyKApw/qTrk4VSQyB9z9WPVvuJ28Omk/3LBwaKENJwc6nli67iohfo8tc4wxOE6FvSb4B/pWQD0uyW+5iyke5XNBeLVYBVzrjRZ0XTXYisR5mrcWF+aWidJHvbT3eL/aXunAo2rIfiYMCXMDz1fEp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fz4j0/RA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fz4j0/RA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD1DC4AF0A;
	Tue,  9 Jul 2024 11:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523871;
	bh=GvDSyb4zcaP/7gKqNu/P1cN6gUKyl6LQvCDAJu4Rt2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fz4j0/RAoYvdR7HaoVz2OG7O6auqKJvbDNzqo9s8f7+9fab+bZwnE1nnNwjb2xNfI
	 5rFmzSzmi8CcG9Tm/CmYOq+wpv5Ajlqx8FKhxA90JZ3kr3aSptJSwnNYVDDST0X3OT
	 rO0X18q5fv5pDG2qHtR97S5XDZ8s27oTGfW5Qn+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Witold Sadowski <wsadowski@marvell.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 135/139] spi: cadence: Ensure data lines set to low during dummy-cycle period
Date: Tue,  9 Jul 2024 13:10:35 +0200
Message-ID: <20240709110703.385678895@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Witold Sadowski <wsadowski@marvell.com>

[ Upstream commit 4a69c1264ff41bc5bf7c03101ada0454fbf08868 ]

During dummy-cycles xSPI will switch GPIO into Hi-Z mode. In that dummy
period voltage on data lines will slowly drop, what can cause
unintentional modebyte transmission. Value send to SPI memory chip will
depend on last address, and clock frequency.
To prevent unforeseen consequences of that behaviour, force send
single modebyte(0x00).
Modebyte will be send only if number of dummy-cycles is not equal
to 0. Code must also reduce dummycycle byte count by one - as one byte
is send as modebyte.

Signed-off-by: Witold Sadowski <wsadowski@marvell.com>
Link: https://msgid.link/r/20240529074037.1345882-2-wsadowski@marvell.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-cadence-xspi.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-cadence-xspi.c b/drivers/spi/spi-cadence-xspi.c
index b7e04b03be58e..ee342501b759f 100644
--- a/drivers/spi/spi-cadence-xspi.c
+++ b/drivers/spi/spi-cadence-xspi.c
@@ -145,6 +145,9 @@
 #define CDNS_XSPI_STIG_DONE_FLAG		BIT(0)
 #define CDNS_XSPI_TRD_STATUS			0x0104
 
+#define MODE_NO_OF_BYTES			GENMASK(25, 24)
+#define MODEBYTES_COUNT			1
+
 /* Helper macros for filling command registers */
 #define CDNS_XSPI_CMD_FLD_P1_INSTR_CMD_1(op, data_phase) ( \
 	FIELD_PREP(CDNS_XSPI_CMD_INSTR_TYPE, (data_phase) ? \
@@ -157,9 +160,10 @@
 	FIELD_PREP(CDNS_XSPI_CMD_P1_R2_ADDR3, ((op)->addr.val >> 24) & 0xFF) | \
 	FIELD_PREP(CDNS_XSPI_CMD_P1_R2_ADDR4, ((op)->addr.val >> 32) & 0xFF))
 
-#define CDNS_XSPI_CMD_FLD_P1_INSTR_CMD_3(op) ( \
+#define CDNS_XSPI_CMD_FLD_P1_INSTR_CMD_3(op, modebytes) ( \
 	FIELD_PREP(CDNS_XSPI_CMD_P1_R3_ADDR5, ((op)->addr.val >> 40) & 0xFF) | \
 	FIELD_PREP(CDNS_XSPI_CMD_P1_R3_CMD, (op)->cmd.opcode) | \
+	FIELD_PREP(MODE_NO_OF_BYTES, modebytes) | \
 	FIELD_PREP(CDNS_XSPI_CMD_P1_R3_NUM_ADDR_BYTES, (op)->addr.nbytes))
 
 #define CDNS_XSPI_CMD_FLD_P1_INSTR_CMD_4(op, chipsel) ( \
@@ -173,12 +177,12 @@
 #define CDNS_XSPI_CMD_FLD_DSEQ_CMD_2(op) \
 	FIELD_PREP(CDNS_XSPI_CMD_DSEQ_R2_DCNT_L, (op)->data.nbytes & 0xFFFF)
 
-#define CDNS_XSPI_CMD_FLD_DSEQ_CMD_3(op) ( \
+#define CDNS_XSPI_CMD_FLD_DSEQ_CMD_3(op, dummybytes) ( \
 	FIELD_PREP(CDNS_XSPI_CMD_DSEQ_R3_DCNT_H, \
 		((op)->data.nbytes >> 16) & 0xffff) | \
 	FIELD_PREP(CDNS_XSPI_CMD_DSEQ_R3_NUM_OF_DUMMY, \
 		  (op)->dummy.buswidth != 0 ? \
-		  (((op)->dummy.nbytes * 8) / (op)->dummy.buswidth) : \
+		  (((dummybytes) * 8) / (op)->dummy.buswidth) : \
 		  0))
 
 #define CDNS_XSPI_CMD_FLD_DSEQ_CMD_4(op, chipsel) ( \
@@ -351,6 +355,7 @@ static int cdns_xspi_send_stig_command(struct cdns_xspi_dev *cdns_xspi,
 	u32 cmd_regs[6];
 	u32 cmd_status;
 	int ret;
+	int dummybytes = op->dummy.nbytes;
 
 	ret = cdns_xspi_wait_for_controller_idle(cdns_xspi);
 	if (ret < 0)
@@ -365,7 +370,12 @@ static int cdns_xspi_send_stig_command(struct cdns_xspi_dev *cdns_xspi,
 	memset(cmd_regs, 0, sizeof(cmd_regs));
 	cmd_regs[1] = CDNS_XSPI_CMD_FLD_P1_INSTR_CMD_1(op, data_phase);
 	cmd_regs[2] = CDNS_XSPI_CMD_FLD_P1_INSTR_CMD_2(op);
-	cmd_regs[3] = CDNS_XSPI_CMD_FLD_P1_INSTR_CMD_3(op);
+	if (dummybytes != 0) {
+		cmd_regs[3] = CDNS_XSPI_CMD_FLD_P1_INSTR_CMD_3(op, 1);
+		dummybytes--;
+	} else {
+		cmd_regs[3] = CDNS_XSPI_CMD_FLD_P1_INSTR_CMD_3(op, 0);
+	}
 	cmd_regs[4] = CDNS_XSPI_CMD_FLD_P1_INSTR_CMD_4(op,
 						       cdns_xspi->cur_cs);
 
@@ -375,7 +385,7 @@ static int cdns_xspi_send_stig_command(struct cdns_xspi_dev *cdns_xspi,
 		cmd_regs[0] = CDNS_XSPI_STIG_DONE_FLAG;
 		cmd_regs[1] = CDNS_XSPI_CMD_FLD_DSEQ_CMD_1(op);
 		cmd_regs[2] = CDNS_XSPI_CMD_FLD_DSEQ_CMD_2(op);
-		cmd_regs[3] = CDNS_XSPI_CMD_FLD_DSEQ_CMD_3(op);
+		cmd_regs[3] = CDNS_XSPI_CMD_FLD_DSEQ_CMD_3(op, dummybytes);
 		cmd_regs[4] = CDNS_XSPI_CMD_FLD_DSEQ_CMD_4(op,
 							   cdns_xspi->cur_cs);
 
-- 
2.43.0



