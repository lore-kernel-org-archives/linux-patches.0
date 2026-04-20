Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672B34C6EEC;
	Mon, 20 Apr 2026 13:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691983; cv=none; b=OVM3VffyL8B7evL3n32x1u7LqdwWBA1vW9zgyhXBqz16kkPL0+iahLBkhci2wWaChHmQ/GSYuaowXMNt6jhokdAA1jPxztwz57dkAUcc1fFT8goeEQZgVjS9Xhx9AOkyYuhV5YIMBeKnZt2a2KGoezTADwgVqjsNdsuK2ULju9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691983; c=relaxed/simple;
	bh=G4rr8t+cL1IGQWS7XAHaJ3u+HohH4a1o5NALoiHwlgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=msd3W23el9kvyJ5G/wR5QE3A/QhQHX0oOt+wMrWzzlwIg9ms0miI2qe3siVzTyvV/+x8Lz+ymv8XSwxY3oDm6d+IRg6eLe8FubdPaXTpx/px4yIRqGLW3WKxbpECbFrIRcMEqP1HnIy/7YfXG5IpIDxaOi+Mb5DabNDYytZySPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bcarKyyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bcarKyyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58804C2BCB4;
	Mon, 20 Apr 2026 13:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691983;
	bh=G4rr8t+cL1IGQWS7XAHaJ3u+HohH4a1o5NALoiHwlgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bcarKyyC2bFbZ/0y7L340sLrPL+jfDV3xBkYb6wTGNV/RMTp43dDOAxTH4bUTjMVX
	 teCU8IaojAE5VB7L13Gt5wTPZmR47lTqre4yZggr6sY5TVgJC4gROgL/H+2ML6RBoB
	 jepQORGTc7caM3vr5PEXaSjl6SVyUTp7R1b3o3Q8efYFBx4Cf1NtLZ/d9PhL+/euyy
	 nLJZVJWI9Z/JfPbGVapuhL/jQ7lVlUQv4RBNn7Cc5qpwggXiNMrbZplIRfEaweSXAk
	 06VpY1aLNdQUs4P76B9li2ElM/F4+ypb5kPK4w4T2oaZz3KimIWMu2n91vg27NWKXG
	 /pRlebxa5ghuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	krzk@kernel.org,
	bongsu.jeon@samsung.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] nfc: s3fwrn5: allocate rx skb before consuming bytes
Date: Mon, 20 Apr 2026 09:21:39 -0400
Message-ID: <20260420132314.1023554-305-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5c14a19d5b1645cce1cb1252833d70b23635b632 ]

s3fwrn82_uart_read() reports the number of accepted bytes to the serdev
core. The current code consumes bytes into recv_skb and may already
deliver a complete frame before allocating a fresh receive buffer.

If that alloc_skb() fails, the callback returns 0 even though it has
already consumed bytes, and it leaves recv_skb as NULL for the next
receive callback. That breaks the receive_buf() accounting contract and
can also lead to a NULL dereference on the next skb_put_u8().

Allocate the receive skb lazily before consuming the next byte instead.
If allocation fails, return the number of bytes already accepted.

Fixes: 3f52c2cb7e3a ("nfc: s3fwrn5: Support a UART interface")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260402042148.65236-1-pengpeng@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 drivers/nfc/s3fwrn5/uart.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/uart.c b/drivers/nfc/s3fwrn5/uart.c
index 9c09c10c2a464..4ee481bd7e965 100644
--- a/drivers/nfc/s3fwrn5/uart.c
+++ b/drivers/nfc/s3fwrn5/uart.c
@@ -58,6 +58,12 @@ static size_t s3fwrn82_uart_read(struct serdev_device *serdev,
 	size_t i;
 
 	for (i = 0; i < count; i++) {
+		if (!phy->recv_skb) {
+			phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
+			if (!phy->recv_skb)
+				return i;
+		}
+
 		skb_put_u8(phy->recv_skb, *data++);
 
 		if (phy->recv_skb->len < S3FWRN82_NCI_HEADER)
@@ -69,9 +75,7 @@ static size_t s3fwrn82_uart_read(struct serdev_device *serdev,
 
 		s3fwrn5_recv_frame(phy->common.ndev, phy->recv_skb,
 				   phy->common.mode);
-		phy->recv_skb = alloc_skb(NCI_SKB_BUFF_LEN, GFP_KERNEL);
-		if (!phy->recv_skb)
-			return 0;
+		phy->recv_skb = NULL;
 	}
 
 	return i;
-- 
2.53.0

