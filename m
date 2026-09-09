Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A56455C1D4;
	Wed,  9 Sep 2026 14:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962810; cv=none; b=GPk1GOYoGOPqjwbgvDgmOcPeSQ4pDcWglOZyuAam1NbFcS+R6l7Zf2ukUO0YL0PKcvhSLRNEL15U8T3YF+yoW4Q9Pl9eD27J6N0Rm1lqCyfX6hBWuVFrZ4GvYxUbc3jgtNBxc+4pJ6LzUDmLY6CkopZHyeEhjxsSKyE5DqlPOok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962810; c=relaxed/simple;
	bh=qucF6YfMR+azAn4hb0mUlSp2hxs3EJVmkior6KbSYsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXVylpPLcOOR7LjVEScguP54XEURfcf9OIwjx/l0x187okfooPLAMLeKa/sX/hFrXr0ji39MnfAQ2AVpMWsTFjvI4Wx/omRg80NkNnMPWvxoJG7Hl1vNO8W7lmsENwgpjvM6SFqJJdygynNkLR70x5XHMgvlbQUN/xAnNDWPIkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lZOOFp0B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lZOOFp0B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B9C1F00A3A;
	Wed,  9 Sep 2026 14:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962809;
	bh=AM2+jLnMAkfA9VC6WBguLDbHg8ltPt9xi+pb8xPglsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lZOOFp0BbiWJ7YB4Re5b/BnWAHEm0/g0SMqIP3dDqtOBqhgtdNIfeP6E+M3wIyJUs
	 LApT5J1l0p45Gl2KQ4dnoyMWjcBtslJ1AM1BrOBbaQQS+R/1kQdjgD2pEQwdUqtas3
	 nSC8V03gLKXkDtXn7B/7eEez1kGdRELJNPlnzsso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 418/556] scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
Date: Wed,  9 Sep 2026 15:41:38 +0200
Message-ID: <20260909134245.304857032@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3492,6 +3492,9 @@ void qla_chk_edif_rx_sa_delete_pending(s
 	struct scsi_cmnd *cmd = GET_CMD_SP(sp);
 	uint32_t handle;
 
+	if (!cmd)
+		return;
+
 	handle = (uint32_t)LSW(sts24->handle);
 
 	/* find out if this status iosb is for a scsi read */


