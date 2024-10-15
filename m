Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFCD41CFEA9;
	Tue, 15 Oct 2024 11:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992918; cv=none; b=HQMew1EgDsPG8VUno/oSqK8aShShaO/Me6UelOAYSYpaVwXeecueXaTWSBVN8aV3/DCqiPwX2WxtF31RtaIztZeNjxZ68E+fQMtxiF20FhwDQPN6/y4enGEhESgDHqMGgirkBBwibwGezvUJU/Cnk8Jz1enP6mVxBU7iTf8ID04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992918; c=relaxed/simple;
	bh=PyntYH5wYqgzk5/2hrm6YL0ecjqRRVdAnhvPIAHqmMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gku52TrbuyVYTboAkq1AiMJ76ijFJlbqEQKAaBrtaL6LSbhZGzegLz/1gT6J/nP2zgMZpeKPR3twImwCtHSziWHo4Mme6PXo7C2PQp2NIa+k8l+u4kFR4Yxo4piX8wZSAGngmhK9a6nDrcA43KlkiKqAVAXWuX3VLRZQGqdAu44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIJ30RCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIJ30RCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C459C4CEC6;
	Tue, 15 Oct 2024 11:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992918;
	bh=PyntYH5wYqgzk5/2hrm6YL0ecjqRRVdAnhvPIAHqmMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIJ30RCd+g3lw8e2V7srM7vehgX6gWfMXH73pCG8A5IglWynImKWOd2HvqIzSP5D7
	 GrJ+1nvy6XwSg7IE+3+Drf7hjWB7P7bz/vFBlP6+NF8KdRtCf9Mz37zSVAf/oEKBCt
	 j8ZgyS9WHRXuzIhc/KIabkzy4W8yGnpoqCpDQAcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/691] ntb: intel: Fix the NULL vs IS_ERR() bug for debugfs_create_dir()
Date: Tue, 15 Oct 2024 13:23:26 +0200
Message-ID: <20241015112450.589967711@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 41897167abc71..e0a5744372532 100644
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



