Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2620C4F403E;
	Thu, 17 Sep 2026 18:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668011; cv=none; b=lGwmawaHHeLQt2KUCID9KZ6KJdzV+kPb4w8l3ZYXad4xz3GIodhWE2Zd+SkEDeLtXDYkPI7Ziqkl5+kIUOPXuFa7bIm48+DkFw8YCyjYOyPQx7I5/PoWCjifmgwdgjP5A1TDk6egXJZC5Qv13LF3NxJkpDURBGrxdJ8oAvJ4gCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668011; c=relaxed/simple;
	bh=/IDXnEytmIS/nK77+WL4KEEecLIc7x6tP79uxM80j7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mxtvwg7/hnxyaLkPbVvKxj8zuekF8+Ooq8cbU8TlARaQNZi9qavMs72GUKWDrRV6dsVqKthYMiMKBieUPOeDKv2+7EUH9hE3Yf1RBOLwXkU+oRvgTvVEVIGqrzrDrRLKGPWk9qp5XlOUNL2IedRNAzwbaLEi6cDRBMErTl/0ZwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/6lWBTe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/6lWBTe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A8A1F00893;
	Thu, 17 Sep 2026 18:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668009;
	bh=qD/2+tRnZDOIPR2grBRrSk/8ahvsKODy0NTmW+WD+bY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/6lWBTeKgvVo6Q/ks6HOUd3UtkZiux8w81fqEaA0yZF8PFPqeTCD6QSagcER/kyn
	 TrnukRAYj2Hk4ZLZ67lNVP18ZQG/lQ4st/cgSBN+L8aA8cLENRHCHJjge3CJulWsMV
	 Oj91V269aIrYEWuC1Y7bcSrVhOFzfh0NzqxEpp9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0251/1102] pds_core: quiesce DMA before freeing resources
Date: Thu, 17 Sep 2026 16:03:14 +0100
Message-ID: <20260917151545.896673299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nikhil P. Rao <nikhil.rao@amd.com>

[ Upstream commit 6443f4f20bdae726fe01cf5946fba9742a0ffda6 ]

pdsc_teardown() frees DMA buffers but does not disable bus mastering,
leaving the device able to perform DMA after the buffers are freed.
This can lead to use-after-free if the device writes to freed memory.

Add pci_clear_master() to pdsc_teardown() to disable bus mastering
before freeing resources, ensuring all DMA is quiesced.

Add pci_set_master() to pdsc_setup() to re-enable bus mastering,
which is needed for the firmware recovery path since pdsc_teardown()
now disables it.

Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260604213637.3844317-1-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 276e61f043c5e..08d2fd793111f 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -449,6 +449,8 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 {
 	int err;
 
+	pci_set_master(pdsc->pdev);
+
 	err = pdsc_dev_init(pdsc);
 	if (err)
 		return err;
@@ -481,6 +483,8 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	if (!pdsc->pdev->is_virtfn)
 		pdsc_devcmd_reset(pdsc);
 
+	pci_clear_master(pdsc->pdev);
+
 	pdsc_core_uninit(pdsc);
 
 	if (removing) {
-- 
2.53.0



