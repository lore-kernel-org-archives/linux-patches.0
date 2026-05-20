Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6C4352C52;
	Wed, 20 May 2026 17:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296805; cv=none; b=MnDP1zBuLqoDs2za6rY+uI3pHrJx8lJ3YsIJ1t8h8MRO2eaGdLFBJrWGT59x2UoKez1TbNTuFozKs4eoJRgTAQilvGjlqFfrn7i2UHNnJKz3fEk4eDsK9b67KFOj60SqIvc5q2Z9ICP9l0yjlmpTTap97XbE5t5ZMSycAZJGXdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296805; c=relaxed/simple;
	bh=j4lvfqSgkHHG8KcRUSFtpV0KxvLskKJiT73kkUqcYY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnCWvhgDGZ7DnKOw8X1zYiDJUf3rxF2JmXE+vGFM7kv+3jZkY3DwlQtNEr3Y94E4KW3h/qgF+7yc5QFnmPKQv3nIkB1EYqJO5sbqiAz9JS1ehtfGaRNTV+dTIj520pEBsB2DPctMMBpcXxXgO34zZ80vLETI7tDe1KWuc2jwSyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQq2z+iF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQq2z+iF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713451F000E9;
	Wed, 20 May 2026 17:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296803;
	bh=JWbsFHTHBH3IRdu3381vc1Mh/Be9x3w+TH+yPhng2T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQq2z+iFODnXDzPWEhYYeWHvE5If94YVm8BBNKXqHf1VGPOt6Cgtli2bK1DCgZyJV
	 8qoSc8W8ZN4EH3vHTswZtGdRLDQHrfosSeAfOQjNjcwKYx7TyR0JrthWS5LihkepUr
	 x+mgFpLnm04MrfmcWWtxh21WbHSIcObOgMKILG68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0938/1146] net: airoha: Do not read uninitialized fragment address in airoha_dev_xmit()
Date: Wed, 20 May 2026 18:19:48 +0200
Message-ID: <20260520162209.464093976@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index f9e6406ca55da..3e406d880c0cd 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -2005,8 +2005,8 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 	struct netdev_queue *txq;
 	struct airoha_queue *q;
 	LIST_HEAD(tx_list);
+	int i = 0, qid;
 	void *data;
-	int i, qid;
 	u16 index;
 	u8 fport;
 
@@ -2065,7 +2065,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 			     list);
 	index = e - q->entry;
 
-	for (i = 0; i < nr_frags; i++) {
+	while (true) {
 		struct airoha_qdma_desc *desc = &q->desc[index];
 		skb_frag_t *frag = &skb_shinfo(skb)->frags[i];
 		dma_addr_t addr;
@@ -2077,7 +2077,7 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
 			goto error_unmap;
 
 		list_move_tail(&e->list, &tx_list);
-		e->skb = i ? NULL : skb;
+		e->skb = i == nr_frags - 1 ? skb : NULL;
 		e->dma_addr = addr;
 		e->dma_len = len;
 
@@ -2096,6 +2096,9 @@ static netdev_tx_t airoha_dev_xmit(struct sk_buff *skb,
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



