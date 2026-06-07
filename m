Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B616E2AD00;
	Sun,  7 Jun 2026 10:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827458; cv=none; b=OX0vgq2v7T5nH2JT/ZibG8LThcWZFqdV/G9RUGpD7pCaFFQ5/RYr+83yolYl+/j8eE3u6OKUrtZ6TuzPHOWcQ7ADViWU2nTB30Phr5WBhNNyut+PrQ+kHfNX8jbCP8m/ghWovsRDs8muzAs6G2ogYGrLMfpvIc20feX70d20P9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827458; c=relaxed/simple;
	bh=PXyu85d7mKe85l8sMH+cdyQkWIFgW1C3QKSPOTQKwa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhdy4ymMYz9JZtPJJwlMd2UHV0ZqZ7LdTHrZHYCWRktWNvazVJy1vNy2YN05OF5jYN+kPhznzqoy9a4zJdBkNAUzQN6kabLVOkQsgpKXl+Gm8qCr+/HAxf80cpaj0RRLMt4BUdc/FXgIsw8dq/R9+1GHH51Wzta5oaQrHJya71w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PS50NR37; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PS50NR37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CA41F00893;
	Sun,  7 Jun 2026 10:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827457;
	bh=axAw4j+1FZTptNB/reG1pQnUVHIuTaeBOFaN45pB+SY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PS50NR378Wi0g4/CKYQHIdHHPrtA3BNrfq4Hevc7SMPJmyrk9jvhm4RRLvAtSDxUD
	 tn6bi8VtegVVRfVOERiMvYxRYF2nWRHqzUUPnO7mTfXETBJcEDn5owYcPTHKW9dzuC
	 6hOSiXLSyKwGPTfbiAZBm1zu7/pT6NbeSybZPaU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Danielle Ratson <danieller@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 057/307] ethtool: cmis: validate start_cmd_payload_size from module
Date: Sun,  7 Jun 2026 11:57:34 +0200
Message-ID: <20260607095729.831436786@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 12c2496a71f82f63617971ca9b730dffa05cf58b ]

The CMIS firmware update code reads start_cmd_payload_size from
the module's FW Management Features CDB reply and uses it directly
as the byte count for memcpy. The destination buffer is 112 bytes
(ETHTOOL_CMIS_CDB_LPL_MAX_PL_LENGTH - 8). So a malicious
module (or corrupted response) can cause a OOB write later on in
cmis_fw_update_start_download().

Let's error out. If modules that expect longer LPL writes actually
exist we should revisit.

struct cmis_cdb_start_fw_download_pl's definition has to move,
no change there.

Fixes: c4f78134d45c ("ethtool: cmis_fw_update: add a layer for supporting firmware update using CDB")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Reviewed-by: Danielle Ratson <danieller@nvidia.com>
Link: https://patch.msgid.link/20260522231312.1710836-9-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ethtool/cmis_fw_update.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/net/ethtool/cmis_fw_update.c b/net/ethtool/cmis_fw_update.c
index 48aef6220f0094..560bafd4d16864 100644
--- a/net/ethtool/cmis_fw_update.c
+++ b/net/ethtool/cmis_fw_update.c
@@ -43,6 +43,20 @@ enum cmis_cdb_fw_write_mechanism {
 	CMIS_CDB_FW_WRITE_MECHANISM_BOTH	= 0x11,
 };
 
+/* See section 9.7.2 "CMD 0101h: Start Firmware Download" in CMIS standard
+ * revision 5.2.
+ * struct cmis_cdb_start_fw_download_pl is a structured layout of the
+ * flat array, ethtool_cmis_cdb_request::payload.
+ */
+struct cmis_cdb_start_fw_download_pl {
+	__struct_group(cmis_cdb_start_fw_download_pl_h, head, /* no attrs */,
+			__be32	image_size;
+			__be32	resv1;
+	);
+	u8 vendor_data[ETHTOOL_CMIS_CDB_LPL_MAX_PL_LENGTH -
+		sizeof(struct cmis_cdb_start_fw_download_pl_h)];
+};
+
 static int
 cmis_fw_update_fw_mng_features_get(struct ethtool_cmis_cdb *cdb,
 				   struct net_device *dev,
@@ -85,6 +99,14 @@ cmis_fw_update_fw_mng_features_get(struct ethtool_cmis_cdb *cdb,
 	 */
 	cdb->read_write_len_ext = rpl->read_write_len_ext;
 	fw_mng->start_cmd_payload_size = rpl->start_cmd_payload_size;
+	if (fw_mng->start_cmd_payload_size >
+	    sizeof_field(struct cmis_cdb_start_fw_download_pl, vendor_data)) {
+		ethnl_module_fw_flash_ntf_err(dev, ntf_params,
+					      "Start cmd payload size exceeds max LPL payload",
+					      NULL);
+		return -EINVAL;
+	}
+
 	fw_mng->write_mechanism =
 		rpl->write_mechanism == CMIS_CDB_FW_WRITE_MECHANISM_LPL ?
 		CMIS_CDB_FW_WRITE_MECHANISM_LPL :
@@ -96,20 +118,6 @@ cmis_fw_update_fw_mng_features_get(struct ethtool_cmis_cdb *cdb,
 	return 0;
 }
 
-/* See section 9.7.2 "CMD 0101h: Start Firmware Download" in CMIS standard
- * revision 5.2.
- * struct cmis_cdb_start_fw_download_pl is a structured layout of the
- * flat array, ethtool_cmis_cdb_request::payload.
- */
-struct cmis_cdb_start_fw_download_pl {
-	__struct_group(cmis_cdb_start_fw_download_pl_h, head, /* no attrs */,
-			__be32	image_size;
-			__be32	resv1;
-	);
-	u8 vendor_data[ETHTOOL_CMIS_CDB_LPL_MAX_PL_LENGTH -
-		sizeof(struct cmis_cdb_start_fw_download_pl_h)];
-};
-
 static int
 cmis_fw_update_start_download(struct ethtool_cmis_cdb *cdb,
 			      struct ethtool_cmis_fw_update_params *fw_update,
-- 
2.53.0



