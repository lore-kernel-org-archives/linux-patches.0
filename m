Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026521;
	b=FPtn6bvgJsINiYDPC3U4AbsVwgGN7KxYO/jP7NF34NTeq9aMDpp4fykrVKaLjOAsIrS4
	 03K4etCq35vTHd5ezlJHdFsR3Zb803aM6UjT8yGUFmVTGODDFnHIc1J1+WkvuTnxv8q8C
	 WzaKp/q7usbnAYEPwx15WC1qZkshjt+FABbaDsBeE2fQDPJ/YiEi1w305zgbuwYwti7/F
	 duSp7o1/rDrY6QTv/nYxe3Yb7ZmV7/D+H2Fc+E7UobuJu978L+Z8OM40ODUdcLbiC3y+X
	 7v4qnQhUMhu0TF9rGZOiQFzEwrjKsXOvk9/LeTr+czJceH4QGZkP7Jpxd7cUrdvuqqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HzOuP1lutZIK1ReEOnlpJQYBFX5yAG1uqBJHNEma1QY=;
	b=PsKVRHgX7oDEUxVULFenQRVUmwNsf0/mZ9bdaKJHZ8v7G6r8As7D9lcYRQlv0jUbA/QU
	 yw5ZSTdkYLeLZFwQt0Jkp0j6UybnLOBEGK6cJ33b/00AgLknAaf+j3rskpisrb6W89Ptc
	 m14raT2J1K9nQ7kWAwrw7cRlQvJc2yWgqGAQlS8uG7flEXf5rSNDRP/O5z86+H8hC5tNd
	 v/jMh4WIGtlQFYiZJnXfAmZgqiQynn2k82DqsfQDxRi3a+eMKz4XwgNO30Tfx2rAjDHmP
	 uYTJ+nds2nCFjF0Sa2DL5PPNk/U1R5KhvntT5CIvNwueIT8Deao1fNuRLcgpV5F52cQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMezlPdD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACE2606A31C;
	Wed, 18 Nov 2026 18:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gMezlPdD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89561F000C4;
	Wed, 18 Nov 2026 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026521;
	bh=HzOuP1lutZIK1ReEOnlpJQYBFX5yAG1uqBJHNEma1QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gMezlPdD/iNX3d+SPx5xkuz4ea91f/eIIkg0c0JvT4YOaLoFHI7k8OCNN292Ggf9g
	 cJniuxeBSZC6xT052QtoRLU65pZ/K9bof6pilOHeLTYWduYotv0aYoQIiybuhL5Oki
	 aQlHZYyBj3E6u56P/jClWT6FJoRJ6TVXkVF/kIgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1463/2151] spi: spi-qpic-snand: skip BBM copy on regular raw reads
Date: Wed, 18 Nov 2026 15:53:18 +0100
Message-ID: <20261118150215.196842849@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Gabor Juhos <j4g8y7@gmail.com>

[ Upstream commit 2da46f1e9b980a38bc6afd417322ca4963725e16 ]

Trying to read the raw flash contents with nanddump, the second byte
of the OOB area contains 0xff instead of the real data in the flash.
This happens because the qcom_spi_read_last_cw() function unconditionally
copies the bad block marker into the second byte of the output buffer.

Add a new flag to the controller's private data structure, and set it
when only the first two bytes of the OOB area being read in raw mode.
Also change the bad block copying code to run only when the flag is set.

This ensures that the SPI NAND framework still can read the BBM bytes,
but on regular raw read, the output does not contain the duplicated
marker byte.

Fixes: 7304d1909080 ("spi: spi-qpic: add driver for QCOM SPI NAND flash Interface")
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://patch.msgid.link/20261005-qpic-snand-skip-bbm-copy-v1-1-04f6aeda4044@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-qpic-snand.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-qpic-snand.c b/drivers/spi/spi-qpic-snand.c
index 9ac01f53c83b8..4b2e192457938 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -111,6 +111,7 @@ struct qpic_spi_nand {
 	__le32 addr2;
 	__le32 cmd;
 	u32 num_cw;
+	bool bbm_read;
 	bool oob_rw;
 	bool page_rw;
 	bool raw_rw;
@@ -433,6 +434,16 @@ static int qcom_spi_ecc_prepare_io_req_pipelined(struct nand_device *nand,
 	if (req->mode == MTD_OPS_RAW)
 		snandc->qspi->raw_rw = true;
 
+	/*
+	 * Try to detect when the SPI NAND framework reads the first
+	 * two bytes of the OOB area searching for bad block marker
+	 * bytes.
+	 */
+	snandc->qspi->bbm_read = req->mode == MTD_OPS_RAW &&
+				 req->type == NAND_PAGE_READ &&
+				 req->dataoffs == 0 && req->datalen == 0 &&
+				 req->ooboffs == 0 && req->ooblen == 2;
+
 	return 0;
 }
 
@@ -637,7 +648,8 @@ static int qcom_spi_read_last_cw(struct qcom_nand_controller *snandc,
 	 * This can be removed once single-byte bad block marker support
 	 * gets implemented in the SPINAND code.
 	 */
-	snandc->data_buffer[bbpos + 1] = snandc->data_buffer[bbpos];
+	if (snandc->qspi->bbm_read)
+		snandc->data_buffer[bbpos + 1] = snandc->data_buffer[bbpos];
 
 	memcpy(op->data.buf.in, snandc->data_buffer + bbpos, op->data.nbytes);
 
-- 
2.53.0



