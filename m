Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 082811DDCE;
	Tue, 16 Jul 2024 15:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145461; cv=none; b=hPAk0Ur6YLYWC24jNjzhuMZfnzOqMM3PtHLj0RfIWYcBWvy0QRxtpUpzhF7NEfoS1zpTbSrIX8bpXmcwMIM9RJ0lrNqY0a49i6VlprN/dSqdtK1yeY8VLMZIVOTmrkA8+Qng24fsMJfIcAjrBzSrIv3CFautcBnvN90s7TXKDZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145461; c=relaxed/simple;
	bh=vALNRUNckyJo14cXVeXcwEsOPBQ/H2pUh4QEKqoA6HA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sB+punamIqUb+2kiyIsU8zXzbGpymiuKPFLCiYnfAWL/QCHtl1S2YJGWF/pCXpMQWkOpkCzgqIOJTMEA7SAF7wHaj2HBtgKQTxrwUQT9oc7pIpryYG8Poa6MIOB4qTD3sNFgpRfFUiw2eJfjjVnXoJsGDxlGqN4hnG/BiszpRGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NufDXBDK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NufDXBDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DDDC116B1;
	Tue, 16 Jul 2024 15:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145460;
	bh=vALNRUNckyJo14cXVeXcwEsOPBQ/H2pUh4QEKqoA6HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NufDXBDKw/qA4r7jSoUkTeg8O5OKV2pZ+4uUry+Xt2GTSCYQ5ooP2hY0x+tSRP6oL
	 DMbsvNFLUrgxnmt4s2oK4PbQoE+TDqCfXI4qKRMIxL0K9P5dQmy8KF9375vPO1EuK/
	 7fbukplryCWjX8bbeATL3R2SeANzjsIYs0BgkNSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 31/96] firmware: cs_dsp: Fix overflow checking of wmfw header
Date: Tue, 16 Jul 2024 17:31:42 +0200
Message-ID: <20240716152747.709668928@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 3019b86bce16fbb5bc1964f3544d0ce7d0137278 ]

Fix the checking that firmware file buffer is large enough for the
wmfw header, to prevent overrunning the buffer.

The original code tested that the firmware data buffer contained
enough bytes for the sums of the size of the structs

	wmfw_header + wmfw_adsp1_sizes + wmfw_footer

But wmfw_adsp1_sizes is only used on ADSP1 firmware. For ADSP2 and
Halo Core the equivalent struct is wmfw_adsp2_sizes, which is
4 bytes longer. So the length check didn't guarantee that there
are enough bytes in the firmware buffer for a header with
wmfw_adsp2_sizes.

This patch splits the length check into three separate parts. Each
of the wmfw_header, wmfw_adsp?_sizes and wmfw_footer are checked
separately before they are used.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f6bc909e7673 ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Link: https://patch.msgid.link/20240627141432.93056-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 64ed9d3f5d5d8..fd1145b2894b3 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1228,6 +1228,10 @@ static unsigned int cs_dsp_adsp1_parse_sizes(struct cs_dsp *dsp,
 	const struct wmfw_adsp1_sizes *adsp1_sizes;
 
 	adsp1_sizes = (void *)&firmware->data[pos];
+	if (sizeof(*adsp1_sizes) > firmware->size - pos) {
+		cs_dsp_err(dsp, "%s: file truncated\n", file);
+		return 0;
+	}
 
 	cs_dsp_dbg(dsp, "%s: %d DM, %d PM, %d ZM\n", file,
 		   le32_to_cpu(adsp1_sizes->dm), le32_to_cpu(adsp1_sizes->pm),
@@ -1244,6 +1248,10 @@ static unsigned int cs_dsp_adsp2_parse_sizes(struct cs_dsp *dsp,
 	const struct wmfw_adsp2_sizes *adsp2_sizes;
 
 	adsp2_sizes = (void *)&firmware->data[pos];
+	if (sizeof(*adsp2_sizes) > firmware->size - pos) {
+		cs_dsp_err(dsp, "%s: file truncated\n", file);
+		return 0;
+	}
 
 	cs_dsp_dbg(dsp, "%s: %d XM, %d YM %d PM, %d ZM\n", file,
 		   le32_to_cpu(adsp2_sizes->xm), le32_to_cpu(adsp2_sizes->ym),
@@ -1283,7 +1291,6 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 	struct regmap *regmap = dsp->regmap;
 	unsigned int pos = 0;
 	const struct wmfw_header *header;
-	const struct wmfw_adsp1_sizes *adsp1_sizes;
 	const struct wmfw_footer *footer;
 	const struct wmfw_region *region;
 	const struct cs_dsp_region *mem;
@@ -1296,10 +1303,8 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 
 	ret = -EINVAL;
 
-	pos = sizeof(*header) + sizeof(*adsp1_sizes) + sizeof(*footer);
-	if (pos >= firmware->size) {
-		cs_dsp_err(dsp, "%s: file too short, %zu bytes\n",
-			   file, firmware->size);
+	if (sizeof(*header) >= firmware->size) {
+		ret = -EOVERFLOW;
 		goto out_fw;
 	}
 
@@ -1327,13 +1332,16 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 
 	pos = sizeof(*header);
 	pos = dsp->ops->parse_sizes(dsp, file, pos, firmware);
+	if ((pos == 0) || (sizeof(*footer) > firmware->size - pos)) {
+		ret = -EOVERFLOW;
+		goto out_fw;
+	}
 
 	footer = (void *)&firmware->data[pos];
 	pos += sizeof(*footer);
 
 	if (le32_to_cpu(header->len) != pos) {
-		cs_dsp_err(dsp, "%s: unexpected header length %d\n",
-			   file, le32_to_cpu(header->len));
+		ret = -EOVERFLOW;
 		goto out_fw;
 	}
 
@@ -1459,6 +1467,9 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 	cs_dsp_buf_free(&buf_list);
 	kfree(text);
 
+	if (ret == -EOVERFLOW)
+		cs_dsp_err(dsp, "%s: file content overflows file data\n", file);
+
 	return ret;
 }
 
-- 
2.43.0



