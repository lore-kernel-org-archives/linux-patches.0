Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026138;
	b=41l8Fc20Uj7RybFs3+ujM2HI54iYVsvfLk2cW4cnm4Xb1I5ZoZHRRg09OixxmSHmsCww
	 aL/uxMYZxjAry08JlROqmOnCdSEdosW7sfJxKOQS8eZLw5lECcha0ipX5VUGo56EhUDzk
	 vl17dS058Z7mldDbt1AQ051uVu60+zrpMTSviig8IuvMIpHFKM5QUf6ir0JwqqRe5AbN9
	 waGYowoCx3w1yiBR1B62itl9Gfp9cT1A05ebKkqsViVufBaSQMUFeOHcgo8viPyIdMICz
	 eQipvqWC6FgAXGqvA4EsfzSZvkrl1qZP/weAos/4OlmYmfuUawQp9JC34ApqmMuRW3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G+MVBHelLvSF4Y36ODOnAvQ6zOJwVqb4EdvA3UWnlBs=;
	b=m7NffeZjO/3mbVIKiBxYiT6iaFASbPUrLbL1mJukNXxTgyiW5gkPT9OIKPdqUExFpe51
	 1CaPg7p6B7Ptiq0OZVToyQlyJN0BjaUNMmhx1e0ySASDg86L+qW0SnuZq3X1KrgXp+ziN
	 fKWnkOqgUaHm8CsUjd0QGAkb7mD1cXZ2guxolfHRux1VEmEmZ8myughMZCYJtG9wnU5bt
	 LGAhpnE50Dig2znWgD4YyJWba/k85PgYTty2zJsxzBTd8pAQR4O3qxZde6eStbrNyKU/5
	 fF25/9nrZ/5Dif+coiyCx6xhyqJaYn25okn3Iea+aBiqTQVxmw4DkkVKl9WXwGbOUSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFMfkIzb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF92606A331;
	Wed, 18 Nov 2026 18:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bFMfkIzb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07371F000CB;
	Wed, 18 Nov 2026 18:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026138;
	bh=G+MVBHelLvSF4Y36ODOnAvQ6zOJwVqb4EdvA3UWnlBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bFMfkIzbtFe6tuEgzSXCDWvqop/WbvK/GTuV/g6LeNHmZ3cAMirQ4ZrqKiowLu9YF
	 5/b9dwPH53P5iwwPuSyKRJcwSYOHfRj1t3sTplRlPAaCbxilYBZoI7+4DovwhYsmcM
	 Fi1CTp6A2STaANmwnTbjDA+6U83fjIlCL3LqXEDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1326/2151] mailbox: ti-msgmgr: Read exact number of trailing message bytes
Date: Wed, 18 Nov 2026 15:51:01 +0100
Message-ID: <20261118150210.382066478@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 8eb8df8d95a4c..fb3f7e41ac36b 100644
--- a/drivers/mailbox/ti-msgmgr.c
+++ b/drivers/mailbox/ti-msgmgr.c
@@ -20,6 +20,7 @@
 #include <linux/platform_device.h>
 #include <linux/property.h>
 #include <linux/soc/ti/ti-msgmgr.h>
+#include <linux/string.h>
 
 #define Q_DATA_OFFSET(proxy, queue, reg)	\
 		     ((0x10000 * (proxy)) + (0x80 * (queue)) + ((reg) * 4))
@@ -425,10 +426,15 @@ static int ti_msgmgr_send_data(struct mbox_chan *chan, void *data)
 
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



