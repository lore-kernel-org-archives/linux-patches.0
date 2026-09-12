Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56374CA6F;
	Sat, 12 Sep 2026 10:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208469; cv=none; b=cL9nA2RR/M/NTjG+tjmX7VO1boVbfadUWLlWCIIlGcntKZSjoSFKARYraoEd46mHTBj4sMP4KbE3/orbONjzyA8Opf8+Y4IPsFNMgJr24MMDC9HkOzOP4mFe/Lcf3paHWY7v96kyR1lOgNslA1YDHOsfNW7s5+iVecvp1mx+39E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208469; c=relaxed/simple;
	bh=nYe9ivs2XInBqHj5TTmZPn/9qjDVgqiFIsfUg0jxEdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T+bZb7bUFn81VTduxzjHjuVleG9gwPiNt+X909Xp80U9oM6HzzoM/K2kNkkT08nY09KP6wYH9Y7nHnQbCJXY9h+LnMwngQUX7QkKNlpObEc3AEG91fy95kxXGRCQHTccBJsfMfwlW3eG+GYNQxgJ00F4RCprzPYkZq0n9PCf15w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+ahsOBC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+ahsOBC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7D61F000FF;
	Sat, 12 Sep 2026 10:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208468;
	bh=DSXPM9opMiDeod7oPb9ZY7FXx1vQ9w4Dr8VZQXfs9Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S+ahsOBCs9+c9G2p7WlGWOel5RtcNmv6GgoYyuqhajomH3rDe1qsEfhqBOL7QZUiC
	 bdRH0yXJv7eTt0bSBM35EcLIG/gwe2HcG/DTN3yK4ae9yxT36nvbRJyqJbeuF9JL+6
	 o+J6ti8WJVB0HRtUIvgCldSkCrMOHOAjRZioViRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	David Strahan <david.strahan@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0623/1518] scsi: smartpqi: Fix AIO retry marker cleared by SCSI core between dispatches.
Date: Sat, 12 Sep 2026 08:46:32 +0200
Message-ID: <20260912065637.526539708@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: David Strahan <David.Strahan@microchip.com>

[ Upstream commit 225548863f0a2350c6f34231ca56710c3dd1a5d5 ]

On recent Linux kernels the driver can enter a retry loop on the AIO fast
path when a request is retried, looping until timeout.  A diagnostic path
that takes a physical drive offline on AIO-bypass failure is also never
entered on affected kernels.

Register a per-command initialization callback with the SCSI core. Its
presence causes the core to skip the per-dispatch clear, so the retry
marker now survives across the requeue and the AIO-to-RAID fallback
proceeds as intended. The driver takes over the marker's lifetime: it is
zeroed at tag allocation, preserved across the retry requeue so the error
path can act on it, and cleared on terminal completion so the tag starts
clean on its next use.

Fixes: dce5c4afd035 ("scsi: core: Clear driver private data when retrying request")
Co-developed-by: Mike McGowen <mike.mcgowen@microchip.com>
Signed-off-by: Mike McGowen <mike.mcgowen@microchip.com>
Acked-by: Don Brace <don.brace@microchip.com>
Signed-off-by: David Strahan <david.strahan@microchip.com>
Link: https://lore.kernel.org/linux-scsi/20260722220401.6357-1-david.strahan@microchip.com/
Link: https://patch.msgid.link/20260722220401.6357-2-david.strahan@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 090e786470b39..88cffb1fb59ce 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -66,6 +66,12 @@ static struct pqi_cmd_priv *pqi_cmd_priv(struct scsi_cmnd *cmd)
 	return scsi_cmd_priv(cmd);
 }
 
+static int pqi_init_cmd_priv(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
+{
+	memset(pqi_cmd_priv(cmd), 0, sizeof(struct pqi_cmd_priv));
+	return 0;
+}
+
 static void pqi_verify_structures(void);
 static void pqi_take_ctrl_offline(struct pqi_ctrl_info *ctrl_info,
 	enum pqi_ctrl_shutdown_reason ctrl_shutdown_reason);
@@ -5943,6 +5949,17 @@ void pqi_prep_for_scsi_done(struct scsi_cmnd *scmd)
 	struct pqi_scsi_dev *device;
 	struct completion *wait;
 
+	/*
+	 * Clear the AIO-retry marker on final completion so the tag
+	 * starts clean on its next dispatch.  On DID_IMM_RETRY leave
+	 * it intact: pqi_aio_io_complete() sets DID_IMM_RETRY and
+	 * bumps the marker to steer the requeue onto the RAID path,
+	 * and pqi_process_raid_io_error() consumes the non-zero
+	 * marker to offline a misbehaving drive.
+	 */
+	if (host_byte(scmd->result) != DID_IMM_RETRY)
+		pqi_cmd_priv(scmd)->this_residual = 0;
+
 	if (!scmd->device) {
 		set_host_byte(scmd, DID_NO_CONNECT);
 		return;
@@ -7596,6 +7613,7 @@ static const struct scsi_host_template pqi_driver_template = {
 	.sdev_groups = pqi_sdev_groups,
 	.shost_groups = pqi_shost_groups,
 	.cmd_size = sizeof(struct pqi_cmd_priv),
+	.init_cmd_priv = pqi_init_cmd_priv,
 };
 
 static int pqi_register_scsi(struct pqi_ctrl_info *ctrl_info)
-- 
2.53.0



