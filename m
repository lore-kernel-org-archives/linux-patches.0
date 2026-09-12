Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E7335677C;
	Sat, 12 Sep 2026 15:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228507; cv=none; b=Z1RR7oRALHE6Qqd05gk5poXpd5H3wg6gcgNuCRacd+x4Vu1eggU630aB7POpdVIQGNn2yBwaED9gyTwSj3rMnh/K/l/eZCM96XzUAqW9n3bj1xCyEGAE0FCdSUFk4qXBWKB088KnG/6kl7usrPSghET6/yj8Z5nHGoDvlMrdGRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228507; c=relaxed/simple;
	bh=l2juEsfL/lfLX0aOfwmwlmfUFQgkG2MjHiYSKFwojy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dL8sQywGFFy1Jt6iu75ColFZILfvMcmFABYSX6vK95O6GSsR5mT9ajMVvFPfCz2Qbn+Tyi/tFe75BMiDPq5LQTXC502yxHGc/642OgBifNzPQCMNYkvOOhqYc0E5l1NahI4taJUnKjFlsrKl8W8yodoobPby01XuYiP4/fl5YIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fx9a2EgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fx9a2EgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2067D1F000FF;
	Sat, 12 Sep 2026 15:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228506;
	bh=dePWe4SqXY4p1sTdtdIFlByqnhRvlSKqyN6cSnRuisg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fx9a2EgGFJNtbwnaDLStJbGinSU3SotPKhJptIT1pJIExDJHBygv9HFnQaVCmpuZk
	 4fhI8aqaixkuXynha2+W3Lqt4c5LC1vqGYpYorCXeJa6Zk7MJ5rfGDK4K1JBr4Zq9A
	 TRgo9lNoQVNZh3KE2d7SsjJ4/cWdbbEyZk1w3g3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0399/1191] scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
Date: Sat, 12 Sep 2026 08:52:07 +0200
Message-ID: <20260912065557.200319531@linuxfoundation.org>
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


