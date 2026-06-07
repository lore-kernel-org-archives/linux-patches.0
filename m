Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9DA14071FD;
	Sun,  7 Jun 2026 10:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829160; cv=none; b=EZjbLBDQ8xvCYFrueFMPviMkDxFqifLmaO41+CjtoMTaHYkyd9aMjSYRQadDhKhflZ5S/YGucGkgPI7SMjKqwzV7r4u8Gfo4sE7eflnjjekO4IkfRs2r7gHj3kUkkVtZT8rYofw4DUHnAdB+hXE21JpRuvTSZnnIQABI/Ax8Mgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829160; c=relaxed/simple;
	bh=glsFfIJCT06sinpzsfuoJ2ow107Q3cKI7no9lqHzMiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZIlsGq7YD8EMyGwaaHryPTLmhXNXYEHxJbq49jGTQF6741ba7j1EM9bWFXp5E+Xfq+EHVUYex4RzxlXFZtZR12WK/a2D1SUMYWWooqQuN3VsQNMHI12UILpFHFy2Q9VmaUVSMSN2LYbmnvJ3uYvUtojj4wLlSG4aDYRbyCHH37w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCI53C2V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCI53C2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B657E1F00893;
	Sun,  7 Jun 2026 10:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829159;
	bh=zLL3QisGb6SatQnAydsiPNdZxI+xgpOJwK8mZnAGSBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XCI53C2VLzWTZY7DBxCfwF8WzsLuO8IAd3SuITtNiIw6R3pKf9/eKaPkByR+f6krD
	 BAjrwzgoA4uBiM+6jGPhTfiSahKYCfQqSGzBl+66tzCgRxBZAxRQE9eEku7MyYw8GW
	 b+aj291ndK4hrVt6chJcsZBlW0NoR8yfaG2lm5Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH 7.0 250/332] uio: uio_pci_generic_sva: fix double free of devm_kzalloc() memory
Date: Sun,  7 Jun 2026 12:00:19 +0200
Message-ID: <20260607095737.227949051@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit f74c8696f14149d5e43cc28b015326a759c48f00 upstream.

uio_pci_sva allocates struct uio_pci_sva_dev with devm_kzalloc() in
probe(), but then calls kfree(udev) both on the probe() error path
(label out_free) and again in remove().

Because devm_kzalloc() allocations are devres-managed and are freed
automatically when the device is detached (including after a failing
probe() and during driver unbind), the explicit kfree() can lead to a
double free.

If probe() fails after devm_kzalloc(), the error path frees udev and
devres cleanup will free it again when the core unwinds the partially
bound device. On normal driver removal, remove() frees udev and devres
will free it again when the device is detached.

This issue was identified by a static analysis tool I developed and
confirmed by manual review. Fix by removing the manual kfree() calls
and dropping the now-unused label.

Fixes: 3397c3cd859a2 ("uio: Add SVA support for PCI devices via uio_pci_generic_sva.c")
Cc: stable <stable@kernel.org>
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Link: https://patch.msgid.link/20260505150256.614071-1-lgs201920130244@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/uio/uio_pci_generic_sva.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/drivers/uio/uio_pci_generic_sva.c
+++ b/drivers/uio/uio_pci_generic_sva.c
@@ -129,15 +129,13 @@ static int probe(struct pci_dev *pdev, c
 	ret = devm_uio_register_device(&pdev->dev, &udev->info);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register uio device\n");
-		goto out_free;
+		goto out_disable;
 	}
 
 	pci_set_drvdata(pdev, udev);
 
 	return 0;
 
-out_free:
-	kfree(udev);
 out_disable:
 	pci_disable_device(pdev);
 
@@ -146,11 +144,8 @@ out_disable:
 
 static void remove(struct pci_dev *pdev)
 {
-	struct uio_pci_sva_dev *udev = pci_get_drvdata(pdev);
-
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
-	kfree(udev);
 }
 
 static ssize_t pasid_show(struct device *dev,


