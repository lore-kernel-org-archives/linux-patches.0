Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E88D2EAEA;
	Fri, 24 Nov 2023 18:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DEJ/cwKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 061B8C433C8;
	Fri, 24 Nov 2023 18:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852377;
	bh=/OxRqtQDiY84py3QbPsb8nT2kv8u+SDeWY5ztXFzHq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DEJ/cwKdftjhcbhIiiJRaPfD6rc/0t6mnLhaXIJiqvOUnL7Vqy77gUn/mbQ4H7B0i
	 2X+LhOAEQ2xd4tOG25BMNka7+j6lOh+yBDSuVUNrCOBeSsI2EPVmzbnVAofvCSgLm6
	 7Mo6nHbAyYWXfBUWbT1TJvL+zQwZDRwejPShHBTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@Huawei.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 296/372] cxl/region: Cleanup target list on attach error
Date: Fri, 24 Nov 2023 17:51:23 +0000
Message-ID: <20231124172020.295869644@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 86987c766276acf1289700cd38bd6d5b5a167fea ]

Jonathan noticed that the target list setup is not unwound completely
upon error. Undo all the setup in the 'err_decrement:' exit path.

Fixes: 27b3f8d13830 ("cxl/region: Program target lists")
Reported-by: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
Link: http://lore.kernel.org/r/20230208123031.00006990@Huawei.com
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: https://lore.kernel.org/r/167601996980.1924368.390423634911157277.stgit@dwillia2-xfh.jf.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 0718588c7aaa ("cxl/region: Do not try to cleanup after cxl_region_setup_targets() fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/region.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 99b0501066e57..bd1c511bba987 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1317,6 +1317,8 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 
 err_decrement:
 	p->nr_targets--;
+	cxled->pos = -1;
+	p->targets[pos] = NULL;
 err:
 	for (iter = ep_port; !is_cxl_root(iter);
 	     iter = to_cxl_port(iter->dev.parent))
-- 
2.42.0



