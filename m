Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED362F12BA;
	Fri, 17 Oct 2025 15:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713207; cv=none; b=rtvPaXorWd7TYzTZaYbwRSLzTni4Jv1QW1UCFa3pJb2aHebLB7+FurOBqfhcLR13xosPNLC8epZT729bEbEJUAs6ZE4XDkEslJTehKY/yVAvO5Qv1uZaQWZ7yuNkmUu2zMXgvKqrh+nDXqtZYM1YU3L5iF2ww/j40L7WcQEQFUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713207; c=relaxed/simple;
	bh=kTVtFCZPM699PohySB59zPvbrNEZrRNrHeiS7IAVrbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Agl4xBJd2ob2Rfq82goSgRTFde+tU6qTHwvxyUr7t6tSdtI/HAuf8VYSifUHoFR7kSwJ2XrtmcR7TDQofBAksgoiamVAP9y9Jv9fs7uM+nHNrtBSm6ZN27xCBVZejfK4BiJveL/gHertJTD7u0cJ3d14l4Mz4Xg+NhKGnq3/fII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8cM+5Ay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8cM+5Ay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF60C4CEE7;
	Fri, 17 Oct 2025 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713206;
	bh=kTVtFCZPM699PohySB59zPvbrNEZrRNrHeiS7IAVrbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8cM+5AyvgDjNmqAcKuTTr37b/LOyiGZTTkd4faP/apuDTsGmfTDSqQr83Jl+Ejzr
	 bMVTlhlzbbR0YWGNbGW0XglV5ALmJJz20y0Ru4TG3N56aZMPtwZsDGSkbqkQwL1bur
	 tCjVcFWdgF1WCzRmV30Gnu62XlC7nJu2jZ9N3oY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Nyekjaer <sean@geanix.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 083/168] iio: imu: inv_icm42600: Drop redundant pm_runtime reinitialization in resume
Date: Fri, 17 Oct 2025 16:52:42 +0200
Message-ID: <20251017145132.084401660@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Nyekjaer <sean@geanix.com>

commit a95a0b4e471a6d8860f40c6ac8f1cad9dde3189a upstream.

Remove unnecessary calls to pm_runtime_disable(), pm_runtime_set_active(),
and pm_runtime_enable() from the resume path. These operations are not
required here and can interfere with proper pm_runtime state handling,
especially when resuming from a pm_runtime suspended state.

Fixes: 31c24c1e93c3 ("iio: imu: inv_icm42600: add core of new inv_icm42600 driver")
Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Link: https://patch.msgid.link/20250901-icm42pmreg-v3-2-ef1336246960@geanix.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -730,10 +730,6 @@ static int __maybe_unused inv_icm42600_r
 	if (ret)
 		goto out_unlock;
 
-	pm_runtime_disable(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
-
 	/* restore sensors state */
 	ret = inv_icm42600_set_pwr_mgmt0(st, st->suspended.gyro,
 					 st->suspended.accel,


