Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292F632D43C;
	Sat, 12 Sep 2026 18:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236957; cv=none; b=tQGMrohi6NencMTJ2lCcC9WYCjUSNbCZ660SFSdNRoffKPzDUprElhYqqfg+nkOinpZA5CQxgWr1wutvrLiRa98qMrX25ItgFRZ/u0s9+6HiLVx3MC0Bo6fND2w/mdSifYv1xTEiC2bqTqxqTRdJEeBXBWVSUg3p3ghY1C7Ihkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236957; c=relaxed/simple;
	bh=RZ0ID02bKBGusjei0XbtoBxqqXa5kMlkvgo+D3bQtEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qO70bA1ZQDNVK3pkVPFv/su0Vk9MkcQtpBiONYscSP+vBK50Sl6ZfEFb7yKTJ2bnK0Rz+5gNR+ahub/o52ec+o1Ko24BZgSqQotPpp/rncrb805KqTAxRcwyPFaKVBV1xpjGGBkMqOXFWFfWwPP0GfzdYIDSvaPwghplPe+avVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlQuqG8n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlQuqG8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF2851F000FF;
	Sat, 12 Sep 2026 18:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236955;
	bh=e4ErykZtRUlMQD7sGKBMCdF+vkyODWE2UZyRx9fm0mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlQuqG8nfyRwiFeCnAm1vv7Gnk31+2LzLlpm3KbPfCWNvVXXc1uXscwWmtCKtouwU
	 agdUWEhPCn182CW08ZVnOFyaIAAcUboy5Crq5x5Xoxb5fyPTgFfc/u7yNDw4kYs+Gj
	 6TDmnhp3BNohCCJtDRszO7DmHQ76NyoFld1ze5qQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 160/935] s390/dasd: Propagate partial completion length across ERP recovery
Date: Sat, 12 Sep 2026 08:53:10 +0200
Message-ID: <20260912065530.490588419@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit 6fb5ba2e7e43173a3761e46f091070a8185efa14 upstream.

dasd_default_erp_postaction() copies the timing and device state from
the finished ERP request back to the original request but drops
proc_bytes. A request that was partially completed, an ESE read of a
not-yet-allocated track returns fewer bytes than requested, and then
recovered through the ERP chain loses its partial-completion length.
__dasd_cleanup_cqr() then sees proc_bytes == 0 and completes the whole
request instead of requeueing the remainder, silently returning zeroed
data for the part that was never read.

Carry proc_bytes over to the original request like the other
per-request state.

Fixes: 5e6bdd37c552 ("s390/dasd: fix data corruption for thin provisioned devices")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260805111612.1285190-3-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_erp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/s390/block/dasd_erp.c
+++ b/drivers/s390/block/dasd_erp.c
@@ -127,6 +127,7 @@ struct dasd_ccw_req *dasd_default_erp_po
 	int success;
 	unsigned long startclk, stopclk;
 	struct dasd_device *startdev;
+	unsigned int proc_bytes;
 
 	BUG_ON(cqr->refers == NULL || cqr->function == NULL);
 
@@ -134,6 +135,7 @@ struct dasd_ccw_req *dasd_default_erp_po
 	startclk = cqr->startclk;
 	stopclk = cqr->stopclk;
 	startdev = cqr->startdev;
+	proc_bytes = cqr->proc_bytes;
 
 	/* free all ERPs - but NOT the original cqr */
 	while (cqr->refers != NULL) {
@@ -151,6 +153,7 @@ struct dasd_ccw_req *dasd_default_erp_po
 	cqr->startclk = startclk;
 	cqr->stopclk = stopclk;
 	cqr->startdev = startdev;
+	cqr->proc_bytes = proc_bytes;
 	if (success)
 		cqr->status = DASD_CQR_DONE;
 	else {


