Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C123146D556;
	Tue, 21 Jul 2026 15:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649184; cv=none; b=s2dkxEyKYI9KTQEanNX9cAY1dlbU1W3y1+JsUHijGgxqrN0atG62aWn3JboZfRxAEIUPyzdhJP+sagClfYiJdmzUQcggG9q6lpZWqtcF0fW7Ztgcc3av5KLpAFPr4iU0XVzl9Z49mH0DWqx3Dv32N2NlRhEvzn5fc2UkCjVoEHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649184; c=relaxed/simple;
	bh=DLJ5zd4/W6UgN3EUKFpARnXQAzKAM+79l3Bk2S/Pi/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbu48YLk6HFhZywOxcGSKfTLTsZXGnaS+QkT/FCEugRz4jlXFXrDjXl9+eGYs/bKEQMawQdfsbCQNGsm7xIu0rqsnvdkRdLtMNL4mdL4zY4OoRbIw4BQffazxamlIPGJmV8xGRv4m9zSt9rSgcDXgk7vKpxdiYNpl/udqsgPcc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYBQKPgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYBQKPgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312441F00A3A;
	Tue, 21 Jul 2026 15:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649183;
	bh=WdXTdJMdTp6RSN8+UIsqfEJWpncwlhpqPU1+3IetoxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YYBQKPgThtkKLY3u2yBQIT8Pw29CP1PZisWCEUV+8u/UkIWa3F97jTInTIX2/PHYr
	 WY3TssXPpBy8mFzZ+rVRIcEeYHR08Ik0x911QyeOt9L1On4vtvOZqYbLh6Gjt8Yebm
	 LNc4czmpRNucPIYBduAYZDae9wjcnbWE8GC7zh+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Cheng <icheng@nvidia.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0482/2077] cxl/pci: Fix the incorrect check of pci_read_config_word() return
Date: Tue, 21 Jul 2026 17:02:35 +0200
Message-ID: <20260721152604.174836847@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Jiang <dave.jiang@intel.com>

[ Upstream commit 66782cfa0085369e2d8c861042f7c6d43431bdb3 ]

pci_read_config_word() returns PCIBIOS_* status on error which are
positive values. The check should be for non-zero values to indicate
error. Fix cxl_set_mem_enable() to check for non-zero return value
instead of negative value.

While fixing this, also convert the error to negative errno value when
returning on error path.

Fixes: 34e37b4c432c ("cxl/port: Enable HDM Capability after validating DVSEC Ranges")
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Assisted-by: Claude:claude-opus-4-8
Link: https://patch.msgid.link/20260604180154.1925149-2-dave.jiang@intel.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/pci.c b/drivers/cxl/core/pci.c
index d1f487b3d809ad..43885c59a7f246 100644
--- a/drivers/cxl/core/pci.c
+++ b/drivers/cxl/core/pci.c
@@ -187,8 +187,8 @@ static int cxl_set_mem_enable(struct cxl_dev_state *cxlds, u16 val)
 	int rc;
 
 	rc = pci_read_config_word(pdev, d + PCI_DVSEC_CXL_CTRL, &ctrl);
-	if (rc < 0)
-		return rc;
+	if (rc)
+		return pcibios_err_to_errno(rc);
 
 	if ((ctrl & PCI_DVSEC_CXL_MEM_ENABLE) == val)
 		return 1;
@@ -196,8 +196,8 @@ static int cxl_set_mem_enable(struct cxl_dev_state *cxlds, u16 val)
 	ctrl |= val;
 
 	rc = pci_write_config_word(pdev, d + PCI_DVSEC_CXL_CTRL, ctrl);
-	if (rc < 0)
-		return rc;
+	if (rc)
+		return pcibios_err_to_errno(rc);
 
 	return 0;
 }
-- 
2.53.0



