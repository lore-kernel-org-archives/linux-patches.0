Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6B4136988;
	Mon, 23 Jun 2025 13:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684371; cv=none; b=lV5pXzqgxm5zcBoltD7Gl19hyP9nTLXVTInNVO4x9RJ/gF0ZBugkE8dkRthcKwyB+gsYksHI/8uBd9dlfcseNLR4KsWzmkzYhTjpEuZr68QoLwqY7haV6fXPhFIY+82fZgAwB+5yvDEt7GahHEX8v2e5QyZf6f503O/gerQcygE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684371; c=relaxed/simple;
	bh=QiRImQFxKOM+m+qc6y+lwNhtiOi/JixJW7Ndrq0eNSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZB8tBb9zBiCy5ln/SIlgRv8Fg9v1WxU7gzK/pRaLC2gihV/OvzZwckdZ+Z+q67WXojjo5/6iclHSjuJgeWLCsSnI4c6U3VsUpeh7TogcTCxDVBHgkclSfRZRvL6NCDNTkJ7EgL4zX5fZP3RE/9tlfYTxSUqOli22DPC5PCoD5ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A7SZK2qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A7SZK2qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1F2C4CEF0;
	Mon, 23 Jun 2025 13:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684371;
	bh=QiRImQFxKOM+m+qc6y+lwNhtiOi/JixJW7Ndrq0eNSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A7SZK2qyX5/YHu5SGaT/miNXaJB4fYXXnj6ZRD6wMIYjtG54N3R/stIRgSkHGLZ/j
	 vLw5tckzqDhYSlHq4K62ueCETuRg/xsrjYhXVBlibYApqBts3rP8PiDtOofSLhyD/w
	 /UYIwuwbhsc3/Gqdg2daXwr4sEuQD0j9oFJLBKg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.15 026/592] s390/pci: Serialize device addition and removal
Date: Mon, 23 Jun 2025 14:59:44 +0200
Message-ID: <20250623130700.856601086@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -45,6 +45,7 @@
 /* list of all detected zpci devices */
 static LIST_HEAD(zpci_list);
 static DEFINE_SPINLOCK(zpci_list_lock);
+static DEFINE_MUTEX(zpci_add_remove_lock);
 
 static DECLARE_BITMAP(zpci_domain, ZPCI_DOMAIN_BITMAP_SIZE);
 static DEFINE_SPINLOCK(zpci_domain_lock);
@@ -74,7 +75,9 @@ void zpci_zdev_put(struct zpci_dev *zdev
 {
 	if (!zdev)
 		return;
+	mutex_lock(&zpci_add_remove_lock);
 	kref_put_lock(&zdev->kref, zpci_release_device, &zpci_list_lock);
+	mutex_unlock(&zpci_add_remove_lock);
 }
 
 struct zpci_dev *get_zdev_by_fid(u32 fid)
@@ -844,6 +847,7 @@ int zpci_add_device(struct zpci_dev *zde
 {
 	int rc;
 
+	mutex_lock(&zpci_add_remove_lock);
 	zpci_dbg(1, "add fid:%x, fh:%x, c:%d\n", zdev->fid, zdev->fh, zdev->state);
 	rc = zpci_init_iommu(zdev);
 	if (rc)
@@ -857,12 +861,14 @@ int zpci_add_device(struct zpci_dev *zde
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
 
@@ -953,6 +959,7 @@ void zpci_release_device(struct kref *kr
 {
 	struct zpci_dev *zdev = container_of(kref, struct zpci_dev, kref);
 
+	lockdep_assert_held(&zpci_add_remove_lock);
 	WARN_ON(zdev->state != ZPCI_FN_STATE_RESERVED);
 	/*
 	 * We already hold zpci_list_lock thanks to kref_put_lock().


