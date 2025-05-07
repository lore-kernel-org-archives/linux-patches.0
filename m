Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E533729A0;
	Wed,  7 May 2025 19:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644553; cv=none; b=O1/cM9uRe4XPvxrAs0MurfRkKxkE0ccwiX3aEXpDA8Sx470jenzNz5zNzLXR4xMEoNAXsGOs5neJP6UgjHsBOMsyi9/5ND099xyNJgnPPcxPI8OPswv2lMnxzH1kOVyzywY3ahDMC2DeMD+Fk8fnQU6hrF9fZGioiDEsdK/O1oU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644553; c=relaxed/simple;
	bh=wx5eTAPKebNDaq26kRNfNeXRvYr8Gqv8Anfe+6lN4CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vFAHMD534KBAfT2x6uYTdZAxdZUPfwnvQQw0mGTyTSDgMo25yiQaAFpj06XZiDUPcBg5Xjf00TKBC7PwjuEfpwL2ko3htuWmrh+eBjIm1zPnlImR0J9KEXdQbXHR+XGEr1TAjM0JgI4ZjK+H/UkWxNuF9hhtADolAvEJlgGOuK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WkmU90+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WkmU90+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C923C4CEE2;
	Wed,  7 May 2025 19:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644552;
	bh=wx5eTAPKebNDaq26kRNfNeXRvYr8Gqv8Anfe+6lN4CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WkmU90+otfKrHOqGwMaQaSPqOcijT2d/xMjqUlgg/+TbQ7b3stBxHduk9G5yPNydL
	 RD9gkBxWgi1678l7ixlB8gAYDjQLW/QUzIU+MlJdRMaLNfZ3usE9ucyrEymUc8vuEN
	 sPyQgJ6Fnhiph7bJKdTj45AWF6xhGaRGHyx5lYkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/164] Bluetooth: L2CAP: copy RX timestamp to new fragments
Date: Wed,  7 May 2025 20:39:25 +0200
Message-ID: <20250507183824.200276786@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 3908feb1bd7f319a10e18d84369a48163264cc7d ]

Copy timestamp too when allocating new skb for received fragment.
Fixes missing RX timestamps with fragmentation.

Fixes: 4d7ea8ee90e4 ("Bluetooth: L2CAP: Fix handling fragmented length")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/l2cap_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index a55388fbf07c8..c219a8c596d3e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7380,6 +7380,9 @@ static int l2cap_recv_frag(struct l2cap_conn *conn, struct sk_buff *skb,
 			return -ENOMEM;
 		/* Init rx_len */
 		conn->rx_len = len;
+
+		skb_set_delivery_time(conn->rx_skb, skb->tstamp,
+				      skb->tstamp_type);
 	}
 
 	/* Copy as much as the rx_skb can hold */
-- 
2.39.5



