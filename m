Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC9D417BF8;
	Fri,  4 Sep 2026 05:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499531; cv=none; b=iyAHXyY55hE+Tp3RwAh5d7DMhSg8vOpU92NqzCsfDrQY3gAd95uTUQhUrw2Fhb0iDumu101NKj7wd1cG9+Kz/HW+w/O5Ph4/lEbakloyfbNBxcCtYF/p6sGv9zgMwQdykyOoJS2Lmt1dz3deVuHCsSRCX1JMJnT3sksMQsNscP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499531; c=relaxed/simple;
	bh=ZKqOSeHRS3jqrV8tJbvg32c5LeZDHGF55WqiG6pjvqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYVM5Q7+nRSky0dQPLYzvCYGXnu+35SDHRChfXb/QVgF+qSWiw7+sj3GVi4bZolEE/QBOVwGPeHgP3h72ut3eTC0GCe+W+nj6FH5DB8ozPRpNJmJZI98swBipG++IJMmRogsxHx4Kkv5hpMXQFpyWABBdKmzPNGgnPzsF/Phow8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cu7tAMP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cu7tAMP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168AB1F00A3D;
	Fri,  4 Sep 2026 05:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499530;
	bh=vD66oj4uFnO4QFt5yeJf3VwxkJp/cRMV2SeB0+vl5c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cu7tAMP3QHGZJyoQy/rlD6ONKrWRTIEjsfjRimWVB72MWsmqkpWxlKijZKrJbMyH/
	 C9ZAWiJ8Sen7QvAfqTb/WzziZdraAv3LBCqlzK1BNxWDii5sWfyNhiN/XgAToiJZU8
	 fn33ykp3T0VfWHpxFSwtyi7EEWOF39RKKZ1dwWKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 7.2 406/713] media: staging/ipu7: fix async notifier UAF on probe error path
Date: Fri,  4 Sep 2026 06:56:14 +0200
Message-ID: <20260904045812.922748046@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit d7f48aa7d60c65d3e6d5312c27f17d5525a245fb upstream.

isys_register_devices() registers the V4L2 async notifier via
isys_notifier_init(). If a subsequent probe step such as
isys_fw_log_init() fails, isys_probe() jumps to the out_cleanup label
which only calls isys_unregister_devices(). That helper tears down the
video devices, subdevices, V4L2 device and media device, but never
unregisters or cleans up the async notifier.

As a result the notifier stays chained in the global notifier_list while
the enclosing struct ipu7_isys is freed by devres, leading to list
corruption and a use-after-free the next time the list is walked.

The remove path already does the right thing by calling
isys_notifier_cleanup() before isys_unregister_devices(). Mirror that on
the probe error path so the notifier is unregistered and cleaned up
before the device is torn down.

Fixes: a516d36bdc3d ("media: staging/ipu7: add IPU7 input system device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/ipu7/ipu7-isys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/media/ipu7/ipu7-isys.c
+++ b/drivers/staging/media/ipu7/ipu7-isys.c
@@ -773,6 +773,7 @@ static int isys_probe(struct auxiliary_d
 	return 0;
 
 out_cleanup:
+	isys_notifier_cleanup(isys);
 	isys_unregister_devices(isys);
 out_cleanup_fw:
 	ipu7_fw_isys_release(isys);


