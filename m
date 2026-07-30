Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD448421EF8;
	Thu, 30 Jul 2026 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422880; cv=none; b=ELi1/r0bWcV3Bx9PZ4aacrGbrR3PvD6NkVnAVxFw+oTUxZSRABbcVDUMmQ2wkiPz+esbY+DI/k3S1Er1n3Sa2l8pG/TlIq/cgveDZjs1BA/9I4u8ks+UumRWyGfB7umkdsLO9uCZHIF+F1MmDParg6Be7WpMS3o85eyHT4ZQsj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422880; c=relaxed/simple;
	bh=F/Tw0otRv4TybJ1Edrvg3U1c3GCYLEexj7EhyiQXxFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vb2HPQxMRG9Ju/PFS3UC/091ANhm6kKd+xv5l7lR0oqChR1yU/oQYOrXHJ7/+3fC8kUe30lI44PopKA/BLDWg1bUNWwY/mGW0uR70yQ7i3Per38FL97GjzC9H1DS6qOum7boAEIr0hl0/Q1YtbpZtsPQDJdPLM13KujgfwVm9Lo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uVU/0pxn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uVU/0pxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC4E1F000E9;
	Thu, 30 Jul 2026 14:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422878;
	bh=45U7JPm7cmUO78v6bn7cwBGZ80ZSGzA3ItILe2iq5BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVU/0pxnKQzcBHOWXm5PhYHtZfl5PS+TkdvWxHsHCTOYOZxoOlyMZz/4xTaAGa3gZ
	 QjgprTERt1d1ZSktcdntLobDeYup2gjtxcCagzEi/WBBi012/sloCGxTDw1r2p+In+
	 gxX9haxcPrwiIgVZWrcP1niC+QxjJYdckrup+eFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 7.1 587/744] intel_th: fix MSC output device reference leak
Date: Thu, 30 Jul 2026 16:14:20 +0200
Message-ID: <20260730141456.759988843@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -843,18 +843,8 @@ err_put_dev:
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


