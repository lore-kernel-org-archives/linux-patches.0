Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7656E3B6366;
	Thu, 30 Jul 2026 16:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428154; cv=none; b=HPwYTvRQ64op0hRstljFle+IUWLlAA6Jn3FC0BT0NQjveWWj1b+TEiQcni/emzXzdLRCLYztg4vlKRUnB/F3dkNwtUfLNEShVWGyi2N0mcBpgzA04WJ+eh5QtFRhUei87B9DWDZazigG8oDV0+W+hAr5n6G06dRz0QafQVhCRsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428154; c=relaxed/simple;
	bh=1J7XsPNIciRdhOt7AI+dddjyKjaAi6WYuqfQx6FT+1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLFX8Y53+aOafcUvCkMRqxanRfWWzNe8AsjPukMyGwLKWftZSPTqO5/QL7qPYEM0irWe1RlN4KGrGNn+gijxVp9Fls5B2qtNhWnZT/QFoqt5QfjBF0fke7KEMf9cbAmhsxnVp0hj2jKWEwyOThO8fDlQIwPzCRC+8CN6SWWJ7xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HeM/8Sx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HeM/8Sx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FF01F00A3A;
	Thu, 30 Jul 2026 16:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428139;
	bh=tY5D+sPVtc77plXsYpIPVbRB/NK9nvTuuIQqZthORjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HeM/8Sx9zrmH2lGD6/1MZ6L4xK2ryizUNIX5xA4gMp+VfdbGijpakT7iH0gLjuvF5
	 1YT2bYlcj1K9JtT07PKDE1/0wU3/R9ZOLNwDPKDui3LbhflOgynl23kwyUnYmRv1tf
	 eB9105sZ08H60DKeCZj1JESn4/2+kWHFDB+b9FRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 373/484] i2c: i801: fix hardware state machine corruption in error path
Date: Thu, 30 Jul 2026 16:14:30 +0200
Message-ID: <20260730141431.578141785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

[ Upstream commit 10dd1a736d557e310a77117832874729a0175d57 ]

A severe livelock and subsequent Hung Task panic were observed in the
i2c-i801 driver during concurrent Fuzzing. The crash is caused by an
unconditional hardware register cleanup in the error handling path of
i801_access().

When i801_check_pre() fails (e.g., returning -EBUSY because the SMBus
controller is actively used by BIOS/ACPI), the kernel does not actually
acquire the hardware ownership. However, the code jumps to the 'out'
label and executes:

    iowrite8(SMBHSTSTS_INUSE_STS | STATUS_FLAGS, SMBHSTSTS(priv));

This forcefully clears the INUSE_STS lock and resets the hardware status
flags without owning the controller. Doing so interrupts ongoing BIOS/ACPI
transactions and totally corrupts the SMBus hardware state machine.

Consequently, all subsequent i801_access() calls fail at the pre-check
stage, triggering an endless stream of "SMBus is busy, can't use it!"
error logs. Over a slow serial console, this printk flood monopolizes
the CPU (Console Livelock), starving other processes trying to acquire
the mmap_lock down_read semaphore, ultimately triggering the hung task
watchdog.

Fix this by moving the 'out' label below the hardware register cleanup.
If i801_check_pre() fails, we safely bypass the iowrite8() and only
release the software locks (pm_runtime and mutex), strictly adhering to
the rule of not releasing resources that were never acquired.

Fixes: 1f760b87e54c ("i2c: i801: Call i801_check_pre() from i801_access()")
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Cc: <stable@vger.kernel.org> # v6.3+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260512093534.348655-1-w15303746062@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-i801.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -918,13 +918,13 @@ static s32 i801_access(struct i2c_adapte
 	 */
 	if (hwpec)
 		outb_p(inb_p(SMBAUXCTL(priv)) & ~SMBAUXCTL_CRC, SMBAUXCTL(priv));
-out:
 	/*
 	 * Unlock the SMBus device for use by BIOS/ACPI,
 	 * and clear status flags if not done already.
 	 */
 	outb_p(SMBHSTSTS_INUSE_STS | STATUS_FLAGS, SMBHSTSTS(priv));
 
+out:
 	pm_runtime_mark_last_busy(&priv->pci_dev->dev);
 	pm_runtime_put_autosuspend(&priv->pci_dev->dev);
 	mutex_unlock(&priv->acpi_lock);


