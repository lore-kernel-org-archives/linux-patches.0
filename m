Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899D24E01FA;
	Wed, 30 Sep 2026 18:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793562; cv=none; b=RaRF0z+F/PMa0Yu2EQbTHk0ZDEg96V1sQU5SGZGTnlPIWG+tHvXeKMEVjBsTaYxUvJ7fD/WwYXAaKRfXGWNUbf/bhByoTuITcjqcSuaQxdH9mcteU/hEAo48FdpfKrEUsoh9ITnOgO6SF4rNS07y54GXrFK1lHY6k7si47guHF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793562; c=relaxed/simple;
	bh=BuKiRKFRfNQJHuXjsRP6jAhw4iyJiNR8R4Wsj1T+ktM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bu3iYZ74vMQFRbkBPhc6KQqMykcdaNmpGUv/P1aiadtyqs+hBSwkcW4pM/bP1eeaKUrgrT1+Ro2IIDRBS9sxmc08WaB1H1+o0IeUOGFou6RqyChe6IA3qdp05TPA6WhFRcb2wzPmK8smtMU75EPJhGWJjG2zxPHie3NbZYC4OTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgsRvZ6J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgsRvZ6J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAF91F000FF;
	Wed, 30 Sep 2026 18:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793560;
	bh=MeXiJjjodFvgR1v1Jrq9wzQOvWr2vHwHRdGPgesgGTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zgsRvZ6JSMWRnRH56IAukP5Lj/h11pX2DhbI498VtasWlaXqGNhmm/1nvpnVLC2gC
	 YVwi4POyHiwygY3TyNwP4kZGBuTdsStcvDPSvu6ban0TLekLF3VEtpwASSrU+oRTpT
	 iHR1Pb8elnJHw342T92UzgVqdSk4dcwgqWWlPcGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 297/395] scsi: libiscsi_tcp: Check the data direction of a Data-In PDU
Date: Wed, 30 Sep 2026 17:29:19 +0200
Message-ID: <20260930152347.098089042@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
@@ -480,6 +480,9 @@ static int iscsi_tcp_data_in(struct iscs
 	int datasn = be32_to_cpu(rhdr->datasn);
 	unsigned total_in_length = task->sc->sdb.length;
 
+	if (task->sc->sc_data_direction != DMA_FROM_DEVICE)
+		return ISCSI_ERR_PROTO;
+
 	/*
 	 * lib iscsi will update this in the completion handling if there
 	 * is status.


