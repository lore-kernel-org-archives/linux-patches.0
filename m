Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D46C56B863;
	Wed,  9 Sep 2026 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964186; cv=none; b=W6T0p+5BqK8J4i0zr3t2LE5c/NeulFwZGRO19STtDlZkjjRtPN68ArpImQGhi+4j3dZhRnsmerTTxntOjJwHcdPoOIXuPsa9gF5CoWkIWnK5eduoP6WhbGdZFpvyptUjzG9Ze8HzBq3peDKpL4b82gGNHegjJXtXaZ0ab3gIRnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964186; c=relaxed/simple;
	bh=z/eNnt8ntVsYiuzubYUcvnNMqX492DSlTce8wIfUu+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQSQTibMy+3eUDmvYoR8iqkQZr3RXLH1wb9hf0xEmmUuIWSTkwg04R8ChfFJ+UF3ZM8nKKk6ntAPAErnuJGef0BGe3zR2YX5ADwUnluKZvB3gFbVDzscjAn+n/AcohDQJcqrx4cJl4PhWaJ2J01jlVVMpeLswIWWXMrNn6y5Sig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohmn2q5J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohmn2q5J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66341F00A3A;
	Wed,  9 Sep 2026 14:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964185;
	bh=ZI27Bf2e6pY8W7GxQ6+xOom3qd2T7PFaxpJbTKGRg/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ohmn2q5J0zqNIpeTENtUVT/uDEn6qRM7L3CBin0MLLVH5excdAd5APPxZKv1tNbep
	 88tTonvTp0rGCsAsJBxpTftd1KbI07yKAlHthsIaYATwOVYlBTX7oBgeqwtU3sAOPp
	 iMlDyMDgTAAqDJoU2VCKVezca+Ud1P2JQYdjrz/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 336/583] scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
Date: Wed,  9 Sep 2026 15:40:21 +0200
Message-ID: <20260909134249.639248498@linuxfoundation.org>
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
@@ -2214,6 +2214,8 @@ qla2x00_get_firmware_state(scsi_qla_host
 	if (!ha->flags.fw_started)
 		return QLA_FUNCTION_FAILED;
 
+	memset(&mc, 0, sizeof(mc));
+
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(vha->hw))


