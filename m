Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591033;
	b=Z7pHoLFyoHb/+qaPH03D/DoMTJumqlqzZwBHeJCsI9789pyGfmH9uyv9YroxGjXo37DN
	 RXlVIIJbYNS/ZdpGLRGA7JS7Any6PRqPMjl2aJX1RLc2t5qZIVKKuLPsI3Ywk9hxHmTBS
	 XhUOOvY1CyOGSqiDoFOnJzbonB54Y6UcD3QUdgfTOzRwzzhYAyJin6sIAGilnL1zwhJkj
	 jUwvspvH+Nb0LbfiZwviP+UNeTIMy3x4JrICTY6CDvja1JBGPvWdobUAVSJX+eYHmWWhx
	 aX/KliagjbuCHDFRLNLGeS6AWUya/xAHhGxh2kvcUApadPok9MTgHTyeJfH92JfXLCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3s52FCBJ5DQ8hSa3Qoi7LPFriyKhJieOOFjfb+RBHHM=;
	b=FV0yVa4lGpCd0Ju4ork3u8FkRxQUf9rzSAlhmkse7n08SsiHuDUp9uoXmUOyG5kH5Pf2
	 DX4cDeym2xfr4oN332QopPYjKlYQctH+wnUVJB1D8efAkX85jBFXVOluSklfHvH9JskoF
	 3TCtURCKAHX5FU4iHj7UbeW9nbo9QaPDiQ+xIvl0Yc5r5aSrx9sTQM/pQkC9LBvF4mnL2
	 TPgD5LyMfhmL8FFSa2cjcQL43ZakgfU3cY75eigsMO+oJF5WEV8P1mrXwRh8brndHbQIP
	 imBrO9WdGODOo6D7tOEeLe9CSMxpIV3x0f3sZ/Un2doQx4wum2YkadgrgLxcRwXQh5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OV5lTvNx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40E1606B352;
	Fri, 13 Nov 2026 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OV5lTvNx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB011F000C6;
	Fri, 13 Nov 2026 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591033;
	bh=3s52FCBJ5DQ8hSa3Qoi7LPFriyKhJieOOFjfb+RBHHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OV5lTvNx6vwN1OqYD9tGjcODcgr6yA49hOR6sKPNUCs1DAfjrTyDIm4FGjAF0NziM
	 EkFXbDOXhvX4/esI3dgM2ArfInYx8Dyf5EvOg25vHt6gmXSWsNeCdn5MbIyXiWBaGp
	 XBfaERHaVvHEWbETqRuSAOvD0NyrGI/uhpJXtno8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Andrew Luebke <andrew.luebke@gmail.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/670] scsi: aic79xx: Fix NULL pointer dereference in device reset
Date: Fri, 13 Nov 2026 10:45:56 -0500
Message-ID: <20261113153818.511503316@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Luebke <andrew.luebke@gmail.com>

[ Upstream commit f057a8bfeb6ff89c65e95540b8700a53c66d4a31 ]

Since commit c67e63800446 ("scsi: aic79xx: Do not reference SCSI command
when resetting device") the device reset SCB has no SCSI command, but
ahd_linux_dev_reset() still sets its residual, and ahd_abort_scbs(), which
completes it, sets its status. Seen on an AIC-7902 when a failing disk
triggered a device reset, which killed the SCSI error handler:

  BUG: kernel NULL pointer dereference, address: 0000009c
  EIP: ahd_linux_dev_reset.cold+0xee/0x26e

Add NULL command checks to the accessors in aic79xx_osm.h. Also skip
autosense for an SCB without a command and complete it with ahd_done()
right away: the REQUEST SENSE path can clear SCB_DEVICE_RESET, after which
ahd_done() would dereference the missing command.

Fixes: c67e63800446 ("scsi: aic79xx: Do not reference SCSI command when resetting device")
Cc: stable@vger.kernel.org
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Andrew Luebke <andrew.luebke@gmail.com>
Assisted-by: LLM
Link: https://patch.msgid.link/20261026172032.749756-1-andrew.luebke@gmail.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic79xx_core.c |  4 +++-
 drivers/scsi/aic7xxx/aic79xx_osm.h  | 26 +++++++++++++++++++++-----
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_core.c b/drivers/scsi/aic7xxx/aic79xx_core.c
index 3e3100dbfda35..287df87238105 100644
--- a/drivers/scsi/aic7xxx/aic79xx_core.c
+++ b/drivers/scsi/aic7xxx/aic79xx_core.c
@@ -8942,8 +8942,10 @@ ahd_handle_scsi_status(struct ahd_softc *ahd, struct scb *scb)
 		}
 #endif
 
