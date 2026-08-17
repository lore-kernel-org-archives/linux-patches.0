Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BE93EC83A;
	Mon, 17 Aug 2026 15:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980046; cv=none; b=UmFZolWA4TqW2jUKozgoMs1d2O0TjmsNGVsInmKFEQqNLvNfmHFa4PsnWcT55YDFHb85AqwlYonAPtO8xkVB/ii3nQ9ZDbhXzzV+bVtZxaS3B7+9JGujsQcgRuWbwqN1shRtge95vDvvtm5LPNa4VPikwfqe1eMJJ4to5lfPwJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980046; c=relaxed/simple;
	bh=SSfmVpG0Amivm7nYSL/gzbpFc2+FBDeE7R2pbAMTtrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oq3Z9I6Pbom1ltXgAsCqNwZGWaoOPPAMYGwliVfUCoDiOQXlkV0SPCz9ciS6WD0LNOEKgX7kn+5rL1OpBQtHSxRz/Dn4zMOcN4tk08lNL1zhK7Lt/CxsoA1JD5vA0HCMZPFvDHdurXVuvypm+WPPUpcElXSYPyZlygCY6yS8HTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWi4P/US; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWi4P/US"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF20F1F000E9;
	Mon, 17 Aug 2026 15:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980045;
	bh=0PlBQfwnfnhlLLBuRkipG0r0+h1hkphVzA8pprTvPBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QWi4P/US4XLRaRb3riuIQgCUoy6HKgkCTUkt8fQAURARqfhmwPrH3xBHvLtr9pjZu
	 7vQv1RXqNU8EAyf/jV7gdOBLalaq5bTGQi8zMZxnrAeGqire0gZTyX/R6zjVwqsbZS
	 wT6B7vtkZPFJg720+r0qCFVegNK9dXqCOZkPF43A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Eduard Shishkin <edward6@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 436/609] s390/dasd: Fix potential NULL pointer dereference
Date: Mon, 17 Aug 2026 15:32:12 +0200
Message-ID: <20260817132558.663717859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Höppner <hoeppner@linux.ibm.com>

commit 9973026f572db6b67570cadc30942f3014e41079 upstream.

dasd_release_space() checks the implementation of the is_ese()
discipline function before calling it to determine if a given device is
an ESE DASD.

The current usage of the logical AND operator will lead to a NULL
pointer dereference as the function is called even if the function
pointer is NULL.

Fix this by using the logical OR operator.

Fixes: 91dc4a197569 ("s390/dasd: Add new ioctl to release space")
Cc: stable@vger.kernel.org # v5.3+
Reported-by: Vasily Gorbik <gor@linux.ibm.com>
Acked-by: Eduard Shishkin <edward6@linux.ibm.com>
Reviewed-by: Stefan Haberland <sth@linux.ibm.com>
Signed-off-by: Jan Höppner <hoeppner@linux.ibm.com>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://patch.msgid.link/20260727142840.567286-3-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -330,7 +330,7 @@ out_err:
 static int dasd_release_space(struct dasd_device *device,
 			      struct format_data_t *rdata)
 {
-	if (!device->discipline->is_ese && !device->discipline->is_ese(device))
+	if (!device->discipline->is_ese || !device->discipline->is_ese(device))
 		return -ENOTSUPP;
 	if (!device->discipline->release_space)
 		return -ENOTSUPP;


