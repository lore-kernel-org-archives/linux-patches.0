Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5A43E49EF;
	Tue, 21 Jul 2026 17:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655421; cv=none; b=rcPcccQbmO3tlYvS5pd3QU3RuV4BrTY5F5djA1qC9SrFh1OBp8fRcVxqUfFWjXSCQ1aiykXcC6JVbq0I85aQ/UHFJqJgRCH6FrDQ89VCWQF1HsulZclDCXAMs4DEuI5cfNtnaoisxAe4VHg39C2O0x2D7W8TNUfRMLb5XNKiqpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655421; c=relaxed/simple;
	bh=AGkuVkGoiXpjBZ6tNkinfAtKiatIStKfd9r3EGPcxxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WvwRqixSlJInK8Xn4ZLPUfy4f7XAQmHUk3VhoVm4LmbQh1vlYAcbUPnBEQ9oeRv4r1pG3KwjMEG1/XSEwSsL+ZvVzhUYLOP0r7KURgArudCRQa1Kb4sCCYAZc0Xdo12xY7sxZ661vuEALxBZ+63T7wGoUCNZaGOgKkqJd1sNL3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FKu4rPV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FKu4rPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 631591F000E9;
	Tue, 21 Jul 2026 17:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655419;
	bh=CXrdQAaLf+45MU5TwunhAkN3hDhGRTNaoc+dnfalLE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FKu4rPVw3fJQBh/vPbzIC3gTWzabT0Q/uN0pQL5yxLlPtvct4Aj6wtiIT2YIuHSD
	 NbD2hGrfuaI5QrHtXI3L5ob+G1KIU7IYpNlYC5s6zd/w+yqwe9fiNtOFoXpRKqrM9+
	 l13MNOhpZJZshVirXiJjC0FSjcs+7WRclKo+LDEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiazi Li <jiazi.li@transsion.com>,
	Ao Sun <ao.sun@transsion.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 2034/2077] mmc: block: fix RPMB device unregister ordering
Date: Tue, 21 Jul 2026 17:28:27 +0200
Message-ID: <20260721152640.673048203@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Ao Sun <ao.sun@transsion.com>

commit 86152fef52cac15cd662ed3bfc7604fbfef378f0 upstream.

Since commit 7852028a35f0 ("mmc: block: register RPMB partition with
the RPMB subsystem"), each mmc RPMB partition is represented by two
device objects:
 - the mmc-owned device (`rpmb->dev`, backing the legacy /dev/mmcblkXrpmb
   char device) and
 - the rpmb-core device (`rdev`, backing /dev/rpmbN).

The child RPMB device holds a reference to its parent, so the
parent's release callback cannot be invoked if the child device
is still registered.

Remove rpmb_dev_unregister() from the parent release handler and
unregister the child RPMB device in the remove path before tearing
down the parent device.

Also delete the extra blank line between mmc_blk_remove_rpmb_part()
and {.

Fixes: 7852028a35f0 ("mmc: block: register RPMB partition with the RPMB subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Jiazi Li <jiazi.li@transsion.com>
Signed-off-by: Ao Sun <ao.sun@transsion.com>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2715,7 +2715,6 @@ static void mmc_blk_rpmb_device_release(
 {
 	struct mmc_rpmb_data *rpmb = dev_get_drvdata(dev);
 
-	rpmb_dev_unregister(rpmb->rdev);
 	mmc_blk_put(rpmb->md);
 	ida_free(&mmc_rpmb_ida, rpmb->id);
 	kfree(rpmb);
@@ -2930,8 +2929,8 @@ out_put_device:
 }
 
 static void mmc_blk_remove_rpmb_part(struct mmc_rpmb_data *rpmb)
-
 {
+	rpmb_dev_unregister(rpmb->rdev);
 	cdev_device_del(&rpmb->chrdev, &rpmb->dev);
 	put_device(&rpmb->dev);
 }


