Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A39A30C360;
	Tue, 16 Jun 2026 15:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623686; cv=none; b=jIMCC2KjvOAh0YaKYoXxrelLXV+FJcacyKoUFGym6/NjihYDHZpikFC5J1j3yrXss5uxodT4jt+DIw1oGfddAH6rD7D6DzDuEDErM2bU2tS1IYYN+pp2+ZVJkOIYp9gTU2LxsazidQS29vzSNvlFQECOiy+jp8MalBV06k8T5cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623686; c=relaxed/simple;
	bh=71sgXWGe2vK0+5IggJ/fBbZan+tWQnmJDMl3ZHSHXoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WeY9I0AbwoxQvEc0gX0gqZpKMklXW+YGalSvtIasCNdzjv8FWKrBCyEEs/YPR1FfUVcTb0HUQy1s3HxfU7to+7IEE9zIsAGSQT6n0+yei+fCL5idz3ucUg4QtakXs2D/YtGStH0PcKfYLtrtp1oTXpF0ErjQN+twiUztnRam6nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCjz2soZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCjz2soZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E081F000E9;
	Tue, 16 Jun 2026 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623685;
	bh=DM2g3FEVlQ/jgjZhrkB+8uXzxmE4xJALpp8wqM6Rz9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCjz2soZ9Q/bWdCEL4WDJ+6nlZ5hvWnuUOxxNEP3gFDSthLP68xv9RaKUycbFq9tR
	 4db8+Jdoitv6kLAr/r3lRsJ22B/mzJwXyr3IRKwQmU7mlYvNHu4TSGQFZ13C3CFQ1q
	 okRf4Fu9uhsvkIUJlzdEp142rlxQfOMUr21tmF8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Amirul Asyraf Mohamad Jamian <muhammad.amirul.asyraf.mohamad.jamian@altera.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH 7.0 179/378] firmware: stratix10-svc: Dont fail probe when async ops unsupported
Date: Tue, 16 Jun 2026 20:26:50 +0530
Message-ID: <20260616145119.800861687@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Amirul Asyraf Mohamad Jamian <muhammad.amirul.asyraf.mohamad.jamian@altera.com>

commit 371aa062219a0af108fb8992f0759d1bac1e8c91 upstream.

When the ATF version is too old to support SIP SVC v3 asynchronous
operations (e.g. ATF 2.5), stratix10_svc_async_init() returns
-EOPNOTSUPP. The probe function currently treats any non-zero return
as fatal and aborts, logging:

  stratix10-svc firmware:svc: Intel Service Layer Driver: ATF version \
    is not compatible for async operation
  stratix10-svc firmware:svc: probe with driver stratix10-svc failed \
    with error -95

This prevents the SVC driver from loading entirely, causing all
dependent client drivers (hwmon, RSU, FCS) to also fail to probe even
though they can operate correctly via the synchronous V1 SMC path.

Fix this by treating -EOPNOTSUPP from stratix10_svc_async_init() as a
non-fatal degraded condition. The driver loads in sync-only mode and
logs:

  stratix10-svc firmware:svc: Intel Service Layer Driver Initialized \
    (sync-only mode)

Fixes: bcb9f4f07061 ("firmware: stratix10-svc: Add support for async communication")
Cc: stable@vger.kernel.org
Signed-off-by: Muhammad Amirul Asyraf Mohamad Jamian <muhammad.amirul.asyraf.mohamad.jamian@altera.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/stratix10-svc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -1952,10 +1952,14 @@ static int stratix10_svc_drv_probe(struc
 	init_completion(&controller->complete_status);
 
 	ret = stratix10_svc_async_init(controller);
-	if (ret) {
+	if (ret == -EOPNOTSUPP) {
+		dev_info(dev, "Intel Service Layer Driver Initialized (sync-only mode)\n");
+	} else if (ret) {
 		dev_dbg(dev, "Intel Service Layer Driver: Error on stratix10_svc_async_init %d\n",
 			ret);
 		goto err_destroy_pool;
+	} else {
+		dev_info(dev, "Intel Service Layer Driver Initialized\n");
 	}
 
 	fifo_size = sizeof(struct stratix10_svc_data) * SVC_NUM_DATA_IN_FIFO;


