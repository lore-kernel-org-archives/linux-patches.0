Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1237B36D9EA;
	Wed, 20 May 2026 16:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295935; cv=none; b=HRZ2hqJn5YX2PbePn22E6njmqczFqCkGf3JyKx3BvksBP4O1Znz5aPQQ1yaArk5HW+sAczRn8hKK6XNG7w2sgRoycacwVequRL9Nv5Lw5C/Cga9RNgaU9bRVAssKo4aK7/i3cLaUqHiACagiRkXyw57/DGfcTyq6DxyvoAHB7GM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295935; c=relaxed/simple;
	bh=D6aQgEtLC+dGoYRLW7Ycx3nLWOBqYp5W5EajzqgCXeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEOYUY7a/U1a9IXcbt/kjsaAOwsUCd13HepmYW6vqh9XWfqgd7R7Au8e9k4rcpSrpnUCI1rlI9Plhwc6rbctXnTPZXDXisdtqwJY/t2tnwc2vX80c4cjuV9nDD6040WejznhGfNRvsSrANtyN1nmffhvgmCqkhHvwqe2L69ykNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+DAupIS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+DAupIS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 780E41F000E9;
	Wed, 20 May 2026 16:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295934;
	bh=KLZ2UisTsf7I0oSbRIWZF+EiY2l9eP48GWBak9GiuwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+DAupISmwphNj9Jy/xlzhEXBTlYsbxogOHdEJvyNPQz76pYtxIXEw5/GjJep8vNx
	 a6CriAuGuxt493zoFGNe+Ewx5sDuMkoJJQ6ocq+aZeHuQsbxjI3uKK3GEcaUiEnPB6
	 ex8E98yX6TdxOu6ALVpMJCQaCXMUIJx/Py0utgYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Kai-Heng Feng <kaihengf@nvidia.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0568/1146] fwctl: Fix class init ordering to avoid NULL pointer dereference on device removal
Date: Wed, 20 May 2026 18:13:38 +0200
Message-ID: <20260520162201.039686504@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



