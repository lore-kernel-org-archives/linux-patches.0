Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07361D0F74;
	Wed,  2 Oct 2024 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880055; cv=none; b=f1Ovb2t6RcxW7Ur40YDQbVQgEoA/eoJhwxp0kFLx06groXgEsO6+G+J71hZDsbO/B7iET1No7duK4+xTIg+gxAkBoJYLYHYULcesqpeujvufDdHN32T9/8wSsZyV7UxlE98zw7oxqXmuUA3Bx94s3cE6MsMGOcYUZtMqRhBKn4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880055; c=relaxed/simple;
	bh=pYw/1rUmoaUuSXzwY7JG/A8wbKYbp0CU2bFt95fuYDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRuIa1nFbreRDnMmmTF4XWmg4XgpLFHC7h7k9nkQJ7ciMIXUZBF5Kk++VVNYPuFsK/Lr/GrpsKCBgXRnp43S0YZgoalNIAkDo+pNLjYrVxJ4MoD6NZ/5apCs+4Gx6OB3En2ezOm7S7htgdoHd8gG2SmobPvMxBd5gBDiSfq1tK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H4v/WX2u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H4v/WX2u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C32C4CEC2;
	Wed,  2 Oct 2024 14:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880055;
	bh=pYw/1rUmoaUuSXzwY7JG/A8wbKYbp0CU2bFt95fuYDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H4v/WX2uJD3m5CrQbLkPZYWEe77sLSHhSp91lyVoIAiRImP2GzGgktJoH7a23PT29
	 3PCV1daOIYNz4q99KMq1+Y+gbZ6LxHG9FRUH+ChABFffntaaSTCXYYqmGQQ/CKEIG1
	 G92LwfrLUeMmpDfUMLnZoN/oJ3hPYDS4InwElYZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 327/538] ntb: intel: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Wed,  2 Oct 2024 14:59:26 +0200
Message-ID: <20241002125805.338450666@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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
index 9ab836d0d4f12..079b8cd797857 100644
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



