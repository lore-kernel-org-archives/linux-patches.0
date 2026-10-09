Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DF344E77EB;
	Fri,  9 Oct 2026 14:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557010; cv=none; b=tiHHk1WsA8ZmdZwoVX3r9VegpXD0oWQAE3m+3/1Qads3aPYaTf0zsk1+CPCHUWbFMzq7xg9ySvo3lTMTjfkkqaALE1yRWZeDMSU60k8sJhnvpBzgX8sOCxF4LW3RtwXQdZtNHfz/ezd4Cf9rqjBAj/Je25TPU9aZ7wNSNWJoNi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557010; c=relaxed/simple;
	bh=7bdI1iQ1DOmpskIk8jfAJVOJoEvNrFF9HiIsTfYcQKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gelydzmuGaOKpsW8A5VGE4dUrlY4Emnso09bEzjFwciXp5YNdIK2bs6QZCZggWLJiIu4dPtU4sXY9qQNPfHgToXlwWSPJ9nkQrjN62HJvjcsuwwQahex8L/oTJ7kUwck8ZsYrdjTmu5j5WNDiF9RaYPmIedm8+3WH+QTzsZhTig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KK7vNWq4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KK7vNWq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2DF1F000FF;
	Fri,  9 Oct 2026 14:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557009;
	bh=l+3fQwnzWyPGHPWbFTKWcXGwdaNYxEy5N3BjTi2cmK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KK7vNWq4Dfkhs83i52YEbyRLxJinYWUZk+8Ub5cwJgsROoflYKBsZShV52iMFAyA5
	 NgvbIxtYPRFQPf49DB/EYvxIEna1mS/thgoKdfyzn/13wNISggyGraIcFoQ7+Ile7f
	 e7pjnWM6vFNO04qx9NX3c1QmkxUuAaKKSPvb7g1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 332/403] iio: proximity: aw96103: validate firmware data length
Date: Fri,  9 Oct 2026 16:11:33 +0200
Message-ID: <20261009141000.003593499@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

commit 1a7c522a35477d70320bd64aba8e9de0c1058c6f upstream.

The firmware parser reads a length from the binary header and then uses
it to walk six-byte register/value entries. A truncated firmware image
can make the parser read beyond the copied firmware buffer. A value
smaller than the four-byte count field also underflows, producing a very
large length.

Read the little-endian field with get_unaligned_le32(), as previously
proposed by David Lechner. Validate the header size, reject an
underflowed length, ensure the resulting payload is contained in the
firmware image, and require it to contain whole register/value entries.

Fixes: 07b241262dca ("iio: proximity: aw96103: Add support for aw96103/aw96105 proximity sensor")
Link: https://lore.kernel.org/r/20260314-iio-proximity-aw96103-fix-firmware-read-v1-1-c74fe9ccd82b@baylibre.com
Cc: stable@vger.kernel.org
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/aw96103.c |   30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

--- a/drivers/iio/proximity/aw96103.c
+++ b/drivers/iio/proximity/aw96103.c
@@ -24,6 +24,7 @@
 #define AW96103_BIN_VALID_DATA_OFFSET		64
 #define AW96103_BIN_DATA_LEN_OFFSET		16
 #define AW96103_BIN_DATA_REG_NUM_SIZE		4
+#define AW96103_BIN_REG_SIZE			6
 #define AW96103_BIN_CHIP_TYPE_SIZE		8
 #define AW96103_BIN_CHIP_TYPE_OFFSET		24
 
@@ -229,14 +230,27 @@ static const struct aw_chip_info aw_chip
 	},
 };
 
-static void aw96103_parsing_bin_file(struct aw_bin *bin)
+static int aw96103_parsing_bin_file(struct aw_bin *bin)
 {
+	u32 data_len;
+
+	if (bin->len < AW96103_BIN_VALID_DATA_OFFSET)
+		return -EINVAL;
+
+	data_len = get_unaligned_le32(bin->data + AW96103_BIN_DATA_LEN_OFFSET);
+	if (data_len < AW96103_BIN_DATA_REG_NUM_SIZE)
+		return -EINVAL;
+
+	bin->valid_data_len = data_len - AW96103_BIN_DATA_REG_NUM_SIZE;
+	if (bin->valid_data_len > bin->len - AW96103_BIN_VALID_DATA_OFFSET ||
+	    bin->valid_data_len % AW96103_BIN_REG_SIZE)
+		return -EINVAL;
+
 	bin->valid_data_addr = AW96103_BIN_VALID_DATA_OFFSET;
-	bin->valid_data_len =
-		*(unsigned int *)(bin->data + AW96103_BIN_DATA_LEN_OFFSET) -
-		AW96103_BIN_DATA_REG_NUM_SIZE;
 	memcpy(bin->chip_type, bin->data + AW96103_BIN_CHIP_TYPE_OFFSET,
 	       AW96103_BIN_CHIP_TYPE_SIZE);
+
+	return 0;
 }
 
 static const struct regmap_config aw96103_regmap_confg = {
@@ -500,7 +514,7 @@ static int aw96103_bin_valid_loaded(stru
 	int ret;
 
 	for (i = 0; i < aw_bin_data_s->valid_data_len;
-	     i += 6, start_addr += 6) {
+	     i += AW96103_BIN_REG_SIZE, start_addr += AW96103_BIN_REG_SIZE) {
 		reg_addr = get_unaligned_le16(aw_bin_data_s->data + start_addr);
 		reg_data = get_unaligned_le32(aw_bin_data_s->data +
 					      start_addr + 2);
@@ -550,6 +564,8 @@ static int aw96103_para_loaded(struct aw
 static int aw96103_cfg_all_loaded(const struct firmware *cont,
 				  struct aw96103 *aw96103)
 {
+	int ret;
+
 	if (!cont)
 		return -EINVAL;
 
@@ -561,7 +577,9 @@ static int aw96103_cfg_all_loaded(const
 	aw_bin->len = cont->size;
 	memcpy(aw_bin->data, cont->data, cont->size);
 	release_firmware(cont);
-	aw96103_parsing_bin_file(aw_bin);
+	ret = aw96103_parsing_bin_file(aw_bin);
+	if (ret)
+		return ret;
 
 	return aw96103_bin_valid_loaded(aw96103, aw_bin);
 }


