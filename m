Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E771EC017;
	Wed,  6 Nov 2024 13:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898092; cv=none; b=SVpwyCPFnDNI8MmXwsLenW46BeHHssqIl9jpVzawcHU0sT4R73PUZDuUZOHHnsUBvVU7+gcJ/mjZrjBaSxB/5edVnh86Ii6bKo3P/kRqIX9O/QBjlyO6z3oWwHgkfbccGGgWkQiZgnlD7Kgc4iFyzGPSDa8dSRWGzfN3vEbNilI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898092; c=relaxed/simple;
	bh=pRXzOAsu2edH+ne0RLDGczJWOeUW/vOMIotKj0N9Wbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCJAIYbE8yHhJj7e6C5oDEe+ABS0Li0lS0BYzohWnYA82edVUv3+gvPGNMDOqvVqvD4ayH4aFMccPXn7z3J3WzzMFBIIVC1lel+LgFvaPTAC40T1Jgy+lLQm0gjkG47QhGK0VJtopgsszQAVLuQwRJ/p77/dPlZTBxQNdFy2OLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTE62uMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTE62uMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87178C4CED3;
	Wed,  6 Nov 2024 13:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898091;
	bh=pRXzOAsu2edH+ne0RLDGczJWOeUW/vOMIotKj0N9Wbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTE62uMbCXa4SpuC9LROOBn5dpBsRDOb+/FSUyuZTB75fiqe0yNDYGeptZnzly6cr
	 paYhyn01/JKq91hKiQ3KrEsiOKC/XW0offVvoPfOjZSSGKipiRXapL0RNb46ghQYl+
	 s65RtwkVFLxfsEO9eC6ahtMbueAHnPMnVu+bskvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/462] ntb: intel: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Wed,  6 Nov 2024 13:00:15 +0100
Message-ID: <20241106120334.519919979@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 8d8739bff9f3c..6fd5d5e21e36a 100644
--- a/drivers/ntb/hw/intel/ntb_hw_gen1.c
+++ b/drivers/ntb/hw/intel/ntb_hw_gen1.c
@@ -775,7 +775,7 @@ static void ndev_init_debugfs(struct intel_ntb_dev *ndev)
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



