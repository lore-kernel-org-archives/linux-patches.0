Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 936AC242D9B;
	Wed, 25 Feb 2026 01:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983363; cv=none; b=FWGQwNI7U05Hci9PSgPLlBqSG9KczbjiJr2N48rnitubjQNTq+602U0bHx+c8xCKOeo8+QUBT2d92+Ng+918oxL5HoicibhjWPsItG4FLLGvRGFTWWURd8KuZfr7YIpuLY2VOkIONGkAts7d/96na09rkV/byTBINpZOz/R/v5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983363; c=relaxed/simple;
	bh=oSbFuhzIUPgjI229+V4YTeLFi7zfHOjAtNdp/KDwDA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+n5kbcNpGKP3h7Y9mSuRokG+q94tiK0fwgcmZ9PbTykD/ZPqyZSh+j0/j/wg/wtKRyPCCyL1EtZr9TrditYDn2glZrlKQbF+epgycxT6D7XF3uaW7JoZYewE8J+7lUBdNiG3G7+eTUCsOpVcKpj4jYen+1PwRjhAlZbJ7J0ls8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ltwvMBZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ltwvMBZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E486C116D0;
	Wed, 25 Feb 2026 01:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983363;
	bh=oSbFuhzIUPgjI229+V4YTeLFi7zfHOjAtNdp/KDwDA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ltwvMBZbj4NRTxNN9+z91BQW9ZR2MvMbYAkfLP7YWd705ItHCAKfI9hXD9Py5Yd2T
	 osnvCpCWxKO9GVpfu2YrgI66xpvvpWak9PN5gMsore67phMvURDf5ET2xsVyK/B4Nf
	 se0J80Quvo/4RqgKhGWwNOVG3IM2IawzcOHrsggU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cheatham <Benjamin.Cheatham@amd.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 482/781] cxl/core: Fix cxl_dport debugfs EINJ entries
Date: Tue, 24 Feb 2026 17:19:51 -0800
Message-ID: <20260225012411.634073285@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheatham, Benjamin <benjamin.cheatham@amd.com>

[ Upstream commit 4ed7952b9e87cf731ebc8251874416e60eb15230 ]

Protocol error injection is only valid for CXL 2.0+ root ports and CXL
1.1 memory-mapped downstream ports as per the ACPI v6.5 spec (Table
8-31). The core code currently creates an 'einj_inject' file in CXL debugfs
for all CXL 1.1 downstream ports and all PCI CXL 2.0+ downstream ports.
This results in debugfs EINJ files that won't work due to platform/spec
restrictions.

Fix by limiting 'einj_inject' file creation to only CXL 1.1 dports and
CXL 2.0+ root ports. Update the comment above the check to more accurately
represent the requirements expected by the EINJ module and ACPI spec.

Fixes: 8039804cfa73 ("cxl/core: Add CXL EINJ debugfs files")
Signed-off-by: Ben Cheatham <Benjamin.Cheatham@amd.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/6e9fb657-8264-4028-92e2-5428e2695bf1@amd.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/port.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 3310dbfae9d66..4717dcff264be 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -822,16 +822,18 @@ DEFINE_DEBUGFS_ATTRIBUTE(cxl_einj_inject_fops, NULL, cxl_einj_inject,
 
 static void cxl_debugfs_create_dport_dir(struct cxl_dport *dport)
 {
+	struct cxl_port *parent = parent_port_of(dport->port);
 	struct dentry *dir;
 
 	if (!einj_cxl_is_initialized())
 		return;
 
 	/*
-	 * dport_dev needs to be a PCIe port for CXL 2.0+ ports because
-	 * EINJ expects a dport SBDF to be specified for 2.0 error injection.
+	 * Protocol error injection is only available for CXL 2.0+ root ports
+	 * and CXL 1.1 downstream ports
 	 */
-	if (!dport->rch && !dev_is_pci(dport->dport_dev))
+	if (!dport->rch &&
+	    !(dev_is_pci(dport->dport_dev) && parent && is_cxl_root(parent)))
 		return;
 
 	dir = cxl_debugfs_create_dir(dev_name(dport->dport_dev));
-- 
2.51.0



