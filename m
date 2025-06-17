Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD462EE5FD;
	Tue, 17 Jun 2025 15:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175160; cv=none; b=odHL4rvClJ4oAM9HhoJZgK8RNx6KFvf+MQbkZfH1CEB9D1V5f3JEeE7S3Vqr17hc1xZ4G7K67oNhkWUo/F5eGL8HMrK0IC7Sq7tmU0vc0v5ZhGDJi4hTZxgQ9XVbJTH+QkTqNR6oG1lZj45/EZeg1dz4wTqxYTIReRCDUPaV7aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175160; c=relaxed/simple;
	bh=CYKAoRmL1FzmCnpIsug7Y9hNubj/bi4FD4bTli1x+Ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZdMJHk7fbn1jBxrpXnXuOsE8bVSxB+3MSo5ZXoyezwhgt+X8KovB8vLtXgkqrj1EH79RrUh2ye7L7LJUO/6GRHpspfwYS66XosKLc3NjUZQAjzE41WnfD1iDfbL1rcGZWrSkwePgtlj7m/3kGYSRPfejmeVdb7q7yYimL2I4Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVd79Jv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVd79Jv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFDDC4CEE3;
	Tue, 17 Jun 2025 15:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175159;
	bh=CYKAoRmL1FzmCnpIsug7Y9hNubj/bi4FD4bTli1x+Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVd79Jv0vJbcHEUIFXCcuxUEgI+twns3UjMxLKB9HWFV1pxwLpzGJx+skq89d61Zu
	 F+CrDdmASbeyPwqGQq6E8wz23V6pBLYZPGEJ5PKFC6tIJy65YVmjaXZxPuKElZoPS7
	 3fB5NKWBeBOOq68BcuHSq6KTJC4HkLD/Kd3To1fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Xu <feng.f.xu@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 058/780] EDAC/skx_common: Fix general protection fault
Date: Tue, 17 Jun 2025 17:16:06 +0200
Message-ID: <20250617152453.865266826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index fa5b442b18449..c9ade45c1a99f 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -116,6 +116,7 @@ EXPORT_SYMBOL_GPL(skx_adxl_get);
 
 void skx_adxl_put(void)
 {
+	adxl_component_count = 0;
 	kfree(adxl_values);
 	kfree(adxl_msg);
 }
-- 
2.39.5



