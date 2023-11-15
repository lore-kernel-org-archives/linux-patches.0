Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E66645BE4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 22:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fydxLBMV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E82C433C8;
	Wed, 15 Nov 2023 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700085786;
	bh=898njf3w9TXqTuKveEaqrULxkNF1nowpSJny7jhit1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fydxLBMVL4PZD4W2c1aBG1fuv6V5Hp8oEAI8M+B3YpJnwg+/D9NZOd94v5yQj0fQs
	 ADJ2hnjt0YwNbwL1V0k3ikivqVFMQtpOqhF+FgvwkovWlyvFh75qXo/szFO92X/IEA
	 obig+LmqG7xNxeswlCvV46Ag7iqznQD0/ieNEV3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 052/119] libnvdimm/of_pmem: Use devm_kstrdup instead of kstrdup and check its return value
Date: Wed, 15 Nov 2023 17:00:42 -0500
Message-ID: <20231115220134.243684764@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115220132.607437515@linuxfoundation.org>
References: <20231115220132.607437515@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit 6fd4ebfc4d61e3097b595ab2725d513e3bbd6739 ]

Use devm_kstrdup() instead of kstrdup() and check its return value to
avoid memory leak.

Fixes: 49bddc73d15c ("libnvdimm/of_pmem: Provide a unique name for bus provider")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/of_pmem.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/nvdimm/of_pmem.c
+++ b/drivers/nvdimm/of_pmem.c
@@ -42,7 +42,13 @@ static int of_pmem_region_probe(struct p
 		return -ENOMEM;
 
 	priv->bus_desc.attr_groups = bus_attr_groups;
-	priv->bus_desc.provider_name = kstrdup(pdev->name, GFP_KERNEL);
+	priv->bus_desc.provider_name = devm_kstrdup(&pdev->dev, pdev->name,
+							GFP_KERNEL);
+	if (!priv->bus_desc.provider_name) {
+		kfree(priv);
+		return -ENOMEM;
+	}
+
 	priv->bus_desc.module = THIS_MODULE;
 	priv->bus_desc.of_node = np;
 


