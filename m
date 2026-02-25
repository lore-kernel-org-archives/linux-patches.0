Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7E72C17A0;
	Wed, 25 Feb 2026 06:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002644; cv=none; b=N+pIrHLxOgyzngOY+yZYapOWH8SbXCkV936ydrkDxNzeMr49de4HbVafMSKEctIL/HLYnGNjTu3hrBdE7zBXMOAyXFmc3YL9x0GY7fb5mW9/apvuWboaYOj1+2tmYDJDpYzIkp/i7fO+sqUjBKAeGw5LfJk77cVTFLixZEe7jzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002644; c=relaxed/simple;
	bh=hhbliT3yuURcYFpV2N9dwG/8CEWBQMbZ2IAQ2vfVCr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kzsd+XDQwCccsVd4RT4xqHreop1UpwpWUytr97QMiXaXGJth+0WhwFEafIsb49qdHmZ6KORrByVXAdKbTRYs9jCa3rSDSIfESIkd8z9JNnicQp+SIglNha5Cf8dku6sc+GU6al4EegZMBIR03bjnQNc2jTPCU3Xz+nbktgUmBgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9xsLQkq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9xsLQkq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD81C19425;
	Wed, 25 Feb 2026 06:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002644;
	bh=hhbliT3yuURcYFpV2N9dwG/8CEWBQMbZ2IAQ2vfVCr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G9xsLQkqFVLtQ8YfysrdBwCg8z9OZBDfCJ7/I0olBX6cHXk4/dUn+4N46IB8DQIao
	 p1Tz46yvrkAqd1txs4iiShyRxGlR+cHYjIm1l7Ka1okdN/Eec+lfSVBiKuRd4XVpju
	 EhnFprVUw055GjqPnGt9YXjld3iTs+fO7oUeNQUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Cheatham <Benjamin.Cheatham@amd.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 377/641] cxl/core: Fix cxl_dport debugfs EINJ entries
Date: Tue, 24 Feb 2026 17:21:43 -0800
Message-ID: <20260225012357.732648598@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index 804e4a48540f6..85131872d7f6e 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -823,16 +823,18 @@ DEFINE_DEBUGFS_ATTRIBUTE(cxl_einj_inject_fops, NULL, cxl_einj_inject,
 
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



