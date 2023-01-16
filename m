Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B38D6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D412AC433EF;
	Mon, 16 Jan 2023 16:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887376;
	bh=OfSAtDbt3kj2ZCKANMxfynTP3m4tHjRp7q2gzIzrGcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xgewTldzbfCgSbNMUUeVCB4S0hNf1XRc8+HZ3upXrjWfnTt810eEJ2SJA7ePs+9hc
	 7Y5FYhVhze7JZHTAETr+AHDitBPuws/qVLLDpfuJ9P/fiscvZ7gzzmgfVdJqy2mHXa
	 2ll9nlWweIMZm/tu5zf8w/YUoUFqQ4+ZeNYHdpS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 125/521] drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()
Date: Mon, 16 Jan 2023 16:46:27 +0100
Message-Id: <20230116154852.867874380@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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
index 8154d2d7fe9e..0246edecc61f 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -223,6 +223,7 @@ static bool radeon_atrm_get_bios(struct radeon_device *rdev)
 
 	if (!found)
 		return false;
+	pci_dev_put(pdev);
 
 	rdev->bios = kmalloc(size, GFP_KERNEL);
 	if (!rdev->bios) {
-- 
2.35.1



