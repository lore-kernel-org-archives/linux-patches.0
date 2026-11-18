Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055113;
	b=L8nhOPgacIKBjNYogFayLIED74jk29e6XWITsz3xIkpMRHeTKSQC4J+LFGQVaC71Bmu5
	 WeI01IJIJLD5nhKcFebuIEKA6ogRnymX9KNvMWIA1jFk9XGnGzQgE4Z/m5drt38ccaKlf
	 Cg7znd9VW19sKuQB7gZjfa+sbDN39Fm0u8UpY1NRSFw+gTafhIPheoQNHaxaDZNo2Y4na
	 Rd9E/cbNvALq2PHSDgWQKDPxT8tXv6JZvQZ3hCE37PRYHIFayKqpUD+DkqesYPFGIzoOU
	 qkt4ozTcnrOog53PKvN0KmhA7lcZaeu0eT9lcTdds8mDsEnk6wAjCI/vNd549koq5Sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055113;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=44r1ZpKMrw9fGWfWTGNmy6lVanmCKr7pl7VGZbk+HEE=;
	b=ngiK5xOnHk8g8aDtl7BNccue5ljiW6Hzv4v3CHr2BTiamZ44cRNsFprvtvmC6VVDT01Y
	 j9WCfctm9t5bGF5sEVgt96qNRaanM0tt/Su1Kli6MLxZKXKpglWp59sIUocAkAHieoXPg
	 41RE/sn/6wx3TrUrseWgQHufplDrv2qUqAXSYBBDUcwaB2Qs/emkLzUN3V4iKNzGxRpSJ
	 u2b0b317QS0pTJYigyOcKAI+TW8RzSZcXE8qEvfkn2hwxzdHnpap/4PJltUYoBQ5s7IX2
	 4LvTUusHTsPRZ1cJuWoqFbsrOxCktCxggMR4n/ftzdnR/4BO3qyY+d78QK3iv3TA0NA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nXkbYOtm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED9D606A31C;
	Thu, 19 Nov 2026 02:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nXkbYOtm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9821B1F000C4;
	Thu, 19 Nov 2026 02:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055113;
	bh=44r1ZpKMrw9fGWfWTGNmy6lVanmCKr7pl7VGZbk+HEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nXkbYOtmkMTt/gqQ+a07+DTuOOX/DiCiam58HI9pKJcaaxCRdCQIruM8JI1PT8sQp
	 H8gtlb/JZ/YeJ/SQi9bMqoqER8OX81fF79UWZRc2Wt17j/6Fs/fLqn4/LX0cOuEsOx
	 UNaPS+bWF4px5l7kCwOAlUJ0gyYachPPdaK4gYsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1516/2214] scsi: pm8001: Fix SATA FIS offset in struct hw_event_resp
Date: Wed, 18 Nov 2026 15:53:12 +0100
Message-ID: <20261118150112.691701598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit cdc97921de02a0c1a8324afa03e8b3e30a72bbe6 ]

In struct hw_event_resp, sas_identify was defined using struct
sas_identify_frame, which is 32 bytes long because it includes a 4-byte CRC
field. However, PM8001 and PM80xx hardware does not send the CRC in the
event response frame, providing only the 28-byte identify payload.

Because sas_identify had a size of 32 bytes, the following sata_fis member
was located at byte offset 44 instead of the actual hardware offset 40. In
hw_event_sata_phy_up(), this discrepancy was worked around with negative
pointer arithmetic: ((u8 *)&pPayload->sata_fis - 4).  This triggers a
compiler error under Clang with -Wstringop-overread:

  error: 'memcpy' reading 20 bytes from a region of size 0
  [-Werror,-Wstringop-overread]
          memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),

Move struct sas_identify_frame_local (28 bytes) into pm8001_defs.h, and
update struct hw_event_resp in both pm8001_hwi.h and pm80xx_hwi.h to use
struct sas_identify_frame_local followed by sata_fis and a 4-byte padding
word. This correctly aligns sata_fis at byte offset 40 while maintaining
the 64-byte total payload size.

Update hw_event_sata_phy_up() in pm8001_hwi.c and pm80xx_hwi.c to copy
directly from &pPayload->sata_fis.

Compile-tested only. Both the patch and its description have been generated
by Gemini.

