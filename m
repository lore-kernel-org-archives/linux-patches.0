Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B803BCD11;
	Thu, 16 Jul 2026 13:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210213; cv=none; b=SKY7Hf/3y+7Lrc+M6/SYhnRrzf2rzPl1PpaoBL8u9qJ2iMdQSLpO3jg96gMr4J/fOWfRNsAWaT84lFO3lK5REdG6g78V3AqbcLYlBQjsCWjosgpe5vafx2pxjh8kc4EbX/5w5Xo6KCtvIkDQu0DE2UkPRFVfGs4qiOBbEMJ+rNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210213; c=relaxed/simple;
	bh=MVx0TRgjpgHc6IRVDB9avZU9yMw2ChWGakvs1cuPJsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOp3d/t9YVnIWEpYkP7g44Qp8oU9cvMZ9m5pkUPKgYYI8/ikm/y5i7ouHnIzpVyUtQsmswPdn9EUk22e6Zo0ztb7eytL9wmxAn0zLXnmnrovcdWCVWtYn17ssca8oY4lLN2HVjwgt9BPa3sMW8I42bN/wjsTV0IhJg9pKEBE0Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7kwijkm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7kwijkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0EF1F000E9;
	Thu, 16 Jul 2026 13:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210211;
	bh=nOjm+ZXS/x7GpB1gHM0ffaXifSB1OG9n3bbHrwV8GWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7kwijkmxsMz4+5G15BiIOqkx+H2iYX0ne7WasLKbzGKQu3u3/A78WFPUnMi4tE1l
	 RIYESSEiCnGzdtmdHQypW6+8LIeZr9WGx1JMtXqm52rhgnMgZ+N448XXPL4DDeiEua
	 HyT9zzp4bY65xmQ1gp3dVlZaZRjYDuS3ZvvdB1ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.1 479/518] i2c: i801: fix hardware state machine corruption in error path
Date: Thu, 16 Jul 2026 15:32:27 +0200
Message-ID: <20260716133058.329359738@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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
@@ -931,13 +931,13 @@ static s32 i801_access(struct i2c_adapte
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


