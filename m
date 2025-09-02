Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1865303C8B;
	Tue,  2 Sep 2025 13:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819537; cv=none; b=tOblQAQpOpALoI3a8ueQBa51jTByn4sjVKwBwuX0J4bv2gU8SAl5FLEUpEmkRxa3lsRgL5aX+Z8ollWQFAx5vsKd1+wgZDBzzlRE4lK6YGeNc/BmJumjRdDbs1dn1fJMpO6ing+QOkF0mK2nDB3CW3iuLd/MLMMqdSJ0KKuBoqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819537; c=relaxed/simple;
	bh=SBLfv1eOjuvaYIfbCXtRRFf80JcZ7PGuTXDQvSG8des=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IG59nE83iMKpoDjX4PlSjsg5TY4KBJBSukgwuo/TG9CmtL4UJAxOgQPWQSyBYe1TUts+Kt+1N0Wuf8So/0aqeaj+prDpZzhWD+JD7WOEe6k6yTqENz9YOxi5nbeCMTqlR4kc14rxEgiHg+Qh6WXzUsKZPNmRi/NWFRmnbC67ugM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLhU6ooo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLhU6ooo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345F2C4CEED;
	Tue,  2 Sep 2025 13:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819537;
	bh=SBLfv1eOjuvaYIfbCXtRRFf80JcZ7PGuTXDQvSG8des=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLhU6ooo/pZyBm/j+TYgmgiXTkfGUQcNCt+MuO+qp2xLiuc8ByV2u3vcfYCXxdgBe
	 nMwfaowj8nWqG1rliOZKvzifPLgK5X322y1240QqanqiVhH7WQf/0bwyRX1A9CLjjW
	 Sf3oV5okN9uqcGUfXaBeFa7Kcn/VggeiEtwapbOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 032/142] HID: intel-thc-hid: intel-thc: Fix incorrect pointer arithmetic in I2C regs save
Date: Tue,  2 Sep 2025 15:18:54 +0200
Message-ID: <20250902131949.375910242@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Ma <aaron.ma@canonical.com>

[ Upstream commit a7fc15ed629be89e51e09b743277c53e0a0168f5 ]

Improper use of secondary pointer (&dev->i2c_subip_regs) caused
kernel crash and out-of-bounds error:

 BUG: KASAN: slab-out-of-bounds in _regmap_bulk_read+0x449/0x510
 Write of size 4 at addr ffff888136005dc0 by task kworker/u33:5/5107

 CPU: 3 UID: 0 PID: 5107 Comm: kworker/u33:5 Not tainted 6.16.0+ #3 PREEMPT(voluntary)
 Workqueue: async async_run_entry_fn
 Call Trace:
  <TASK>
  dump_stack_lvl+0x76/0xa0
  print_report+0xd1/0x660
  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
  ? kasan_complete_mode_report_info+0x26/0x200
  kasan_report+0xe1/0x120
  ? _regmap_bulk_read+0x449/0x510
  ? _regmap_bulk_read+0x449/0x510
  __asan_report_store4_noabort+0x17/0x30
  _regmap_bulk_read+0x449/0x510
  ? __pfx__regmap_bulk_read+0x10/0x10
  regmap_bulk_read+0x270/0x3d0
  pio_complete+0x1ee/0x2c0 [intel_thc]
  ? __pfx_pio_complete+0x10/0x10 [intel_thc]
  ? __pfx_pio_wait+0x10/0x10 [intel_thc]
  ? regmap_update_bits_base+0x13b/0x1f0
  thc_i2c_subip_pio_read+0x117/0x270 [intel_thc]
  thc_i2c_subip_regs_save+0xc2/0x140 [intel_thc]
  ? __pfx_thc_i2c_subip_regs_save+0x10/0x10 [intel_thc]
[...]
 The buggy address belongs to the object at ffff888136005d00
  which belongs to the cache kmalloc-rnd-12-192 of size 192
 The buggy address is located 0 bytes to the right of
  allocated 192-byte region [ffff888136005d00, ffff888136005dc0)

Replaced with direct array indexing (&dev->i2c_subip_regs[i]) to ensure
safe memory access.

Fixes: 4228966def884 ("HID: intel-thc-hid: intel-thc: Add THC I2C config interfaces")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Tested-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-thc/intel-thc-dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dev.c b/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dev.c
index c105df7f6c873..4698722e0d0a6 100644
--- a/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dev.c
+++ b/drivers/hid/intel-thc-hid/intel-thc/intel-thc-dev.c
@@ -1539,7 +1539,7 @@ int thc_i2c_subip_regs_save(struct thc_device *dev)
 
 	for (int i = 0; i < ARRAY_SIZE(i2c_subip_regs); i++) {
 		ret = thc_i2c_subip_pio_read(dev, i2c_subip_regs[i],
-					     &read_size, (u32 *)&dev->i2c_subip_regs + i);
+					     &read_size, &dev->i2c_subip_regs[i]);
 		if (ret < 0)
 			return ret;
 	}
@@ -1562,7 +1562,7 @@ int thc_i2c_subip_regs_restore(struct thc_device *dev)
 
 	for (int i = 0; i < ARRAY_SIZE(i2c_subip_regs); i++) {
 		ret = thc_i2c_subip_pio_write(dev, i2c_subip_regs[i],
-					      write_size, (u32 *)&dev->i2c_subip_regs + i);
+					      write_size, &dev->i2c_subip_regs[i]);
 		if (ret < 0)
 			return ret;
 	}
-- 
2.50.1



