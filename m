Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECB12E285C;
	Sat, 12 Sep 2026 14:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222028; cv=none; b=sH4ZuKw88MqF3wQd+1XfGD7WJHfe+mH19IZehVWkwETta/UGns1hw662+aFdMOZBEjEy8C8CVKpJKcNUTMy/xlC0Wv0O9USOh0oRcJ1tYME6TPd+LbNISlxlpDtr0IKsKAXfgUOehsu+2y4BPkux0IlNH6lUbzh8LJFc6CSct2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222028; c=relaxed/simple;
	bh=GSmgTwQ5Oz4MsYBIt1Xe3G3DWC7laOJvle4Akk3Sel8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RHyy4fjj+lw/yoDlhHMkf0VufIUsNHB6YCHDz8lNBPICHJCM4xTawnuSHcSIVOnrwLn0cEcw5fpfuFjA7XQuw7r6oVbSZI9HLS2ZyWJH55azba8bOCS67v0bfe+vckW6KX8gAbl/i1eQYul+D7L4xfYJ5wq1m5P1ZDIu51+aLyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQmmUiRQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQmmUiRQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4C91F000FF;
	Sat, 12 Sep 2026 14:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222027;
	bh=EkJmGRkRprcUJXkHKFjYFg6/0O5o/j5OQ8+hWvQy4N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQmmUiRQsl5/XHesxbfSc+1n+P10FwjHNbEiLyihWGzAQH0HnH5H0SRyvaFSig7JP
	 k0BllzccGIqU1TvdBJ1DrCzwwML5DIXGgHK7x5cXFHX+2uAokCXesS0WDetfelbsjD
	 LmV82DTY4zBydrNf6S9vQ2txlP9/7nKUwL/+/qlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 0486/1424] scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
Date: Sat, 12 Sep 2026 08:48:38 +0200
Message-ID: <20260912065618.171361483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


