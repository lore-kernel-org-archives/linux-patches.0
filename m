Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25C133EC
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2867AC433D2;
	Mon, 16 Jan 2023 16:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673884916;
	bh=AtDXUXTep2VDDNmGKsPCXJkv6DS9oTrhh+ZSMB8DqW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwnvsl6cr/+VWRIWyt5z1+0xBa+yx0TnKvlxFfdbzSzRmXU4CRKtwXHrZMdKILFtN
	 n0cEo0S9qDskLNE+ode4U8rBTE3144GblbI5nalE9sOvRHTRYb3b4jWSWQhvgRY1Z+
	 4JaaMltsl2QaJTj8GMO/zJi1xXDJBpWCY1A9E+KA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <gospo@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/183] bnxt: make sure we return pages to the pool
Date: Mon, 16 Jan 2023 16:51:34 +0100
Message-Id: <20230116154810.521164006@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 97f5e03a4a27d27ee4fed0cdb1658c81cf2784db ]

Before the commit under Fixes the page would have been released
from the pool before the napi_alloc_skb() call, so normal page
freeing was fine (released page == no longer in the pool).

After the change we just mark the page for recycling so it's still
in the pool if the skb alloc fails, we need to recycle.

Same commit added the same bug in the new bnxt_rx_multi_page_skb().

Fixes: 1dc4c557bfed ("bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff")
Reviewed-by: Andy Gospodarek <gospo@broadcom.com>
Link: https://lore.kernel.org/r/20230111042547.987749-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index f5a8bae8d79a..edca16b5f9e3 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -990,7 +990,7 @@ static struct sk_buff *bnxt_rx_multi_page_skb(struct bnxt *bp,
 			     DMA_ATTR_WEAK_ORDERING);
 	skb = build_skb(page_address(page), PAGE_SIZE);
 	if (!skb) {
-		__free_page(page);
+		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
 	}
 	skb_mark_for_recycle(skb);
@@ -1028,7 +1028,7 @@ static struct sk_buff *bnxt_rx_page_skb(struct bnxt *bp,
 
 	skb = napi_alloc_skb(&rxr->bnapi->napi, payload);
 	if (!skb) {
-		__free_page(page);
+		page_pool_recycle_direct(rxr->page_pool, page);
 		return NULL;
 	}
 
-- 
2.35.1



