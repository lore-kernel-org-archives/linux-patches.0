Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6766332D7F8;
	Sat, 12 Sep 2026 18:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236947; cv=none; b=pezGmfJ9vA6MCs8T0nNVQpmoJKI0UYThfbWeAYrva5nUIFW/qYxJmKubmu1Q88jAlf87slXss515rdcobOCmgLPRzAGJ/fC13BK0q5VZZ9Ntxib1jXFa+Ft2C0SbaXPFmdZ0BL0FYEK6dduJxQy43dgk0tPV3aea86rdoy4WDPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236947; c=relaxed/simple;
	bh=i2oPYGwMgQCajMRhQhRGAKEx4w15q2t43CORzrX3Ywo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LwTifOZd3j40MWD0tYp/86bkTpEf15CIq+4N2r1yemrlGRfk98Pww2KBT0slHwep2U32ezphiazHy4BRovR0XxRrGhKRrn2EOWnIOHXbmLdQqRIKF0e+/ujm0gIUJL77wPzkshGTpBZUKoI1NiB8GNinoMjlhy/vs2YB+in1Iog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igkvRoHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igkvRoHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D89C11F000FF;
	Sat, 12 Sep 2026 18:15:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236946;
	bh=l8C2K9rKfc841xuN6FKsbKG5WNiRMHdIrF5NwrNiYuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=igkvRoHcGkvAuWWNspCmUe4DkwDuBy9YzrVN/MR8yOxzjZTv9eFEuodUk9nmPCC6x
	 2cdb33LtPTSRY2EmCQWhZk/Q/1gxRq1+QkpmNZtSopUhPwZGmuJGYGSRlfnXLfriqQ
	 HV/UeD4zg0VkzbrGuPi+j2cV9vWcWArq+YAwHPyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 158/935] s390/dasd: Do not complete a failed ESE read as successful
Date: Sat, 12 Sep 2026 08:53:08 +0200
Message-ID: <20260912065530.444535795@linuxfoundation.org>
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
@@ -1760,8 +1760,10 @@ void dasd_int_handler(struct ccw_device
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


