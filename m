Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFCF33C4576;
	Wed, 20 May 2026 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299443; cv=none; b=W5lGECjOKs0MiGcexTaE1PugejcJKP8aGe9p3DEjPKj04jxxPFAqz82RTLyijXF+IGZOB/eD5I8kx5ztegbCnlPU9bQYLVL9q9x2sXPByxony6hLeO9BhUi9YU+EKlm7XCCc28ghyS7foyxwT9Z3/Qo6Y+5ycBW+3KbCtPElE58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299443; c=relaxed/simple;
	bh=ZQHl6X7XPLUKHTLMuhnxGpxB29H5KuzjQpCHzJvsS68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVPdTyKyhRwMdmMfBbTauu7pYtLeFzh44Qux4bELYZMbgwZl6CGSF/UZTJ1+R0bK5AqhsLsnWU/97uXGvNJ7KbJL+VtYtVdWyzn4wqDxIMXp2hisqQu4OegVf1JHg40l0KFU/YRTJeM1kvFXvn2DnA+yWeycpymZLkLuooBaC20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYTWzdpQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYTWzdpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AA21F00893;
	Wed, 20 May 2026 17:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299442;
	bh=sRkuEiSEHPpezoOW3kpyaAmGudGx4W6OpIouRcw1Qq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yYTWzdpQOxhDzg2Klqr4vrgMOGotPElUprvhOqT3SqFwpN7/1UJ/Q2jbduXMnAkb4
	 3gr51zJpO3KRfXj8Y7aomPh1YAazmdl7KdoNG7IwrpETQXX6eKl3c0JiMwvoNQ26NB
	 JU2xGl0hbJkZcF2LaPtVbkWlI/3kTI0I4K9iHFYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 774/957] net: airoha: Do not read uninitialized fragment address in airoha_dev_xmit()
Date: Wed, 20 May 2026 18:20:57 +0200
Message-ID: <20260520162151.346819070@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit bde34e84edc8b5571fbde7e941e175a4293ee1eb ]

The transmit loop in airoha_dev_xmit() reads fragment address and length
during its final iteration, when the loop index equals
skb_shinfo(skb)->nr_frags, at which point the fragment data is
uninitialized. While these values are never consumed, the read itself is
unsafe and may trigger a page fault. Fix this by avoiding the fragment
read on the last iteration.
Additionally, move the skb pointer from the first to the last used packet
descriptor, so that airoha_qdma_tx_napi_poll() defers freeing the skb
until the final descriptor is processed.

Fixes: 23020f0493270 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260424-airoha-xmit-fix-read-frag-v1-1-fdc0a83c79e8@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 7d7f2bf6172a3..a69544e785a2a 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2024,8 +2024,8 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	struct netdev_queue *txq;
 	struct airoha_queue *q;
 	LIST_HEAD(tx_list);
+	int i = 0, qid;
 	void *data;
-	int i, qid;
 	u16 index;
 	u8 fport;
 
@@ -2084,7 +2084,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 			     list);
 	index = e - q->entry;
 
-	for (i = 0; i < nr_frags; i++) {
+	while (true) {
 		struct airoha_qdma_desc *desc = &q->desc[index];
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		dma_addr_t addr;
@@ -2096,7 +2096,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 			goto error_unmap;
 
 		list_move_tail(&e->list, &tx_list);
-		e->skb = i ? NULL : skb;
+		e->skb = i == nr_frags - 1 ? skb : NULL;
 		e->dma_addr = addr;
 		e->dma_len = len;
 
@@ -2115,6 +2115,9 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 		WRITE_ONCE(desc->msg1, cpu_to_le32(msg1));
 		WRITE_ONCE(desc->msg2, cpu_to_le32(0xffff));
 
+		if (++i == nr_frags)
+			break;
+
 		data = skb_frag_address(frag);
 		len = skb_frag_size(frag);
 	}
-- 
2.53.0



