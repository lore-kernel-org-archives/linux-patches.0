Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD363B19BC;
	Fri,  4 Sep 2026 05:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501371; cv=none; b=VsNMkIYXWkSaJW5i+rjsp2z2qejqqk43W1siWHonvYP/f7g9pSSNeA6iyStheFC+VfIF0qVdzuKykUgBZfdfewc7PEI260bNZRtK+9BZg8kFA8eqYzhELKy+jvEO9/IEveR3cvwSqu3IPJPtb0RR4XyFAbtNty7uwx3Kpxx68R8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501371; c=relaxed/simple;
	bh=y1ylPj4g+ERk0zPmkEStOB/FTih9bWOXJEH8a5Zn6Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mMMGUYexNVuem6va6H1xxr9VSL91zdn0pfhyaC09uBeILcBlqgVGeN1AWgiNhkPk+cw0xUpaabsxR21kItrNv+oMXwJ6yo8w3UJLIiv/Z9QI0Upulcfbj/p/508Q1s9bmcMLZK/n+/DCSXlC885X0KKg2quJfo2l6d9tIQ5Si20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zNvvWToO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zNvvWToO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB26D1F00A3D;
	Fri,  4 Sep 2026 05:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501370;
	bh=I5FlBcljzrjFNxov3PDf047Pv2opnRdMQHucYK6KZqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zNvvWToOVUbMj4KAz5vqv16qrbN3b6QiEFKNHufGt0ehChN+GgecjdcpAp+d6sWEI
	 sSGfRr/8LeXJA7BuaIwrqumzDyLWXWaKSzbSWzt2ySwNsoc04xpWZHnqW7o7w+ouE7
	 u8V2o9ug3XweYEFslDRtsIX7JnmPO65KnxXW8HKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 385/552] s390/dasd: Propagate partial completion length across ERP recovery
Date: Fri,  4 Sep 2026 06:59:02 +0200
Message-ID: <20260904045758.938709888@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -123,6 +123,7 @@ struct dasd_ccw_req *dasd_default_erp_po
 	int success;
 	unsigned long startclk, stopclk;
 	struct dasd_device *startdev;
+	unsigned int proc_bytes;
 
 	BUG_ON(cqr->refers == NULL || cqr->function == NULL);
 
@@ -130,6 +131,7 @@ struct dasd_ccw_req *dasd_default_erp_po
 	startclk = cqr->startclk;
 	stopclk = cqr->stopclk;
 	startdev = cqr->startdev;
+	proc_bytes = cqr->proc_bytes;
 
 	/* free all ERPs - but NOT the original cqr */
 	while (cqr->refers != NULL) {
@@ -147,6 +149,7 @@ struct dasd_ccw_req *dasd_default_erp_po
 	cqr->startclk = startclk;
 	cqr->stopclk = stopclk;
 	cqr->startdev = startdev;
+	cqr->proc_bytes = proc_bytes;
 	if (success)
 		cqr->status = DASD_CQR_DONE;
 	else {


