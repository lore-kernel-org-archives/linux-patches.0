Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B2B3769F5;
	Thu, 30 Jul 2026 15:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424707; cv=none; b=tDXy9W93XaYyTXXlcn29tnhu09blVLTrs3mtMwhSWtD5dZWUH0wCzwYArZvaV1pG+LWvIU36IzzOd6sGYLYznW9qBsO9i8ubHDrIkqpmlqTMoonGSOtU5CBSdgE/vP+NpHTrZOakKMPC2eCft76lyddJ6dM/0wc6/h9lzXdejOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424707; c=relaxed/simple;
	bh=ItL/hFqOoZz+B713KVBO8KhIiiyI7KsbxyO1wtSgwWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5+8HsCUCe9l9746oQwVkCZ351fXCw/OT6Gpyt+p8K/l4XmkY2WrQEXqx4e0lUjtFdZK8MjY3KuCSMdPbLHti6r2dLXJG1e55udgl4H1Gv0pNWryEx0pHWNis0HdFkfZv0OxwhEQ85O0oigJ0AvlurQe8MXKUzvcgI8HQJXab94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WEb5jCWx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WEb5jCWx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B8E1F000E9;
	Thu, 30 Jul 2026 15:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424706;
	bh=AUXoYG/iSrPLZRV/rKs82FSp9bhWdIbaCO3kP0lafSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEb5jCWxylDnOwwfym7UUiZKvsjTI91xD28QN66gjVRZZr6YxgrGL0prwGHXS4NCe
	 dwnzp3rE8ubFJW7sKVmnBfQYXBR5iM7rFrQXj/aMw3elHUEt12qL9o6SZet3Y1ETGr
	 W/HVYCKW8RMldw93QjbNrwYQBeFqB//rzz2Q5o1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 6.18 487/675] intel_th: fix MSC output device reference leak
Date: Thu, 30 Jul 2026 16:13:37 +0200
Message-ID: <20260730141455.471559202@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1490,8 +1490,10 @@ static int intel_th_msc_release(struct i
 {
 	struct msc_iter *iter = file->private_data;
 	struct msc *msc = iter->msc;
+	struct intel_th_device *thdev = msc->thdev;
 
 	msc_iter_remove(iter, msc);
+	put_device(&thdev->dev);
 
 	return 0;
 }


