Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678F51AB505;
	Mon, 14 Oct 2024 15:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918226; cv=none; b=j8PXip5QTUPHWhxfQYqzxqLauE3Qo6UXCAE1eeyAxRtsvOOtDvJaP9jiMpO1S5xZ3M/Fu5BGOrDOwh6ez/+DR0+PhnNtEYRwZue9v3ehmX2jmpXC0Nnre49GWaMV8yNord/IcrG/3zVlnzIcYprqxHdfNuWGw7SLGRt6QeYcV10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918226; c=relaxed/simple;
	bh=hZ6IxC2lxVOxKKLzfHp5IHWBdZaJ4fflTRpvbxoi9/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkmVUcn7gipjmyL4B1VAjOnbJWj2YtXyvs+hmkB6nXX+6HCBYwyY8fvp7SeOfJ/SdgcrBw1qkZTSWwDY6q/2IUikbSh1wVdQ3tfYzyouIULLCkTZwRDM6/GKwxTJMLcZJv2dUqgcWP7YMSkyokbmLNJCkrOqBm2TcDga6r7yNss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzvcru5l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzvcru5l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9933C4CEC3;
	Mon, 14 Oct 2024 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918226;
	bh=hZ6IxC2lxVOxKKLzfHp5IHWBdZaJ4fflTRpvbxoi9/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzvcru5lsAaAqUEtPXmVWW9aW9adk7Fcl/H95FmPsMtba5MGigWaWOAqK4El8FiPO
	 zcA3zCnByvAvFfnQzkCZ7CquAU/NuTi7hfxHcrF/Cm6t3jPqnStnFWuqEej4oHUaeu
	 aPYCdA+Z0sRyKDO6cvod5BRx6wXJNJylFQ8uVRsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 229/798] ntb: intel: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Mon, 14 Oct 2024 16:13:03 +0200
Message-ID: <20241014141226.919803722@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit e229897d373a87ee09ec5cc4ecd4bb2f895fc16b ]

The debugfs_create_dir() function returns error pointers.
It never returns NULL. So use IS_ERR() to check it.

Fixes: e26a5843f7f5 ("NTB: Split ntb_hw_intel and ntb_transport drivers")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/intel/ntb_hw_gen1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/intel/ntb_hw_gen1.c b/drivers/ntb/hw/intel/ntb_hw_gen1.c
index 60a4ebc7bf35a..f647693f8f929 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen1.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen1.c
@@ -778,7 +778,7 @@ static void ndev_init_debugfs(struct intel_ntb_dev *ndev)
 		ndev->debugfs_dir =
 			debugfs_create_dir(pci_name(ndev->ntb.pdev),
 					   debugfs_dir);
-		if (!ndev->debugfs_dir)
+		if (IS_ERR(ndev->debugfs_dir))
 			ndev->debugfs_info = NULL;
 		else
 			ndev->debugfs_info =
-- 
2.43.0



