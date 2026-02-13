Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD3081D432D;
	Fri, 13 Feb 2026 13:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990920; cv=none; b=ZsMQclfrg0swv3aeG5MlbWab8Nr+FPExXCOMWt0+e3VeRRzDBbG0TqjPP5irfPBCNeaE3PHaCEwXOO/5TQZRTknI5WocB1zW2PW8q1SHZ/IXxaE3nMRBVpVY2yy1853EaDZ2XOZ9cgAOtO1y1zC2OTegvzw0RJCfbiRWMP3NVAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990920; c=relaxed/simple;
	bh=7Y7ZMCzB6ELaIc5QFmYIa2h9MeDu1C/MDQBSIWxRHAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qj9j4keF0wN70QjcTr4xO3M13W4t0nYxYto5Gwo+h5IetdvT53HZsMkLeNTUFjbNMim5xqGLY6m5lBiHNpTXZJdjZ+q8BhoMfrDp7xLeOU/Nt+7BRN7awjXoPexeTNykk+ZrcU4hLAZX147ANRdQeq6+iMBCGfObF18V3CmN2do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J45fu5u7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J45fu5u7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A21FC116C6;
	Fri, 13 Feb 2026 13:55:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990920;
	bh=7Y7ZMCzB6ELaIc5QFmYIa2h9MeDu1C/MDQBSIWxRHAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J45fu5u7FA6onRjiJwcOz1ahgPs+fXTp6lva8DP+qvufx4sR+U98SbKaDyWmKUnI7
	 8/nNZdlm4vT87mqvKdDQmbQJzJ0nwyAOvyX3AWnt3m+S3g/byj7E7A/3nXJ5s4ON5O
	 wRxHxfurv5SQw8CSH6B/DZlISdnOttN6BEzoE0bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 14/24] scsi: qla2xxx: Allow recovery for tape devices
Date: Fri, 13 Feb 2026 14:48:33 +0100
Message-ID: <20260213134705.246861709@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134704.728003077@linuxfoundation.org>
References: <20260213134704.728003077@linuxfoundation.org>
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

From: Shreyas Deodhar <sdeodhar@marvell.com>

commit b0335ee4fb94832a4ef68774ca7e7b33b473c7a6 upstream.

Tape device doesn't show up after RSCNs.  To fix this, remove tape
device specific checks which allows recovery of tape devices.

Fixes: 44c57f205876 ("scsi: qla2xxx: Changes to support FCP2 Target")
Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
Link: https://patch.msgid.link/20251210101604.431868-7-njavali@marvell.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gs.c   |    3 ---
 drivers/scsi/qla2xxx/qla_init.c |    9 ---------
 2 files changed, 12 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -3356,9 +3356,6 @@ login_logout:
 			    atomic_read(&fcport->state) == FCS_ONLINE) ||
 				do_delete) {
 				if (fcport->loop_id != FC_NO_LOOP_ID) {
-					if (fcport->flags & FCF_FCP2_DEVICE)
-						continue;
-
 					ql_log(ql_log_warn, vha, 0x20f0,
 					       "%s %d %8phC post del sess\n",
 					       __func__, __LINE__,
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -1859,15 +1859,6 @@ void qla2x00_handle_rscn(scsi_qla_host_t
 	case RSCN_PORT_ADDR:
 		fcport = qla2x00_find_fcport_by_nportid(vha, &ea->id, 1);
 		if (fcport) {
-			if (ql2xfc2target &&
-			    fcport->flags & FCF_FCP2_DEVICE &&
-			    atomic_read(&fcport->state) == FCS_ONLINE) {
-				ql_dbg(ql_dbg_disc, vha, 0x2115,
-				       "Delaying session delete for FCP2 portid=%06x %8phC ",
-					fcport->d_id.b24, fcport->port_name);
-				return;
-			}
-
 			if (vha->hw->flags.edif_enabled && DBELL_ACTIVE(vha)) {
 				/*
 				 * On ipsec start by remote port, Target port


