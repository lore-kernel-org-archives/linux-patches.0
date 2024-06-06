Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43A1197A65;
	Thu,  6 Jun 2024 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682996; cv=none; b=sQsE33q6UPL8EYQEDGc8/h30S7D61k5kqJmp695RT4XAtuJHPmEnRekZj17D0sd+vMuPAqKGMljt8K2aDmCiZwJHGHfvUx0Cp2nUw2fqrS80hRnq/VXS3zVpa2bnpvKKm3sJcLWCid7+K2+NqnIN5qQLGIQS7liBxy/1f3nJGB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682996; c=relaxed/simple;
	bh=muep+J0ukVMnV4ScOBjqyCPJpAFWUacsaIETRCM3ZEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hv8XeXFScE+IMsonE6laXlfHYKRKn4+0pzCUMnxgJZLmHthpyWPxxFwf0Ap4D06S5lODs9k/Ue4OvK6NU1KS5gjgkDnLzfhkLGOoT1UapyBGSdbqsmPLOvqEJ0V5AeIVJIGHp5aG8bhx+SqErZF+oHG/rEdJF5k6JcSLD4pbZHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bN69Cas; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bN69Cas"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4DEC2BD10;
	Thu,  6 Jun 2024 14:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682996;
	bh=muep+J0ukVMnV4ScOBjqyCPJpAFWUacsaIETRCM3ZEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bN69CasNAQ3w/lRsa2j7MbKdtQLD8fulQV9nK8tWDlGR8oT3zwxPL+UBfX6IgIAC
	 vst7zpE0ixYvlI/nT78oJ/ohd9vIlFiJ7SdHXoC4lE33O3bedncQ5V/ycsLG0vtNuL
	 6PSuPiJz0wVnDRo9+X4baOki9cLmewmeuho1R9Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 196/374] cxl/region: Fix cxlr_pmem leaks
Date: Thu,  6 Jun 2024 16:02:55 +0200
Message-ID: <20240606131658.416247243@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 1c987cf22d6b65ade46145c03eef13f0e3e81d83 ]

Before this error path, cxlr_pmem pointed to a kzalloc() memory, free
it to avoid this memory leaking.

Fixes: f17b558d6663 ("cxl/pmem: Refactor nvdimm device registration, delete the workqueue")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/20240428030748.318985-1-lizhijian@fujitsu.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 5c186e0a39b96..812b2948b6c65 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2719,6 +2719,7 @@ static struct cxl_pmem_region *cxl_pmem_region_alloc(struct cxl_region *cxlr)
 		if (i == 0) {
 			cxl_nvb = cxl_find_nvdimm_bridge(cxlmd);
 			if (!cxl_nvb) {
+				kfree(cxlr_pmem);
 				cxlr_pmem = ERR_PTR(-ENODEV);
 				goto out;
 			}
-- 
2.43.0



