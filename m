Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A6F184549;
	Tue, 30 Jul 2024 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358618; cv=none; b=RSCcoxPmoWrseCKogl/891st9PacDyti0K9/hMbscprnTcSSk7yWH1o1o6JEv1Rh26jVufmoOfZKSsCI2vJbeFqfq9jpKdz9i161FZ9dW/VP79uq6MzRds0FDXqCTEdPq39dHgLuHuACwijFtqxUEJL3vZ3Ylj2eNO0BJiFQWw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358618; c=relaxed/simple;
	bh=96H8SNTIovS7q0TCenF6n7BkRtB/L1HJf/kf93WRcnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouFy6a+WMpTIv3mj/PftTzkutSLf4l5Dfb3i7t6wN3Qo/Ur1UbAFj+OjYv9kAPW7e0pj06DyooidAGQ0cmSBqBRbmy10hWADUbiZgvs2JN+nBtOUdxzEghs2xTDFmBPfG+SFHUDZAYioQyLdPssJ0Yv7XBksLxHCnlIEuRyTYPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zHSP0ctn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zHSP0ctn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE58C4AF0A;
	Tue, 30 Jul 2024 16:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358617;
	bh=96H8SNTIovS7q0TCenF6n7BkRtB/L1HJf/kf93WRcnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zHSP0ctnKx8rKATWE659drW/qxp9vEXvMqsObSChyYbpxdD3HWYv9Wra2Z81ClHh7
	 S2yDHseih2N8mb6UfqduR1lFNVE+VKAn7WwKhrRFz4rEDwk/er2B7n1k7AyLsw/+B0
	 zr+VwGSNVBhXPPJg2pUrPK4vZ8KDzoBrzn8FIGIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lance Richardson <rlance@google.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 407/440] dma: fix call order in dmam_free_coherent
Date: Tue, 30 Jul 2024 17:50:40 +0200
Message-ID: <20240730151631.693137784@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 33437d6206445..f1051ad0da7cc 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -63,8 +63,8 @@ void dmam_free_coherent(struct device *dev, size_t size, void *vaddr,
 {
 	struct dma_devres match_data = { size, vaddr, dma_handle };
 
-	dma_free_coherent(dev, size, vaddr, dma_handle);
 	WARN_ON(devres_destroy(dev, dmam_release, dmam_match, &match_data));
+	dma_free_coherent(dev, size, vaddr, dma_handle);
 }
 EXPORT_SYMBOL(dmam_free_coherent);
 
-- 
2.43.0



