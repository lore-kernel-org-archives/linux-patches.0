Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C9A375ADC;
	Sat, 12 Sep 2026 19:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241476; cv=none; b=cK2Tz5TxB8syUg+2tVzLQ6WV5knKV1++AAoxBDmgtQRwwJTmKL2busZmt0Jz0GqQ4SM39h1PcnTmyFOEuTNhtBOckwpXjPT54/q/Y9x/awAWWvxDli/I+1JY7hQZWOoIPY2syY7kEohf61E/oMHPd1gEmMTO+GVX07IwZt7jH+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241476; c=relaxed/simple;
	bh=KSlhbIMtJQnpSMURKLJKONhhyKpPFu3we0pN4n0XbcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GB38COoKmcKXzg8PWMZr73FXzFtfXFUqixjxrNZ9NuffKWYEP4QE+4daulezNpDZuaX5uHthWBGipN40eGF4lgkl+xTxzt6VYVmWHzKap7wZ1ORx9pMViT7v5jybHjE+XZOD4wu827W+qKI1JoAguqcJWhUX1wt2TYn1IqpzI/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1jYsJ+mv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1jYsJ+mv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B46D61F00899;
	Sat, 12 Sep 2026 19:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241473;
	bh=N5DNlI/yQGpCxNvQXSF4FgdicIxAELWSEU+tPsTdu10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1jYsJ+mvdeB/uRJMMEVgxqXyZxN+paa3xGG6Aygubl3IAb0/G5LFbPW47IWwSfDlQ
	 Tpv3Hc/vvp4xxvOmuaf0mBGekg49Nw8Y6hNs/NAar4XftXXEXI11OgXJK1TWXE2wvD
	 0W5tDIPbnhSfCAL75DEvBhFl4CVMYYULzRI+K39Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 141/798] s390/dasd: Propagate partial completion length across ERP recovery
Date: Sat, 12 Sep 2026 08:56:09 +0200
Message-ID: <20260912065520.212105102@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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


