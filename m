Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9AF3F1AB8;
	Wed, 20 May 2026 17:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298620; cv=none; b=tvXUrrG9ZWUJ+pBLMAID6cyJ1H6kCHlHtsAJvvBDuOFqeGgWBC8D/iGRa1OA0iF2A7uIXDEQ94YvTgpXUDCmBmy+6FWQsgBR6xus1mCW/KjJ9ObtCOM8mnVx9hoKCz1gjf4+bDRG1sHAqHaChFgSV0x2Tgp4cBusk/Ve4btVcnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298620; c=relaxed/simple;
	bh=XV4cBgjOjJiw5REQQRJ9krJOxkkbSbemYJ5Yq/GxrTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWB1VgCMQsNVTVz7TL3nwgXGR2tHXlG5l9iR6OgrB51hublmo3DMwv+9fQ4hZ4pQFb9PvVowafJxTMEzXZ4DEsjBGxQSPJvomP1w3whoyD9hmm9xdcYw1GXM+QwTjdOPZ3o7Kzo3CRp6Pi1YXgmUCahDf3clz9V8dBjwkFef++s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JVFJ5fVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JVFJ5fVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1201F000E9;
	Wed, 20 May 2026 17:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298617;
	bh=ct0C7fnC0wFOdxNGwH5KDwkO3rthh5PG43UD7Ef0GPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JVFJ5fVFe0D2ZYj6EKq8IRQvswc7SIoEi+GbXqfsJc3kQCo+0NMLIx4L3ggQPivjn
	 HjztJ/L0mEJoRaDGLrA+9wvfaWZkUWztlkUVuF3P6VcJkxYA77+F6f83EWk+eTo6RP
	 JcKjPnU9ycSdw/JyRtBtr8yGeQP5N7Tp+Tui1bgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 442/957] fwctl: Fix class init ordering to avoid NULL pointer dereference on device removal
Date: Wed, 20 May 2026 18:15:25 +0200
Message-ID: <20260520162144.106252113@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Richard Cheng <icheng@nvidia.com>

[ Upstream commit a55f80233f384dc89ef3425b2e1dd0e6d44bcf29 ]

CXL is linked before fwctl in drivers/Makefile. Both use `module_init, so
`cxl_pci_driver_init()` runs first. When `cxl_pci_probe()` calls
`fwctl_register()` and then `device_add()`, fwctl_class is not yet
registered because fwctl_init() hasn't run, causing `class_to_subsys()` to
return NULL and skip knode_class initialization.

On device removal, `class_to_subsys()` returns non-NULL, and
`device_del()` calls `klist_del()` on the uninitialized knode, triggering
a NULL pointer dereference.

Fixes: 858ce2f56b52 ("cxl: Add FWCTL support to CXL")
Link: https://patch.msgid.link/r/20260409051902.40218-1-icheng@nvidia.com
Signed-off-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Kai-Heng Feng <kaihengf@nvidia.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/fwctl/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fwctl/main.c b/drivers/fwctl/main.c
index bc6378506296c..098c3824ad751 100644
--- a/drivers/fwctl/main.c
+++ b/drivers/fwctl/main.c
@@ -415,7 +415,7 @@ static void __exit fwctl_exit(void)
 	unregister_chrdev_region(fwctl_dev, FWCTL_MAX_DEVICES);
 }
 
-module_init(fwctl_init);
+subsys_initcall(fwctl_init);
 module_exit(fwctl_exit);
 MODULE_DESCRIPTION("fwctl device firmware access framework");
 MODULE_LICENSE("GPL");
-- 
2.53.0



