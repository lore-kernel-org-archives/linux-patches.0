Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789F01F3FFE;
	Tue, 21 Jan 2025 18:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482941; cv=none; b=NcBKFH+Edgap2ghWxnyozm3EMFdmbGUgjK9pVOS/Dor4jQOTURZ09TXy+dsGtdc8cXIc7OyKOMzoWz8ZZ1ITl3djUNHt+HdcV7PL/rtLU6rFMhyP2Vz0ieNRKpaw3hRBTUvdLD7FAP8PXBOrxMFb4dfU0Gfw4u01llP0mt3VVs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482941; c=relaxed/simple;
	bh=xX+eoF+W+eh9h7s93fYPREaljZ5+UMEZOOYn4QY9H50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqe7lMM+957PEjbOsO70gkTROshbOd7Md7BEByXgaqAOwqW6dEXgroMEhQRjUEK45CyzygCSssZnX7AMJtqmlYSkkToYwHOxkgcM/18Z3979ZJXB0hVkIA6aRKjQnoHuAdnf/2FeXtYqRy75h62W86FdBbkdGC+y+bYhTXqOMKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ObdDDPrY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ObdDDPrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03307C4CEDF;
	Tue, 21 Jan 2025 18:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482941;
	bh=xX+eoF+W+eh9h7s93fYPREaljZ5+UMEZOOYn4QY9H50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ObdDDPrY5gJ36Jy7wpN74/rRIXOO72Tku2L2RaQW0M68xX4qkX3S0zR7G12rQgtXq
	 gBlpeOfimTjx05ryPE8nvPB5s13acZXtKB54cT7To1uRzTBiWJhoSCG6KrxGK1EBKj
	 rz3btbVJLDHlGdKlpmzp3TZRcx2AZsb6FqTrgY4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 061/127] iio: inkern: call iio_device_put() only on mapped devices
Date: Tue, 21 Jan 2025 18:52:13 +0100
Message-ID: <20250121174532.019742083@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -469,7 +469,7 @@ struct iio_channel *iio_channel_get_all(
 	return chans;
 
 error_free_chans:
-	for (i = 0; i < nummaps; i++)
+	for (i = 0; i < mapind; i++)
 		iio_device_put(chans[i].indio_dev);
 	kfree(chans);
 error_ret:


