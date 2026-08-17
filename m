Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF3542D763;
	Mon, 17 Aug 2026 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974826; cv=none; b=Ii6u4MaWheLkdWx59+38uNO8PtKM1wcyElbX0za/AHKMecOix6H0O/bcsst8EMNpeQ8jMnSkR7VcbsQx3N0DMbjLqJxqVYoeQESjO6Uf2G/be+euaa8h3t1+UEr4mdSeZOQD7m9OXgBKjXuhNXMQtrP6iHBLqiXTDXIldGApLfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974826; c=relaxed/simple;
	bh=wJp8K4yUcN9ZysVntWcKsPhBOZxh06rX6xFynkaEELI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fAAZXhN+mKWesSofTb1/wa/Sy5IJUveGw9cDl6WMJG/KYYY8nPasxq0taouXakO0Kv9zDc5ZPo47tjL2oPP+RqVoi3vvX5bpcTYwbxdiVsD14/osDbGong7hkHwB1pD4zD/INpJTYDqzeWB0oAWMds4OnLq+8v5nKY18HBbCD+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xBtt/Kdm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xBtt/Kdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6DF1F00A3F;
	Mon, 17 Aug 2026 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974821;
	bh=PDc9u/j9XKD5T6FqpL7xmk6BW5sbn/WLm/XvytSJ+rA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xBtt/KdmoEvnGw+dN77NZaTu/8IRQT49Ab8pUs2fv+00tskpQ89+RwWRQQA5ESLmz
	 imP3+xfFC12Cj6uOf6woEqphEBOwA5Qwl6XbNu8sBaBGAlSvU6Z5CzSALg2hOjxvW7
	 FHt+v3xwiBiuT8iEe8Y8FRrkniTXL8uQ/D/3dkaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/250] xsk: require at least 16 bytes of TX metadata
Date: Mon, 17 Aug 2026 15:30:26 +0200
Message-ID: <20260817132539.110440470@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
index 9ec7bd948acc7..81ffda5501078 100644
--- a/net/xdp/xdp_umem.c
+++ b/net/xdp/xdp_umem.c
@@ -209,6 +209,8 @@ static int xdp_umem_reg(struct xdp_umem *umem, struct xdp_umem_reg *mr)
 	if (mr->flags & XDP_UMEM_TX_METADATA_LEN) {
 		if (mr->tx_metadata_len >= 256 || mr->tx_metadata_len % 8)
 			return -EINVAL;
+		if (mr->tx_metadata_len < 16)
+			return -EINVAL;
 		umem->tx_metadata_len = mr->tx_metadata_len;
 	}
 
-- 
2.53.0



