Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3556C198E96;
	Wed,  6 Nov 2024 12:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896433; cv=none; b=OGR9bfS/hNv1lcN49gKSFS9wUEiskxB5MKSNbPPw9cb+/ieIAotKnYTVndt+V7qdJuJW3WSsx+AhkX6lg5XKhYfTly7jkZuKhAIsytWX16H8fKsNrbiNRLNe8HFWJsCLblUbqnqy93aZmUhxj3I5ImsaqmCgoHsn/RVC0CCF5KM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896433; c=relaxed/simple;
	bh=GLvuFiHqGL+ye1VtF9UL5IOpScq3tpVEBEiHPjTGhEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YxGw/3Qu/VaoYR9B3/tWoj1+pOKwzt9piPWZ2n3PfAkwZa6gSSJRyVRltFxHPCZLWLuJKcP7XnuWOpK72KXFPFQFnhrVgkqkVKeRds2Ny70GuDXsed3mWOGzjtrC4pm4rOXDxiExo33YC9BIBtaoua3WU3jY097HpUbr7izdz5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X0rEhQon; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X0rEhQon"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD9C1C4CECD;
	Wed,  6 Nov 2024 12:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896433;
	bh=GLvuFiHqGL+ye1VtF9UL5IOpScq3tpVEBEiHPjTGhEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X0rEhQonJpTdqSCPb9M8bZw3i4KAEpQIQOe1Yp/YIdwVbuCHWixgZpxYxdaO7FflR
	 2E79yvnvvWFhpT7l6bDF0OBpUzI9AVoN9q+kkcb1W6lrS0/eUMGKrVDqQ8MaizaE6s
	 fWtX2JO7dugaoDDJvHSRe/mOKHPYQpuaYF1qPOnM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 163/245] cxl/acpi: Ensure ports ready at cxl_acpi_probe() return
Date: Wed,  6 Nov 2024 13:03:36 +0100
Message-ID: <20241106120323.247164425@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 48f62d38a07d464a499fa834638afcfd2b68f852 ]

In order to ensure root CXL ports are enabled upon cxl_acpi_probe()
when the 'cxl_port' driver is built as a module, arrange for the
module to be pre-loaded or built-in.

The "Fixes:" but no "Cc: stable" on this patch reflects that the issue
is merely by inspection since the bug that triggered the discovery of
this potential problem [1] is fixed by other means. However, a stable
backport should do no harm.

Fixes: 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver")
Link: http://lore.kernel.org/20241004212504.1246-1-gourry@gourry.net [1]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Tested-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/172964781969.81806.17276352414854540808.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/acpi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 82b78e331d8ed..432b7cfd12a8e 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -924,6 +924,13 @@ static void __exit cxl_acpi_exit(void)
 
 /* load before dax_hmem sees 'Soft Reserved' CXL ranges */
 subsys_initcall(cxl_acpi_init);
+
+/*
+ * Arrange for host-bridge ports to be active synchronous with
+ * cxl_acpi_probe() exit.
+ */
+MODULE_SOFTDEP("pre: cxl_port");
+
 module_exit(cxl_acpi_exit);
 MODULE_DESCRIPTION("CXL ACPI: Platform Support");
 MODULE_LICENSE("GPL v2");
-- 
2.43.0



