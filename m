Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C17B1C4ED8;
	Tue, 27 Aug 2024 14:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769960; cv=none; b=IFmsxNtbV5ThUg9L6qcH7MYon2Gi8Cg+YbA4ynmgXxBYADHoMyoMfBqRTrbsz0Lflsh1chtBVqXEF2OrKIQPc+AJeTHRyRuSXr6BoVEptMUBCwl3fimVPJdAEMiiw0Jzr1XJa8ayH8GMljKI38pyiBTM0Yx2Q/O/Yy+RxOV94AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769960; c=relaxed/simple;
	bh=Cbwlx4qlFmJeSYWYELEct1YVuz+8CJursAGl/UDAtUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UW6dnzkNWfDJDMW/l+qZ/tJOm8OLPMuSzTqFFlYzmFBDdG410qCgkEMWf/PbJG7gxvvWp8NX9WnpUX8s5PRI2VBYpSJ/F/3mQ3fPhyvF/Nxva+nj46bLcdWqWP4T5HZEWU3TUyB3EmRgFD9DQJFsoNzsSCWSt3WO2Es+YCFYYxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=07OejZab; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="07OejZab"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB60C61063;
	Tue, 27 Aug 2024 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769960;
	bh=Cbwlx4qlFmJeSYWYELEct1YVuz+8CJursAGl/UDAtUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=07OejZabYw5GITG8mwcmXwC1qSkzhKn77v/0YcyfXnIFIZ9ckCGetAJTdGSjBLCc/
	 8bvAclOARTiJ8UsCGOe8Q8RELnGso6nKWoIIQc7fy9hS729w32ahBNQrZrTwlO/uLJ
	 KYoQISdlHrYzHhnU9nTxT8wxyJaPEVKvBz7WZQy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/341] atm: idt77252: prevent use after free in dequeue_rx()
Date: Tue, 27 Aug 2024 16:34:45 +0200
Message-ID: <20240827143845.474584375@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit a9a18e8f770c9b0703dab93580d0b02e199a4c79 ]

We can't dereference "skb" after calling vcc->push() because the skb
is released.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/idt77252.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/atm/idt77252.c b/drivers/atm/idt77252.c
index e7f713cd70d3f..a876024d8a05f 100644
--- a/drivers/atm/idt77252.c
+++ b/drivers/atm/idt77252.c
@@ -1118,8 +1118,8 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 	rpp->len += skb->len;
 
 	if (stat & SAR_RSQE_EPDU) {
+		unsigned int len, truesize;
 		unsigned char *l1l2;
-		unsigned int len;
 
 		l1l2 = (unsigned char *) ((unsigned long) skb->data + skb->len - 6);
 
@@ -1189,14 +1189,15 @@ dequeue_rx(struct idt77252_dev *card, struct rsq_entry *rsqe)
 		ATM_SKB(skb)->vcc = vcc;
 		__net_timestamp(skb);
 
+		truesize = skb->truesize;
 		vcc->push(vcc, skb);
 		atomic_inc(&vcc->stats->rx);
 
-		if (skb->truesize > SAR_FB_SIZE_3)
+		if (truesize > SAR_FB_SIZE_3)
 			add_rx_skb(card, 3, SAR_FB_SIZE_3, 1);
-		else if (skb->truesize > SAR_FB_SIZE_2)
+		else if (truesize > SAR_FB_SIZE_2)
 			add_rx_skb(card, 2, SAR_FB_SIZE_2, 1);
-		else if (skb->truesize > SAR_FB_SIZE_1)
+		else if (truesize > SAR_FB_SIZE_1)
 			add_rx_skb(card, 1, SAR_FB_SIZE_1, 1);
 		else
 			add_rx_skb(card, 0, SAR_FB_SIZE_0, 1);
-- 
2.43.0



