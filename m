Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D997F319867;
	Tue, 26 Aug 2025 13:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215820; cv=none; b=OKDMcV+0vYL/9bom06H+w9iQS1Tt5RLydLeiqAgYTUhn3oNRrYhysNXono0tCy0vD/CI7r8qrCLo9jIAimNnkKMzg0PM/PJRGe+3v/QgbrW/ma3ney38IHzbA0twMdMnk6fu8eOnWlE+3J5ax61mre2KgIORiL2ndSSrzFIh5KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215820; c=relaxed/simple;
	bh=uNE4aqoccDf3GB8akUdWbysIZEaE62s6Zm+I0I5Gf1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJavJNtDjwsDpcRexwF1yXj8gmEewQIYVcZOGAvS4Zz9wwTylJKO+NKejpsbCe671YN0lit9Ltvp7bx5ji1IVovrMP0uOn2RLbg2XTk6xCPSkSwR4HYg6cW4quHcqiQOxhhDeFFi89XrqweNXlN/6H8FCWLxTAFfr/5RKkhO00E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JK53eMuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JK53eMuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2CFC116D0;
	Tue, 26 Aug 2025 13:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215820;
	bh=uNE4aqoccDf3GB8akUdWbysIZEaE62s6Zm+I0I5Gf1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JK53eMuAQFQDRLYuMIoaTxS/bHViRaK82z4G8A7oj038k/tl7B7ODihHT6rVhd/PH
	 MpGD0UfwR/wb49l3v6WfYf+oJveldMfEnsDQ2ZE6yKvznuC7KEl/KSN+FFjfU6/BT7
	 biNwR9i6gsmJcDtTsGvsLw5M0h5yCQCU8Yq0lNCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mengbiao Xiong <xisme1998@gmail.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 178/644] crypto: ccp - Fix crash when rebind ccp device for ccp.ko
Date: Tue, 26 Aug 2025 13:04:29 +0200
Message-ID: <20250826110950.879891015@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

From: Mengbiao Xiong <xisme1998@gmail.com>

[ Upstream commit 181698af38d3f93381229ad89c09b5bd0496661a ]

When CONFIG_CRYPTO_DEV_CCP_DEBUGFS is enabled, rebinding
the ccp device causes the following crash:

$ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/unbind
$ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/bind

[  204.976930] BUG: kernel NULL pointer dereference, address: 0000000000000098
[  204.978026] #PF: supervisor write access in kernel mode
[  204.979126] #PF: error_code(0x0002) - not-present page
[  204.980226] PGD 0 P4D 0
[  204.981317] Oops: Oops: 0002 [#1] SMP NOPTI
...
[  204.997852] Call Trace:
[  204.999074]  <TASK>
[  205.000297]  start_creating+0x9f/0x1c0
[  205.001533]  debugfs_create_dir+0x1f/0x170
[  205.002769]  ? srso_return_thunk+0x5/0x5f
[  205.004000]  ccp5_debugfs_setup+0x87/0x170 [ccp]
[  205.005241]  ccp5_init+0x8b2/0x960 [ccp]
[  205.006469]  ccp_dev_init+0xd4/0x150 [ccp]
[  205.007709]  sp_init+0x5f/0x80 [ccp]
[  205.008942]  sp_pci_probe+0x283/0x2e0 [ccp]
[  205.010165]  ? srso_return_thunk+0x5/0x5f
[  205.011376]  local_pci_probe+0x4f/0xb0
[  205.012584]  pci_device_probe+0xdb/0x230
[  205.013810]  really_probe+0xed/0x380
[  205.015024]  __driver_probe_device+0x7e/0x160
[  205.016240]  device_driver_attach+0x2f/0x60
[  205.017457]  bind_store+0x7c/0xb0
[  205.018663]  drv_attr_store+0x28/0x40
[  205.019868]  sysfs_kf_write+0x5f/0x70
[  205.021065]  kernfs_fop_write_iter+0x145/0x1d0
[  205.022267]  vfs_write+0x308/0x440
[  205.023453]  ksys_write+0x6d/0xe0
[  205.024616]  __x64_sys_write+0x1e/0x30
[  205.025778]  x64_sys_call+0x16ba/0x2150
[  205.026942]  do_syscall_64+0x56/0x1e0
[  205.028108]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  205.029276] RIP: 0033:0x7fbc36f10104
[  205.030420] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 8d 05 e1 08 2e 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3 66 90 41 54 55 49 89 d4 53 48 89 f5

This patch sets ccp_debugfs_dir to NULL after destroying it in
ccp5_debugfs_destroy, allowing the directory dentry to be
recreated when rebinding the ccp device.

Tested on AMD Ryzen 7 1700X.

Fixes: 3cdbe346ed3f ("crypto: ccp - Add debugfs entries for CCP information")
Signed-off-by: Mengbiao Xiong <xisme1998@gmail.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/ccp-debugfs.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/ccp-debugfs.c b/drivers/crypto/ccp/ccp-debugfs.c
index a1055554b47a..dc26bc22c91d 100644
--- a/drivers/crypto/ccp/ccp-debugfs.c
+++ b/drivers/crypto/ccp/ccp-debugfs.c
@@ -319,5 +319,8 @@ void ccp5_debugfs_setup(struct ccp_device *ccp)
 
 void ccp5_debugfs_destroy(void)
 {
+	mutex_lock(&ccp_debugfs_lock);
 	debugfs_remove_recursive(ccp_debugfs_dir);
+	ccp_debugfs_dir = NULL;
+	mutex_unlock(&ccp_debugfs_lock);
 }
-- 
2.39.5



