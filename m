Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3950154BF5;
	Mon, 16 Sep 2024 12:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488207; cv=none; b=mi48nZ7iF896G1YHHh4NsrdzC8+5xkqMkSHaSTOn2ULFbAmA9Y9uN3yBETdb+JZyInRCx/5dSNeOI0Hb2Iw0Z5C8c9j+2Sd306u6Ox00i2Q/sCuPqLgss6IHTLXxgIhNJxE+o9KKIDBYDuDa2303Fp8RP44PDQFInXuIBq8360M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488207; c=relaxed/simple;
	bh=IZ2gRsNEW2cCBSGI7UyO/q/MFFeW9SbNFwXk9WPvvJY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HSbUBPoG2H2977EJEuqFPe+wvG64MGkU+QpZcEy1nK0CegZY+Bh0gTyPUVyVYzL1AetM3uGK8nV9wgA13mECECGO352LcDAJejdkAre6WQKupBwbGk/04dv+wsPQSE0aiuCBjcnirbaUTt6mJ1cz25oyIWWbJH+ZxkRBdzMisig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WQGN9D2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WQGN9D2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC4FC4CEC4;
	Mon, 16 Sep 2024 12:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488207;
	bh=IZ2gRsNEW2cCBSGI7UyO/q/MFFeW9SbNFwXk9WPvvJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WQGN9D2ToxKz1BzNktGr9DGjOkQlDiK6r49Nf4/Wi+SqKs0CBeEbxE3ogagbHb0NC
	 THNBPPaXIwSF1UG/8wYybfZsc95/BJCuNoO/vPdtTWrBFPy31I7mjPGQTzfWUE0wE1
	 ci5ru2JMz8g2ttCNELJyjS30pJkz9kzLTCXpbBIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 032/121] spi: zynqmp-gqspi: Scale timeout by data size
Date: Mon, 16 Sep 2024 13:43:26 +0200
Message-ID: <20240916114230.090212925@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit 5d61841c74db8b5bbbf9403f1bd4879f614617d2 ]

Large blocks of data time out when reading because we don't wait long
enough for the transfer to complete. Scale our timeouts based on the
amount of data we are tranferring, with a healthy dose of pessimism.

Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Link: https://patch.msgid.link/20240809201540.3363243-1-sean.anderson@linux.dev
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-zynqmp-gqspi.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-zynqmp-gqspi.c b/drivers/spi/spi-zynqmp-gqspi.c
index 99524a3c9f38..558c466135a5 100644
--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1033,6 +1033,18 @@ static int __maybe_unused zynqmp_runtime_resume(struct device *dev)
 	return 0;
 }
 
+static unsigned long zynqmp_qspi_timeout(struct zynqmp_qspi *xqspi, u8 bits,
+					 unsigned long bytes)
+{
+	unsigned long timeout;
+
+	/* Assume we are at most 2x slower than the nominal bus speed */
+	timeout = mult_frac(bytes, 2 * 8 * MSEC_PER_SEC,
+			    bits * xqspi->speed_hz);
+	/* And add 100 ms for scheduling delays */
+	return msecs_to_jiffies(timeout + 100);
+}
+
 /**
  * zynqmp_qspi_exec_op() - Initiates the QSPI transfer
  * @mem: The SPI memory
@@ -1049,6 +1061,7 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 {
 	struct zynqmp_qspi *xqspi = spi_controller_get_devdata
 				    (mem->spi->controller);
+	unsigned long timeout;
 	int err = 0, i;
 	u32 genfifoentry = 0;
 	u16 opcode = op->cmd.opcode;
@@ -1077,8 +1090,10 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 		zynqmp_gqspi_write(xqspi, GQSPI_IER_OFST,
 				   GQSPI_IER_GENFIFOEMPTY_MASK |
 				   GQSPI_IER_TXNOT_FULL_MASK);
-		if (!wait_for_completion_timeout
-		    (&xqspi->data_completion, msecs_to_jiffies(1000))) {
+		timeout = zynqmp_qspi_timeout(xqspi, op->cmd.buswidth,
+					      op->cmd.nbytes);
+		if (!wait_for_completion_timeout(&xqspi->data_completion,
+						 timeout)) {
 			err = -ETIMEDOUT;
 			goto return_err;
 		}
@@ -1104,8 +1119,10 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 				   GQSPI_IER_TXEMPTY_MASK |
 				   GQSPI_IER_GENFIFOEMPTY_MASK |
 				   GQSPI_IER_TXNOT_FULL_MASK);
-		if (!wait_for_completion_timeout
-		    (&xqspi->data_completion, msecs_to_jiffies(1000))) {
+		timeout = zynqmp_qspi_timeout(xqspi, op->addr.buswidth,
+					      op->addr.nbytes);
+		if (!wait_for_completion_timeout(&xqspi->data_completion,
+						 timeout)) {
 			err = -ETIMEDOUT;
 			goto return_err;
 		}
@@ -1173,8 +1190,9 @@ static int zynqmp_qspi_exec_op(struct spi_mem *mem,
 						   GQSPI_IER_RXEMPTY_MASK);
 			}
 		}
-		if (!wait_for_completion_timeout
-		    (&xqspi->data_completion, msecs_to_jiffies(1000)))
+		timeout = zynqmp_qspi_timeout(xqspi, op->data.buswidth,
+					      op->data.nbytes);
+		if (!wait_for_completion_timeout(&xqspi->data_completion, timeout))
 			err = -ETIMEDOUT;
 	}
 
-- 
2.43.0



