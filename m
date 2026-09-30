Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9121552842C;
	Wed, 30 Sep 2026 17:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789574; cv=none; b=BktHhI8sPo5+gTxw/cAuOrwkCoewKnf+M7qMr+jayOpvDdKjz/WB2Qs6LL3T0NI9TrbNfO9GbwB5jb64nwvBOriTyMH1QvKoy30De3YdDbEi9aPjG7ygbW2jAaP0RAsradzCHc6UP59lDHQKSnycJmZ02EVGaWuoRPKVCDsH9G4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789574; c=relaxed/simple;
	bh=zm8+yuAJQ3E0M5jf4Z3Fa/SiGOhO4+P8CUqX4PJDRnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHIh/r5P8B65GB/SQ0E4R2EJkCKJTL+g6fkfq1rBWEEr58sFFdRwGIz3Q99pPQVcPTbIolgijXg+tceNkymCZqXz3GjpcNN6rgDus4h/5lTlOKTlA6NrPF9bttAMwkYpOFmcoMDIMctKfyWeHxWhJoNkvGd0EyfqOCn+W9Naje0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMnEIZfn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMnEIZfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C108E1F000FF;
	Wed, 30 Sep 2026 17:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789573;
	bh=Mza1CNOPrDHjbeG/Zd8Cn0tJg5/FuWg2l41NUSR/PxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iMnEIZfn2uJ/AnFx2bxaduVtrmsSNpnyIRb6u8dfGwt41pociylnAufhpofzYMbPR
	 tJ54NSJ9dPnI401/fLPimNNpOUYMQ7iDzVVfEZSBYd8CQPmDdezgLjNEeGea1t3EbG
	 wrhuYcY7y5hMgUrFCAheNWyRuLypXd2aCGu3fw0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.12 524/877] scsi: libiscsi_tcp: Check the data direction of a Data-In PDU
Date: Wed, 30 Sep 2026 17:23:55 +0200
Message-ID: <20260930152425.958864253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit bce07e2f37b5e4a427d36fd6b1c14067b27591db upstream.

The Data-In branch of iscsi_tcp_hdr_dissect() resolves the ITT to a task
and copies the PDU's data segment into that command's scatterlist without
asking whether the command was reading. iscsi_tcp_r2t_rsp() in the same
file does ask, and rejects an R2T for a command that is not DMA_TO_DEVICE.

A target that answers a WRITE command's ITT with a Data-In therefore has
the initiator write target-supplied bytes into the pages that write was
about to send. Those are the caller's own pinned pages for an O_DIRECT
write, and page cache pages for a buffered one.

Observed against a test target that emits one 512-byte Data-In naming a 128
KB write's ITT, after the R2T for that write. With O_DIRECT the caller's
buffer ends up holding 512 bytes of the target's data while pwrite()
returns 131072. Buffered is quieter: pwrite() and fsync() both succeed,
nothing is logged, and reading those blocks back returns the target's bytes
out of the page cache without a command going on the wire.

Check the direction before using the scatterlist, the way the R2T path
already does.

Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Link: https://patch.msgid.link/20260801133635.1986706-1-yhlee@isslab.korea.ac.kr
Fixes: a081c13e39b5 ("[SCSI] iscsi_tcp: split module into lib and lld")
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/libiscsi_tcp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -491,6 +491,9 @@ static int iscsi_tcp_data_in(struct iscs
 	int datasn = be32_to_cpu(rhdr->datasn);
 	unsigned total_in_length = task->sc->sdb.length;
 
+	if (task->sc->sc_data_direction != DMA_FROM_DEVICE)
+		return ISCSI_ERR_PROTO;
+
 	/*
 	 * lib iscsi will update this in the completion handling if there
 	 * is status.


