Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3CC3093A5;
	Tue,  2 Sep 2025 13:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819534; cv=none; b=hulKOOeZggF/1TmnSrtT/xnsDYdcxHCepAlOhhTkM5lnFcl514weIqYsbH3RGZvDc2KYegEkOiTIiJ0Gcepoet3Ucr/pVQwdaALCkRFwOuJOcF3PK/po3wZOcg5Pp9+DML34hRqHj5CLu/ZB5XYtyPYKwEfae3KFC2AcZMcC6xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819534; c=relaxed/simple;
	bh=hQ3ibyUPruuK6iQd/E3aaj19AnYljWi9pxM7CH2anFY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jg8o3q/eZIvmRNTHeCFj4vyKE/t2I5QkvF15vcqvd6GfJxwgQzH9GVuti5VtZ/i3YylubpJWsQqeBZGTbQ28oOrIgWrX2Bj57SfGm/P6g9KA2ebL7mvpwcGN54fL7DOpY00Xnuq3Hcu9cf1o2zP1idpdXxbGnst3B/36qa9OBmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L4os8VIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L4os8VIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCC95C4CEED;
	Tue,  2 Sep 2025 13:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819534;
	bh=hQ3ibyUPruuK6iQd/E3aaj19AnYljWi9pxM7CH2anFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4os8VIeY809ixKu0fVqe8ryFPbumn0Zjv1vKkQvKAKJghVvIIXWMH2OnYpTnzUN3
	 hShoRWWefn8rqaGIqPLW/3kByB/tugaOIjpEyMkYjHuZaFk1bBykLL2AQBwWNLv6Tk
	 QYR7vx3Gb/StsbEX6nt2zTYNwLIjVwIePkMgb3tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Ma <aaron.ma@canonical.com>,
	Even Xu <even.xu@intel.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 031/142] HID: intel-thc-hid: intel-quicki2c: Fix ACPI dsd ICRS/ISUB length
Date: Tue,  2 Sep 2025 15:18:53 +0200
Message-ID: <20250902131949.336040644@linuxfoundation.org>
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

[ Upstream commit 1db9df89a213318a48d958385dc1b17b379dc32b ]

The QuickI2C ACPI _DSD methods return ICRS and ISUB data with a
trailing byte, making the actual length is one more byte than the
structs defined.

It caused stack-out-of-bounds and kernel crash:

kernel: BUG: KASAN: stack-out-of-bounds in quicki2c_acpi_get_dsd_property.constprop.0+0x111/0x1b0 [intel_quicki2c]
kernel: Write of size 12 at addr ffff888106d1f900 by task kworker/u33:2/75
kernel:
kernel: CPU: 3 UID: 0 PID: 75 Comm: kworker/u33:2 Not tainted 6.16.0+ #3 PREEMPT(voluntary)
kernel: Workqueue: async async_run_entry_fn
kernel: Call Trace:
kernel:  <TASK>
kernel:  dump_stack_lvl+0x76/0xa0
kernel:  print_report+0xd1/0x660
kernel:  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
kernel:  ? __kasan_slab_free+0x5d/0x80
kernel:  ? kasan_addr_to_slab+0xd/0xb0
kernel:  kasan_report+0xe1/0x120
kernel:  ? quicki2c_acpi_get_dsd_property.constprop.0+0x111/0x1b0 [intel_quicki2c]
kernel:  ? quicki2c_acpi_get_dsd_property.constprop.0+0x111/0x1b0 [intel_quicki2c]
kernel:  kasan_check_range+0x11c/0x200
kernel:  __asan_memcpy+0x3b/0x80
kernel:  quicki2c_acpi_get_dsd_property.constprop.0+0x111/0x1b0 [intel_quicki2c]
kernel:  ? __pfx_quicki2c_acpi_get_dsd_property.constprop.0+0x10/0x10 [intel_quicki2c]
kernel:  quicki2c_get_acpi_resources+0x237/0x730 [intel_quicki2c]
[...]
kernel:  </TASK>
kernel:
kernel: The buggy address belongs to stack of task kworker/u33:2/75
kernel:  and is located at offset 48 in frame:
kernel:  quicki2c_get_acpi_resources+0x0/0x730 [intel_quicki2c]
kernel:
kernel: This frame has 3 objects:
kernel:  [32, 36) 'hid_desc_addr'
kernel:  [48, 59) 'i2c_param'
kernel:  [80, 224) 'i2c_config'

ACPI DSD methods return:

\_SB.PC00.THC0.ICRS Buffer       000000003fdc947b 001 Len 0C = 0A 00 80 1A 06 00 00 00 00 00 00 00
\_SB.PC00.THC0.ISUB Buffer       00000000f2fcbdc4 001 Len 91 = 00 00 00 00 00 00 00 00 00 00 00 00

Adding reserved padding to quicki2c_subip_acpi_parameter/config.

Fixes: 5282e45ccbfa9 ("HID: intel-thc-hid: intel-quicki2c: Add THC QuickI2C ACPI interfaces")
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Reviewed-by: Even Xu <even.xu@intel.com>
Tested-by: Even Xu <even.xu@intel.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h
index 6ddb584bd6110..97085a6a7452d 100644
--- a/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h
+++ b/drivers/hid/intel-thc-hid/intel-quicki2c/quicki2c-dev.h
@@ -71,6 +71,7 @@ struct quicki2c_subip_acpi_parameter {
 	u16 device_address;
 	u64 connection_speed;
 	u8 addressing_mode;
+	u8 reserved;
 } __packed;
 
 /**
@@ -120,6 +121,7 @@ struct quicki2c_subip_acpi_config {
 	u64 HMTD;
 	u64 HMRD;
 	u64 HMSL;
+	u8 reserved;
 };
 
 struct device;
-- 
2.50.1



