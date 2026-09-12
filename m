Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358673AC0D9;
	Sat, 12 Sep 2026 18:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237870; cv=none; b=nOz7cMAB/jZu+ReEP3gUhXnIPYFmRGaHegQMzt7G1008IClWtAeG4Q96XEUs/krOXMJhWZOU1PcbUi4OtpNtsFSdu0YucO7bhret1EIELZAdpkcvRiMxkLd+n1h+I4hbFAVxotiOqpiKdqVSjYwOhSlmfiaq8IcNY0yb6w6c0ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237870; c=relaxed/simple;
	bh=JMeWSlQWGbrmEIXy1R0FCP8NieZKj3fNj52pMy9C3mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=irt9cXCiq4cqHz9vOYp5Six1zskUCbelvaQq8Ia8y53upIYx5hdw+BXWqIAN3o4K0hhOm+SvpO21sHo1Ssb7waHNUqCn4oe869HMf4/vj3KIsAvyW+d1z858oZa+aNtVcx9HumXRYTtILuXqaAKqqPy1DwFtFelh/08Z8C7/LCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1K9sEum; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1K9sEum"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 071E61F000FF;
	Sat, 12 Sep 2026 18:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237869;
	bh=pqfJlOYwNRJo0D3OhJAYbq+OAgf8/pbdDZUDoqX+cak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1K9sEumkuTkQvLS9hxjcdIhW638GrhBjnQ9aPA3L5ntlNSW7RR9IhoX06KsAuKHh
	 C0+Enx76c4yXZsHBG1PvhEaK7eN1lCnQdVRlJt+tHhdyB41QI3lFor++iDBjwje6ne
	 LidYbowSLHjkDBs+n1irglNQxEx/YXqTEaBFWrNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 344/935] scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
Date: Sat, 12 Sep 2026 08:56:14 +0200
Message-ID: <20260912065534.697212277@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2208,6 +2208,8 @@ qla2x00_get_firmware_state(scsi_qla_host
 	if (!ha->flags.fw_started)
 		return QLA_FUNCTION_FAILED;
 
+	memset(&mc, 0, sizeof(mc));
+
 	mcp->mb[0] = MBC_GET_FIRMWARE_STATE;
 	mcp->out_mb = MBX_0;
 	if (IS_FWI2_CAPABLE(vha->hw))


