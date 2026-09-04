Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A17C351C35;
	Fri,  4 Sep 2026 05:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499721; cv=none; b=CjNDT9inDYv11OeWFVV0hNIq1jpXbKBm1ftLIqWy90wXS0jSRA95aO0NkO4JfoIDKnRNsWCVfzna0GYve3PPFjQkxeNA0ljARelGjNGexikQK9qffORIk3IgVGtXtLkPcows1jz9xQ5q5JS/uBTF6pcZQFm4J1Fkrhhetbv8Bb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499721; c=relaxed/simple;
	bh=6qwnAkkH38vMmYUE3COovu1ODHVAql7QNJ2m/NCX4I8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kxRxTgPHB9Zb+2SGN/R7+uTAvSA7cfjkUxv8tikqPwDxHsOhvwY/gz1GUa19pjrIv2RXjXU8pUEBDPcDAHR+AOtiuWg6Bgc4X3vnJRUvhAuNV0X76nUKEF3Oys0ndzGVDTJblkdUyHu6LAdMvaGT71uGjjVFVGfsOUzbVsSYNyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JlZXQBxz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JlZXQBxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B211F00A3D;
	Fri,  4 Sep 2026 05:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499720;
	bh=mkjRAlJFO7+ZOq90ONJKEgJCyml90XE1v04LrXNAexE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JlZXQBxzoABjK3KPbtvxwMoIJBiZxSJRkwQPN5MmVLTsksGvUkyrVay9IbZjXEfts
	 yfe/0VHde1yds5md4nu5QqQuXdwEYzFYfr7D4DLIMLMxBD9PnlcVN3sI+KbQGmEklP
	 QPVdK2AYck9SnXHzyLU22mtURNFrXbXeZK7C/ESI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 517/713] s390/dasd: Do not complete a failed ESE read as successful
Date: Fri,  4 Sep 2026 06:58:05 +0200
Message-ID: <20260904045815.407258295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Haberland <sth@linux.ibm.com>

commit cddb447c62466f3076938ce120028d7b591f9f37 upstream.

dasd_int_handler() completes an NRF read of an unallocated ESE track by
calling ese_read() and unconditionally marking the request
DASD_CQR_SUCCESS. dasd_eckd_ese_read() can return an error before it has
zeroed the destination buffer: a failed sense-data parse or a current
track outside the requested range both return early, leaving the
destination pages untouched. The request is still completed successfully,
so the block layer is handed stale / uninitialized memory instead of
zeros.

Check the ese_read() return value and fail the request through the normal
error path instead of forcing DASD_CQR_SUCCESS.

Fixes: 5e6bdd37c552 ("s390/dasd: fix data corruption for thin provisioned devices")
Cc: stable@vger.kernel.org
Reviewed-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260805111612.1285190-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1698,8 +1698,10 @@ void dasd_int_handler(struct ccw_device
 			return;
 		}
 		if (rq_data_dir(req) == READ) {
-			device->discipline->ese_read(cqr, irb);
-			cqr->status = DASD_CQR_SUCCESS;
+			if (device->discipline->ese_read(cqr, irb))
+				cqr->status = DASD_CQR_ERROR;
+			else
+				cqr->status = DASD_CQR_SUCCESS;
 			cqr->stopclk = now;
 			dasd_device_clear_timer(device);
 			dasd_schedule_device_bh(device);


