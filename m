Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EC947ACE2;
	Sat, 12 Sep 2026 11:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213938; cv=none; b=DSVc5PodphbFydVDIvlmhb5Rd+526etOQc5ZS6o3OD5BBUKTbQXpYvUcvZcgqFMbn8fcksysXsfiPd4tla2zXL90YCL5zl33T45PFoa+0u0r7ESS2TM7bL8a7y1fyavSch+e74gcGqgzG+nCz1LZE5FPri17iAjVqulmXbQKUkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213938; c=relaxed/simple;
	bh=m6Y/hFZVEpBrVnh3XDizjSjIiXo3i9TNQibAQBCyP1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pqS/fihbcY6rgVOC8UTcy0o+TKZd2XBijuFokpLnyeBSuiIwdarn5Ltj1FidJVWu5LqRUsTZ/HDDsCnkYhdbnOE1B3/KD6aWwXbCS9GuiBZz2Yucz9u/MAbVr+lNHH82xQnTyn9wwZ1X4rnbhT03u3bwIOMVVa/IgeIu/eiXDDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nwgsd+kq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nwgsd+kq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72301F000FF;
	Sat, 12 Sep 2026 11:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213934;
	bh=ayGrtLj/+vKWp6lvgCrzPnJ1YKYoIDnPaftUc2I+o6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwgsd+kq2RxLBdshZJHaQzZlSz0qm5g2tVZsZm1dM+v8fLjkVgAtQudxtDTV8RaOf
	 edWEEX5bg3b5r6cK+9l/J9P7e8vs9MF6OXDXQvHYfh4qEC0qWLeeXFjQdFViMPCCRn
	 1+Fp+mvCJn+iW+ka+fUGAtlcu8JwIJxSLUTpV2ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.12 0222/1376] scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
Date: Sat, 12 Sep 2026 08:44:08 +0200
Message-ID: <20260912065612.494823062@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Nilesh Javali <njavali@marvell.com>

commit c20ee380ca59c5a8646750c4849969a815924e2e upstream.

qla_chk_edif_rx_sa_delete_pending() obtains the SCSI command via
GET_CMD_SP(sp) and immediately dereferences cmd->sc_data_direction.
That command pointer can be NULL: the firmware may post a status
completion for a command that has already been returned or aborted.  The
caller qla2x00_status_entry() acknowledges this on the very same status
path, re-fetching GET_CMD_SP(sp) and bailing out with the "Command
already returned" message when it is NULL -- but that check runs only
after qla_chk_edif_rx_sa_delete_pending() has already dereferenced the
pointer, so a NULL cmd crashes the kernel in interrupt context.

Return early when cmd is NULL, before touching cmd->sc_data_direction.

Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-47-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_edif.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -3491,6 +3491,9 @@ void qla_chk_edif_rx_sa_delete_pending(s
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	uint32_t handle;
 
+	if (!cmd)
+		return;
+
 	handle = (uint32_t)LSW(sts24->handle);
 
 	/* find out if this status iosb is for a scsi read */


