Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4227C29DB64;
	Sat, 12 Sep 2026 15:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228458; cv=none; b=LlOvI6H90F9dto6D+WAsqAQpoJv2G3KL5an7jaFElZvTSwjtPmxb0BjerDvmOfXnhCD2bnUu64QRtZ/Szxu9uymxlO+j+jcOZ+viHeU7SO2beHKQrkD213BlG0bX2NpwsCpBYp8bDTjBlFdPQ3J/H/Lcp+1gL1oPeEMeMV0tasU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228458; c=relaxed/simple;
	bh=rn20/+xqHxkeCaaqm1WprUjau3LEC5WxKWZUTThVcEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKo+dEDYAFii/gXUPmeg/RonTAn6gg472gQt4s6IqMbdA6PgihtPePPonpDc8sGf7fwavGGwefXZto5NXD5de/L4TtpZOFg7DW8D1LCpsIfdbfvtoG//ruwpDyNtbG/AXEdzfnVaWc2aVUR0tStZXtQN5GZZHDCmfsFniIyioY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQuOWPH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQuOWPH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0380C1F000FF;
	Sat, 12 Sep 2026 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228457;
	bh=+CvJJJRHEuwmJr5EdqtywWkk4dIaUFq9uMYWqmW7GMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FQuOWPH0onS4zCKy8kh7Rfu59I6zrksfOhbLzGmi9Nx5dcgvCBTG4XnopE5MORdqX
	 FjcsnvHsbG3QKo1inKSEoaiyrtMpWAMBZHdnhKXZy2CGr6Kd2xvs+0ahHk2CBS1UBz
	 Jag7myy9z1nnBk/Z6HzU3dnEiHyjt23Es3aJSCeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0390/1191] scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
Date: Sat, 12 Sep 2026 08:51:58 +0200
Message-ID: <20260912065556.998695776@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3464,6 +3464,9 @@ void qla_chk_edif_rx_sa_delete_pending(s
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	uint32_t handle;
 
+	if (!cmd)
+		return;
+
 	handle = (uint32_t)LSW(sts24->handle);
 
 	/* find out if this status iosb is for a scsi read */


