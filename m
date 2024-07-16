Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28EB1DA4D;
	Tue, 16 Jul 2024 15:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144971; cv=none; b=u+kuP9TYIMyuKWrwTXlLYjTRajvEuCJDRfV4lU2sZuQ9snGYTRO7ZkZS523zeANtTALU03XlpSt4ONEpZqGWru08QCNvKtVWDTqFz+QkTNvG9FSXzuK4Yw+H8/V0Pl+au+s3HK9Fy9X6bukH+gRQf12ud34CgPAMXybr7U2oZKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144971; c=relaxed/simple;
	bh=WGzhKZQEeh2kp13Gd/oPVk4iRElzQAKOmCbvj8Bxhhg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l3+FwXZ1yUR7bGodsZQYvLsHNdoRvHr03d1QopQSuOdN7yu3G3tVYfFOD7o5sCxWcRoX5NigcBOD7eur0H5FDcB30+Wsmb4x38/Jxv40UPMu7G/1O1B2F46BebM1sDbNQC2K3fg2PGysqG3oC4i80LBCPxwvzwldBrV67MGPdx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GH3F52V8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GH3F52V8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35F28C116B1;
	Tue, 16 Jul 2024 15:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144971;
	bh=WGzhKZQEeh2kp13Gd/oPVk4iRElzQAKOmCbvj8Bxhhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GH3F52V8VeNqfcR3DllqoO4bm9CCsQcZYt1o/yjndA9wP7VhTUzzRnh1nebvj3wTO
	 x48GJV42C2eX2Xnk0PkjXw32ctODQa5Q1qphA9tcxgNvGyd8H0TnTibK5x0RWZqoHD
	 9ooTxh3fyWhRTxQBuQ2wQY2ouzuHE/iv9/PNYDTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 054/143] firmware: cs_dsp: Prevent buffer overrun when processing V2 alg headers
Date: Tue, 16 Jul 2024 17:30:50 +0200
Message-ID: <20240716152758.061653485@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 2163aff6bebbb752edf73f79700f5e2095f3559e ]

Check that all fields of a V2 algorithm header fit into the available
firmware data buffer.

The wmfw V2 format introduced variable-length strings in the algorithm
block header. This means the overall header length is variable, and the
position of most fields varies depending on the length of the string
fields. Each field must be checked to ensure that it does not overflow
the firmware data buffer.

As this ia bugfix patch, the fixes avoid making any significant change to
the existing code. This makes it easier to review and less likely to
introduce new bugs.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f6bc909e7673 ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Link: https://patch.msgid.link/20240627141432.93056-5-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 144 ++++++++++++++++++++++++-------
 1 file changed, 113 insertions(+), 31 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 68dbbcd55b34c..b6fd2ea1ce643 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1053,9 +1053,16 @@ struct cs_dsp_coeff_parsed_coeff {
 	int len;
 };
 
-static int cs_dsp_coeff_parse_string(int bytes, const u8 **pos, const u8 **str)
+static int cs_dsp_coeff_parse_string(int bytes, const u8 **pos, unsigned int avail,
+				     const u8 **str)
 {
-	int length;
+	int length, total_field_len;
+
+	/* String fields are at least one __le32 */
+	if (sizeof(__le32) > avail) {
+		*pos = NULL;
+		return 0;
+	}
 
 	switch (bytes) {
 	case 1:
@@ -1068,10 +1075,16 @@ static int cs_dsp_coeff_parse_string(int bytes, const u8 **pos, const u8 **str)
 		return 0;
 	}
 
+	total_field_len = ((length + bytes) + 3) & ~0x03;
+	if ((unsigned int)total_field_len > avail) {
+		*pos = NULL;
+		return 0;
+	}
+
 	if (str)
 		*str = *pos + bytes;
 
-	*pos += ((length + bytes) + 3) & ~0x03;
+	*pos += total_field_len;
 
 	return length;
 }
@@ -1096,51 +1109,100 @@ static int cs_dsp_coeff_parse_int(int bytes, const u8 **pos)
 	return val;
 }
 
-static inline void cs_dsp_coeff_parse_alg(struct cs_dsp *dsp, const u8 **data,
-					  struct cs_dsp_coeff_parsed_alg *blk)
+static int cs_dsp_coeff_parse_alg(struct cs_dsp *dsp,
+				  const struct wmfw_region *region,
+				  struct cs_dsp_coeff_parsed_alg *blk)
 {
 	const struct wmfw_adsp_alg_data *raw;
+	unsigned int data_len = le32_to_cpu(region->len);
+	unsigned int pos;
+	const u8 *tmp;
+
+	raw = (const struct wmfw_adsp_alg_data *)region->data;
 
 	switch (dsp->fw_ver) {
 	case 0:
 	case 1:
-		raw = (const struct wmfw_adsp_alg_data *)*data;
-		*data = raw->data;
+		if (sizeof(*raw) > data_len)
+			return -EOVERFLOW;
 
 		blk->id = le32_to_cpu(raw->id);
 		blk->name = raw->name;
 		blk->name_len = strlen(raw->name);
 		blk->ncoeff = le32_to_cpu(raw->ncoeff);
+
+		pos = sizeof(*raw);
 		break;
 	default:
-		blk->id = cs_dsp_coeff_parse_int(sizeof(raw->id), data);
-		blk->name_len = cs_dsp_coeff_parse_string(sizeof(u8), data,
+		if (sizeof(raw->id) > data_len)
+			return -EOVERFLOW;
+
+		tmp = region->data;
+		blk->id = cs_dsp_coeff_parse_int(sizeof(raw->id), &tmp);
+		pos = tmp - region->data;
+
+		tmp = &region->data[pos];
+		blk->name_len = cs_dsp_coeff_parse_string(sizeof(u8), &tmp, data_len - pos,
 							  &blk->name);
-		cs_dsp_coeff_parse_string(sizeof(u16), data, NULL);
-		blk->ncoeff = cs_dsp_coeff_parse_int(sizeof(raw->ncoeff), data);
+		if (!tmp)
+			return -EOVERFLOW;
+
+		pos = tmp - region->data;
+		cs_dsp_coeff_parse_string(sizeof(u16), &tmp, data_len - pos, NULL);
+		if (!tmp)
+			return -EOVERFLOW;
+
+		pos = tmp - region->data;
+		if (sizeof(raw->ncoeff) > (data_len - pos))
+			return -EOVERFLOW;
+
+		blk->ncoeff = cs_dsp_coeff_parse_int(sizeof(raw->ncoeff), &tmp);
+		pos += sizeof(raw->ncoeff);
 		break;
 	}
 
+	if ((int)blk->ncoeff < 0)
+		return -EOVERFLOW;
+
 	cs_dsp_dbg(dsp, "Algorithm ID: %#x\n", blk->id);
 	cs_dsp_dbg(dsp, "Algorithm name: %.*s\n", blk->name_len, blk->name);
 	cs_dsp_dbg(dsp, "# of coefficient descriptors: %#x\n", blk->ncoeff);
+
+	return pos;
 }
 
-static inline void cs_dsp_coeff_parse_coeff(struct cs_dsp *dsp, const u8 **data,
-					    struct cs_dsp_coeff_parsed_coeff *blk)
+static int cs_dsp_coeff_parse_coeff(struct cs_dsp *dsp,
+				    const struct wmfw_region *region,
+				    unsigned int pos,
+				    struct cs_dsp_coeff_parsed_coeff *blk)
 {
 	const struct wmfw_adsp_coeff_data *raw;
+	unsigned int data_len = le32_to_cpu(region->len);
+	unsigned int blk_len, blk_end_pos;
 	const u8 *tmp;
-	int length;
+
+	raw = (const struct wmfw_adsp_coeff_data *)&region->data[pos];
+	if (sizeof(raw->hdr) > (data_len - pos))
+		return -EOVERFLOW;
+
+	blk_len = le32_to_cpu(raw->hdr.size);
+	if (blk_len > S32_MAX)
+		return -EOVERFLOW;
+
+	if (blk_len > (data_len - pos - sizeof(raw->hdr)))
+		return -EOVERFLOW;
+
+	blk_end_pos = pos + sizeof(raw->hdr) + blk_len;
+
+	blk->offset = le16_to_cpu(raw->hdr.offset);
+	blk->mem_type = le16_to_cpu(raw->hdr.type);
 
 	switch (dsp->fw_ver) {
 	case 0:
 	case 1:
-		raw = (const struct wmfw_adsp_coeff_data *)*data;
-		*data = *data + sizeof(raw->hdr) + le32_to_cpu(raw->hdr.size);
+		if (sizeof(*raw) > (data_len - pos))
+			return -EOVERFLOW;
 
-		blk->offset = le16_to_cpu(raw->hdr.offset);
-		blk->mem_type = le16_to_cpu(raw->hdr.type);
 		blk->name = raw->name;
 		blk->name_len = strlen(raw->name);
 		blk->ctl_type = le16_to_cpu(raw->ctl_type);
@@ -1148,19 +1210,33 @@ static inline void cs_dsp_coeff_parse_coeff(struct cs_dsp *dsp, const u8 **data,
 		blk->len = le32_to_cpu(raw->len);
 		break;
 	default:
-		tmp = *data;
-		blk->offset = cs_dsp_coeff_parse_int(sizeof(raw->hdr.offset), &tmp);
-		blk->mem_type = cs_dsp_coeff_parse_int(sizeof(raw->hdr.type), &tmp);
-		length = cs_dsp_coeff_parse_int(sizeof(raw->hdr.size), &tmp);
-		blk->name_len = cs_dsp_coeff_parse_string(sizeof(u8), &tmp,
+		pos += sizeof(raw->hdr);
+		tmp = &region->data[pos];
+		blk->name_len = cs_dsp_coeff_parse_string(sizeof(u8), &tmp, data_len - pos,
 							  &blk->name);
-		cs_dsp_coeff_parse_string(sizeof(u8), &tmp, NULL);
-		cs_dsp_coeff_parse_string(sizeof(u16), &tmp, NULL);
+		if (!tmp)
+			return -EOVERFLOW;
+
+		pos = tmp - region->data;
+		cs_dsp_coeff_parse_string(sizeof(u8), &tmp, data_len - pos, NULL);
+		if (!tmp)
+			return -EOVERFLOW;
+
+		pos = tmp - region->data;
+		cs_dsp_coeff_parse_string(sizeof(u16), &tmp, data_len - pos, NULL);
+		if (!tmp)
+			return -EOVERFLOW;
+
+		pos = tmp - region->data;
+		if (sizeof(raw->ctl_type) + sizeof(raw->flags) + sizeof(raw->len) >
+		    (data_len - pos))
+			return -EOVERFLOW;
+
 		blk->ctl_type = cs_dsp_coeff_parse_int(sizeof(raw->ctl_type), &tmp);
+		pos += sizeof(raw->ctl_type);
 		blk->flags = cs_dsp_coeff_parse_int(sizeof(raw->flags), &tmp);
+		pos += sizeof(raw->flags);
 		blk->len = cs_dsp_coeff_parse_int(sizeof(raw->len), &tmp);
-
-		*data = *data + sizeof(raw->hdr) + length;
 		break;
 	}
 
@@ -1170,6 +1246,8 @@ static inline void cs_dsp_coeff_parse_coeff(struct cs_dsp *dsp, const u8 **data,
 	cs_dsp_dbg(dsp, "\tCoefficient flags: %#x\n", blk->flags);
 	cs_dsp_dbg(dsp, "\tALSA control type: %#x\n", blk->ctl_type);
 	cs_dsp_dbg(dsp, "\tALSA control len: %#x\n", blk->len);
+
+	return blk_end_pos;
 }
 
 static int cs_dsp_check_coeff_flags(struct cs_dsp *dsp,
@@ -1193,12 +1271,16 @@ static int cs_dsp_parse_coeff(struct cs_dsp *dsp,
 	struct cs_dsp_alg_region alg_region = {};
 	struct cs_dsp_coeff_parsed_alg alg_blk;
 	struct cs_dsp_coeff_parsed_coeff coeff_blk;
-	const u8 *data = region->data;
-	int i, ret;
+	int i, pos, ret;
+
+	pos = cs_dsp_coeff_parse_alg(dsp, region, &alg_blk);
+	if (pos < 0)
+		return pos;
 
-	cs_dsp_coeff_parse_alg(dsp, &data, &alg_blk);
 	for (i = 0; i < alg_blk.ncoeff; i++) {
-		cs_dsp_coeff_parse_coeff(dsp, &data, &coeff_blk);
+		pos = cs_dsp_coeff_parse_coeff(dsp, region, pos, &coeff_blk);
+		if (pos < 0)
+			return pos;
 
 		switch (coeff_blk.ctl_type) {
 		case WMFW_CTL_TYPE_BYTES:
-- 
2.43.0



