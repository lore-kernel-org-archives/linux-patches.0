Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F88947D466;
	Sat, 12 Sep 2026 13:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220648; cv=none; b=C0dFYUnLmAJjy8iPtHfh3IWBm58q0ZTijyGjhhag7hi5AIWMcDLtxeFblKNXKqCaKeT8PMHwnkDs/LsLm25I4t8BfOSLCvKvIx0z3jKnZhkIAev4LNxeLdCQpnQlg0l539jobVsSWKgvI17CErzvvDOe9FIcUaKgqbwkeJbdZLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220648; c=relaxed/simple;
	bh=hHOZ/OjYZeEto7QuTHLCiK/hUWzJBIdHg9UIEXDm07U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aOPrPOb+hmg/bfvCl6Rw7vHaQLlo6GnICaacGOKYcLPcgwLkFmX7rFz2hGIzQdeLsp/cwdXIcOLJsrRE9lCzM0pLomjV7gXr+e2Q9kl7FiE8bdUzfkUtfdF5R3oOLDbOc387sFnE+lNFvWI1tJ+Z21MKuLeRatKCDd66T7Dyh7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6oBxdfp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6oBxdfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A8831F000FF;
	Sat, 12 Sep 2026 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220647;
	bh=8MuQxw8jg/WXgWTXysMk4QXHGmVVCSWX4kNNxhSWhWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6oBxdfpuC/QEllJ31P7/1NwFx6Ld0FGHY6mp9IkRXM5KaCU89ifPJ0fVWZpQdOuB
	 21h3/E0vmCDdyU+YFfRsgaAumO7RDvUOhCOo/1N7uFCoMlXGCjQC87UbaO4drVKsvK
	 9lm93K3q+nB8WcavWJKO6Q6nuXPLM3sOxutZX5Ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 0221/1424] s390/dasd: Propagate partial completion length across ERP recovery
Date: Sat, 12 Sep 2026 08:44:13 +0200
Message-ID: <20260912065612.235603641@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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


