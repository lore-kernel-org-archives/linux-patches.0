Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968B8280037;
	Tue, 12 Aug 2025 18:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022705; cv=none; b=OmB7Zp3jr+tr8WTuPKIWW4EtpmxlwsZQR9pmYi80WtHANUFPwMa6zF3jztgGhiKcDTrTfrHWXuHvYaS0WxqRV+5MT5xobcFWIwYfKsYoTKXWac2/7aInI9W8I+e06RSUbr0hXdtKPf1SNmHwkSyTAmyQPsytue/74MhmL0zrXuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022705; c=relaxed/simple;
	bh=lwXA0QqFBtU9+BI+YgztEiteczC9ChdbfwyXfSOw7ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjPmUO/6WclpKDpVvmalSxhUpDrs6t9GeOTnd9sMIzz4V5aOifDVvyVQyIvd2myEzVru2dRuo5q/He1q35Lc+CC2GZ0tK05kh0gp6drUL7b43BEuE/XaE9UveTPup5RYxW1gaLLpzI+sRre9JPKmXiAFPzZElgmuJxzefe4gTY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JL3lhFNu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JL3lhFNu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03AEFC4CEF6;
	Tue, 12 Aug 2025 18:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022705;
	bh=lwXA0QqFBtU9+BI+YgztEiteczC9ChdbfwyXfSOw7ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JL3lhFNupPEqn0DsM0onBdgFFLdYjznFH0MB8ag/JvXbX9yYnVDGiC82jjgHMVUSb
	 YMgNKhfyNfJllT6xofQUEGCwpPSVBJ3+ASy10Zrqb6Hi0HkT5gDnuS/OxQEspJsSvJ
	 yUvI2udEpxYeYrN+gDxVpGv+u6RatY+wOBpKsaxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Roxell <anders.roxell@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 234/369] vdpa: Fix IDR memory leak in VDUSE module exit
Date: Tue, 12 Aug 2025 19:28:51 +0200
Message-ID: <20250812173023.574628701@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anders Roxell <anders.roxell@linaro.org>

[ Upstream commit d9ea58b5dc6b4b50fbb6a10c73f840e8b10442b7 ]

Add missing idr_destroy() call in vduse_exit() to properly free the
vduse_idr radix tree nodes. Without this, module load/unload cycles leak
576-byte radix tree node allocations, detectable by kmemleak as:

unreferenced object (size 576):
  backtrace:
    [<ffffffff81234567>] radix_tree_node_alloc+0xa0/0xf0
    [<ffffffff81234568>] idr_get_free+0x128/0x280

The vduse_idr is initialized via DEFINE_IDR() at line 136 and used throughout
the VDUSE (vDPA Device in Userspace) driver for device ID management. The fix
follows the documented pattern in lib/idr.c and matches the cleanup approach
used by other drivers.

This leak was discovered through comprehensive module testing with cumulative
kmemleak detection across 10 load/unload iterations per module.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
Message-Id: <20250704125335.1084649-1-anders.roxell@linaro.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index 7ae99691efdf..7f569ce8fc7b 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -2215,6 +2215,7 @@ static void vduse_exit(void)
 	cdev_del(&vduse_ctrl_cdev);
 	unregister_chrdev_region(vduse_major, VDUSE_DEV_MAX);
 	class_unregister(&vduse_class);
+	idr_destroy(&vduse_idr);
 }
 module_exit(vduse_exit);
 
-- 
2.39.5



