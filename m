Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3B65540AE;
	Wed,  9 Sep 2026 14:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964151; cv=none; b=hkU2UTyPziXg1ps+fcfzD/v4Yv9Wz3eYIwbc5lY7wuW+3pB0lUk8MEojEO3i9CqtOy3BHYuI+1Wrd7cTS6hUXnRVMrzCRW23/osvHQIcIW+SO30bF20kdJsOHgstpm4vM/zCiqfySzXwdz52/iBrFuDXhm9o2nlFBoEfMu9X+VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964151; c=relaxed/simple;
	bh=IBUhL3QU9/pueteWEAzGEfveJi5hxvFVf6V3i88Tezk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CH9+WwSnCT4SVfnJa0Vfv/3FC7MYJYWSiw5AakqX0GLdNsLRAKvO/WvFkiTS4/8ShO+eBR/9jJmpmXaly9O3mjPsSmkXao6DsznZXmaXv98cxcCsFO7Y9XZNFfnhYRkLqmarB9PXmiMwlUhyv3dz2Tg3yIMrLxurFSDaEdwqpko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdeng4pW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdeng4pW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 033A11F00A3A;
	Wed,  9 Sep 2026 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964150;
	bh=2PkST12hGeeX9AHko6KupqxUiNJ70lQX1j9S58DHCh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wdeng4pWWJJ87hRyGMvICbJbdJlQ7JXrH7CmCA41bvs6MGMO1+qKP+nvdUTYOxbGU
	 RDxUpC3Ys/inFWQITzpS+FJDKxdLNQBAUoupN/7E+mVcKxysCVc0eejq8BFnKtlmhj
	 zr1ZOlHnKgUt5Z+/QfQqhMp+XWrxLFF6Gp7X0B78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 325/583] scsi: qla2xxx: edif: Fix NULL pointer deref in RX SA delete check
Date: Wed,  9 Sep 2026 15:40:10 +0200
Message-ID: <20260909134249.255767808@linuxfoundation.org>
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


