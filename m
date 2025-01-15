Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7557A1DB15D;
	Wed, 15 Jan 2025 11:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938900; cv=none; b=trcDRNRsXep+fRRDNVqqfnizqJTYiOv8piDHqrb+TL8ttyhD8rswED3wdcz4REHyuar3rM8CGl0hyfsNYZV1xDUdpEk3GYb2zClxLsnMWMmNuKG0MSMku0O3vbV9yTGLm0tpsQfjhu3YOepCz+BTyF7CtmkDpq3CkTOJzcS1X7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938900; c=relaxed/simple;
	bh=3++wBy0d6lbn2Yf1iOqHDhcFEfrDqjuu8iPEV5KQezM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjSkNsmki35rq++QBCaLw2q1b/WY5txm+HVEUjki0PNrpY6GKT/u0sT2NY0Jli8UtTDMDcqK6Ml5RnNvShRLgite4AxRSZ7Ml/sdz6hSITLBrteJzyhMjMTjpxb0S8b0gK2PHuPtfk7BQsldYQ1WCXZMD1qJf5Ku9Ypr9OJU5CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6ieLglN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6ieLglN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF04C4CEDF;
	Wed, 15 Jan 2025 11:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938900;
	bh=3++wBy0d6lbn2Yf1iOqHDhcFEfrDqjuu8iPEV5KQezM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6ieLglNefKq2GnuDzcXKly+V0XOe+LBymd5OaRESsbOkQOhNHMhtZc+njLye3DwE
	 SjDRnW1ZafETFNocbc890apdehoIJyUNtsqqK6pAHbSuooF75cgaiBAV67Em8GbDGs
	 vEwQITfw97vIva2LgcRVoreFP7KQ1q/EjpZ2/rBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 111/129] iio: inkern: call iio_device_put() only on mapped devices
Date: Wed, 15 Jan 2025 11:38:06 +0100
Message-ID: <20250115103558.773857119@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

commit 64f43895b4457532a3cc524ab250b7a30739a1b1 upstream.

In the error path of iio_channel_get_all(), iio_device_put() is called
on all IIO devices, which can cause a refcount imbalance. Fix this error
by calling iio_device_put() only on IIO devices whose refcounts were
previously incremented by iio_device_get().

Fixes: 314be14bb893 ("iio: Rename _st_ functions to loose the bit that meant the staging version.")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241204111342.1246706-1-joe@pf.is.s.u-tokyo.ac.jp
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -514,7 +514,7 @@ struct iio_channel *iio_channel_get_all(
 	return chans;
 
 error_free_chans:
-	for (i = 0; i < nummaps; i++)
+	for (i = 0; i < mapind; i++)
 		iio_device_put(chans[i].indio_dev);
 	kfree(chans);
 error_ret:


