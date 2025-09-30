Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE240846F;
	Tue, 30 Sep 2025 15:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244762; cv=none; b=PAPFXuWeWkYFR5OqoDt024Ac+Sva92XVDkK6N03qbVkajoaIAQtZB4a/QTkRAunWqNGiqWZ2M25vXBbMbduDziCvetAIpfOmf9OFy65Zb9UpuwOy0CTwPbqsKym5dZktOwF2rl3P+FxfSO4B14F1gr/lDaC0FOKOAWc+NAkt8Ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244762; c=relaxed/simple;
	bh=S/Z+2m+Qd9VO6T8tVY1C1HzZF3B/CDjtC5ZXNgID5Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZBw0EXtLb3/eWhjJOp3EPxXKt4O7pFxme9oHq8ULi59MBen6HT0z+f8vD9M5PE4dteukPbNpLIs5+cVgP48CHYtsV2icxQVb443wYasj8QQok0IOJLJLvAAouhRLjQZ2NBWNCr+taCU1cG8QrdDHofgyhaIt/X+n9yYCQg2MxeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prah/3vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prah/3vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C971C4CEF0;
	Tue, 30 Sep 2025 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244762;
	bh=S/Z+2m+Qd9VO6T8tVY1C1HzZF3B/CDjtC5ZXNgID5Os=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prah/3vdWw7cPhzLWcrCOL+qgGpmFfUkKX756sTapsVEhXYv0iiK7d8hL+ckt9+pE
	 dl+H5irIFxu6Gl/PEi+BlWsEacpyqzIuq/llpw5FPlBfxyPxulVz/P8cfdJAJCRr2G
	 LOLWK+ukmBYzIb2zY5vGzPAcWKeel8ukOXH6ZvU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 089/143] drm/xe/vf: Dont expose sysfs attributes not applicable for VFs
Date: Tue, 30 Sep 2025 16:46:53 +0200
Message-ID: <20250930143834.777688925@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 500dad428e5b0de4c1bdfa893822a6e06ddad0b5 ]

VFs can't read BMG_PCIE_CAP(0x138340) register nor access PCODE
(already guarded by the info.skip_pcode flag) so we shouldn't
expose attributes that require any of them to avoid errors like:

 [] xe 0000:03:00.1: [drm] Tile0: GT0: VF is trying to read an \
                     inaccessible register 0x138340+0x0
 [] RIP: 0010:xe_gt_sriov_vf_read32+0x6c2/0x9a0 [xe]
 [] Call Trace:
 []  xe_mmio_read32+0x110/0x280 [xe]
 []  auto_link_downgrade_capable_show+0x2e/0x70 [xe]
 []  dev_attr_show+0x1a/0x70
 []  sysfs_kf_seq_show+0xaa/0x120
 []  kernfs_seq_show+0x41/0x60

Fixes: 0e414bf7ad01 ("drm/xe: Expose PCIe link downgrade attributes")
Fixes: cdc36b66cd41 ("drm/xe: Expose fan control and voltage regulator version")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Lukasz Laguna <lukasz.laguna@intel.com>
Reviewed-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://lore.kernel.org/r/20250916170029.3313-2-michal.wajdeczko@intel.com
(cherry picked from commit a2d6223d224f333f705ed8495bf8bebfbc585c35)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_device_sysfs.c b/drivers/gpu/drm/xe/xe_device_sysfs.c
index b9440f8c781e3..652da4d294c0b 100644
--- a/drivers/gpu/drm/xe/xe_device_sysfs.c
+++ b/drivers/gpu/drm/xe/xe_device_sysfs.c
@@ -166,7 +166,7 @@ int xe_device_sysfs_init(struct xe_device *xe)
 			return ret;
 	}
 
-	if (xe->info.platform == XE_BATTLEMAGE) {
+	if (xe->info.platform == XE_BATTLEMAGE && !IS_SRIOV_VF(xe)) {
 		ret = sysfs_create_files(&dev->kobj, auto_link_downgrade_attrs);
 		if (ret)
 			return ret;
-- 
2.51.0



