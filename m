Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBEA6FB1;
	Tue,  5 Dec 2023 03:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n0Pshky4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 228F2C433C8;
	Tue,  5 Dec 2023 03:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747371;
	bh=iNf1AvLg4oipGEt0ZY5SbZyaqgz3LRjjiU/gFdLCgjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n0Pshky4fzZCbw1j3iSbRZs//suXKf59fzKRPPrpzHzCyEHtAK6f2TLwlrGSw/3Fu
	 hNmRinHw1z33/cQ97F9uBoHnJMAgUZvQbzm9lWAaAWhmLZFWLe1hGJN+OrRBbTMIjH
	 mScDjb4989Po3R7/oblv3iHyzXjvlSHxgXG1UurA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Juergen Gross <jgross@suse.com>
Subject: [PATCH 5.10 050/135] swiotlb-xen: provide the "max_mapping_size" method
Date: Tue,  5 Dec 2023 12:16:11 +0900
Message-ID: <20231205031533.665457847@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031530.557782248@linuxfoundation.org>
References: <20231205031530.557782248@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

commit bff2a2d453a1b683378b4508b86b84389f551a00 upstream.

There's a bug that when using the XEN hypervisor with bios with large
multi-page bio vectors on NVMe, the kernel deadlocks [1].

The deadlocks are caused by inability to map a large bio vector -
dma_map_sgtable always returns an error, this gets propagated to the block
layer as BLK_STS_RESOURCE and the block layer retries the request
indefinitely.

XEN uses the swiotlb framework to map discontiguous pages into contiguous
runs that are submitted to the PCIe device. The swiotlb framework has a
limitation on the length of a mapping - this needs to be announced with
the max_mapping_size method to make sure that the hardware drivers do not
create larger mappings.

Without max_mapping_size, the NVMe block driver would create large
mappings that overrun the maximum mapping size.

Reported-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Link: https://lore.kernel.org/stable/ZTNH0qtmint%2FzLJZ@mail-itl/ [1]
Tested-by: Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
Suggested-by: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Acked-by: Stefano Stabellini <sstabellini@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/151bef41-e817-aea9-675-a35fdac4ed@redhat.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/xen/swiotlb-xen.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/xen/swiotlb-xen.c
+++ b/drivers/xen/swiotlb-xen.c
@@ -579,4 +579,5 @@ const struct dma_map_ops xen_swiotlb_dma
 	.get_sgtable = dma_common_get_sgtable,
 	.alloc_pages = dma_common_alloc_pages,
 	.free_pages = dma_common_free_pages,
+	.max_mapping_size = swiotlb_max_mapping_size,
 };


