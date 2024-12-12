Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC40215774;
	Thu, 12 Dec 2024 15:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017562; cv=none; b=RQT4kPXrX9enmmDAUwZeIUyHYgyt3MOeLMtfHNgRpB2nPccjODDbfUVmk9Af/fQ8WGAofsZQZodYJwj7r5drYOTqinCfqG75ng5DKhDSrFvV39VnyhQKMLNgi2AywclF7cD7ANQhgdt96lIEwoKmf/o+7YPXwl5G2P22LEkHHYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017562; c=relaxed/simple;
	bh=qGEJmUhj9Q8NzZbwZmHXxHyegz+hk7r5FiVCe0MHH2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuUQd20zYfl3gtoomEqDsMtchYW4Ad7rTCGNRki4xCcHGzKNhLVuRstDSSNub+c1JgP+fqGwamY+zfw9CE6WlthD31Aup0k6FjCJHvZ7tDeXR9NM6QNL+puqKNMMj72nSJWQgKzGD8CKyn+wkb5vm7iY+DuYN5ngZpuLNz8hr4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQy2G86+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQy2G86+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF76C4CEDE;
	Thu, 12 Dec 2024 15:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017561;
	bh=qGEJmUhj9Q8NzZbwZmHXxHyegz+hk7r5FiVCe0MHH2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQy2G86+nlu9Lsu6oolbXvLMIOoJul6lmBqCHS466mSNbFClvsS6vKZ6cvOBABKo7
	 jDIKGljzhNiD+o20Md7s+1+/dQa6Rn1iGgwOmyMFoXc5U4yOftx8U4Ib+q17Ler9Vu
	 Ma1WlbF501ZS4SFo8nqaWmTyrmySCF67nHIXleMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 6.6 048/356] igb: Fix potential invalid memory access in igb_init_module()
Date: Thu, 12 Dec 2024 15:56:07 +0100
Message-ID: <20241212144246.532070567@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 0566f83d206c7a864abcd741fe39d6e0ae5eef29 ]

The pci_register_driver() can fail and when this happened, the dca_notifier
needs to be unregistered, otherwise the dca_notifier can be called when
igb fails to install, resulting to invalid memory access.

Fixes: bbd98fe48a43 ("igb: Fix DCA errors and do not use context index for 82576")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 49b349fa22542..c38be2880efcf 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -665,6 +665,10 @@ static int __init igb_init_module(void)
 	dca_register_notify(&dca_notifier);
 #endif
 	ret = pci_register_driver(&igb_driver);
+#ifdef CONFIG_IGB_DCA
+	if (ret)
+		dca_unregister_notify(&dca_notifier);
+#endif
 	return ret;
 }
 
-- 
2.43.0



