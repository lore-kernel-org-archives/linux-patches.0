Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7969129DB81;
	Wed, 23 Apr 2025 15:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422047; cv=none; b=MaszZA1rkP5lzryrey1o14xBor+7eK4OYW8nB+lIZc6aU7/ry4NmZk20rDn4LeHa7AeebNLtUTY9O/yFfoZZuzHpDAu3tIsFnu1sChh5Z/9TR3Ty4jrjGEpElRifLOhYBpnIynosKyxPcFKBLbFe1fHjob0vTqQBVzDOz8PyOBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422047; c=relaxed/simple;
	bh=P0mcXjs9sXgiKVZ86y/zKs3EgJiihY68QrPDNuY0y40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZ27RHJAEeE4EGYWD1u+vKBIFQu0f20CAJ9CuQnpmTsBD8Pk3Qrby5NFo30f3cNqbPFlHg3ym0+LovN/9yVfq98Yoa358ApO4nYM/xMn2hsufY+WnjrZlTJaSxF8Gi0bPkfPYAJn5BodcW4RzLRD4wqXfoSOna3xE+SU40vNwgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGnwmUYg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGnwmUYg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA1DC4CEE2;
	Wed, 23 Apr 2025 15:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422047;
	bh=P0mcXjs9sXgiKVZ86y/zKs3EgJiihY68QrPDNuY0y40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGnwmUYgBmwY7Q+1sx/h9gQ7qdO0wAfxS8C8MySJOpB8xemXFu+H/fBdwXvP55GhL
	 Fj+HUlfkn+Gr9PDqk4xjTh3q1staBxApRsTJCFAu9i/1iMp7gCbd/a6SiTDOc5Tj5i
	 v78mVfY63lDhFXUiQG4hveF9suf8MxdmhcXSQIo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	Ryan Lahfa <ryan@lahfa.xyz>
Subject: [PATCH 6.1 224/291] scsi: megaraid_sas: Block zero-length ATA VPD inquiry
Date: Wed, 23 Apr 2025 16:43:33 +0200
Message-ID: <20250423142633.577458907@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

commit aad9945623ab4029ae7789609fb6166c97976c62 upstream.

A firmware bug was observed where ATA VPD inquiry commands with a
zero-length data payload were not handled and failed with a non-standard
status code of 0xf0.

Avoid sending ATA VPD inquiry commands without data payload by setting
the device no_vpd_size flag to 1. In addition, if the firmware returns a
status code of 0xf0, set scsi_cmnd->result to CHECK_CONDITION to
facilitate proper error handling.

Suggested-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250402193735.5098-1-chandrakanth.patil@broadcom.com
Tested-by: Ryan Lahfa <ryan@lahfa.xyz>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/megaraid/megaraid_sas_base.c   |    9 +++++++--
 drivers/scsi/megaraid/megaraid_sas_fusion.c |    5 ++++-
 2 files changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -2101,6 +2101,9 @@ static int megasas_slave_configure(struc
 	/* This sdev property may change post OCR */
 	megasas_set_dynamic_target_properties(sdev, is_target_prop);
 
+	if (!MEGASAS_IS_LOGICAL(sdev))
+		sdev->no_vpd_size = 1;
+
 	mutex_unlock(&instance->reset_mutex);
 
 	return 0;
@@ -3661,8 +3664,10 @@ megasas_complete_cmd(struct megasas_inst
 
 		case MFI_STAT_SCSI_IO_FAILED:
 		case MFI_STAT_LD_INIT_IN_PROGRESS:
-			cmd->scmd->result =
-			    (DID_ERROR << 16) | hdr->scsi_status;
+			if (hdr->scsi_status == 0xf0)
+				cmd->scmd->result = (DID_ERROR << 16) | SAM_STAT_CHECK_CONDITION;
+			else
+				cmd->scmd->result = (DID_ERROR << 16) | hdr->scsi_status;
 			break;
 
 		case MFI_STAT_SCSI_DONE_WITH_ERROR:
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -2040,7 +2040,10 @@ map_cmd_status(struct fusion_context *fu
 
 	case MFI_STAT_SCSI_IO_FAILED:
 	case MFI_STAT_LD_INIT_IN_PROGRESS:
-		scmd->result = (DID_ERROR << 16) | ext_status;
+		if (ext_status == 0xf0)
+			scmd->result = (DID_ERROR << 16) | SAM_STAT_CHECK_CONDITION;
+		else
+			scmd->result = (DID_ERROR << 16) | ext_status;
 		break;
 
 	case MFI_STAT_SCSI_DONE_WITH_ERROR:


