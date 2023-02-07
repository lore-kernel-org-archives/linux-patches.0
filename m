Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D372C9C
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 13:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3042C433EF;
	Tue,  7 Feb 2023 13:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675775128;
	bh=5yAkyVE9BfCYKplOhkQm0g2qe6wzbyzACmGOsIhcEOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TC/4MhQ72jIt8dNgNM4ZLO6dG7TfN+kKCEXP8KyfYVR5SChMKh1cQjxXBv43tCkOg
	 klf8R95+vsqp4/ty7p7wXjBKx9hxqBcLAiqHLv25wDVvmYTxZFWJChfDM+iBRsCN60
	 bysZJ/B91rEvCnBL7ajchN/IUC9dKTUv2Ya4qN6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Kelley <mikelley@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 117/208] hv_netvsc: Fix missed pagebuf entries in netvsc_dma_map/unmap()
Date: Tue,  7 Feb 2023 13:56:11 +0100
Message-Id: <20230207125639.694453814@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Michael Kelley <mikelley@microsoft.com>

commit 99f1c46011cc0feb47d4f4f7bee70a0341442d14 upstream.

netvsc_dma_map() and netvsc_dma_unmap() currently check the cp_partial
flag and adjust the page_count so that pagebuf entries for the RNDIS
portion of the message are skipped when it has already been copied into
a send buffer. But this adjustment has already been made by code in
netvsc_send(). The duplicate adjustment causes some pagebuf entries to
not be mapped. In a normal VM, this doesn't break anything because the
mapping doesn’t change the PFN. But in a Confidential VM,
dma_map_single() does bounce buffering and provides a different PFN.
Failing to do the mapping causes the wrong PFN to be passed to Hyper-V,
and various errors ensue.

Fix this by removing the duplicate adjustment in netvsc_dma_map() and
netvsc_dma_unmap().

Fixes: 846da38de0e8 ("net: netvsc: Add Isolation VM support for netvsc driver")
Cc: stable@vger.kernel.org
Signed-off-by: Michael Kelley <mikelley@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Link: https://lore.kernel.org/r/1675135986-254490-1-git-send-email-mikelley@microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -987,9 +987,6 @@ static void netvsc_copy_to_send_buf(stru
 void netvsc_dma_unmap(struct hv_device *hv_dev,
 		      struct hv_netvsc_packet *packet)
 {
-	u32 page_count = packet->cp_partial ?
-		packet->page_buf_cnt - packet->rmsg_pgcnt :
-		packet->page_buf_cnt;
 	int i;
 
 	if (!hv_is_isolation_supported())
@@ -998,7 +995,7 @@ void netvsc_dma_unmap(struct hv_device *
 	if (!packet->dma_range)
 		return;
 
-	for (i = 0; i < page_count; i++)
+	for (i = 0; i < packet->page_buf_cnt; i++)
 		dma_unmap_single(&hv_dev->device, packet->dma_range[i].dma,
 				 packet->dma_range[i].mapping_size,
 				 DMA_TO_DEVICE);
@@ -1028,9 +1025,7 @@ static int netvsc_dma_map(struct hv_devi
 			  struct hv_netvsc_packet *packet,
 			  struct hv_page_buffer *pb)
 {
-	u32 page_count =  packet->cp_partial ?
-		packet->page_buf_cnt - packet->rmsg_pgcnt :
-		packet->page_buf_cnt;
+	u32 page_count = packet->page_buf_cnt;
 	dma_addr_t dma;
 	int i;
 


