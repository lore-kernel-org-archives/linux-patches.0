Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2516F3FE2D;
	Mon,  1 Apr 2024 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986889; cv=none; b=bWs6LgEIiG7BUX2jx4WZeY3sXZBODbnEA0BMwXZ/AIiV6sVqclPADnCbA/pVOOuzMZN0VJ01IgAEfNW3fbdGwSWI2FPTkdPBINLjX7dO5QuXztAElkb5I8Nfkd1nbl3fpdJyhb4K2xyUeVvTBWAtCGU8APkKXTmBXy71n0gIei0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986889; c=relaxed/simple;
	bh=Ihx+0iEp51lPBI6QD5T6vXL1jUYe5ApqJSzjNXkuTls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+dg0NseywYrMKiQtc4HaGjFmXElLw7LrrSMLiKw82kAQ/ZcyLAg8sJwI4GVFXKOa8vd9iWG4h4RAoQOwlRr7rSNjH1KiOF4S+BsH0qMOIhaN6GhrjEg5bxBPpAkYR9v37QY6hcDcD2S3+z+DKpznUl/2bj8t3jch5TU9YcAhL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzuEnhSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzuEnhSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2059C433F1;
	Mon,  1 Apr 2024 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986889;
	bh=Ihx+0iEp51lPBI6QD5T6vXL1jUYe5ApqJSzjNXkuTls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzuEnhSJ5k7fNGkxgnxGwMe/rZqjuXgekb4eTfVDO3+d8kpGEbPEt2u5OmoWTIUbw
	 xAPGCj08Bpp9ha4kLtr09xzxe1R5MvxAUXfT36eDU+8E12H3euy7EGnIdpAuhGv4In
	 GEQh3ECIUxWbClTGA1qROI8y2okzzo9Csn2JreJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Ricky Wu <ricky_wu@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 100/399] PCI/PM: Drain runtime-idle callbacks before driver removal
Date: Mon,  1 Apr 2024 17:41:06 +0200
Message-ID: <20240401152552.171158903@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 9d5286d4e7f68beab450deddbb6a32edd5ecf4bf ]

A race condition between the .runtime_idle() callback and the .remove()
callback in the rtsx_pcr PCI driver leads to a kernel crash due to an
unhandled page fault [1].

The problem is that rtsx_pci_runtime_idle() is not expected to be running
after pm_runtime_get_sync() has been called, but the latter doesn't really
guarantee that.  It only guarantees that the suspend and resume callbacks
will not be running when it returns.

However, if a .runtime_idle() callback is already running when
pm_runtime_get_sync() is called, the latter will notice that the runtime PM
status of the device is RPM_ACTIVE and it will return right away without
waiting for the former to complete.  In fact, it cannot wait for
.runtime_idle() to complete because it may be called from that callback (it
arguably does not make much sense to do that, but it is not strictly
prohibited).

Thus in general, whoever is providing a .runtime_idle() callback needs
to protect it from running in parallel with whatever code runs after
pm_runtime_get_sync().  [Note that .runtime_idle() will not start after
pm_runtime_get_sync() has returned, but it may continue running then if it
has started earlier.]

One way to address that race condition is to call pm_runtime_barrier()
after pm_runtime_get_sync() (not before it, because a nonzero value of the
runtime PM usage counter is necessary to prevent runtime PM callbacks from
being invoked) to wait for the .runtime_idle() callback to complete should
it be running at that point.  A suitable place for doing that is in
pci_device_remove() which calls pm_runtime_get_sync() before removing the
driver, so it may as well call pm_runtime_barrier() subsequently, which
will prevent the race in question from occurring, not just in the rtsx_pcr
driver, but in any PCI drivers providing .runtime_idle() callbacks.

Link: https://lore.kernel.org/lkml/20240229062201.49500-1-kai.heng.feng@canonical.com/ # [1]
Link: https://lore.kernel.org/r/5761426.DvuYhMxLoT@kreacher
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Ricky Wu <ricky_wu@realtek.com>
Acked-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pci-driver.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 51ec9e7e784f0..9c59bf03d6579 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -473,6 +473,13 @@ static void pci_device_remove(struct device *dev)
 
 	if (drv->remove) {
 		pm_runtime_get_sync(dev);
+		/*
+		 * If the driver provides a .runtime_idle() callback and it has
+		 * started to run already, it may continue to run in parallel
+		 * with the code below, so wait until all of the runtime PM
+		 * activity has completed.
+		 */
+		pm_runtime_barrier(dev);
 		drv->remove(pci_dev);
 		pm_runtime_put_noidle(dev);
 	}
-- 
2.43.0



