Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B2511D0B91;
	Wed,  2 Oct 2024 13:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876474; cv=none; b=NsoAAKdTlH2wrJ99Y4NOsxH+gufpHcaZV/r9Mi4Zthuw1pCyB5Mo/0XS/Fch6cL5VC1zkK0aJSB39zR6zEK1rjPVOk5KjD4WCCBDXulJo9PKaLyOSp00yo5bZSuGxX/1nuRRvh9MCiJTKdy0wV4Q4xlf2cqs1Ds16FQhbhO0AXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876474; c=relaxed/simple;
	bh=m3UJU86oE6qp9+R43LVcezlzSMzLapK10ohy5b/hAYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpI7+ZKfmlSMZZlnLQveXvTqRXtLp4guBXAiUoJosgEBkRRdweiKPHhBX7lWFf2Y0lezgjFF1aaV0hLo/6TrL3xlxRdTr4RHd41fUG5wsBtzM/lVnmUNbflgrhkNoETugEdf4ahEGRax7H30oEoBVe3h/0X45/NC1RDd6TSZd28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oSh7tLte; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oSh7tLte"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 859D4C4CEC5;
	Wed,  2 Oct 2024 13:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876473;
	bh=m3UJU86oE6qp9+R43LVcezlzSMzLapK10ohy5b/hAYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oSh7tLte1FLMxd70TABVBPXbU4/T7B9eyqgym5lWilefYGWDJJDFXE9Uf4TCF8X3D
	 ZmIqc7aeWEg6pduA442sYH/Mpfkw2ajF8hmkQ1LT2LzvMY4dZrFydWNmd/YBCaVMML
	 1SxopVnGLxgNLOt2ynU37um/g1zuBtJtkQcoYaOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 425/695] ntb: intel: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Wed,  2 Oct 2024 14:57:03 +0200
Message-ID: <20241002125839.421970648@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



