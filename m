Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8BD1F4FBB;
	Wed,  6 Nov 2024 12:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897637; cv=none; b=Fx91d2F07Z36pf3uxAf3UR3jy2tMRh6s2aTKNV9wJ0oQy8fesweyCAjBY1GudIJi+uNAGOExMNPrqN6Kf2Bk1O81QXwIsXPjllbzp/4xnrc7kJycNUejy2fOHaOBQ7zSGwa07+y8z7yZfU7RRO9lwRLMploa+pJJKMEbw2mynk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897637; c=relaxed/simple;
	bh=dfNmGu+kGUQb7EX/fL3j6GKQu+DYgKn4VtEZlqXIBQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmfFfeqY6siSC8cM1HCV9MtlBEr4/M9mVPj8Ul8PU6E7oclpxPlLSw6zEPmq7PMgn3aQW48doA7nxzvqr2wZYGBiXSi/EbUSH+8schOQklJmadWZrnmTuTFPThWX6lBLa987zkLEYz1iVOv9mQJdKLe9UGwEUDxM4JUQX7U5od0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A+uFZt8r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A+uFZt8r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A3FC4CECD;
	Wed,  6 Nov 2024 12:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897636;
	bh=dfNmGu+kGUQb7EX/fL3j6GKQu+DYgKn4VtEZlqXIBQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A+uFZt8rFgnyC3fHl/BQYde44b+GZyv1mZZtmnRJFHvAONwoiwnScTMSyUM5/PP2d
	 +XaERG3jrQxvK9nC2w5F77EMI4OvA0jrSrw7JLj9ChzmrO/nyL6OdBeXLjnV7W1NVP
	 c4pOc2hv7pQt5sphlcKuwn71ZNtNTlMmud+gfWSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Williams <dan.j.williams@intel.com>,
	Gregory Price <gourry@gourry.net>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 121/151] cxl/acpi: Ensure ports ready at cxl_acpi_probe() return
Date: Wed,  6 Nov 2024 13:05:09 +0100
Message-ID: <20241106120312.195262451@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4319534558309..9a881a764cf35 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -768,6 +768,13 @@ static void __exit cxl_acpi_exit(void)
 
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
 MODULE_LICENSE("GPL v2");
 MODULE_IMPORT_NS(CXL);
-- 
2.43.0



