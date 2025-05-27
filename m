Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31DD41D88D7;
	Tue, 27 May 2025 17:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366559; cv=none; b=Ts1fMHz8Mm91x9GdBdpOEe3idB9Ia3dePKFCoxOHxNfLewoAjmCpFP0gzky5qD4ybIyekdsr41PcQsJID0Vd+vwFrTuTITJ5RvkH1D2iVHFAgoPQMPy4vp3vJEjrcLB61aRP2CzslvpoABNlGk5ZuvtfaMXn5CYxLS8CrJ/QdgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366559; c=relaxed/simple;
	bh=ZU4+HMVh+mVaW04fACHRYly9e0qHkLCbp0c8QcheBAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jT/fuNkIN+jXnGEi5nrnM/72ty3fegV6v245bSaUqaTIC2ZLKJkFq1eCrplbZwEmdCxE6WrOxGYFQORroA9bi1TqEmlzzfAwxe6+7R24LWpXsBTKe1ZpqNdTsj7FmW2OSQ1fKtUL4IsKbu6QBoT2MUcvsyALBaKSXcf/cWiQGAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C3csMofY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C3csMofY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD428C4CEE9;
	Tue, 27 May 2025 17:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366559;
	bh=ZU4+HMVh+mVaW04fACHRYly9e0qHkLCbp0c8QcheBAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C3csMofYfBEqzBlYZ1YGvWTQdxzrtM0M1VI+ZLXwl+71/808JTfekrS6Gn7vISM+s
	 GOpaXAZwrl+p5rytPQ9KjBPRRqaw3bVuBzCoIa/tW8ivuWH4J2Ymqjoq1Zl/C0J471
	 itjGtglW83+hDVDSS0ZC/tIZFBu6pezr5yeXg6ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Richter <rrichter@amd.com>,
	Pankaj Gupta <pankaj.gupta@amd.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 107/783] libnvdimm/labels: Fix divide error in nd_label_data_init()
Date: Tue, 27 May 2025 18:18:24 +0200
Message-ID: <20250527162517.502252696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <rrichter@amd.com>

[ Upstream commit ef1d3455bbc1922f94a91ed58d3d7db440652959 ]

If a faulty CXL memory device returns a broken zero LSA size in its
memory device information (Identify Memory Device (Opcode 4000h), CXL
spec. 3.1, 8.2.9.9.1.1), a divide error occurs in the libnvdimm
driver:

 Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
 RIP: 0010:nd_label_data_init+0x10e/0x800 [libnvdimm]

Code and flow:

1) CXL Command 4000h returns LSA size = 0
2) config_size is assigned to zero LSA size (CXL pmem driver):

drivers/cxl/pmem.c:             .config_size = mds->lsa_size,

3) max_xfer is set to zero (nvdimm driver):

drivers/nvdimm/label.c: max_xfer = min_t(size_t, ndd->nsarea.max_xfer, config_size);

4) A subsequent DIV_ROUND_UP() causes a division by zero:

drivers/nvdimm/label.c: /* Make our initial read size a multiple of max_xfer size */
drivers/nvdimm/label.c: read_size = min(DIV_ROUND_UP(read_size, max_xfer) * max_xfer,
drivers/nvdimm/label.c-                 config_size);

Fix this by checking the config size parameter by extending an
existing check.

Signed-off-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Link: https://patch.msgid.link/20250320112223.608320-1-rrichter@amd.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/label.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index 082253a3a9560..04f4a049599a1 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -442,7 +442,8 @@ int nd_label_data_init(struct nvdimm_drvdata *ndd)
 	if (ndd->data)
 		return 0;
 
-	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0) {
+	if (ndd->nsarea.status || ndd->nsarea.max_xfer == 0 ||
+	    ndd->nsarea.config_size == 0) {
 		dev_dbg(ndd->dev, "failed to init config data area: (%u:%u)\n",
 			ndd->nsarea.max_xfer, ndd->nsarea.config_size);
 		return -ENXIO;
-- 
2.39.5



