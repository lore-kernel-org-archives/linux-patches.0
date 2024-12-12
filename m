Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806D9229683;
	Thu, 12 Dec 2024 16:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021343; cv=none; b=Ed3O+27M63dF/l1RuflXIo2cuJZTNMlRZZEwjBSOgAxCCQ+1bxMsoi2pm5fnpZ+VvHFHenq3mpjzIDtPDSSYVzWOEqbumBTgP/Wt1eT6IsPm6ubeZzOTPgCi9a4cc5wJebrA0QOyOd3lyajS1o5wWGLsoTrvyviW1fwekA25NdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021343; c=relaxed/simple;
	bh=ac+MiWKbYW3vYfPi6TVNULgG8bnIX3a/vARLXro6xVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kmmGDevpHJod/YCQ4qKEbp9fHBJEVWaZ/54a116NcHhlHq+zcAe/v8DB95xI5CUcPL4J71wTTKYMUa3DNdf+rFQfriigO+wFjLFRG1S2wn+AQkw7L0b4Y3eUAI8Ouqufu0y8LvXvbJECqa5jKrjR4TAs+4Fs1xuUD1t+lAbDTkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWNGMY3z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWNGMY3z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9AD8C4CECE;
	Thu, 12 Dec 2024 16:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021343;
	bh=ac+MiWKbYW3vYfPi6TVNULgG8bnIX3a/vARLXro6xVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWNGMY3z1MtgrVIzwoGMr9sb9Cvv19yNefaYOln4gxzbOLXGgOkO++b1GpzQIMiY6
	 qyG0KlkzUjj3t8pPi+Ph9F+y9McwF10iToci+lO/Vt4hmAJZk07QUZfxj/GxQkDScH
	 q1hBx8quW6IZ37d+T0cDFl5XGnqthcLrEw2dkBRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 710/772] nvdimm: rectify the illogical code within nd_dax_probe()
Date: Thu, 12 Dec 2024 16:00:55 +0100
Message-ID: <20241212144419.234293798@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit b61352101470f8b68c98af674e187cfaa7c43504 ]

When nd_dax is NULL, nd_pfn is consequently NULL as well. Nevertheless,
it is inadvisable to perform pointer arithmetic or address-taking on a
NULL pointer.
Introduce the nd_dax_devinit() function to enhance the code's logic and
improve its readability.

Signed-off-by: Yi Yang <yiyang13@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20241108085526.527957-1-yiyang13@huawei.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/dax_devs.c | 4 ++--
 drivers/nvdimm/nd.h       | 7 +++++++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index 7f4a9d28b6702..5cafca6ba1da3 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -106,12 +106,12 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 
 	nvdimm_bus_lock(&ndns->dev);
 	nd_dax = nd_dax_alloc(nd_region);
-	nd_pfn = &nd_dax->nd_pfn;
-	dax_dev = nd_pfn_devinit(nd_pfn, ndns);
+	dax_dev = nd_dax_devinit(nd_dax, ndns);
 	nvdimm_bus_unlock(&ndns->dev);
 	if (!dax_dev)
 		return -ENOMEM;
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
+	nd_pfn = &nd_dax->nd_pfn;
 	nd_pfn->pfn_sb = pfn_sb;
 	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
 	dev_dbg(dev, "dax: %s\n", rc == 0 ? dev_name(dax_dev) : "<none>");
diff --git a/drivers/nvdimm/nd.h b/drivers/nvdimm/nd.h
index ec5219680092d..cce728f5409d6 100644
--- a/drivers/nvdimm/nd.h
+++ b/drivers/nvdimm/nd.h
@@ -601,6 +601,13 @@ struct nd_dax *to_nd_dax(struct device *dev);
 int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns);
 bool is_nd_dax(struct device *dev);
 struct device *nd_dax_create(struct nd_region *nd_region);
+static inline struct device *nd_dax_devinit(struct nd_dax *nd_dax,
+					    struct nd_namespace_common *ndns)
+{
+	if (!nd_dax)
+		return NULL;
+	return nd_pfn_devinit(&nd_dax->nd_pfn, ndns);
+}
 #else
 static inline int nd_dax_probe(struct device *dev,
 		struct nd_namespace_common *ndns)
-- 
2.43.0



