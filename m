Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056021;
	b=1wJrhaFqK98o2ISo+vo953FRM77y+ASvUfpB1+TeVLClfOK8HncH1tUhoQvwixm9XCW9
	 iMg3VxYx6SPB4jOtbQykd0nGLOVEPt3hQuQLkint0IFEOuwKL9HJq8bXMtC9j4w+cy3CN
	 rE1K04075D+LkC8nYj/IKj+PGy/VFKrA3bNJ6yuhmUZJ8G4GEuzHu90LHO+367SLLASHF
	 pe8qFsLjlYrS5jssE51SrVzjHtDco2XQntXtig3Lt7/dNKp6OVRhtXOlEF7Lv4JA8/vZL
	 zxZJ4glmhkIpxKTMqE6rnvg62n5T+Ykw3AqmXxzAU76vHF64sArxGLcaNePP3pgzaEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=obViikbhAU399pFfcAxYc7GjAgf0Rm55RlCNSgXVrsY=;
	b=XiiepkBimI+qn3QrZOS2+Eh1aXFwz5M8oYxLtOlQodknMiibzphqR1d///R2/w3ckfel
	 1t85NxfDZImTG/HWRcfWs+CdhvdmnF0b8/PsnhEpXeeTQCGnb1ycbuLzaUATCWg3suX3+
	 /nWhfUv67AUB4QUQ4bIAmkaYLSK0oaUmyvgVnL90Xf2Ai7ND55GiDIq1S33eOGvrmr+45
	 VnPOdhhRhDqDV3/3WfkFRtUq+vUlAc0WCkwtun2SsFdEsLNocWFNrEflgLwS5sG/SmEBn
	 Dn9CgI8wKEaTCsDlHp5A+U/RM8ffZb6jsG0aOiclpRL5S6smAHPxeu3rHJyMyNlg2EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSCtpJQt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D02C606A31C;
	Thu, 19 Nov 2026 02:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wSCtpJQt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 784BB1F000C5;
	Thu, 19 Nov 2026 02:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056021;
	bh=obViikbhAU399pFfcAxYc7GjAgf0Rm55RlCNSgXVrsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wSCtpJQtir2Wn5RJDaUjtUhOn5du/HIstRtJ0iOuI98vch579AU/a69JPO5JiZURe
	 ZVyRLh6UKM8B6rErfqpnBGsA2UOCwbZqwmB/aUc1As9nGLGRLpF921byQxPX80eyLl
	 mGJaKB641YFDVdeF5l4X10SD9d5XnuqCNXhggByU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1839/2214] mailbox: ti-msgmgr: Read exact number of trailing message bytes
Date: Wed, 18 Nov 2026 15:58:35 +0100
Message-ID: <20261118150124.996062488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beleswar Padhi <b-padhi@ti.com>

[ Upstream commit 645ae2edd5597501b4af3837a644877fbe194227 ]

ti_msgmgr_send_data() copies the message to the data registers in u32
units. This has been harmless so far because the clients (TI-SCI)
always passed its preallocated message buffer, which is sized to the
maximum message size (60 or 64 bytes, a multiple of 4), so the extra
bytes read were still within the buffer. But, with a later TI-SCI
update, the message size can be varying now and not guaranteed to be a
multiple of 4, which would trigger KASAN out-of-bounds reports.

Therefore, memcpy() only the trailing bytes into a zeroed u32 before
writing it to the register. This is at most 3 bytes, so the overhead
is negligible.

Fixes: aace66b170ce ("mailbox: Introduce TI message manager driver")
Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Acked-by: Andrew Davis <afd@ti.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/ti-msgmgr.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/ti-msgmgr.c b/drivers/mailbox/ti-msgmgr.c
index fa71ae837d235..dab9659a1a9d6 100644
--- a/drivers/mailbox/ti-msgmgr.c
+++ b/drivers/mailbox/ti-msgmgr.c
@@ -19,6 +19,7 @@
 #include <linux/of_irq.h>
 #include <linux/platform_device.h>
 #include <linux/soc/ti/ti-msgmgr.h>
+#include <linux/string.h>
 
 #define Q_DATA_OFFSET(proxy, queue, reg)	\
 		     ((0x10000 * (proxy)) + (0x80 * (queue)) + ((reg) * 4))
@@ -380,10 +381,15 @@ static int ti_msgmgr_send_data(struct mbox_chan *chan, void *data)
 
 	trail_bytes = message->len % sizeof(u32);
 	if (trail_bytes) {
-		u32 data_trail = *word_data;
-
-		/* Ensure all unused data is 0 */
-		data_trail &= 0xFFFFFFFF >> (8 * (sizeof(u32) - trail_bytes));
+		/*
+		 * Copy only the trailing bytes instead of reading a full u32,
+		 * as the message buffer may end right after them and a u32
+		 * read would go past the end of it. This also leaves all
+		 * unused data as 0.
+		 */
+		u32 data_trail = 0;
+
+		memcpy(&data_trail, word_data, trail_bytes);
 		writel(data_trail, data_reg);
 		data_reg += sizeof(u32);
 	}
-- 
2.53.0



