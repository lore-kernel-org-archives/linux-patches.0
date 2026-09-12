Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762B247045A;
	Sat, 12 Sep 2026 11:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214072; cv=none; b=PXZiWJOfQGXstj/v7baNlGFZiAaBIFKzBtgkSnsKUUvqYp7UqI5EzyVEC6fwkPLMjUki71TN/h7mjjSBl/MelCrBmLAoU/SGd38W0C8i9shsYGqQd3Sh8CTob4pkW0sIg4S/2rD1TNLVcLmopnP55GfBgEwZ7OwVsikaesE+uno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214072; c=relaxed/simple;
	bh=BcMbEouzrYLFvuPqbEi5/iP27olrzy3D/DAVtrK9dQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUL9gPC2mlXZbcvxtle3zyjc0rR73ka/oFM6JfdXqfy8fM9o3qTp0KE7UJdh32578EE/B7TCfLbjq5VYW+WUUIdUjOY66pqHfRBLi+T2Bg5+vrkSZERJlgYEEA23iYfI7g9wQF7QgTMO0DJRXrHIpnNbOL4eQ86GIC1rYkOr0rQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EpeKiKNB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EpeKiKNB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33511F000FF;
	Sat, 12 Sep 2026 11:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214070;
	bh=3TrVS8WBPmWQyZ520eUsBenSPds/wqhaR5waIDjWoDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EpeKiKNBlHr1OrnlHL+3kc1yYqU8NHfxRfanBAtSKpT3Ug13D1T4acQD5Ggv8/wk0
	 etG3s5IM6PudAoRYlaIDYKH9KYY1a1aG4jQHecHOKzxDoLhADO+B1IRMqvIr4c1KVD
	 aFRaUQNoofgQIMgeWyfsCG56z5PKkYpGpPb3Nqp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.12 0233/1376] scsi: qla2xxx: Zero mailbox struct in qla2x00_get_firmware_state()
Date: Sat, 12 Sep 2026 08:44:19 +0200
Message-ID: <20260912065612.739140040@linuxfoundation.org>
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


