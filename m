Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A41525783C;
	Wed,  9 Sep 2026 14:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963436; cv=none; b=GET9YoxQDHEV60Hwl+9GUJ296mVLUTnL35dGoSZ0Bi1Onh1tEOfxQ4ytRVDDNMbuVzheyC+VOTwPUtrdCB7S4oekz5tNWaJ6kAEeJDUVpLGZYspwgIlO2sQ55BzyETmAfJHqn6ucE+z14i4Br3GWmCA+QLPLSd8UbLQ9JlIKI0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963436; c=relaxed/simple;
	bh=Tsbdx5/JnNo0Jd5eMZNf/dr2Fk52HmOZ2nmMQbsso+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHT+rgq1RwuMFoZsrUIF3bWHOzZ1iutyqrCgDnQqQgC7LvBYkMHHuA9x9gN1iu7AF0cRFeZEn+wUSB0ouP+oSKqtovSBSD4Qz8aLwy/wWg3gmQP76yMmNFXLrYjz6WGXZxt4anFjI9VVJeprgPCqYjfpytWfQx4aCPgxmqFbLL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiHm1B7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiHm1B7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FFEA1F00A3A;
	Wed,  9 Sep 2026 14:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963435;
	bh=zV+Zmo14j9iHOGB71uZw075ZuNe//q+/dk6LTxDtNIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UiHm1B7iIwj52imrH0pGv9+32jO/K5ZAOHTchci1GfO5Ihyp1yv1nToUP0YvhQ+oz
	 47E0pma3OLdCmlntZ/lyIfi7y6lsAZlcuHmIyQMnUF5h7gDXh6ZjZEItV57cguZIMi
	 woYmMrWsuIk0n5UjZyT3AEunz0+a9x/R5ugNJe0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.18 039/583] soc: qcom: geni-se: Use HW PROG_RAM_DEPTH to validate firmware size
Date: Wed,  9 Sep 2026 15:35:24 +0200
Message-ID: <20260909134239.273155822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>

commit 522bfb4f33c0930b3d14d5c5ee80bc93a883b544 upstream.

The hardcoded MAX_GENI_CFG_RAMn_CNT limit is not accurate for all SoCs:
some targets have less CFG RAM than the constant implies, while others
like QCS615 need more entries than the old limit of 455 allowed, causing
valid firmware to be rejected at load time.

Rather than hardcoding a constant, read PROG_RAM_DEPTH from SE_HW_PARAM_2
at runtime to get the actual CFG RAM depth of the hardware instance and
use that as the upper bound for firmware size validation.

Fixes: d4bf06592ad6 ("soc: qcom: geni-se: Add support to load QUP SE Firmware via Linux subsystem")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Viken Dadhaniya <viken.dadhaniya@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260702-qup-se-increase-ram-cnt-v3-1-80b363373a5b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/qcom-geni-se.c  |   24 +++++++++++++-----------
 include/linux/soc/qcom/geni-se.h |    4 ++++
 2 files changed, 17 insertions(+), 11 deletions(-)

--- a/drivers/soc/qcom/qcom-geni-se.c
+++ b/drivers/soc/qcom/qcom-geni-se.c
@@ -152,8 +152,6 @@ struct se_fw_hdr {
 /*Magic numbers*/
 #define SE_MAGIC_NUM			0x57464553
 
-#define MAX_GENI_CFG_RAMn_CNT		455
-
 #define MI_PBT_NON_PAGED_SEGMENT	0x0
 #define MI_PBT_HASH_SEGMENT		0x2
 #define MI_PBT_NOTUSED_SEGMENT		0x3
@@ -990,24 +988,27 @@ EXPORT_SYMBOL_GPL(geni_icc_disable);
 
 /**
  * geni_find_protocol_fw() - Locate and validate SE firmware for a protocol.
- * @dev: Pointer to the device structure.
+ * @se: Pointer to the serial engine structure.
  * @fw: Pointer to the firmware image.
  * @protocol: Expected serial engine protocol type.
  *
  * Identifies the appropriate firmware image or configuration required for a
- * specific communication protocol instance running on a  Qualcomm GENI
- * controller.
+ * specific communication protocol instance running on a Qualcomm GENI
+ * controller. Validates the firmware size against the hardware PROG_RAM_DEPTH
+ * read from SE_HW_PARAM_2.
  *
  * Return: pointer to a valid 'struct se_fw_hdr' if found, or NULL otherwise.
  */
-static struct se_fw_hdr *geni_find_protocol_fw(struct device *dev, const struct firmware *fw,
+static struct se_fw_hdr *geni_find_protocol_fw(struct geni_se *se, const struct firmware *fw,
 					       enum geni_se_protocol_type protocol)
 {
+	struct device *dev = se->dev;
 	const struct elf32_hdr *ehdr;
 	const struct elf32_phdr *phdrs;
 	const struct elf32_phdr	*phdr;
 	struct se_fw_hdr *sefw;
 	u32 fw_end, cfg_idx_end, cfg_val_end;
+	u32 prog_ram_depth;
 	u16 fw_size;
 	int i;
 
@@ -1066,10 +1067,11 @@ static struct se_fw_hdr *geni_find_proto
 			sefw->fw_size_in_items = cpu_to_le16(fw_size);
 		}
 
-		if (fw_size >= MAX_GENI_CFG_RAMn_CNT) {
-			dev_err(dev,
-				"Firmware size (%u) exceeds max allowed RAMn count (%u)\n",
-				fw_size, MAX_GENI_CFG_RAMn_CNT);
+		prog_ram_depth = FIELD_GET(PROG_RAM_DEPTH_MSK,
+					   readl_relaxed(se->base + SE_HW_PARAM_2));
+		if (fw_size >= prog_ram_depth) {
+			dev_err(dev, "Firmware size (%u) exceeds RAM size (%u)\n",
+				fw_size, prog_ram_depth);
 			continue;
 		}
 
@@ -1193,7 +1195,7 @@ static int geni_load_se_fw(struct geni_s
 	int ret;
 	struct se_fw_hdr *hdr;
 
-	hdr = geni_find_protocol_fw(se->dev, fw, protocol);
+	hdr = geni_find_protocol_fw(se, fw, protocol);
 	if (!hdr)
 		return -EINVAL;
 
--- a/include/linux/soc/qcom/geni-se.h
+++ b/include/linux/soc/qcom/geni-se.h
@@ -118,6 +118,7 @@ struct geni_se {
 #define SE_DMA_RX_FSM_RST		0xd58
 #define SE_HW_PARAM_0			0xe24
 #define SE_HW_PARAM_1			0xe28
+#define SE_HW_PARAM_2			0xe2c
 
 /* GENI_FORCE_DEFAULT_REG fields */
 #define FORCE_DEFAULT	BIT(0)
@@ -285,6 +286,9 @@ struct geni_se {
 #define RX_FIFO_DEPTH_MSK		GENMASK(21, 16)
 #define RX_FIFO_DEPTH_SHFT		16
 
+/* SE_HW_PARAM_2 fields */
+#define PROG_RAM_DEPTH_MSK		GENMASK(10, 0)
+
 #define HW_VER_MAJOR_MASK		GENMASK(31, 28)
 #define HW_VER_MAJOR_SHFT		28
 #define HW_VER_MINOR_MASK		GENMASK(27, 16)


