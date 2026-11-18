Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056023;
	b=qCTgcaC9pcT3C8XLrYathz1+bKj3KU4cLTvwF7ORGiTvMLUOLCEXbyZS+heYLfrGq5ye
	 AV+KWCzNhLnq3FCAM6NRci4kqSlzIfA7lIY1Dcz33p/xQoc/oc8858KkSOh2VgOWKNr3v
	 9oFcdS+JrvbBOasA2ZXk06nC29Ionn96o4v1x5fdfTDxmwZlPFPx3khJnfIetyC8Yvo3X
	 e6AZKWTfxCy30broFrqutWQQM2xncuOz/zXZbv3+vu3MQCwoh4xUvEXfihAJEdGogvQBD
	 mBX4a352qI7A31/5miz4plTqs5f/VjgHUoJVCq5DaHd+ggms2UtjITyIr1KmTmtco2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=asTfcevqmzzfJSEWxLbqEKHy6z6vE1jFjKQArAOBj4s=;
	b=aWceH2PeDvR/Dw6UofMrY8LleD61Yvd+QbFGFAN9RI1PWqKIzSAttl90UEvEuVFn61gH
	 teEUlbYvs38LtnKQBQ6PDqXad5xStBJw9mYxQgxWdIMkNgVJt23QJXCEMcP40BXKVjvc7
	 OmYRrhLOs+jX4Xa/q47ISJZBA6YQ2LBX4+dHzkuyWxBdCWSucp6svGZy68B5GVDZ7i28f
	 P62Fuj4JrrjnbtdOgYgy1wHODGEfDCpf1+qUT0RM5vSZELNqqqhQI9so52pKCaQ00NKWU
	 LnjjXtB7oe+3wrYBadI36DkmdbV1e7HFLEbm5tMAkD/RWOQUk/cO8BNsrYV6YK0x9Lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8hJSpvq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D730A606A320;
	Thu, 19 Nov 2026 02:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i8hJSpvq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B75D1F000C4;
	Thu, 19 Nov 2026 02:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056023;
	bh=asTfcevqmzzfJSEWxLbqEKHy6z6vE1jFjKQArAOBj4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i8hJSpvqrAkd9ZzfSM3qdjc3CNIfZRfenp3YwaNG+RKBL0En0m2H0vOpaFd4LAiu8
	 Way0b+7I3wjLZqCPeeqhtqBp6n8zGZNoS2PtjgzATDxiVcdfzHkRElRaL+2PxNAJyx
	 Zvn1dpt5yKvOtX8szeBnULsXJsGnghAky8ck07rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1840/2214] mailbox: arm_mhuv2: time out if the receiver never comes up
Date: Wed, 18 Nov 2026 15:58:36 +0100
Message-ID: <20261118150125.034910698@linuxfoundation.org>
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

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit 86976f7cc324aac254136a352f74ac17f21e574c ]

mhuv2_tx_init() waits forever for access_ready. Fail probe
after 1s instead of hanging boot.

Fixes: 5a6338cce9f4 ("mailbox: arm_mhuv2: Add driver")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/arm_mhuv2.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/mailbox/arm_mhuv2.c b/drivers/mailbox/arm_mhuv2.c
index 9785b2f8ed62f..0a6c6947541f6 100644
--- a/drivers/mailbox/arm_mhuv2.c
+++ b/drivers/mailbox/arm_mhuv2.c
@@ -27,6 +27,7 @@
 
 #include <linux/amba/bus.h>
 #include <linux/interrupt.h>
+#include <linux/iopoll.h>
 #include <linux/mailbox_controller.h>
 #include <linux/mailbox/arm_mhuv2_message.h>
 #include <linux/module.h>
@@ -967,6 +968,7 @@ static int mhuv2_tx_init(struct amba_device *adev, struct mhuv2 *mhu,
 {
 	struct device *dev = mhu->mbox.dev;
 	int ret, i;
+	u32 val;
 
 	mhu->frame = SENDER_FRAME;
 	mhu->mbox.ops = &mhuv2_sender_ops;
@@ -1010,8 +1012,11 @@ static int mhuv2_tx_init(struct amba_device *adev, struct mhuv2 *mhu,
 out:
 	/* Wait for receiver to be ready */
 	writel_relaxed(0x1, &mhu->send->access_request);
-	while (!readl_relaxed(&mhu->send->access_ready))
-		continue;
+	if (readl_relaxed_poll_timeout(&mhu->send->access_ready, val, val,
+				       100, 1000000)) {
+		dev_err(dev, "receiver not ready\n");
+		return -ETIMEDOUT;
+	}
 
 	return 0;
 }
-- 
2.53.0