Fixes: dbf9bfe61571 ("[SCSI] pm8001: add SAS/SATA HBA driver")
Fixes: f5860992db55 ("[SCSI] pm80xx: Added SPCv/ve specific hardware functionalities and relevant changes in common files")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/31963d53810f42970447e78ef46030ab13d2e91f.1788198434.git.bvanassche@acm.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_defs.h |  98 +++++++++++++++++++++++++++++
 drivers/scsi/pm8001/pm8001_hwi.c  |   2 +-
 drivers/scsi/pm8001/pm8001_hwi.h  |   4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c  |   2 +-
 drivers/scsi/pm8001/pm80xx_hwi.h  | 100 +-----------------------------
 5 files changed, 106 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_defs.h b/drivers/scsi/pm8001/pm8001_defs.h
index 501b574239e8b..ff7b282090792 100644
--- a/drivers/scsi/pm8001/pm8001_defs.h
+++ b/drivers/scsi/pm8001/pm8001_defs.h
@@ -41,6 +41,104 @@
 #ifndef _PM8001_DEFS_H_
 #define _PM8001_DEFS_H_
 
+#include <scsi/sas.h>
+
+#ifdef __LITTLE_ENDIAN_BITFIELD
+struct sas_identify_frame_local {
+	/* Byte 0 */
+	u8  frame_type:4;
+	u8  dev_type:3;
+	u8  _un0:1;
+
+	/* Byte 1 */
+	u8  _un1;
+
+	/* Byte 2 */
+	union {
+		struct {
+			u8  _un20:1;
+			u8  smp_iport:1;
+			u8  stp_iport:1;
+			u8  ssp_iport:1;
+			u8  _un247:4;
+		};
+		u8 initiator_bits;
+	};
+
+	/* Byte 3 */
+	union {
+		struct {
+			u8  _un30:1;
+			u8 smp_tport:1;
+			u8 stp_tport:1;
+			u8 ssp_tport:1;
+			u8 _un347:4;
+		};
+		u8 target_bits;
+	};
+
+	/* Byte 4 - 11 */
+	u8 _un4_11[8];
+
+	/* Byte 12 - 19 */
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	/* Byte 20 */
+	u8 phy_id;
+
+	u8 _un21_27[7];
+
+} __packed;
+
+#elif defined(__BIG_ENDIAN_BITFIELD)
+struct sas_identify_frame_local {
+	/* Byte 0 */
+	u8  _un0:1;
+	u8  dev_type:3;
+	u8  frame_type:4;
+
+	/* Byte 1 */
+	u8  _un1;
+
+	/* Byte 2 */
+	union {
+		struct {
+			u8  _un247:4;
+			u8  ssp_iport:1;
+			u8  stp_iport:1;
+			u8  smp_iport:1;
+			u8  _un20:1;
+		};
+		u8 initiator_bits;
+	};
+
+	/* Byte 3 */
+	union {
+		struct {
+			u8 _un347:4;
+			u8 ssp_tport:1;
+			u8 stp_tport:1;
+			u8 smp_tport:1;
+			u8 _un30:1;
+		};
+		u8 target_bits;
+	};
+
+	/* Byte 4 - 11 */
+	u8 _un4_11[8];
+
+	/* Byte 12 - 19 */
+	u8 sas_addr[SAS_ADDR_SIZE];
+
+	/* Byte 20 */
+	u8 phy_id;
+
+	u8 _un21_27[7];
+} __packed;
+#else
+#error "Bitfield order not defined!"
+#endif
+
 enum chip_flavors {
 	chip_8001,
 	chip_8008,
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 537b762a2b834..97441653e355f 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3433,7 +3433,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
 	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
-	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
+	memcpy(phy->frame_rcvd, &pPayload->sata_fis,
 		sizeof(struct dev_to_host_fis));
 	phy->frame_rcvd_size = sizeof(struct dev_to_host_fis);
 	phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
diff --git a/drivers/scsi/pm8001/pm8001_hwi.h b/drivers/scsi/pm8001/pm8001_hwi.h
index d1f3aa93325bf..288d35029e7d6 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.h
+++ b/drivers/scsi/pm8001/pm8001_hwi.h
@@ -42,6 +42,7 @@
 
 #include <linux/types.h>
 #include <scsi/libsas.h>
+#include "pm8001_defs.h"
 
 
 /* for Request Opcode of IOMB */
@@ -229,8 +230,9 @@ struct hw_event_resp {
 	__le32	lr_evt_status_phyid_portid;
 	__le32	evt_param;
 	__le32	npip_portstate;
-	struct sas_identify_frame	sas_identify;
+	struct sas_identify_frame_local	sas_identify;
 	struct dev_to_host_fis	sata_fis;
+	u32	_r_a;
 } __attribute__((packed, aligned(4)));
 
 
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index e5b5a730116a9..d3eb6eef9d6bf 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3420,7 +3420,7 @@ hw_event_sata_phy_up(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	phy->sas_phy.oob_mode = SATA_OOB_MODE;
 	sas_notify_phy_event(&phy->sas_phy, PHYE_OOB_DONE, GFP_ATOMIC);
 	spin_lock_irqsave(&phy->sas_phy.frame_rcvd_lock, flags);
-	memcpy(phy->frame_rcvd, ((u8 *)&pPayload->sata_fis - 4),
+	memcpy(phy->frame_rcvd, &pPayload->sata_fis,
 		sizeof(struct dev_to_host_fis));
 	phy->frame_rcvd_size = sizeof(struct dev_to_host_fis);
 	phy->identify.target_port_protocols = SAS_PROTOCOL_SATA;
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.h b/drivers/scsi/pm8001/pm80xx_hwi.h
index c41ed039c92ac..c663a8dc34c7a 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.h
+++ b/drivers/scsi/pm8001/pm80xx_hwi.h
@@ -43,6 +43,7 @@
 
 #include <linux/types.h>
 #include <scsi/libsas.h>
+#include "pm8001_defs.h"
 
 /* for Request Opcode of IOMB */
 #define OPC_INB_ECHO				1	/* 0x000 */
@@ -236,102 +237,6 @@
 /* Port recovery timeout, 10000 ms for PM8006 controller */
 #define CHIP_8006_PORT_RECOVERY_TIMEOUT 0x640000
 
-#ifdef __LITTLE_ENDIAN_BITFIELD
-struct sas_identify_frame_local {
-	/* Byte 0 */
-	u8  frame_type:4;
-	u8  dev_type:3;
-	u8  _un0:1;
-
-	/* Byte 1 */
-	u8  _un1;
-
-	/* Byte 2 */
-	union {
-		struct {
-			u8  _un20:1;
-			u8  smp_iport:1;
-			u8  stp_iport:1;
-			u8  ssp_iport:1;
-			u8  _un247:4;
-		};
-		u8 initiator_bits;
-	};
-
-	/* Byte 3 */
-	union {
-		struct {
-			u8  _un30:1;
-			u8 smp_tport:1;
-			u8 stp_tport:1;
-			u8 ssp_tport:1;
-			u8 _un347:4;
-		};
-		u8 target_bits;
-	};
-
-	/* Byte 4 - 11 */
-	u8 _un4_11[8];
-
-	/* Byte 12 - 19 */
-	u8 sas_addr[SAS_ADDR_SIZE];
-
-	/* Byte 20 */
-	u8 phy_id;
-
-	u8 _un21_27[7];
-
-} __packed;
-
-#elif defined(__BIG_ENDIAN_BITFIELD)
-struct sas_identify_frame_local {
-	/* Byte 0 */
-	u8  _un0:1;
-	u8  dev_type:3;
-	u8  frame_type:4;
-
-	/* Byte 1 */
-	u8  _un1;
-
-	/* Byte 2 */
-	union {
-		struct {
-			u8  _un247:4;
-			u8  ssp_iport:1;
-			u8  stp_iport:1;
-			u8  smp_iport:1;
-			u8  _un20:1;
-		};
-		u8 initiator_bits;
-	};
-
-	/* Byte 3 */
-	union {
-		struct {
-			u8 _un347:4;
-			u8 ssp_tport:1;
-			u8 stp_tport:1;
-			u8 smp_tport:1;
-			u8 _un30:1;
-		};
-		u8 target_bits;
-	};
-
-	/* Byte 4 - 11 */
-	u8 _un4_11[8];
-
-	/* Byte 12 - 19 */
-	u8 sas_addr[SAS_ADDR_SIZE];
-
-	/* Byte 20 */
-	u8 phy_id;
-
-	u8 _un21_27[7];
-} __packed;
-#else
-#error "Bitfield order not defined!"
-#endif
-
 struct mpi_msg_hdr {
 	__le32	header;	/* Bits [11:0] - Message operation code */
 	/* Bits [15:12] - Message Category */
@@ -427,8 +332,9 @@ struct hw_event_resp {
 	__le32	lr_status_evt_portid;
 	__le32	evt_param;
 	__le32	phyid_npip_portstate;
-	struct sas_identify_frame	sas_identify;
+	struct sas_identify_frame_local	sas_identify;
 	struct dev_to_host_fis	sata_fis;
+	u32	_r_a;
 } __attribute__((packed, aligned(4)));
 
 /*
-- 
2.53.0



