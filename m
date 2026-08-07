Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ECD633DEFE;
	Fri,  7 Aug 2026 15:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115429; cv=none; b=Ldyd43HrFm2ox1Nsbv5XDvIUP6zPXSW5R2XepSE4OcjJt7yigAoW1kNtcILFUsB2pnV6fhB4d4kowLYEySQvW5HzE0RBLkZ4NlhDE64X4xAIQ/ofNmvAkeC5FoN75BSPAe//NdKRo2lVXMTZFkw+zoBwX8VSMTDHZK2nwZYRVNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115429; c=relaxed/simple;
	bh=/YYfGoiDFrmHLm0lORHceMs7+aA5mtOKP5Zr1/XqfgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q3CtyWkQI3QZp8BORr2melikEOxcH8vJa65Cn+nqIkzLLL/TRfbEpTRx7XqIaVI9XpP2MVpDjGFlHSuZFu7k2xIrkKdlmYK+a+numZj44MD8Oar5zRlu7zW9JhuiRnMEdZur7RfrWw2rY/ZzPPFem4oLkanPeAr7UTkswn0M6eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gaiSB8gf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gaiSB8gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE8B1F000E9;
	Fri,  7 Aug 2026 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115428;
	bh=hOW3wmJKSggPL05NaBZ/ME1paNcuAZfSVqwg+mo26wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gaiSB8gfuVCq0vgPeECuJ2A0IWafy64k8JjOQA5yiyPA0IECNcknpNl7P8fCQTFFn
	 Dej6mSQULDHJY20dkb+fPKTSnpolC/QbgB2dm2xxeOULUM+zGb9ucF6rR++f19NqbC
	 GtPJ1ur71fPiUQfM3v2UDMGcxsegfbxqf2cUikPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	Eduard Shishkin <edward6@linux.ibm.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	=?UTF-8?q?Jan=20H=C3=B6ppner?= <hoeppner@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 272/396] s390/dasd: Fix potential NULL pointer dereference
Date: Fri,  7 Aug 2026 16:37:12 +0200
Message-ID: <20260807143430.122027480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -325,7 +325,7 @@ out_err:
 static int dasd_release_space(struct dasd_device *device,
 			      struct format_data_t *rdata)
 {
-	if (!device->discipline->is_ese && !device->discipline->is_ese(device))
+	if (!device->discipline->is_ese || !device->discipline->is_ese(device))
 		return -ENOTSUPP;
 	if (!device->discipline->release_space)
 		return -ENOTSUPP;


