Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755DB2D879F;
	Wed, 28 Jan 2026 15:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614673; cv=none; b=K8BthXQ7MjNP1OgpBuc0IHoqHVs36PzNlqdEKbdtfkXbqhY/LbnNLd9hnxxxTiLErvTlc5cnueRXmJDnWWvq2HymsN0LuqqV0jcliv9gQecnvpYcMAvtoy9bG9BahyWHs4UOMZXOpgh35UFptCC8HlBgMBGQxPKOmIJAGggcBuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614673; c=relaxed/simple;
	bh=lZDjzN2JDVWVeLT0X7lVOuZXlrKRENW/ss384iJlD6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7FmBuAQJdG1MrbXiVJMKKqTuRrv2to+psqztugysZ/JgOlo0I6rQBcGd8YjagSkvMTKSuQxWBVFP2Bn7TTOaBHYpyIEnZ9mRIJSriQ+ObFiE9ZRSbQZMSG4YT9abadSBGNMKPorPvbYOKFDyR1cXBdXvJ3cUKROIinSEpE1zYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSsEumFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSsEumFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA13C4CEF1;
	Wed, 28 Jan 2026 15:37:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614673;
	bh=lZDjzN2JDVWVeLT0X7lVOuZXlrKRENW/ss384iJlD6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSsEumFTjBpm0JrPdznQH1F9mKP66bItMBiWV8kWZAFLsCX4mT/0E2Pu6I1AdNgY1
	 7anh8eb2jiBsXqkx6pC2SQsHF3penVGV43fLQ/218rLLM01WiadVHFI0aK0nXZJpzY
	 gadLPUTY3FW2rPmjMtx+DRxoxLxuXZ2ThRu7L2yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.6 206/254] intel_th: fix device leak on output open()
Date: Wed, 28 Jan 2026 16:23:02 +0100
Message-ID: <20260128145352.208168193@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 95fc36a234da24bbc5f476f8104a5a15f99ed3e3 upstream.

Make sure to drop the reference taken when looking up the th device
during output device open() on errors and on close().

Note that a recent commit fixed the leak in a couple of open() error
paths but not all of them, and the reference is still leaking on
successful open().

Fixes: 39f4034693b7 ("intel_th: Add driver infrastructure for Intel(R) Trace Hub devices")
Fixes: 6d5925b667e4 ("intel_th: Fix error handling in intel_th_output_open")
Cc: stable@vger.kernel.org	# 4.4: 6d5925b667e4
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ma Ke <make24@iscas.ac.cn>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251208153524.68637-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/core.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -810,9 +810,12 @@ static int intel_th_output_open(struct i
 	int err;
 
 	dev = bus_find_device_by_devt(&intel_th_bus, inode->i_rdev);
-	if (!dev || !dev->driver) {
+	if (!dev)
+		return -ENODEV;
+
+	if (!dev->driver) {
 		err = -ENODEV;
-		goto out_no_device;
+		goto out_put_device;
 	}
 
 	thdrv = to_intel_th_driver(dev->driver);
@@ -836,12 +839,22 @@ static int intel_th_output_open(struct i
 
 out_put_device:
 	put_device(dev);
-out_no_device:
+
 	return err;
 }
 
+static int intel_th_output_release(struct inode *inode, struct file *file)
+{
+	struct intel_th_device *thdev = file->private_data;
+
+	put_device(&thdev->dev);
+
+	return 0;
+}
+
 static const struct file_operations intel_th_output_fops = {
 	.open	= intel_th_output_open,
+	.release = intel_th_output_release,
 	.llseek	= noop_llseek,
 };
 


