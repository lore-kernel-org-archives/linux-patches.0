Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 290103B71A7;
	Sat, 17 Oct 2026 18:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260307; cv=none; b=XcRKtjrh4k+TIa+PvOpvSvsW77TnzUNTuhDD9kgFgtMTvq9cpIWC9D0yrx8bTm04mLh9IrtZfh4/XX++8iVtzNiWFoAladAcmdV1r7KYSmfZpi6PAydGopxmx2Ub3f1xPb3pwyW+nLovijGdaAnDPmdVGf7IAVH4G1VwIYiWSq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260307; c=relaxed/simple;
	bh=er96CcQqFsaGeCNVd+1JudlmPZg+hyls/bVi2w4PZ28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfngyfH9LZg8gB1wtMFZIrfaZGwvVu6xY0x/AZA1PsS72M/wcqRZyFnWmHP81uZhKXVbjpeQVy8hql/MEog2DQW0mH+pR4ZEso9SEL66/rTep0/kZbQik1+tfXS8RE8Lj9PVQ8VJaqdGuYXtYa00vHfkvWi0+teA9YmDSyvBg/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sjKlmWtI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sjKlmWtI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4061F000C4;
	Sat, 17 Oct 2026 18:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260305;
	bh=1VQUt2zqIowuFu9gRoU72k1QqhIGiudILI7pW6xwcPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjKlmWtIg/6AZZFNNlZ/g+2AbwSgG9j8SJS0Voyn+pQ1alIuqOf7Djxx4ER8W73jF
	 Fdu9nNlCWlieYDoYq/RmyGc+5TbaOKyTDv4IUlRNWKVEnjxivoEF4yMGZhjhidzfbY
	 K/tso2yVIPeHirjCQ7tz9/z8pEb+yLWJtrDF6lCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1460/1674] PCI: Initialize temporary device in new_id_store()
Date: Sat, 17 Oct 2026 18:02:12 +0200
Message-ID: <20261017160508.644295231@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Samiullah Khawaja <skhawaja@google.com>

[ Upstream commit f45a49a2380a47332817b7248c61a0ebbc6f0d00 ]

When setting new_id of a PCI device driver using sysfs a lockdep splat
occurs. This is because new_id_store() builds a temporary pci_dev for
pci_match_device(), which calls device_match_driver_override().  That
depends on the driver_override.lock added by cb3d1049f4ea ("driver core:
generalize driver_override in struct device").

The new driver_override.lock was not initialized in the temporary pci_dev,
resulting in this lockdep splat.

Initialize the temporary pci_dev to fix this.

Repro:

  Build with CONFIG_LOCKDEP=y, boot with QEMU, and add a new ID:

  # echo "8086 10f5" > /sys/bus/pci/drivers/e1000e/new_id

  INFO: trying to register non-static key.
  The code is fine but needs lockdep annotation, or maybe
  you didn't initialize this object before use?
  turning off the locking correctness validator.
  CPU: 2 UID: 0 PID: 177 Comm: liveupdate-iomm Not tainted 7.0.0+ #9 PREEMPT(full)
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
  Call Trace:
   <TASK>
   dump_stack_lvl+0x5d/0x80
   register_lock_class+0x77e/0x790
   lock_acquire+0xbf/0x2e0
   pci_match_device+0x24/0x180
   new_id_store+0x189/0x1d0
   kernfs_fop_write_iter+0x14f/0x210
   vfs_write+0x263/0x5e0
   ksys_write+0x79/0xf0
   do_syscall_64+0x117/0xf80

Fixes: 10a4206a2401 ("PCI: use generic driver_override infrastructure")
Fixes: 8895d3bcb8ba ("PCI: Fail new_id for vendor/device values already built into driver")
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
[bhelgaas: add commit log details and repro, trim backtrace]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20260505234327.716630-1-skhawaja@google.com
Stable-dep-of: 3ffc4c9690c3 ("PCI: Fix UAF when probe runs concurrent to dyn ID removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 9b4a8bc416453..7672cd5966cc9 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -179,6 +179,11 @@ static const struct pci_device_id *pci_match_device(struct pci_driver *drv,
 	return NULL;
 }
 
+static void _pci_free_device(struct device *dev)
+{
+	kfree(to_pci_dev(dev));
+}
+
 /**
  * new_id_store - sysfs frontend to pci_add_dynid()
  * @driver: target device driver
@@ -214,11 +219,13 @@ static ssize_t new_id_store(struct device_driver *driver, const char *buf,
 		pdev->subsystem_vendor = subvendor;
 		pdev->subsystem_device = subdevice;
 		pdev->class = class;
+		pdev->dev.release = _pci_free_device;
 
+		device_initialize(&pdev->dev);
 		if (pci_match_device(pdrv, pdev))
 			retval = -EEXIST;
 
-		kfree(pdev);
+		put_device(&pdev->dev);
 
 		if (retval)
 			return retval;
-- 
2.53.0



