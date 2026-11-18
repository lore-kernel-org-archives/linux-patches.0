Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020010;
	b=fjZCCtxf4qothRU17S5JIAptljM+8BF+PHI6nq7uIJsagloUmcEQjXr7eXU1TfMy9qu/
	 B3ljMnPn9xGLrZG7pQ8L7bv8qNYrofzTouF4PzRXEAWJD5AVH0drpuRqSTuVFqs9dZPoa
	 yjLF45qGueVgczCA4DdT7vzasukUtA9Y/bZoeH+BtsOtEGajCD1DNh6S0mKKF7o0Yuey3
	 Wj3f5oSpmFlDD2uCEJBJqTsqCN91mZNQ85KtQD8WBVn65Ix2Ic45t5+yupm07dDuhcREL
	 SRLlPxG3iWewk183cxgaxSbfUIzh5wAXz7cB9qXnvBUdkGbUsj/lkviweyChQO9Px8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HLpOvE5Q91Hq3xyjBXfLFUvRu3HkdVIfsWCxheLnM7s=;
	b=mPZtiNjClNUTK48TlUlMBWzg7VXfQq0wuzht+8VDZGIIssZ9/dkDvbd/B7lj1LSWbB1W
	 UXZ0+WM+AfhFF9CoLLw5rzvNnWx1fO04GNubYAG4ITYhPHtG4fqqdWKYXkvlYeiT+riFK
	 vAsZ+7S5Xo88omUy/2Jl/YiOeZoNAsAyie6oswfA5TDMdXSInpKTs8qJjudy4v7ow5WKC
	 iphSxsjPbqZo2FraaXzgvVqjEaAFzhfLC515YRzDPXzIAwD5BwNwYyh650l4lzStJIAUg
	 gMouJzIL+plcG6VdPLDUtmMvw8gSpGRPvTPGPCsWBYOgoAA2XpCLCnIMwbafgEnJgnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHqRPxGg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9C4606A337;
	Wed, 18 Nov 2026 16:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jHqRPxGg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734C81F000C5;
	Wed, 18 Nov 2026 16:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020010;
	bh=HLpOvE5Q91Hq3xyjBXfLFUvRu3HkdVIfsWCxheLnM7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHqRPxGgQziNa0E2XPZmqx1dv4V61xS3a+KB7wO4+j/0ZPjgD08dcPLpJObvopAyZ
	 1k9uNopHDtuhTqNHonfhdb9U7aEEW7GrG6jal6vogvGHwFkHO9WGRzMcAVYRtOYDbK
	 1psPzu4NuUHsIY93ORkyPDXzJaI9433HNYlbfQDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabor Juhos <j4g8y7@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1800/2651] spi: spi-qpic-snand: skip BBM copy on regular raw reads
Date: Wed, 18 Nov 2026 15:50:40 +0100
Message-ID: <20261118150352.096939710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 48628ae6e70f4..efea3657a6d70 100644
--- a/drivers/spi/spi-qpic-snand.c
+++ b/drivers/spi/spi-qpic-snand.c
@@ -117,6 +117,7 @@ struct qpic_spi_nand {
 	__le32 addr2;
 	__le32 cmd;
 	u32 num_cw;
+	bool bbm_read;
 	bool oob_rw;
 	bool page_rw;
 	bool raw_rw;
@@ -453,6 +454,16 @@ static int qcom_spi_ecc_prepare_io_req_pipelined(struct nand_device *nand,
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
 
@@ -657,7 +668,8 @@ static int qcom_spi_read_last_cw(struct qcom_nand_controller *snandc,
 	 * This can be removed once single-byte bad block marker support
 	 * gets implemented in the SPINAND code.
 	 */
-	snandc->data_buffer[bbpos + 1] = snandc->data_buffer[bbpos];
+	if (snandc->qspi->bbm_read)
+		snandc->data_buffer[bbpos + 1] = snandc->data_buffer[bbpos];
 
 	memcpy(op->data.buf.in, snandc->data_buffer + bbpos, op->data.nbytes);
 
-- 
2.53.0



