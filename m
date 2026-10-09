Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142542C0F6D;
	Fri,  9 Oct 2026 14:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557591; cv=none; b=pJRLAD7wV9uTAyuqgwCdTJFlXcjihSNSzZEecC9+93Ybb5JlgdQF6doCNaEjBem3qXmcots9FYJIigi/cwMuDRVZPoA7vspndoyrIk3tYVOdCKX2mPCM+WQo3oAV8R6CnoSJ/mAlih+qauhggI3GLAWRayffV0oKGtObs6Ttnyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557591; c=relaxed/simple;
	bh=Qc1KF7q6ezq2mVLAD+gl/g+nxbZTlk220QYBcDmRaOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cx0TKyZ7KSK3tMOaALEl+jEWjb1RKsDPKbWmtPwa6ydGl0DHqU+sXWHvqlpNJ5pXKO3w+TFw8pF2fomalhg+4nmE+aeXxwO1dK+ox5uNCWrEmv7UiXsGZH5auIKDDgmN9z91IcteeqCCs7SXwPu5tPqlDa4SgEjIcBojkCNcuWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCttokM/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCttokM/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1421F000FF;
	Fri,  9 Oct 2026 14:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557589;
	bh=E8Xg1mUM4E6fbGtD8/efYrA8Cxm5cUkFRFmsNFtb55k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCttokM/OeKgPGbbVYHEVTDPZGtZEtx9oO56TxQgjWfE+JXZm+0mVSj1LOwpzRpCp
	 shRH+qN1nYJCoY+6pbAxkMyeJW29NA/mjxwRf+xhTYNwLi2vi4Koo+9DppcfN659Y9
	 8NB6yK7jYyzXBpAbvugLGEJCaaIYA6h40N1WV8oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 413/428] iio: proximity: vl53l0x-i2c: claim direct mode for raw reads
Date: Fri,  9 Oct 2026 16:12:30 +0200
Message-ID: <20261009140955.301827215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit e24328974a88aa8541e94e8bb8dfa2ade1b3c45d upstream.

vl53l0x_read_raw() starts a single-shot ranging measurement and reads
back the result. Once the triggered buffer is enabled the sensor runs in
continuous mode and its data-ready interrupt is routed to the trigger,
so a concurrent in_distance_raw read disturbs the streaming setup and
never gets its completion, returning -ETIMEDOUT.

The original submission claimed direct mode here, but it was dropped
during review because the driver had no buffer support at the time [1].
Continuous (buffered) mode was later added without restoring the
claim [2], reintroducing the conflict.

Reject direct reads while buffered capture is active by claiming direct
mode around the measurement, as the vl53l1x sibling already does.

Fixes: 762186c6e7b1 ("iio: proximity: vl53l0x-i2c: Added continuous mode support")
Link: https://lore.kernel.org/linux-iio/20180911160300.GA9212@himanshu-Vostro-3559/ [1]
Link: https://lore.kernel.org/linux-iio/20240909101508.263085-3-abhashkumarjha123@gmail.com/ [2]
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/vl53l0x-i2c.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/proximity/vl53l0x-i2c.c
+++ b/drivers/iio/proximity/vl53l0x-i2c.c
@@ -221,7 +221,10 @@ static int vl53l0x_read_raw(struct iio_d
 
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
+		if (!iio_device_claim_direct(indio_dev))
+			return -EBUSY;
 		ret = vl53l0x_read_proximity(data, chan, val);
+		iio_device_release_direct(indio_dev);
 		if (ret < 0)
 			return ret;
 


