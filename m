Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4FC27604E;
	Tue, 12 Aug 2025 19:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025422; cv=none; b=CKsDiaL85t7JJT3AlcF/ZPK8VrV0KWV8ZjmgZyYsju30olWU4Gk1c8NcOy5qjBGq+yNdZ4twCEwbryLvA0HVAsmaqSuMwcVFkvZz1kMYgyns47KZ16taDkYuCcLE/gKpTsuAgpCJ8V2iWVcs89FOzKe19DqbLQ1DKCVSjonaPnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025422; c=relaxed/simple;
	bh=JFBq2h0j7EtNEi3Hh3vWGLGj173dHhKS2Xp8OC5iV7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G9zb/HjqHSH7jMb4qlZGB1iXmtECeEoGhwpLsZW2Y/wGV+vgoexFiTRkCZVnxv1gJUNjqB5hQRMF2wrMHRPyKYb8L9+k+8bvrHVRBVsoXNWVDN7PTr1OIGEL2p/2TpB1UcNuR4BepgaVirTZ8KQNyQ/rm3yOiyolJD+visfou34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cfr+wc5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cfr+wc5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC19C4CEF0;
	Tue, 12 Aug 2025 19:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025422;
	bh=JFBq2h0j7EtNEi3Hh3vWGLGj173dHhKS2Xp8OC5iV7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cfr+wc5lfZIoH+gP2uUK2oUVNAPxHXFVqcXVFBPIu/U7O3FzEnbObN+fdnboXSHBN
	 Zq3HN3fWZrX0uAtMP9ZlrdhW/3vy5CWcC6oWt7ZO0l5MBTMpwX7tHXzg3P7ARwYhUS
	 L2bIc/j8hcE3gRBUwqCxFPJ0mx41JARTZ5Zh1k4w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wilhelm <alexander.wilhelm@westermo.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 035/480] soc: qcom: QMI encoding/decoding for big endian
Date: Tue, 12 Aug 2025 19:44:03 +0200
Message-ID: <20250812174358.842894572@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Wilhelm <alexander.wilhelm@westermo.com>

[ Upstream commit 3ced38da5f7de4c260f9eaa86fc805827953243a ]

The QMI_DATA_LEN type may have different sizes. Taking the element's
address of that type and interpret it as a smaller sized ones works fine
for little endian platforms but not for big endian ones. Instead use
temporary variables of smaller sized types and cast them correctly to
support big endian platforms.

Signed-off-by: Alexander Wilhelm <alexander.wilhelm@westermo.com>
Fixes: 9b8a11e82615 ("soc: qcom: Introduce QMI encoder/decoder")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250522143530.3623809-2-alexander.wilhelm@westermo.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/qmi_encdec.c | 46 +++++++++++++++++++++++++++++------
 1 file changed, 38 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/qcom/qmi_encdec.c b/drivers/soc/qcom/qmi_encdec.c
index bb09eff85cff..dafe0a4c202e 100644
--- a/drivers/soc/qcom/qmi_encdec.c
+++ b/drivers/soc/qcom/qmi_encdec.c
@@ -304,6 +304,8 @@ static int qmi_encode(const struct qmi_elem_info *ei_array, void *out_buf,
 	const void *buf_src;
 	int encode_tlv = 0;
 	int rc;
+	u8 val8;
+	u16 val16;
 
 	if (!ei_array)
 		return 0;
@@ -338,7 +340,6 @@ static int qmi_encode(const struct qmi_elem_info *ei_array, void *out_buf,
 			break;
 
 		case QMI_DATA_LEN:
-			memcpy(&data_len_value, buf_src, temp_ei->elem_size);
 			data_len_sz = temp_ei->elem_size == sizeof(u8) ?
 					sizeof(u8) : sizeof(u16);
 			/* Check to avoid out of range buffer access */
@@ -348,8 +349,17 @@ static int qmi_encode(const struct qmi_elem_info *ei_array, void *out_buf,
 				       __func__);
 				return -ETOOSMALL;
 			}
-			rc = qmi_encode_basic_elem(buf_dst, &data_len_value,
-						   1, data_len_sz);
+			if (data_len_sz == sizeof(u8)) {
+				val8 = *(u8 *)buf_src;
+				data_len_value = (u32)val8;
+				rc = qmi_encode_basic_elem(buf_dst, &val8,
+							   1, data_len_sz);
+			} else {
+				val16 = *(u16 *)buf_src;
+				data_len_value = (u32)le16_to_cpu(val16);
+				rc = qmi_encode_basic_elem(buf_dst, &val16,
+							   1, data_len_sz);
+			}
 			UPDATE_ENCODE_VARIABLES(temp_ei, buf_dst,
 						encoded_bytes, tlv_len,
 						encode_tlv, rc);
@@ -523,14 +533,23 @@ static int qmi_decode_string_elem(const struct qmi_elem_info *ei_array,
 	u32 string_len = 0;
 	u32 string_len_sz = 0;
 	const struct qmi_elem_info *temp_ei = ei_array;
+	u8 val8;
+	u16 val16;
 
 	if (dec_level == 1) {
 		string_len = tlv_len;
 	} else {
 		string_len_sz = temp_ei->elem_len <= U8_MAX ?
 				sizeof(u8) : sizeof(u16);
-		rc = qmi_decode_basic_elem(&string_len, buf_src,
-					   1, string_len_sz);
+		if (string_len_sz == sizeof(u8)) {
+			rc = qmi_decode_basic_elem(&val8, buf_src,
+						   1, string_len_sz);
+			string_len = (u32)val8;
+		} else {
+			rc = qmi_decode_basic_elem(&val16, buf_src,
+						   1, string_len_sz);
+			string_len = (u32)val16;
+		}
 		decoded_bytes += rc;
 	}
 
@@ -604,6 +623,9 @@ static int qmi_decode(const struct qmi_elem_info *ei_array, void *out_c_struct,
 	u32 decoded_bytes = 0;
 	const void *buf_src = in_buf;
 	int rc;
+	u8 val8;
+	u16 val16;
+	u32 val32;
 
 	while (decoded_bytes < in_buf_len) {
 		if (dec_level >= 2 && temp_ei->data_type == QMI_EOTI)
@@ -642,9 +664,17 @@ static int qmi_decode(const struct qmi_elem_info *ei_array, void *out_c_struct,
 		if (temp_ei->data_type == QMI_DATA_LEN) {
 			data_len_sz = temp_ei->elem_size == sizeof(u8) ?
 					sizeof(u8) : sizeof(u16);
-			rc = qmi_decode_basic_elem(&data_len_value, buf_src,
-						   1, data_len_sz);
-			memcpy(buf_dst, &data_len_value, sizeof(u32));
+			if (data_len_sz == sizeof(u8)) {
+				rc = qmi_decode_basic_elem(&val8, buf_src,
+							   1, data_len_sz);
+				data_len_value = (u32)val8;
+			} else {
+				rc = qmi_decode_basic_elem(&val16, buf_src,
+							   1, data_len_sz);
+				data_len_value = (u32)val16;
+			}
+			val32 = cpu_to_le32(data_len_value);
+			memcpy(buf_dst, &val32, sizeof(u32));
 			temp_ei = temp_ei + 1;
 			buf_dst = out_c_struct + temp_ei->offset;
 			tlv_len -= data_len_sz;
-- 
2.39.5



