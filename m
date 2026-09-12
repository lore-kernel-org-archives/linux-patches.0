Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC78367B65;
	Sat, 12 Sep 2026 19:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242142; cv=none; b=aRfcRTdLSHz936ciZE5mwitt0t3KpFsE4S7FoRnjKYvTqagDAEjTFMWGSHCKCROvPViajPGoR2GZuJu7nDQ+2ldbMLJd0BZ9QqbUX3Mg1Au13en+xgkxIhzg+4egDSl/tu/VRTUdxUBuVtt6AX9Q7qOQBNSCdRCAvjLMO08XfdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242142; c=relaxed/simple;
	bh=NwYkbR3DbPO8in1mOZ/6C7mdiWEs+VT9S5L6389da94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zkm6L+Sl33p9D+8Yrje4N+ROlLMfKStwiIS1vFpub0E2GpTdDGva6vW+XrOx2VpA9jSQFv1hpiXqRNEnEgJdXk5i124IkG8rO4BcawwoHe3jbAvGlNHWuKu/hCzVEu+ytT0htkt8RP9Apz9242/yaziEI71bv0wc+5TJPzPu/Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U6BrbilV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U6BrbilV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C301F000FF;
	Sat, 12 Sep 2026 19:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242141;
	bh=P3adGMVn9Sr/27fNSyNGY8E1BEAo7zjl6mCAnIx0FmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U6BrbilVemCtsV3X+SrFAaWSb8EDSB+U3A9BboJqc3Ekd6+ZnEBTdE/qCD8YXPhql
	 iehhWT7ReOEhbi+o8sbRpBoBITxvKrGWE3WF6ksKWWz5QqqIsNJ3w6VFi99DLFybtW
	 5j68f2ImCBWTaGyrv2sr8gkwE0E9Kll+rUDaUywo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 301/798] scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
Date: Sat, 12 Sep 2026 08:58:49 +0200
Message-ID: <20260912065524.062007844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit 9efaa782845b4d5fb3e01242be0d06ebc7428d8f upstream.

The mbx_cmd_t is allocated on the stack but left uninitialized.
qla2x00_mailbox_command() has several early-return paths (PCI permanent
failure, device failed, EEH busy, ISP abort pending, mailbox access
timeout, purge mbox) that return without writing the input mailbox
registers back into mcp->mb[]. qla2x00_get_firmware_state() then
unconditionally copies mcp->mb[1..6] (and mb[12]) into the caller's
states[] array regardless of the return value.

On such a failure the copied values are uninitialized kernel stack
memory, which is then exposed to userspace via the fw_state and
mpi_fw_state sysfs handlers. Zero the mailbox struct so a failed query
yields deterministic zeroed state instead of leaking stack contents.

Fixes: 4d4df1932b6b ("[SCSI] qla2xxx: Add ISP84XX support.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-9-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -2161,6 +2161,8 @@ qla2x00_get_firmware_state(scsi_qla_host
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1054,
 	    "Entered %s.\n", __func__);
 
+	memset(&mc, 0, sizeof(mc));
+
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(vha->hw))