-		if (ahd_perform_autosense(scb) == 0)
+		if (ahd_perform_autosense(scb) == 0) {
+			ahd_done(ahd, scb);
 			break;
+		}
 
 		ahd_compile_devinfo(&devinfo, SCB_GET_OUR_ID(scb),
 				    SCB_GET_TARGET(ahd, scb),
diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.h b/drivers/scsi/aic7xxx/aic79xx_osm.h
index 793fe19993a90..3bcfcfe18f08b 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.h
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.h
@@ -499,6 +499,8 @@ int	ahd_linux_show_info(struct seq_file *,struct Scsi_Host *);
 static inline
 void ahd_cmd_set_transaction_status(struct scsi_cmnd *cmd, uint32_t status)
 {
+	if (!cmd)
+		return;
 	cmd->result &= ~(CAM_STATUS_MASK << 16);
 	cmd->result |= status << 16;
 }
@@ -512,6 +514,8 @@ void ahd_set_transaction_status(struct scb *scb, uint32_t status)
 static inline
 void ahd_cmd_set_scsi_status(struct scsi_cmnd *cmd, uint32_t status)
 {
+	if (!cmd)
+		return;
 	cmd->result &= ~0xFFFF;
 	cmd->result |= status;
 }
@@ -525,6 +529,8 @@ void ahd_set_scsi_status(struct scb *scb, uint32_t status)
 static inline
 uint32_t ahd_cmd_get_transaction_status(struct scsi_cmnd *cmd)
 {
+	if (!cmd)
+		return CAM_REQ_INPROG;
 	return ((cmd->result >> 16) & CAM_STATUS_MASK);
 }
 
@@ -537,6 +543,8 @@ uint32_t ahd_get_transaction_status(struct scb *scb)
 static inline
 uint32_t ahd_cmd_get_scsi_status(struct scsi_cmnd *cmd)
 {
+	if (!cmd)
+		return SAM_STAT_GOOD;
 	return (cmd->result & 0xFFFF);
 }
 
@@ -564,13 +572,16 @@ u_long ahd_get_transfer_length(struct scb *scb)
 static inline
 int ahd_get_transfer_dir(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return DMA_NONE;
 	return (scb->io_ctx->sc_data_direction);
 }
 
 static inline
 void ahd_set_residual(struct scb *scb, u_long resid)
 {
-	scsi_set_resid(scb->io_ctx, resid);
+	if (scb->io_ctx)
+		scsi_set_resid(scb->io_ctx, resid);
 }
 
 static inline
@@ -582,6 +593,8 @@ void ahd_set_sense_residual(struct scb *scb, u_long resid)
 static inline
 u_long ahd_get_residual(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return 0;
 	return scsi_get_resid(scb->io_ctx);
 }
 
@@ -595,11 +608,12 @@ static inline
 int ahd_perform_autosense(struct scb *scb)
 {
 	/*
-	 * We always perform autosense in Linux.
-	 * On other platforms this is set on a
-	 * per-transaction basis.
+	 * We always perform autosense in Linux, except for the device
+	 * reset SCB, which has no command to return sense data to.
 	 */
-	return (1);
+	if (!scb->io_ctx)
+		return 0;
+	return 1;
 }
 
 static inline uint32_t
@@ -629,6 +643,8 @@ void	ahd_platform_freeze_devq(struct ahd_softc *ahd, struct scb *scb);
 static inline void
 ahd_freeze_scb(struct scb *scb)
 {
+	if (!scb->io_ctx)
+		return;
 	if ((scb->io_ctx->result & (CAM_DEV_QFRZN << 16)) == 0) {
 		scb->io_ctx->result |= CAM_DEV_QFRZN << 16;
 		scb->platform_data->dev->qfrozen++;
-- 
2.53.0



