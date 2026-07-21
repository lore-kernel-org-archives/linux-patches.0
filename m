Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249932DF3EA;
	Tue, 21 Jul 2026 18:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659400; cv=none; b=gR7syWOex+I3hjZwBWW56nifyh6joqAT0ap8eU0XWx0wFO8Hk37VOfTIaj+Whi+w6/AJrAt7n+QtHsLEo7ZmgGYByC/ZfMxmL6I/K3cDs396wqLAslhBlvCGZgX8+aJbvCsZs1zWQF72P+08Q5qmwNfq5jN/KfUytvAFl2eXB20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659400; c=relaxed/simple;
	bh=FezBdRpc66fgPch0O9JyToNX+qYlVEkvXXw6vDdn148=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsY6rqUdw2TXn5/Z6Zm57BL3Cc2eBlAc5EGCMxtc6BYXQ13k8cNMP6zmZ9U552apWtDL2SIBeDt/RlrxL+Fi/7eodwqgUt1mS+6c+M39OQWuM1X0WRN72zfibkIu6rgjjRxz5GbWlLLfq6gUcqYKwsKtKH+LCqDEfEkv5EE0uYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZvuU0KrG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZvuU0KrG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764711F000E9;
	Tue, 21 Jul 2026 18:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659399;
	bh=eLz3dMhLk0zpiC+ObpCbPkjohlkD1peMnTMk3CZ1I1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZvuU0KrGaDff3wUdmSMyMFnLfeod04vRyRZmlGpvmglqyImwPl5jPfas/gp6CAL22
	 CvRvMtGYfFi3P9nbfRFmKwscPjxYvIvM38pdhGkubFpeuBC+Dec0kxnuOh747A6UFh
	 Nj6LQh4tBMkkK8kstO0b+UDM+Fp5Si3R0km18Dlg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiazi Li <jiazi.li@transsion.com>,
	Ao Sun <ao.sun@transsion.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 1506/1611] mmc: block: fix RPMB device unregister ordering
Date: Tue, 21 Jul 2026 17:27:02 +0200
Message-ID: <20260721152549.315508574@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -2784,7 +2784,6 @@ static void mmc_blk_rpmb_device_release(
 {
 	struct mmc_rpmb_data *rpmb = dev_get_drvdata(dev);
 
-	rpmb_dev_unregister(rpmb->rdev);
 	mmc_blk_put(rpmb->md);
 	ida_free(&mmc_rpmb_ida, rpmb->id);
 	kfree(rpmb);
@@ -2999,8 +2998,8 @@ out_put_device:
 }
 
 static void mmc_blk_remove_rpmb_part(struct mmc_rpmb_data *rpmb)
-
 {
+	rpmb_dev_unregister(rpmb->rdev);
 	cdev_device_del(&rpmb->chrdev, &rpmb->dev);
 	put_device(&rpmb->dev);
 }


