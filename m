Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237503F54B6;
	Thu, 16 Jul 2026 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211479; cv=none; b=WqTuE9SvjDNBv3/pQYKsYNOo5CewUwdlKRS3xoa1TlxYCp6xRSxIbysxek4k7NMx/vQG+ENvI5gdQrYNuv0CTTlarPQ1JrY5EWbvAVlF7pv+obqiCkszj+cJCriBNlCp6ggQwig0Agp85xRNl60nxb3iXbY3dI7PNuZxY/pQxGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211479; c=relaxed/simple;
	bh=4KUMefw2sp3iTfT9XSYeh8y0xLqP3btPAViDPnVri0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCiA0toD4ykoMI2ABrXyfKJN0hxJvNz5epOOpLQ8D0c9U82Yx4CEqWWgtAEY2nXUBAcA79PToZIcYDl+a1RlSawbeb/6b6DaeXR9ADeJs0oW2eqW7xGW7W1AJpM3snNT0KvhYjbVrtsBCR7xm0dHLYTC2TssSoWQM8e49TXXxH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5oj/EGj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5oj/EGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 457F11F00A3A;
	Thu, 16 Jul 2026 14:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211474;
	bh=oIY+v9O57pnXn9rG6CHnPnLXoMEgfB4bUvUVdzPqJqM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5oj/EGj2/gfjSpegVTNLh7xFlzL+fmBXOPgZNWDA8ZIFhTmaduoUcQfNGtNFvmuu
	 I5OM2CIGXYd1asCbw5Vb4BAblybra77LM/oO54od7gg1PWfGO1lNydxow0EvBYEe7f
	 0iOBMVrsfw2vEqY1d0hlQnnWVmMfFRoUavI4P8kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 442/480] i2c: i801: fix hardware state machine corruption in error path
Date: Thu, 16 Jul 2026 15:33:09 +0200
Message-ID: <20260716133054.380688281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

commit 10dd1a736d557e310a77117832874729a0175d57 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-i801.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-i801.c
+++ b/drivers/i2c/busses/i2c-i801.c
@@ -927,13 +927,13 @@ static s32 i801_access(struct i2c_adapte
 	 */
 	if (hwpec)
 		iowrite8(ioread8(SMBAUXCTL(priv)) & ~SMBAUXCTL_CRC, SMBAUXCTL(priv));
-out:
 	/*
 	 * Unlock the SMBus device for use by BIOS/ACPI,
 	 * and clear status flags if not done already.
 	 */
 	iowrite8(SMBHSTSTS_INUSE_STS | STATUS_FLAGS, SMBHSTSTS(priv));
 
+out:
 	pm_runtime_put_autosuspend(&priv->pci_dev->dev);
 	mutex_unlock(&priv->acpi_lock);
 	return ret;


