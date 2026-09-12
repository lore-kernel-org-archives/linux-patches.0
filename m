Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D8B6369D7C;
	Sat, 12 Sep 2026 19:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241460; cv=none; b=mvtBzFvA0J6Vflbuyr/6Q4rzOQGRnh2WBtfjTNdg1Pla0XdYutXLpiYi8hbtgYCANdnn3hMSEOeVHessQdfTwiKActZlylmwBFNtRauF4arCGsf0AsBJWKsSHf3uUpOSHFH8stVOyr1z3C2Ih6zN/OgO2kCZ/NnIoIlD2Dgk8lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241460; c=relaxed/simple;
	bh=agQSh8mDb0XLa/l19gzFNwXSfYZLYcUf9kIluxuy2wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DgCDVQP9b1NkIkBCmxXONTYSkEMYMHOTWFqq66MyrIxHOyZIasBZBD5JGdbd2Bp9cn9egv6/GuE6WIxB6rFaWgbSh0yC125qemdURtghURMfuq99h5bK+nF6HjeJzcjtxdrB+yDqqsAR1t/kx4Sjp98ar8f9UcBkjSromFNiFQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XbSp0iCC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XbSp0iCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB551F000FF;
	Sat, 12 Sep 2026 19:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241459;
	bh=4YCT340kGAlusxM2sFBIOg/6xzlnFYLYIwnpHlLsih0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XbSp0iCC++xcyANz3CVZ3SMq9XOrZ7loGe6ffIGpkFz3DJ11uEyQ5pgwU7NxFPjwx
	 6we4Rqta5E+OHWQjhpQZjb5Ln/7fZfG+LIRYbeEhejN0yH12m8F1yMgh98zYsCc7Re
	 sKMkAPDRP3iFh0FaD1ZrKym+C1fB3JqMC+8XrO4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 139/798] s390/dasd: Do not complete a failed ESE read as successful
Date: Sat, 12 Sep 2026 08:56:07 +0200
Message-ID: <20260912065520.165719559@linuxfoundation.org>
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
@@ -1803,8 +1803,10 @@ void dasd_int_handler(struct ccw_device
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


