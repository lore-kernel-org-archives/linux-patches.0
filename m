Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E9FE53163E;
	Thu, 17 Sep 2026 17:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664488; cv=none; b=nLGFyyxwNk3E4Sj5/ElpXH78zBxCrisDcY/KTNjkkNYqJqYa43WXlk1uCZEMJ5Bu7APB87q7rliisTTv1101DXpxCXO0USh2drSEXheF+yIt/yyfzCqkMNsCTz2XJAQb8ztosMkRPuINnLW+WHnipqXmEU5uVwsC11DmDkhBoQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664488; c=relaxed/simple;
	bh=mHmSd0MRBk5zCUFtuEXrkAqlApkDHgf4xW1xZEXC/gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Llmht2ejvEaVagRzF+MZBsyXwacc2mE+J4GnMl9LqPm5pawyhazq706KcetvPssfpGbOhK/C7w+8ELRu7LySblW/hzPpBvaDQfzjsxdBiEimYr1KcUhNirMlBl17xTcAwBLzSTGJlj2xkmHTCsMw30P4dQpqQILlDszU0GEFrnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RDbjOiEK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RDbjOiEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A206A1F000FF;
	Thu, 17 Sep 2026 17:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664487;
	bh=pZ2Ba0Qv4tQ2MoIWMNrv9yLE0cfs3SEW75Z6nnJfJvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDbjOiEKZBwNJ+I+iwhnXfGNjDRV6iDYinUOWebdScMN5gyKVsNpuMpta4+Kx2EjK
	 O7JI1Wr0VWzgV8mShvNYUP0uATqVv7cUNExbXPrvkfLgje2yxlLSRS2rGYaIICVngb
	 fn9S+aZSNUYzDpte3xuBnZbPJUHmzSaNid9MaFvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0357/1250] pds_core: quiesce DMA before freeing resources
Date: Thu, 17 Sep 2026 16:02:32 +0100
Message-ID: <20260917151601.743369154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d02e096a2c5fb..c8b64c79fde58 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -455,6 +455,8 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 {
 	int err;
 
+	pci_set_master(pdsc->pdev);
+
 	err = pdsc_dev_init(pdsc);
 	if (err)
 		return err;
@@ -487,6 +489,8 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	if (!pdsc->pdev->is_virtfn)
 		pdsc_devcmd_reset(pdsc);
 
+	pci_clear_master(pdsc->pdev);
+
 	pdsc_core_uninit(pdsc);
 
 	if (removing) {
-- 
2.53.0



