Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A7918D630;
	Thu, 15 Aug 2024 13:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730081; cv=none; b=Nhne4qh+ckC6jorBMhZLseQLG04rEtMnkYe+k+8C/EQhG2TNIc1ZHXUkjVjS1rDZH2BdGJB0+fW7fmvB1K5xM+dSN9WhDhYOT/P+RaMni5yA9qtXJY4ibCGgZQzYcWMy+zQnE8icHzvSrwQQw9S9g4KUaiiAdbItK/0Z7SBIqLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730081; c=relaxed/simple;
	bh=lY3vCT/H3sTaGWu2i+Imcd5KK/YKESz2bR72et841zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLHDEqXTezzuk3S9IbYsMlvwuA7t2hW9foWEgrDAJ/xkoVIqn2k3gwK+OiMY1oRmDXjjy6kJ0EM4M0vAC43CT1Iok/0me55yxrTIBFMNgaT/fP0nsND64FGoOdzZrJ4MN58+vGJsJxTUodIhFvWkvDFTwZr/MTxuPhZ831NOmIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQJzOSm/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQJzOSm/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFC2C32786;
	Thu, 15 Aug 2024 13:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730081;
	bh=lY3vCT/H3sTaGWu2i+Imcd5KK/YKESz2bR72et841zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RQJzOSm/C++5H07IFoJqawMcJFbhSEFwxh9QVMvvpLrJgkbhQi5OO0UKZfbZx9VM7
	 aPQlpf5jcE6rMz7vnJS+YX4W6mHw7wJqAcDxCQ6PuiaUUv0ueZ4qDXng9Z8cxhkkGS
	 /uXX5/GsQEw6J40U0i1X30eNcohBgnxiZUmkVEn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Richardson <rlance@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 268/484] dma: fix call order in dmam_free_coherent
Date: Thu, 15 Aug 2024 15:22:06 +0200
Message-ID: <20240815131951.754608393@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c9dbc8f5812b8..9e1a724ae7e7d 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -62,8 +62,8 @@ void dmam_free_coherent(struct device *dev, size_t size, void *vaddr,
 {
 	struct dma_devres match_data = { size, vaddr, dma_handle };
 
-	dma_free_coherent(dev, size, vaddr, dma_handle);
 	WARN_ON(devres_destroy(dev, dmam_release, dmam_match, &match_data));
+	dma_free_coherent(dev, size, vaddr, dma_handle);
 }
 EXPORT_SYMBOL(dmam_free_coherent);
 
-- 
2.43.0



