Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997E824EA9D;
	Mon, 23 Jun 2025 13:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685262; cv=none; b=NWhPzhUgV1QeXr2BH0tun6ekmc0Midz/D/j4amM4NfPNpkthBkJrWjvbrUR2rpYlgZ+6Lj3SOYnzXBLYUojr83/8ftRZ6cad28q17E1GavlBtB397yXwGvNpFjO5XDMx58Y4kh121Web4xw8s5ZkvGHGoRKvXdsaSNMfKcQIQJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685262; c=relaxed/simple;
	bh=qIcyf175drs8agcSUnRw4UpryP8n9ax6ALFUGwS0a/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZjjOxLfYAEa+8C6jp9z6SlFPxudcatWgltyTWKKKvH/P/ZPZvBeLhEbE00uSGpataUQhMOsBMgScW00beH49k7k4qBd8osBnso7MobCWAgSQcHSltV5IvDnhpJHoorjrS8oLN1YmslJtcXuLmNJY437VgVPS3pEtXAhZp+1+FE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+7zNVNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+7zNVNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2D0C4CEEA;
	Mon, 23 Jun 2025 13:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685262;
	bh=qIcyf175drs8agcSUnRw4UpryP8n9ax6ALFUGwS0a/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+7zNVNnaHZtfWyErm4R3yMKzrwMsPxZx5m2mm+9Km4qjF2bZroseozhZ0TRAem1Q
	 dKckbQvapfkfmuz+qAcEYTxqENW1EXLvgX16Qv2ed0UKMeYIaicVyMLdB0tSHaa4Ig
	 +1GVGCoXDriPBYqDNRy7Zwx2mvX/8OQ8Ru2kucq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Xu <feng.f.xu@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/411] EDAC/skx_common: Fix general protection fault
Date: Mon, 23 Jun 2025 15:02:45 +0200
Message-ID: <20250623130633.636589176@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 20d2d476b3ae18041be423671a8637ed5ffd6958 ]

After loading i10nm_edac (which automatically loads skx_edac_common), if
unload only i10nm_edac, then reload it and perform error injection testing,
a general protection fault may occur:

  mce: [Hardware Error]: Machine check events logged
  Oops: general protection fault ...
  ...
  Workqueue: events mce_gen_pool_process
  RIP: 0010:string+0x53/0xe0
  ...
  Call Trace:
  <TASK>
  ? die_addr+0x37/0x90
  ? exc_general_protection+0x1e7/0x3f0
  ? asm_exc_general_protection+0x26/0x30
  ? string+0x53/0xe0
  vsnprintf+0x23e/0x4c0
  snprintf+0x4d/0x70
  skx_adxl_decode+0x16a/0x330 [skx_edac_common]
  skx_mce_check_error.part.0+0xf8/0x220 [skx_edac_common]
  skx_mce_check_error+0x17/0x20 [skx_edac_common]
  ...

The issue arose was because the variable 'adxl_component_count' (inside
skx_edac_common), which counts the ADXL components, was not reset. During
the reloading of i10nm_edac, the count was incremented by the actual number
of ADXL components again, resulting in a count that was double the real
number of ADXL components. This led to an out-of-bounds reference to the
ADXL component array, causing the general protection fault above.

Fix this issue by resetting the 'adxl_component_count' in adxl_put(),
which is called during the unloading of {skx,i10nm}_edac.

Fixes: 123b15863550 ("EDAC, i10nm: make skx_common.o a separate module")
Reported-by: Feng Xu <feng.f.xu@intel.com>
Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Tested-by: Feng Xu <feng.f.xu@intel.com>
Link: https://lore.kernel.org/r/20250417150724.1170168-2-qiuxu.zhuo@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/skx_common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 88c44d5359076..46eeaa142a610 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -112,6 +112,7 @@ EXPORT_SYMBOL_GPL(skx_adxl_get);
 
 void skx_adxl_put(void)
 {
+	adxl_component_count = 0;
 	kfree(adxl_values);
 	kfree(adxl_msg);
 }
-- 
2.39.5



