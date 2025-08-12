Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890131DB92A;
	Tue, 12 Aug 2025 18:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023765; cv=none; b=CXdy3fUKJVI5JCVFzoKEdP6usWpSRBLNDo+35JlxS15KoarvPxPVT/8telPnNHfCw4Fj2yWUTPNcLsnnaGLi2XswJ5WmHLPatgNWkjHDV9pp5wYSDTSbXeWTAmSSba3KwRpjDms6Z8Ueg1+DKP7qdxLdxXVMG/qMigjpAHhw1KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023765; c=relaxed/simple;
	bh=/Xie4eJhInbXatZASg1gdnRp4+LHgyDxrVUONcSt5E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQMXhRZu5dDSVm1g/sZ2DbGzuMr4vkiR81sYRmnP8AaLMIMSHA9B+FojWJ3cvQ9pdAQYsNLnPKW/jvkqX2fo5u1AxpUN6T0wJbuYG71FYgFKZLH8qPwtE1arNndJi2brb1t/WL3gl632zVehDpvP1QDHHB/ZZ1e802YuSZOxPBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2YRy3ph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2YRy3ph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FFB6C4CEF0;
	Tue, 12 Aug 2025 18:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023765;
	bh=/Xie4eJhInbXatZASg1gdnRp4+LHgyDxrVUONcSt5E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2YRy3phX6jpcjjDGxlbfPAt8zdFSiHsyCSSVhLNEjdycMfGfRcHOP2mfVLfERlae
	 zZOEGuof1zisGSmdNmeid3QbjkYStxKqqrig+oU3jilPRlNqjfp0ctrqPpEVhI2nOL
	 CxPNanCHLkVJEI3TTluW4BjyFSfMaX7+SL1wCdLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huan Yang <link@vivo.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 131/627] udmabuf: fix vmap missed offset page
Date: Tue, 12 Aug 2025 19:27:06 +0200
Message-ID: <20250812173424.300477351@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huan Yang <link@vivo.com>

[ Upstream commit a26fd92b7223160ad31c3e2971b63178faed9cf5 ]

Before invoke vmap, we need offer a pages pointer array which each page
need to map in vmalloc area.

But currently vmap_udmabuf only set each folio's head page into pages,
missed each offset pages when iter.

This patch set the correctly offset page in each folio into array.

Signed-off-by: Huan Yang <link@vivo.com>
Fixes: 5e72b2b41a21 ("udmabuf: convert udmabuf driver to use folios")
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://lore.kernel.org/r/20250428073831.19942-3-link@vivo.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index 4cc342fb28f4..40399c26e6be 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -120,7 +120,8 @@ static int vmap_udmabuf(struct dma_buf *buf, struct iosys_map *map)
 		return -ENOMEM;
 
 	for (pg = 0; pg < ubuf->pagecount; pg++)
-		pages[pg] = &ubuf->folios[pg]->page;
+		pages[pg] = folio_page(ubuf->folios[pg],
+				       ubuf->offsets[pg] >> PAGE_SHIFT);
 
 	vaddr = vm_map_ram(pages, ubuf->pagecount, -1);
 	kvfree(pages);
-- 
2.39.5



