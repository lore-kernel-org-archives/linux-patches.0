Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA2BB32D43C;
	Sat, 12 Sep 2026 18:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237634; cv=none; b=nwSLKWCC7J9aqGNZsOxf5898nr35VlJUEqCzljvKtbNUUdlh+F/fSDzfMDJxyWYvnEbSDXcIBgZ/bT1eIlbVcK1jzUiAayxr4X4j32brdct3yiProVKpmVZvHaU7xP0rAcSlcddCIHpmpC/Vc24jyWjAn5cfArU45Ro2SJd5rEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237634; c=relaxed/simple;
	bh=z3Q+mVEuMnTCK4+bv9qzwcw1Z0GXyUiWOFlzxUKWkUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1ap97j8fyCthdd8/UKeHcUDDEXnCMa0i+SpyfePkcmU5FNkwWneK0vHdZM0NF0Cq/Wl5hrTHGgWWemuXNCml7BP7wJjnnRpTh0yf/5DzKpEl2LGhBfg/k58ZWF5CqHMGdqGia6HnBbqNelDldCaNfNTJ+pdDTnF6GpIReIW+WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YFyoECyi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YFyoECyi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320C91F000FF;
	Sat, 12 Sep 2026 18:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237633;
	bh=T6hql3gl1tQujk/emg1Z9USw4jtC6XXZju71Dw/j4nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFyoECyiYL7ndRWab7e3A0Zhbuh7dyDdbWQQ6CpQXMVRi8MAbKjGLYA2tXYSvhouh
	 WBtsZvq3kfE7vu96UAzpDQxe3wyJ+6b55/cxjQEpTyyOYiAX7GlKDBHwwwibthYN45
	 FVqb/6DA0J4B5pE6juRBCvbGxaOlTYuqFdUXsLEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 297/935] iio: srf04: fix pm_runtime handling on probe error path
Date: Sat, 12 Sep 2026 08:55:27 +0200
Message-ID: <20260912065533.622486773@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit a40b2e7a17f26e38ab054363c9c7cde149588357 upstream.

When pm_runtime_set_active() fails during probe, the driver logs the
error and unregisters the IIO device, but then falls through and still
calls pm_runtime_enable() before returning the error.

Since probe returns an error, srf04_remove() is never called, so
runtime PM is left enabled without a matching pm_runtime_disable().
This leaks the enable and triggers an "Unbalanced pm_runtime_enable!"
warning on a subsequent bind of the device.

Return the error right after unregistering the IIO device so that
runtime PM is not enabled on the failure path.

Fixes: 2251157b335b ("iio: srf04: add power management feature")
Cc: stable@vger.kernel.org
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/srf04.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/proximity/srf04.c
+++ b/drivers/iio/proximity/srf04.c
@@ -338,6 +338,7 @@ static int srf04_probe(struct platform_d
 		if (ret) {
 			dev_err(data->dev, "pm_runtime_set_active: %d\n", ret);
 			iio_device_unregister(indio_dev);
+			return ret;
 		}
 
 		pm_runtime_enable(data->dev);


