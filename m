Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EA84DE72B;
	Wed, 30 Sep 2026 16:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786740; cv=none; b=Ep7smUbIxKSWQg51+aUcig4pf3MKCDWkFoXh8tJfUsW4cdL7YZrJ8EeMF9tzbjnPGobSAPph1yy5HLysTA1Ia/T8tY+W2sOIElraDnKsgtJuqzY/PapoPh3fQnfKJyRqxlm78a/eVN0CBxn2XkKK1VVo7yaTAFv0Jn7vgMsqy3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786740; c=relaxed/simple;
	bh=zJ0x4aZRDECj4NsojERXhuMtWwhcVd7r188qJJF0z3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4obJgKScp5AE9ewPOh3xuiad2ltgjV2YW110l+KkZglfMQ/7hQLMJJCxeBfKRkzW35bcf4ZIh/qGkN48GxAfSvOLhmLa2GVIdOnMDJxPlskrh65lU9TkowH80NTLOql5lXdYkdYVf8zLX2ygT0Gf+8j+rLgTfdF+PKgawSYlOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R857ldiB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R857ldiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D21A1F000FF;
	Wed, 30 Sep 2026 16:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786738;
	bh=UPDYaVw10gGlZLu2DpKp/XAHdFYGmOTpsopN76iJXkg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R857ldiBIFZ8Zd/XKsGost07R4j5LfdZoGUCjCjve0z0LA91XBlMctaEONORBAP8s
	 JStoDHGP3RQsP0kIqAeg51HEHD1mKEKY8aaSZALl86eUIvz3c1MDrJRE7xF2kjIxhQ
	 0CQ0zl+FU1vD+HHbgl54iuu+JJjvbYOliO1JnbYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 966/982] scsi: libiscsi_tcp: Check the data direction of a Data-In PDU
Date: Wed, 30 Sep 2026 17:28:22 +0200
Message-ID: <20260930152437.491088865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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


