Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C398B421A1E;
	Wed,  4 Feb 2026 15:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217963; cv=none; b=W7fEFEQin9/bPbAQ8pvve03A3UPkLlcIQ/0qQxt3jRzYUhgWyr9/25fGaMA2kCfAQIFfUjZAByGVem2XDjTOQp7298jZ81Ukr1B0jdY/EfqE0urQFKRsGmPh1l8D2w+naBR8wG6O20Yp9NI6OeAX2lG6lLwc5jW1rXx2IQ7YO3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217963; c=relaxed/simple;
	bh=dwDOluOPZTbvkshn0yxunMWc4Fb37gvnVbEiWFZUxrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlPAiy9iSntTk0m6w4fApUc+r4WM4v8IfV+fcVtMb2LC3qqFzlROFG/ebmEDE9nhPacOsw2z3NVieaMckKCjY3kf19Jdd72/7g28MeRZ4K6FqS+OGRxMxJLeYRjxKb03POyzErSYC8iwL/EAXbk95sCZOwYDv3zJB79RqETPV8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NF9jUmiB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NF9jUmiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1FBC4CEF7;
	Wed,  4 Feb 2026 15:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217963;
	bh=dwDOluOPZTbvkshn0yxunMWc4Fb37gvnVbEiWFZUxrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NF9jUmiB6uPScnlqKPEt5UdwozxqR8VBj5mSfKMoN8gFoJY+0o7nwMbBj19F/CAxW
	 uIrUABEuLpdZh2DlDfoMd7faAL/8Nen7NpL7bwrFWKhsnH2vWKnpJHVPzmLK9l+pK2
	 4KwFnYDapCHtqmblEqiiCtzYlwXhSAUaxOPl0HXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ma Ke <make24@iscas.ac.cn>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.1 172/280] intel_th: fix device leak on output open()
Date: Wed,  4 Feb 2026 15:39:06 +0100
Message-ID: <20260204143915.810855198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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
 


