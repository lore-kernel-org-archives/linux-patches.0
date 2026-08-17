Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5159421259;
	Mon, 17 Aug 2026 14:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977149; cv=none; b=oe9VulmZiLRfs7g2xRt0CIRTp54beCcN4hn6TZJ5aHvCXgMEP/yaQQHRtwUQOELELH9akZrp+QLawEvQ7T6RFawhTpfcpv5ohNJMIhgxqgpPtV5LCyBdzIqAUQ45bGmJ5Yy2Vab7e7O5SADztyjLR1X00ylQrWXS3DTQRsGkkZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977149; c=relaxed/simple;
	bh=Mn+nMsqzhIEa4LR3N8+9Cl/rENxueiqYDVBr1lDKhGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4ynRMXghcYcW2y18QNXgNJWsrYjByQSYvaoMWWZvXjsi5A2ngs+q3sU2l2+R4XBU0VODiOg79QW4SMx1PTweqlRSebD5M3aIhiTu7V8KrO+VwOKAGBk9IuH1GxfAb7esVlMmuNluKGJlGzsABJqKV3wkncpnY9CM//I3dEq5QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o4LgnLlr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o4LgnLlr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CB21F00A3A;
	Mon, 17 Aug 2026 14:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977148;
	bh=LFhQdHyS7dbnr+v0HldKaJBIVwSqeSwu/DPMRcUTlm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o4LgnLlr5lM7sUTEWmplLRKFeTt8XWOJKzbZcH9kY7Hl8QuXtucKH7mooEOUCMyje
	 ynL14dUewVg10JLb3ZGyCkA6eQ0fcQx89tOViX5TqarbiDHtJ1AmlrcroImk5aj15z
	 eaNkY29u1rNg0I/7bMGO0kGvn47X7J8H6trxFrmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.15 190/456] intel_th: fix MSC output device reference leak
Date: Mon, 17 Aug 2026 15:29:40 +0200
Message-ID: <20260817132547.551822262@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 761b785a0cfbce43761227bc42a7f984f31f8921 upstream.

intel_th_output_open() looks up the output device with
bus_find_device_by_devt(), which returns the device with a reference that
must be dropped after use.

commit 95fc36a234da ("intel_th: fix device leak on output open()")
attempted to drop the reference from intel_th_output_release(). However,
a successful open replaces file->f_op with the output driver file
operations before returning, so close runs the output driver release
callback instead.

For MSC outputs, close runs intel_th_msc_release(), which only removes
the per-file iterator and does not drop the device reference taken by
intel_th_output_open(). Consequently, every successful MSC output open
leaks one device reference.

Drop the device reference from intel_th_msc_release(), which is the
release path actually used for MSC output files. Remove the now-unused
intel_th_output_release() callback from intel_th_output_fops.

Fixes: 95fc36a234da ("intel_th: fix device leak on output open()")
Cc: stable <stable@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260715070851.2077965-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/intel_th/core.c |   10 ----------
 drivers/hwtracing/intel_th/msu.c  |    2 ++
 2 files changed, 2 insertions(+), 10 deletions(-)

--- a/drivers/hwtracing/intel_th/core.c
+++ b/drivers/hwtracing/intel_th/core.c
@@ -843,18 +843,8 @@ out_put_device:
 	return err;
 }
 
-static int intel_th_output_release(struct inode *inode, struct file *file)
-{
-	struct intel_th_device *thdev = file->private_data;
-
-	put_device(&thdev->dev);
-
-	return 0;
-}
-
 static const struct file_operations intel_th_output_fops = {
 	.open	= intel_th_output_open,
-	.release = intel_th_output_release,
 	.llseek	= noop_llseek,
 };
 
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -1479,8 +1479,10 @@ static int intel_th_msc_release(struct i
 {
 	struct msc_iter *iter = file->private_data;
 	struct msc *msc = iter->msc;
+	struct intel_th_device *thdev = msc->thdev;
 
 	msc_iter_remove(iter, msc);
+	put_device(&thdev->dev);
 
 	return 0;
 }


