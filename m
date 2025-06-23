Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BFD221739;
	Mon, 23 Jun 2025 21:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712913; cv=none; b=DZSa4e7zH1OuWOfy301dswFOVAdHFxkQFoPsAXMPBm+9aD3YfmhAJtHi/rLkITEzc5QeJSEE2y9NIrvnj4oJLVimQO2fQmQzQWp75GuqOFnwszfgzR8nrt2MYRzkE5SQAuK+8uNfgTvJWd6EbsTMkP5yPXInRGtoqzGlM0zWOrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712913; c=relaxed/simple;
	bh=CdzNXrb5z5zpnSl5McGntsBiw/j+J6JJfQyhQ7GiJTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jbTtT89b2HYJ3dvsdehOqjma0PyITcYrBEDJ340viev/7f/Tk31ZYYxYQO4eG3JPnLJEcLWcBDSTnE2LB/rzmlwJjzJBkvA1IOoEHzw2sd3TerKpKlR+jsTU+7XYjDgB+8Zts7lQu2l6pvEVR1lSdGvweL8gim1uqLy/mWCMbag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwKqTOqi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwKqTOqi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBB1C4CEEA;
	Mon, 23 Jun 2025 21:08:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712913;
	bh=CdzNXrb5z5zpnSl5McGntsBiw/j+J6JJfQyhQ7GiJTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwKqTOqipbSGxA39v5r+3fScW94wVCOQ48XkAQziUU27dqEnQuNVwOZK/u3+RC34v
	 AaMpwgx1u+WY85gQMjh1rytI2spPW/7Hznf3KMEWN3dU2259+0Sb/ipQ60o6W0Y1qf
	 rCzqYDxd06Ncw0vfbwP+e1NaNLJk1+U7oUyW3P7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 018/414] s390/pci: Serialize device addition and removal
Date: Mon, 23 Jun 2025 15:02:35 +0200
Message-ID: <20250623130642.481586483@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

commit 774a1fa880bc949d88b5ddec9494a13be733dfa8 upstream.

Prior changes ensured that when zpci_release_device() is called and it
removed the zdev from the zpci_list this instance can not be found via
the zpci_list anymore even while allowing re-add of reserved devices.
This only accounts for the overall lifetime and zpci_list addition and
removal, it does not yet prevent concurrent add of a new instance for
the same underlying device. Such concurrent add would subsequently cause
issues such as attempted re-use of the same IOMMU sysfs directory and is
generally undesired.

Introduce a new zpci_add_remove_lock mutex to serialize adding a new
device with removal. Together this ensures that if a struct zpci_dev is
not found in the zpci_list it was either already removed and torn down,
or its removal and tear down is in progress with the
zpci_add_remove_lock held.

Cc: stable@vger.kernel.org
Fixes: a46044a92add ("s390/pci: fix zpci_zdev_put() on reserve")
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Tested-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/pci/pci.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -44,6 +44,7 @@
 /* list of all detected zpci devices */
 static LIST_HEAD(zpci_list);
 static DEFINE_SPINLOCK(zpci_list_lock);
+static DEFINE_MUTEX(zpci_add_remove_lock);
 
 static DECLARE_BITMAP(zpci_domain, ZPCI_DOMAIN_BITMAP_SIZE);
 static DEFINE_SPINLOCK(zpci_domain_lock);
@@ -73,7 +74,9 @@ void zpci_zdev_put(struct zpci_dev *zdev
 {
 	if (!zdev)
 		return;
+	mutex_lock(&zpci_add_remove_lock);
 	kref_put_lock(&zdev->kref, zpci_release_device, &zpci_list_lock);
+	mutex_unlock(&zpci_add_remove_lock);
 }
 
 struct zpci_dev *get_zdev_by_fid(u32 fid)
@@ -838,6 +841,7 @@ int zpci_add_device(struct zpci_dev *zde
 {
 	int rc;
 
+	mutex_lock(&zpci_add_remove_lock);
 	zpci_dbg(1, "add fid:%x, fh:%x, c:%d\n", zdev->fid, zdev->fh, zdev->state);
 	rc = zpci_init_iommu(zdev);
 	if (rc)
@@ -851,12 +855,14 @@ int zpci_add_device(struct zpci_dev *zde
 	spin_lock(&zpci_list_lock);
 	list_add_tail(&zdev->entry, &zpci_list);
 	spin_unlock(&zpci_list_lock);
+	mutex_unlock(&zpci_add_remove_lock);
 	return 0;
 
 error_destroy_iommu:
 	zpci_destroy_iommu(zdev);
 error:
 	zpci_dbg(0, "add fid:%x, rc:%d\n", zdev->fid, rc);
+	mutex_unlock(&zpci_add_remove_lock);
 	return rc;
 }
 
@@ -947,6 +953,7 @@ void zpci_release_device(struct kref *kr
 {
 	struct zpci_dev *zdev = container_of(kref, struct zpci_dev, kref);
 
+	lockdep_assert_held(&zpci_add_remove_lock);
 	WARN_ON(zdev->state != ZPCI_FN_STATE_RESERVED);
 	/*
 	 * We already hold zpci_list_lock thanks to kref_put_lock().


