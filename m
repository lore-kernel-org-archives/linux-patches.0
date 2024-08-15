Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76581AC8BB;
	Thu, 15 Aug 2024 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731465; cv=none; b=N4wSWGZRH0z/weXhmlfSlMdIUfr4LWy7/LIci9zlO2WfcYY8xg7E1Ay4/Zed25paQXaYbNWywA0EtleZscZO/RsU9ABWeuQsHA6vZaDRzeyG1v88RJ5iZD0bh/R/FaHTkOZxwnrCFmCEU7BRDm2lhjH8LYFe19IsnwXw2rW8vRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731465; c=relaxed/simple;
	bh=xKuV/1YctkFHOk3Tt8agFAEJZ23HPWLyu1E7yXIN4uA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MFWSypDMFrJ5RwVH2eyJzPJGbhIWPqg5N/NH3jsetEdo1NGzQsTjPr7o/EYWB/VqwA0Ee+Hx6sAws36JBI9Q6DtwU8L9gPGvz/P6f6pCao7OX9YRglIyhdaTlqB1FL53Iw8LjoC34Jg8pg6bRPJSu2VkFE9TrVjQKx1sjMYBpzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BlwbTzPj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BlwbTzPj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22030C32786;
	Thu, 15 Aug 2024 14:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731465;
	bh=xKuV/1YctkFHOk3Tt8agFAEJZ23HPWLyu1E7yXIN4uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BlwbTzPj0W8AMjmapFBbFtmLiy+aCjjRow0fmehrpgn66+uGCk49/mJ8H0++/RU9g
	 7BdRqm7yrIprwYfZkKnnhKupPVc35c1to57BGfvFGG4Wxihy7Nh/Cu3diBgbaObYKe
	 v+yELz9LTY+6zxTHsPxDPmg4bT17Im8A+8t34b9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Richardson <rlance@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/259] dma: fix call order in dmam_free_coherent
Date: Thu, 15 Aug 2024 15:24:32 +0200
Message-ID: <20240815131908.160942711@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

From: Lance Richardson <rlance@google.com>

[ Upstream commit 28e8b7406d3a1f5329a03aa25a43aa28e087cb20 ]

dmam_free_coherent() frees a DMA allocation, which makes the
freed vaddr available for reuse, then calls devres_destroy()
to remove and free the data structure used to track the DMA
allocation. Between the two calls, it is possible for a
concurrent task to make an allocation with the same vaddr
and add it to the devres list.

If this happens, there will be two entries in the devres list
with the same vaddr and devres_destroy() can free the wrong
entry, triggering the WARN_ON() in dmam_match.

Fix by destroying the devres entry before freeing the DMA
allocation.

Tested:
  kokonut //net/encryption
    http://sponge2/b9145fe6-0f72-4325-ac2f-a84d81075b03

Fixes: 9ac7849e35f7 ("devres: device resource management")
Signed-off-by: Lance Richardson <rlance@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/mapping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index 8682a5305cb36..942e489bc1fcb 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -59,8 +59,8 @@ void dmam_free_coherent(struct device *dev, size_t size, void *vaddr,
 {
 	struct dma_devres match_data = { size, vaddr, dma_handle };
 
-	dma_free_coherent(dev, size, vaddr, dma_handle);
 	WARN_ON(devres_destroy(dev, dmam_release, dmam_match, &match_data));
+	dma_free_coherent(dev, size, vaddr, dma_handle);
 }
 EXPORT_SYMBOL(dmam_free_coherent);
 
-- 
2.43.0



