Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B01337EB9;
	Wed, 17 Sep 2025 12:44:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113082; cv=none; b=BLjhuppf3uwZJINrAQAnNT5rX060OLcwxo/W/bMNjyBpG34SVoaRIfQGbptPptgagg8vMYAziBYbHSRKhrNGDBS77o+Pk1+XahXBk4InaEiMnGtMfNEz7DHzY8D+cBPCQJCEx841y7yWm19pFd0Iy3FH3e4oD+jGK+yeKt6aIQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113082; c=relaxed/simple;
	bh=9G2Ox6d+qD6MVu2XzMM+0x64mWCwopSIAnLgCPdD5Ig=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWoxhuYXXlEi6AZR5aSL2103G83pXvc+JKUS9cQerqhkqzk7rfpijFVx6nkRo5aik/12mQADQJLAxbHCzW3RTpeQzcVuPwq+m0qOYsqZzHnkTKzkjOq7PrgaXnzFNk+xFQuuFhA94O1tHLCl6uiggsRj/2VeuIFIhJeRgCHy0Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHwdAicZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHwdAicZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103D4C4CEF0;
	Wed, 17 Sep 2025 12:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113082;
	bh=9G2Ox6d+qD6MVu2XzMM+0x64mWCwopSIAnLgCPdD5Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHwdAicZoGvQ8GvR+O1reZierfgXmu6zhiV8Mu1+puRRURWl9XwS3nZE5ldMlawDb
	 McyGmUax/BQNdgDn1dFpkec7lK4fuzCN65Tis7Xy+g8nRYjHDg2vYkhiG2/+WY9Hpa
	 feowzKuEYvGQfVcBNRM/ImFDwQydUgyqYWUc1NDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 167/189] dmaengine: idxd: Remove improper idxd_free
Date: Wed, 17 Sep 2025 14:34:37 +0200
Message-ID: <20250917123355.959623501@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Yi Sun <yi.sun@intel.com>

[ Upstream commit f41c538881eec4dcf5961a242097d447f848cda6 ]

The call to idxd_free() introduces a duplicate put_device() leading to a
reference count underflow:
refcount_t: underflow; use-after-free.
WARNING: CPU: 15 PID: 4428 at lib/refcount.c:28 refcount_warn_saturate+0xbe/0x110
...
Call Trace:
 <TASK>
  idxd_remove+0xe4/0x120 [idxd]
  pci_device_remove+0x3f/0xb0
  device_release_driver_internal+0x197/0x200
  driver_detach+0x48/0x90
  bus_remove_driver+0x74/0xf0
  pci_unregister_driver+0x2e/0xb0
  idxd_exit_module+0x34/0x7a0 [idxd]
  __do_sys_delete_module.constprop.0+0x183/0x280
  do_syscall_64+0x54/0xd70
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

The idxd_unregister_devices() which is invoked at the very beginning of
idxd_remove(), already takes care of the necessary put_device() through the
following call path:
idxd_unregister_devices() -> device_unregister() -> put_device()

In addition, when CONFIG_DEBUG_KOBJECT_RELEASE is enabled, put_device() may
trigger asynchronous cleanup via schedule_delayed_work(). If idxd_free() is
called immediately after, it can result in a use-after-free.

Remove the improper idxd_free() to avoid both the refcount underflow and
potential memory corruption during module unload.

Fixes: d5449ff1b04d ("dmaengine: idxd: Add missing idxd cleanup to fix memory leak in remove call")
Signed-off-by: Yi Sun <yi.sun@intel.com>
Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Link: https://lore.kernel.org/r/20250729150313.1934101-2-yi.sun@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 80355d03004db..40cc9c070081f 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -1295,7 +1295,6 @@ static void idxd_remove(struct pci_dev *pdev)
 	idxd_cleanup(idxd);
 	pci_iounmap(pdev, idxd->reg_base);
 	put_device(idxd_confdev(idxd));
-	idxd_free(idxd);
 	pci_disable_device(pdev);
 }
 
-- 
2.51.0



