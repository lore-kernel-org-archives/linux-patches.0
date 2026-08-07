Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2057C435AB2;
	Fri,  7 Aug 2026 14:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114194; cv=none; b=W8aVHRa/72gCyPYzO50QZ0J8ol+XKiVLt4nSI0RTgx25biUktC1KxPjXpjC4ymAq0fOMV0juW78uP6tidkZ2pp25yyNaXuVnNon6vmdZoCBQznt/Ea+7IZT+Kw5KkOqnEt3VmlTDsRRECufoCRemCxTyYGhhM6UDA+XbitJklzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114194; c=relaxed/simple;
	bh=1LW+VQ2gA52kNbPC+j93KpyjUUhoJLUgDrmgEHHtbdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRqVybVfGJ38OuKCUc5lqUxvCy6NhtnkfLnMbxwUit4UYfNGlZl1rWrGixD+EF2K4wQcASJVbqk0a1XwcvuDnjCE4o0ciVvdkJRy1KCzoLPNcT3tHQiizZ4uTLxbmlL7h7t8YC6BizyR6JLr/50WcyvW2bcNQ32K8zJHsMa0DSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dt5WlthF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dt5WlthF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3935E1F000E9;
	Fri,  7 Aug 2026 14:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114192;
	bh=O/mEm4DsAzXvgxb8eDW1Qrf3kuhCH6Gw6lr8IL2kMes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dt5WlthF3ECJ5cs+Ar/8/tARx5EtPkFc7QhdHzxhJ+6wfK9SOgkWwSmcQPRFVilDr
	 MI/JkNTti7e2QHiQwrThkwDf0OQoriNO2/qfsHzN113LZeZDk1rBJmaIaGQopgmzoC
	 uEl+7HX48S3yp+ARUsTqEBI8MAH5LRhy8cY8nEDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lakshmi Sowjanya D <lakshmi.d@oss.qualcomm.com>,
	Md Sadre Alam <md.alam@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 170/337] dmaengine: qcom: bam_dma: Fix command element mask field for BAM v1.6.0+
Date: Fri,  7 Aug 2026 16:36:13 +0200
Message-ID: <20260807143422.242588983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Md Sadre Alam <md.alam@oss.qualcomm.com>

commit 867621ba203027338b525af6729719c544135336 upstream.

BAM version 1.6.0 and later changed the behavior of the mask field in
command elements for read operations.

In older BAM versions, or prior implementation assumptions, the mask
field was effectively ignored for read commands. However, starting from
BAM v1.6.0, the mask field for read commands is repurposed to carry the
upper 4 bits of the destination address, enabling support for 36-bit
addressing. For write commands, the mask field continues to function as
a traditional write mask.

The current driver sets mask = 0xffffffff for all command elements.
While this works for write operations, it breaks read operations on
BAM v1.6.0+ hardware. In such cases, the hardware interprets the upper
address bits as 0xf, resulting in an invalid destination address
(0xf_xxxxxxxx instead of 0x0_xxxxxxxx).

This leads to failures such as NAND enumeration issues observed on
platforms like IPQ5424.

Fix this by assigning the mask field based on command type:
  - For read commands: set mask = 0 (upper address bits = 0)
  - For write commands: retain mask = 0xffffffff

Also update the bam_cmd_element structure documentation to reflect the
dual purpose of the mask field across BAM versions.

This ensures correct behavior on BAM v1.6.0+ while maintaining backward
compatibility with older hardware.

Fixes: dfebb055f73a2 ("dmaengine: qcom: bam_dma: wrapper functions for command descriptor")
Tested-by: Lakshmi Sowjanya D <lakshmi.d@oss.qualcomm.com>
Signed-off-by: Md Sadre Alam <md.alam@oss.qualcomm.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Varadarajan Narayanan <varadarajan.narayanan@oss.qualcomm.com>
Link: https://patch.msgid.link/20260615060908.1263171-1-varadarajan.narayanan@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/dma/qcom_bam_dma.h |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/include/linux/dma/qcom_bam_dma.h
+++ b/include/linux/dma/qcom_bam_dma.h
@@ -13,9 +13,12 @@
  * supported by BAM DMA Engine.
  *
  * @cmd_and_addr - upper 8 bits command and lower 24 bits register address.
- * @data - for write command: content to be written into peripheral register.
- *	   for read command: dest addr to write peripheral register value.
- * @mask - register mask.
+ * @data - For write command: content to be written into peripheral register.
+ *	   For read command: lower 32 bits of destination address.
+ * @mask - For write command: register write mask.
+ *	   For read command on BAM v1.6.0+: upper 4 bits of destination address.
+ *	   For read command on BAM < v1.6.0: ignored by hardware.
+ *	   Setting to 0 ensures 32-bit addressing compatibility.
  * @reserved - for future usage.
  *
  */
@@ -42,6 +45,10 @@ enum bam_command_type {
  * @addr: target address
  * @cmd: BAM command
  * @data: actual data for write and dest addr for read in le32
+ *
+ * For BAM v1.6.0+, the mask field behavior depends on command type:
+ * - Write commands: mask = write mask (typically 0xffffffff)
+ * - Read commands: mask = upper 4 bits of destination address (0 for 32-bit)
  */
 static inline void
 bam_prep_ce_le32(struct bam_cmd_element *bam_ce, u32 addr,
@@ -50,7 +57,11 @@ bam_prep_ce_le32(struct bam_cmd_element
 	bam_ce->cmd_and_addr =
 		cpu_to_le32((addr & 0xffffff) | ((cmd & 0xff) << 24));
 	bam_ce->data = data;
-	bam_ce->mask = cpu_to_le32(0xffffffff);
+	if (cmd == BAM_READ_COMMAND)
+		bam_ce->mask = cpu_to_le32(0x0); /* 32-bit addressing */
+	else
+		bam_ce->mask = cpu_to_le32(0xffffffff); /* Write mask */
+	bam_ce->reserved = 0;
 }
 
 /*
@@ -60,7 +71,7 @@ bam_prep_ce_le32(struct bam_cmd_element
  * @bam_ce: BAM command element
  * @addr: target address
  * @cmd: BAM command
- * @data: actual data for write and dest addr for read
+ * @data: actual data for write and destination address for read
  */
 static inline void
 bam_prep_ce(struct bam_cmd_element *bam_ce, u32 addr,


