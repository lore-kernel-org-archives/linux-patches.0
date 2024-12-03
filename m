Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1CE1EE001;
	Tue,  3 Dec 2024 15:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239468; cv=none; b=QLn9kA1JsVofXuHKzpcqXnYGoqIXhgHIuK7prTunFfBjmAk+HKD21EHsfsRs3jZqZ6QzoiDk0J/DEXsAixmFZoBxcFh5yBWtaI6sSaI9KV9pc5JkjjBi40dFAPs2GnjV2HRmsnZVkr5LMRvpd9O9wGvtSK+9fVWyMeMZ79Fy268=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239468; c=relaxed/simple;
	bh=L4txhazBCD/sbpctuQ1DjYAJBFd/5zR6qDPDzE8UANM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXAckZ16R9MHnvdthQLrFSlarqZiXnGd1qmQ83BjEI/rJWke1ZRqByWIsj5jYdYvXWtsS571D7xO467r9ijNuZy2yy6iFoe7HArqGx+MElU6tg3yQbycT6HJ6BVH4jl5J8Ymk6FbHGI0N/sr5LGCRZOkde3uFPhx8MoV3l9YHt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8W/1KOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8W/1KOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52969C4CECF;
	Tue,  3 Dec 2024 15:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239468;
	bh=L4txhazBCD/sbpctuQ1DjYAJBFd/5zR6qDPDzE8UANM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t8W/1KOmLdHMrUiyWkTpOkQUbUkl1DEgYiuYy7ku5OJ0YMFNE1/uQ2t0xoeibF0JZ
	 zldkbRl6K+q9BsxOyhhlshVIQCu4MbQTFd1odfKWbJIwYWuJzcw5I5bfSxC4rXiviJ
	 PmzV9OYCVBhegFAfIh636SN76T1FFVO5QiusFmVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 625/817] s390/pci: Fix potential double remove of hotplug slot
Date: Tue,  3 Dec 2024 15:43:17 +0100
Message-ID: <20241203144020.332902806@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit c4a585e952ca403a370586d3f16e8331a7564901 ]

In commit 6ee600bfbe0f ("s390/pci: remove hotplug slot when releasing the
device") the zpci_exit_slot() was moved from zpci_device_reserved() to
zpci_release_device() with the intention of keeping the hotplug slot
around until the device is actually removed.

Now zpci_release_device() is only called once all references are
dropped. Since the zPCI subsystem only drops its reference once the
device is in the reserved state it follows that zpci_release_device()
must only deal with devices in the reserved state. Despite that it
contains code to tear down from both configured and standby state. For
the standby case this already includes the removal of the hotplug slot
so would cause a double removal if a device was ever removed in
either configured or standby state.

Instead of causing a potential double removal in a case that should
never happen explicitly WARN_ON() if a device in non-reserved state is
released and get rid of the dead code cases.

Fixes: 6ee600bfbe0f ("s390/pci: remove hotplug slot when releasing the device")
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Reviewed-by: Gerd Bayer <gbayer@linux.ibm.com>
Tested-by: Gerd Bayer <gbayer@linux.ibm.com>
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/pci/pci.c | 34 +++++++++-------------------------
 1 file changed, 9 insertions(+), 25 deletions(-)

diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 759983d0e63ed..827b4c7b4688c 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -918,10 +918,8 @@ void zpci_device_reserved(struct zpci_dev *zdev)
 void zpci_release_device(struct kref *kref)
 {
 	struct zpci_dev *zdev = container_of(kref, struct zpci_dev, kref);
-	int ret;
 
-	if (zdev->has_hp_slot)
-		zpci_exit_slot(zdev);
+	WARN_ON(zdev->state != ZPCI_FN_STATE_RESERVED);
 
 	if (zdev->zbus->bus)
 		zpci_bus_remove_device(zdev, false);
@@ -929,28 +927,14 @@ void zpci_release_device(struct kref *kref)
 	if (zdev_enabled(zdev))
 		zpci_disable_device(zdev);
 
-	switch (zdev->state) {
-	case ZPCI_FN_STATE_CONFIGURED:
-		ret = sclp_pci_deconfigure(zdev->fid);
-		zpci_dbg(3, "deconf fid:%x, rc:%d\n", zdev->fid, ret);
-		fallthrough;
-	case ZPCI_FN_STATE_STANDBY:
-		if (zdev->has_hp_slot)
-			zpci_exit_slot(zdev);
-		spin_lock(&zpci_list_lock);
-		list_del(&zdev->entry);
-		spin_unlock(&zpci_list_lock);
-		zpci_dbg(3, "rsv fid:%x\n", zdev->fid);
-		fallthrough;
-	case ZPCI_FN_STATE_RESERVED:
-		if (zdev->has_resources)
-			zpci_cleanup_bus_resources(zdev);
-		zpci_bus_device_unregister(zdev);
-		zpci_destroy_iommu(zdev);
-		fallthrough;
-	default:
-		break;
-	}
+	if (zdev->has_hp_slot)
+		zpci_exit_slot(zdev);
+
+	if (zdev->has_resources)
+		zpci_cleanup_bus_resources(zdev);
+
+	zpci_bus_device_unregister(zdev);
+	zpci_destroy_iommu(zdev);
 	zpci_dbg(3, "rem fid:%x\n", zdev->fid);
 	kfree_rcu(zdev, rcu);
 }
-- 
2.43.0



