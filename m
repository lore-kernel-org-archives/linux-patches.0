Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01E61863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36D86C433D2;
	Wed, 28 Dec 2022 15:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239664;
	bh=i+rZrYsQF5L/j/g4JaaIbpwtUzmf4qv55bP3vVOFMHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DKc3OMBQccyCMFHKVelwwYpSnY/tT89sPwi6fRr91Vh1XQFYwn+bOBaJRStcXSx5O
	 NBaQguxl3dWW0Ydo2ATIevi/lt5hfjoeirmToXEyFmkPeqtHsVYoeLsNVuaxtumx/l
	 n9m1bAH9sI/Dj/eE4ybX/wprXoIY6t3V307a/LYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/731] drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()
Date: Wed, 28 Dec 2022 15:36:02 +0100
Message-Id: <20221228144303.952742881@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit 725a521a18734f65de05b8d353b5bd0d3ca4c37a ]

As comment of pci_get_class() says, it returns a pci_device with its
refcount increased and decreased the refcount for the input parameter
@from if it is not NULL.

If we break the loop in radeon_atrm_get_bios() with 'pdev' not NULL, we
need to call pci_dev_put() to decrease the refcount. Add the missing
pci_dev_put() to avoid refcount leak.

Fixes: d8ade3526b2a ("drm/radeon: handle non-VGA class pci devices with ATRM")
Fixes: c61e2775873f ("drm/radeon: split ATRM support out from the ATPX handler (v3)")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_bios.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 1d99c9a2b56e..63bdc9f6fc24 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -227,6 +227,7 @@ static bool radeon_atrm_get_bios(struct radeon_device *rdev)
 
 	if (!found)
 		return false;
+	pci_dev_put(pdev);
 
 	rdev->bios = kmalloc(size, GFP_KERNEL);
 	if (!rdev->bios) {
-- 
2.35.1



