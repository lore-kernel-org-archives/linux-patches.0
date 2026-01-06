Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66C3C355808;
	Tue,  6 Jan 2026 18:00:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722412; cv=none; b=XGrQwyWJuCKcm2xAPfnwLy26FooU2ALho2niuyEjjDKdhXqMKpnlo8M1qV1S/4UWCu0bFnFjns98CyI2xg5oX2sBlTy0dqwiTIEt1rg6hPrrAsoCyIAu64kT8ZEIKczHrmL4+6EbGfE+FMvh1lKkBdlIhcOu8JCZ7KMOnk+TGi0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722412; c=relaxed/simple;
	bh=yCoA5Plbh6dN32fULhNFX6sKpbyIECbwOAM+nTPoUP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kfyd8gKMGK5EpkFA7ZF2koLL/p6nY9G9lWs81CAtIK+wapY1ib1+d3wZRIM1EsYEBkgkgrjzrnpI21phTZab72SBJBBCsyqfAQnoswfwpG+ZTK8sMduz0Oz1IYKBVmOQB671zqDuW1Nz+gOsW8SY5Sb8IL9UIVfZ03gd0loUPpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ti6la8bu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ti6la8bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FB55C116C6;
	Tue,  6 Jan 2026 18:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722412;
	bh=yCoA5Plbh6dN32fULhNFX6sKpbyIECbwOAM+nTPoUP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ti6la8bughr/DzlzbAXztLkDRZ1BIds12IvYvVehA0BSP9VreD06W+741sXgmXu/I
	 zAF/WSfvgSnAVUS+kUQaTxVHIor+YS9fzsooGfIUNeXOcPVbjI9YlETX7YAp4lwBjp
	 6U+3slZ4LJEK5cLLgHnr/qlBaYlJFAXKhM1YDsa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4ef89409a235d804c6c2@syzkaller.appspotmail.com,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 256/312] net: nfc: fix deadlock between nfc_unregister_device and rfkill_fop_write
Date: Tue,  6 Jan 2026 18:05:30 +0100
Message-ID: <20260106170557.109326993@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 1ab526d97a57e44d26fadcc0e9adeb9c0c0182f5 upstream.

A deadlock can occur between nfc_unregister_device() and rfkill_fop_write()
due to lock ordering inversion between device_lock and rfkill_global_mutex.

The problematic lock order is:

Thread A (rfkill_fop_write):
  rfkill_fop_write()
    mutex_lock(&rfkill_global_mutex)
      rfkill_set_block()
        nfc_rfkill_set_block()
          nfc_dev_down()
            device_lock(&dev->dev)    <- waits for device_lock

Thread B (nfc_unregister_device):
  nfc_unregister_device()
    device_lock(&dev->dev)
      rfkill_unregister()
        mutex_lock(&rfkill_global_mutex)  <- waits for rfkill_global_mutex

This creates a classic ABBA deadlock scenario.

Fix this by moving rfkill_unregister() and rfkill_destroy() outside the
device_lock critical section. Store the rfkill pointer in a local variable
before releasing the lock, then call rfkill_unregister() after releasing
device_lock.

This change is safe because rfkill_fop_write() holds rfkill_global_mutex
while calling the rfkill callbacks, and rfkill_unregister() also acquires
rfkill_global_mutex before cleanup. Therefore, rfkill_unregister() will
wait for any ongoing callback to complete before proceeding, and
device_del() is only called after rfkill_unregister() returns, preventing
any use-after-free.

The similar lock ordering in nfc_register_device() (device_lock ->
rfkill_global_mutex via rfkill_register) is safe because during
registration the device is not yet in rfkill_list, so no concurrent
rfkill operations can occur on this device.

Fixes: 3e3b5dfcd16a ("NFC: reorder the logic in nfc_{un,}register_device")
Cc: stable@vger.kernel.org
Reported-by: syzbot+4ef89409a235d804c6c2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=4ef89409a235d804c6c2
Link: https://lore.kernel.org/all/20251217054908.178907-1-kartikey406@gmail.com/T/ [v1]
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20251218012355.279940-1-kartikey406@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -1154,6 +1154,7 @@ EXPORT_SYMBOL(nfc_register_device);
 void nfc_unregister_device(struct nfc_dev *dev)
 {
 	int rc;
+	struct rfkill *rfk = NULL;
 
 	pr_debug("dev_name=%s\n", dev_name(&dev->dev));
 
@@ -1164,13 +1165,17 @@ void nfc_unregister_device(struct nfc_de
 
 	device_lock(&dev->dev);
 	if (dev->rfkill) {
-		rfkill_unregister(dev->rfkill);
-		rfkill_destroy(dev->rfkill);
+		rfk = dev->rfkill;
 		dev->rfkill = NULL;
 	}
 	dev->shutting_down = true;
 	device_unlock(&dev->dev);
 
+	if (rfk) {
+		rfkill_unregister(rfk);
+		rfkill_destroy(rfk);
+	}
+
 	if (dev->ops->check_presence) {
 		timer_delete_sync(&dev->check_pres_timer);
 		cancel_work_sync(&dev->check_pres_work);


