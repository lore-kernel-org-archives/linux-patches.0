Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24BE1A76AD;
	Tue, 30 Jul 2024 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360631; cv=none; b=PmkeqfMVxIhe+7GJLiAzdlk3X4l/N73u0S8uGtVMpqpYu5owUxNSOAO2OcAzqmUxrwiqtOwiBBw6mwA5VdaF/F0kd2NxJqx3DdnAF9qpsxt2cuFhGCgdhkbCIR47qm20MTFg3p7AupaPgSchP1Dob5IiaSF0NhdlEysX7mx3uug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360631; c=relaxed/simple;
	bh=d8KQelsp+4Gm2TVu0wv72jY1sYG6pMrjV2ennU1u9p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KqxoG5C9PAPynBvhXcyP0byyj01+3XZZyhgejP66r9UkjMWJm8LGc7yPpHZ0f9yYxB99MhanqgEvEICBRP+sCnaEU+dqVRZoBUTntz4ok9NOPT/VvllMK6Rz9tRU5QyykckpiFRqQnVs2qZYteeNjw336dgR3N/QRr9AoRriIrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+BXycJ4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+BXycJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D901C32782;
	Tue, 30 Jul 2024 17:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360631;
	bh=d8KQelsp+4Gm2TVu0wv72jY1sYG6pMrjV2ennU1u9p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+BXycJ4+ULJJl7/JIGipTvrXMfHWQ1kfnMPJ+lBeMM5QjFo4sBRcVWxMfA/QVATg
	 dtWiNxLS+4LkAQghrFQxPdTLkcZSsSGTNwYZXN+dCZN6Rhy9xsMj2sDGy0AB9xhQF3
	 C81Oi6Tv0T0ow+cEHJ4cXA0LxQSPwuEObZ7GIgxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Richardson <rlance@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 757/809] dma: fix call order in dmam_free_coherent
Date: Tue, 30 Jul 2024 17:50:33 +0200
Message-ID: <20240730151754.860039249@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 81de84318ccc7..b1c18058d55f8 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -67,8 +67,8 @@ void dmam_free_coherent(struct device *dev, size_t size, void *vaddr,
 {
 	struct dma_devres match_data = { size, vaddr, dma_handle };
 
-	dma_free_coherent(dev, size, vaddr, dma_handle);
 	WARN_ON(devres_destroy(dev, dmam_release, dmam_match, &match_data));
+	dma_free_coherent(dev, size, vaddr, dma_handle);
 }
 EXPORT_SYMBOL(dmam_free_coherent);
 
-- 
2.43.0



