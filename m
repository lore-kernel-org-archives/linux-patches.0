Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78F746F4B1;
	Tue, 21 Jul 2026 20:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664251; cv=none; b=OzghWaVexU74Nu8JxMDobaG9AMVK5I2dq1Xk0cg+SsBbcY+8+LwMUGlSV7zEdy348qQnwRDhaNtUb5ZOKoLrHGfS7Iz+E5UrUcZ5VBbdT7y53kyE6eCzIXnaM503c/068LVmAm+NTblpfzK+sMY62mSfINvDIcsvHmxDnUnAICw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664251; c=relaxed/simple;
	bh=OV7qcgOOJzYkXtrDdR6fmDyRpxmrfXWNaTkStHvn6Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgFoAIPABmTIziIhzNxOzRwRWgVTF/wli+sSjNwGLGlwyuaC04G+kV8wYpjYL1rWxeYB3w1LCoS5KG+xKrJGTvAwZ37jBi5q5rJno8VJ8YSfk4W+K68TwL2ePOoktj6jqKd5HcFUgIad/MCDoLvs1bmq+PxPJw5mEz8hQO1NhQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VWnJW0Hf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VWnJW0Hf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1BD1F000E9;
	Tue, 21 Jul 2026 20:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664249;
	bh=rFXaElJdWxQ/p3FHZrt259YdFOOXKOSO5rGw3Gw5gko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VWnJW0HfOyVNppqP8HMID+hhp/K+oSX6is3F5jCPZrbd52LMVJy+9wZN6oCUFhHIV
	 ENdzScEJbsd509ZAuqu7ja0clitUYDmAtRFyj7pVn6JekTZHoprxzU5poWmkJihtqY
	 ofXMUXUpuaUssSppkbau4C1Q8fj5ktreNkR2siZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiazi Li <jiazi.li@transsion.com>,
	Ao Sun <ao.sun@transsion.com>,
	Avri Altman <avri.altman@sandisk.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 1129/1276] mmc: block: fix RPMB device unregister ordering
Date: Tue, 21 Jul 2026 17:26:12 +0200
Message-ID: <20260721152511.258027594@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2768,7 +2768,6 @@ static void mmc_blk_rpmb_device_release(
 {
 	struct mmc_rpmb_data *rpmb = dev_get_drvdata(dev);
 
-	rpmb_dev_unregister(rpmb->rdev);
 	mmc_blk_put(rpmb->md);
 	ida_free(&mmc_rpmb_ida, rpmb->id);
 	kfree(rpmb);
@@ -2989,8 +2988,8 @@ out_put_device:
 }
 
 static void mmc_blk_remove_rpmb_part(struct mmc_rpmb_data *rpmb)
-
 {
+	rpmb_dev_unregister(rpmb->rdev);
 	cdev_device_del(&rpmb->chrdev, &rpmb->dev);
 	put_device(&rpmb->dev);
 }


