Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C33A414A2A;
	Fri,  4 Sep 2026 06:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502660; cv=none; b=OEOGa/g6MskBi8Fv1/A1Cfh+mBT4oWAKdYau9tAS319WKjBBzcl27S2JHBSuZy830+JpSN2cMRhZzCs1p148SVLuEIWAEGKCZzDeIUv6WsWEXCTkcQaerdgoBXYXzPlHY1M3+48URxKZKsvedMJ3w5at5qSV9jq0HgL610nTu7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502660; c=relaxed/simple;
	bh=YjkoKluTjuCSlH9bmtYSsVkpYbOPD613f8G0LiU/PuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XoAJK/NJqQHDzn9jbG0093+rAp/54NzxQWklxaC2zKyZDDSaHK368Wd1puJO2EuY2AhFAjZ1SWxdx43u05ZKnQlV2MowA/kQPpTN+PhwcL3Ki8lHwo0ZWS6MmywyQSEQGXLFdM0ojLOGtt2i7kvINbOEvvIfHs5Eltq2UL+jI5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbRzvU2r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbRzvU2r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C771F00A3D;
	Fri,  4 Sep 2026 06:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502659;
	bh=i/D5THT61EjKvmEo9kqy0wMS03rXZk1JvQpVIRQMi9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TbRzvU2rNJ3cwX+yAySVE7qTQzJ0CQJkGeSwmZaV7Zj13+FLI9D3e7BKQ0vuexWmq
	 WFsNPzKTCDnjS2LhfLknqv+4TtQKmluFiPJoVvsA0V+C2FAmkoJ4qaztNVL3ohmQHt
	 17u/TIDUAO+l0O5mccmdERyL8+KiuXGqn1XOSu2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 286/403] s390/dasd: Do not complete a failed ESE read as successful
Date: Fri,  4 Sep 2026 07:01:29 +0200
Message-ID: <20260904045741.358598030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1744,8 +1744,10 @@ void dasd_int_handler(struct ccw_device
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


