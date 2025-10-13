Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE311228CB0;
	Mon, 13 Oct 2025 15:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370046; cv=none; b=OUYnPLZMPI9wEksfEvIIdcGh7qKiSgu1piCjsyjV9ypkU4IFHhiM8IVB0ZbkQ4QI6vRCUsWZhpvheMPhW/1c3jgWjyQSNpxesFsOS+JrtT1vcINeNxgcLAX+EKgsqk29DLR1egavzyIYtahmnz/IK/HwZrRKjNi5UR0TjixJzds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370046; c=relaxed/simple;
	bh=o3ReHMu9X9aZfSHncssf6RpnOSxAmsA4yWh6/DvkQFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3gdimrlm9Sf5lJDQdGLcqofqItxlRoYeQ5xbJxbRep9m09xAT17FGjCOdFXyTq1b/mnj1XhmQcmmY5dA9DXZgm7lJCZ4yk8HeiCxKBrrf4O0MrhdwcqLQSp2EFh3CDNH+h6624l+gjlIqVkzkvbCP9ov/eyDAi6VmvFsMxfnTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxHGldOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxHGldOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16573C4CEE7;
	Mon, 13 Oct 2025 15:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370046;
	bh=o3ReHMu9X9aZfSHncssf6RpnOSxAmsA4yWh6/DvkQFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxHGldOIm02QMuFkGtPFsUnEppYi76qdL5tqOC7ikWkJxtCNXeuqpBic6id6dM8Ma
	 P5kVbBgRf+mKRNmQx0JmCBFNwySGyrlIapCtrkJ9aMABP1CaigKf+QYWtW67fY3xt9
	 qpNNr4Z5tibajWwF7KjgXF/btMSN5LuFWXSqbOwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 460/563] Bluetooth: ISO: dont leak skb in ISO_CONT RX
Date: Mon, 13 Oct 2025 16:45:21 +0200
Message-ID: <20251013144427.949831628@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pauli Virtanen <pav@iki.fi>

[ Upstream commit 5bf863f4c5da055c1eb08887ae4f26d99dbc4aac ]

For ISO_CONT RX, the data from skb is copied to conn->rx_skb, but the
skb is leaked.

Free skb after copying its data.

Fixes: ccf74f2390d6 ("Bluetooth: Add BTPROTO_ISO socket type")
Signed-off-by: Pauli Virtanen <pav@iki.fi>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/iso.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bluetooth/iso.c b/net/bluetooth/iso.c
index 9170c46eb47c6..88602f19decac 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2416,7 +2416,7 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
 					  skb->len);
 		conn->rx_len -= skb->len;
-		return;
+		break;
 
 	case ISO_END:
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
-- 
2.51.0



