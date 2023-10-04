Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 392071D55D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFC1DC433CA;
	Wed,  4 Oct 2023 18:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443155;
	bh=MtI8TBbx5Wi7jqrirkORIAVoqKbyqVbDaKjSKDcM1nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y01/HqFS2pH8sdvCvEVeo5kqX1CBLECJ3ZeKcGmjOVWGiRgeZmvO83PbtQGdnD/i1
	 oJgf+XEY41K9EQSEvuI6SzyH/cCpYu32gkTKxpA8c6Jf9uGmH4zTNo6csk+D8SWt0a
	 leZOsbi0QhlPxflnEN+ODDD+4/m0yK0+1tZ7779I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Christensen <drc@linux.vnet.ibm.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/259] ionic: fix 16bit math issue when PAGE_SIZE >= 64KB
Date: Wed,  4 Oct 2023 19:53:48 +0200
Message-ID: <20231004175219.959131537@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: David Christensen <drc@linux.vnet.ibm.com>

[ Upstream commit 8f6b846b0a86c3cbae8a25b772651cfc2270ad0a ]

The ionic device supports a maximum buffer length of 16 bits (see
ionic_rxq_desc or ionic_rxq_sg_elem).  When adding new buffers to
the receive rings, the function ionic_rx_fill() uses 16bit math when
calculating the number of pages to allocate for an RX descriptor,
given the interface's MTU setting. If the system PAGE_SIZE >= 64KB,
and the buf_info->page_offset is 0, the remain_len value will never
decrement from the original MTU value and the frag_len value will
always be 0, causing additional pages to be allocated as scatter-
gather elements unnecessarily.

A similar math issue exists in ionic_rx_frags(), but no failures
have been observed here since a 64KB page should not normally
require any scatter-gather elements at any legal Ethernet MTU size.

Fixes: 4b0a7539a372 ("ionic: implement Rx page reuse")
Signed-off-by: David Christensen <drc@linux.vnet.ibm.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.h  |  1 +
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 10 +++++++---
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index ad8a2a4453b76..93a4258421667 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -180,6 +180,7 @@ typedef void (*ionic_desc_cb)(struct ionic_queue *q,
 			      struct ionic_desc_info *desc_info,
 			      struct ionic_cq_info *cq_info, void *cb_arg);
 
+#define IONIC_MAX_BUF_LEN			((u16)-1)
 #define IONIC_PAGE_SIZE				PAGE_SIZE
 #define IONIC_PAGE_SPLIT_SZ			(PAGE_SIZE / 2)
 #define IONIC_PAGE_GFP_MASK			(GFP_ATOMIC | __GFP_NOWARN |\
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index f8f5eb1307681..4684b9f194a68 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -207,7 +207,8 @@ static struct sk_buff *ionic_rx_frags(struct ionic_queue *q,
 			return NULL;
 		}
 
-		frag_len = min_t(u16, len, IONIC_PAGE_SIZE - buf_info->page_offset);
+		frag_len = min_t(u16, len, min_t(u32, IONIC_MAX_BUF_LEN,
+						 IONIC_PAGE_SIZE - buf_info->page_offset));
 		len -= frag_len;
 
 		dma_sync_single_for_cpu(dev,
@@ -444,7 +445,8 @@ void ionic_rx_fill(struct ionic_queue *q)
 
 		/* fill main descriptor - buf[0] */
 		desc->addr = cpu_to_le64(buf_info->dma_addr + buf_info->page_offset);
-		frag_len = min_t(u16, len, IONIC_PAGE_SIZE - buf_info->page_offset);
+		frag_len = min_t(u16, len, min_t(u32, IONIC_MAX_BUF_LEN,
+						 IONIC_PAGE_SIZE - buf_info->page_offset));
 		desc->len = cpu_to_le16(frag_len);
 		remain_len -= frag_len;
 		buf_info++;
@@ -463,7 +465,9 @@ void ionic_rx_fill(struct ionic_queue *q)
 			}
 
 			sg_elem->addr = cpu_to_le64(buf_info->dma_addr + buf_info->page_offset);
-			frag_len = min_t(u16, remain_len, IONIC_PAGE_SIZE - buf_info->page_offset);
+			frag_len = min_t(u16, remain_len, min_t(u32, IONIC_MAX_BUF_LEN,
+								IONIC_PAGE_SIZE -
+								buf_info->page_offset));
 			sg_elem->len = cpu_to_le16(frag_len);
 			remain_len -= frag_len;
 			buf_info++;
-- 
2.40.1



