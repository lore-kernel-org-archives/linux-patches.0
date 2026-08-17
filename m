Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C398C41F5C1;
	Mon, 17 Aug 2026 13:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974061; cv=none; b=JGDAYDLIinBTMaajQyQ0KPPXU2znu0wwZo2IDfANWzHYGTOFpPBzeMIluXClMSfoysMD0PsagnJN495u8h2aEpM4vU6KgHzQI0yHExRrrASwwpVGQeDWZGWCJmonkhVAPPBVlCbbwHr454PNlYp2bI06N+IGzgi++1/DPUo9U2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974061; c=relaxed/simple;
	bh=5bl0IjMjS6UPv7EW7tBkpHFI7oyndxEMbSFB1a64Seo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xm6xIuVawbQti0+KVvf29/nAjT4sonmr2prFNcsYw5mI5ELEd6J0YYJqW2Cu8SQbY3r2YH7m/zTnVvuVx0evrHC+20BzJgy5mMMhqhgKMIEkFHRZmuawPbJyUPD6a5F3pcPkoZgZOY2KT2gg3FNYG1uAiIVvSBCZEEnPJS9UUcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tifM4HfC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tifM4HfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0F31F00A3A;
	Mon, 17 Aug 2026 13:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974054;
	bh=9zeHDPcRPpg6sgssCXBcDnyBKgAXVsjL7Y57KRXMNzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tifM4HfCm3LqT/k8ZGEaUsdNmi0Uyu+bSURufkDPip9B9qiJKAB9g1NFdzZAs0LqF
	 d05P0rN9Lo0PVk/FzFQrw6y3yzI+6YjBlTxvoJ1+Pxx28ZtsQ0Y9rI9zWMpUadX9en
	 op2zl+VKuxsPxxAZFDVTXYwx6H/mOXl1oD8UUnMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 072/271] xsk: require at least 16 bytes of TX metadata
Date: Mon, 17 Aug 2026 15:29:57 +0200
Message-ID: <20260817132539.706966122@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf.kernel@gmail.com>

[ Upstream commit 1bb30b181d9f0484e141f8411e15ed906d5c6780 ]

AF_XDP accepts a TX metadata length as small as eight bytes, but every
supported request needs the flags plus at least one eight-byte request
field. Such short metadata also lets the kernel read beyond the registered
area.

Require 16 bytes rather than sizeof(struct xsk_tx_metadata) to preserve
compatibility with applications that do not use launch-time metadata.

Fixes: 341ac980eab9 ("xsk: Support tx_metadata_len")
Reported-by: AutonomousCodeSecurity@microsoft.com
Reported-by: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Link: https://lore.kernel.org/netdev/20260720155210.34229-1-blbllhy@gmail.com/
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260727161959.885642-2-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xdp_umem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xdp/xdp_umem.c b/net/xdp/xdp_umem.c
index 58da2f4f4397a..cd8643360eb3a 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -210,6 +210,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (mr->flags & XDP_UMEM_TX_METADATA_LEN) {
 		if (mr->tx_metadata_len >= 256 || mr->tx_metadata_len % 8)
 			return -EINVAL;
+		if (mr->tx_metadata_len < 16)
+			return -EINVAL;
 		umem->tx_metadata_len = mr->tx_metadata_len;
 	}
 
-- 
2.53.0



