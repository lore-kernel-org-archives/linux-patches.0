Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320121DF25E;
	Tue,  8 Oct 2024 13:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728394097; cv=none; b=TNgO2ftyoclFK8ntkGuyo1Rpxe30p4d/10xZrG1GwQI3zRWCZ5TeM89Uurbg50oBcwLUdtJYEL6X78D90h0isO54kRQEtWwWiZRbOAvULJ8dr/9KV8SsNcHiSDACUeamhfNgwdrgaRUKTeMdaiqEclGRtXVGr2PpGVYQpY7mh5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728394097; c=relaxed/simple;
	bh=i8jTsL8R63fStE1NmLkaSdlP+1OYXE7/Fo8Rv0DEng0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7TMq1lVG56JhchcBLUTU4+Q7/G6Zkhp0YcZn31Apjv0L1jItWByiAZWzW0zsCc16zXI5zuG/azjcyd50Xzfr1v5AXgpMOYbkIuLWLj35hgn07FDeprniO+0iucobHhlIFrlXvJ2Y+LJj96kOFlkF/z+388n457ih9umU74WyRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mRLoVRp7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mRLoVRp7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FCEC4CECD;
	Tue,  8 Oct 2024 13:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728394097;
	bh=i8jTsL8R63fStE1NmLkaSdlP+1OYXE7/Fo8Rv0DEng0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mRLoVRp7lKLjrQdnnT/GSpw+nncLhijeHb9kf/V1rtmMiwcZbWByau/jDz63oDFsg
	 dYkvFfA9XCrmtrh9Mr7oZLWvNkEmUl36IDXpdlubyR4edaIohRaT8LgXD7OCJ5lgZr
	 ycSGD3okqc+lD7zisv7EWhlqZLoHsGog0qhCXK1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <longli@microsoft.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 346/386] RDMA/mana_ib: use the correct page table index based on hardware page size
Date: Tue,  8 Oct 2024 14:09:51 +0200
Message-ID: <20241008115642.998835670@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Li <longli@microsoft.com>

[ Upstream commit 9e517a8e9d9a303bf9bde35e5c5374795544c152 ]

MANA hardware uses 4k page size. When calculating the page table index,
it should use the hardware page size, not the system page size.

Cc: stable@vger.kernel.org
Fixes: 0266a177631d ("RDMA/mana_ib: Add a driver for Microsoft Azure Network Adapter")
Signed-off-by: Long Li <longli@microsoft.com>
Link: https://patch.msgid.link/1725030993-16213-1-git-send-email-longli@linuxonhyperv.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mana/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mana/main.c b/drivers/infiniband/hw/mana/main.c
index 5dd5b9803f4e5..85717482a616e 100644
--- a/drivers/infiniband/hw/mana/main.c
+++ b/drivers/infiniband/hw/mana/main.c
@@ -359,7 +359,7 @@ int mana_ib_gd_create_dma_region(struct mana_ib_dev *dev, struct ib_umem *umem,
 
 	create_req->length = umem->length;
 	create_req->offset_in_page = ib_umem_dma_offset(umem, page_sz);
-	create_req->gdma_page_type = order_base_2(page_sz) - PAGE_SHIFT;
+	create_req->gdma_page_type = order_base_2(page_sz) - MANA_PAGE_SHIFT;
 	create_req->page_count = num_pages_total;
 
 	ibdev_dbg(&dev->ib_dev, "size_dma_region %lu num_pages_total %lu\n",
-- 
2.43.0



