Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D954230F556;
	Mon, 13 Oct 2025 15:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367837; cv=none; b=KMoS4BWTCK9OgrYCTvNeaRVsYakITvjNwPJexJw7NYRy6W6GEaeOijjzfXJySCY2047W0jH/Tim0lnfq4P0TIc2n8vKvHM+NW4lTYMJGTFHy9S2+m8+FkCbkjstYMU55W92Z4b2u81CV6bSn60k/BMuzIUpPiN9Jlz7aU9t26Sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367837; c=relaxed/simple;
	bh=F47G5TXk7JHzRgV0SF5K4DpjxcpXXxOeTXAJZqoKZsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BO7qmL7O0zmZdCmxYEFM1iw4xkDspI/29o4JoO+BrcnwDSyQoy8n5Ke4QaAcMxAmWWjiu0G26U/d/vPBw15DFYgUna+91kg29eSP6lg7C/lfn2tEl8Ob+rD7a1/B3GX8pJgI2Ii/jeOlSobCI1c+9dT2iCaKlHlpFtbyNCGhXzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tALD5Q+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tALD5Q+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62347C4CEE7;
	Mon, 13 Oct 2025 15:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367837;
	bh=F47G5TXk7JHzRgV0SF5K4DpjxcpXXxOeTXAJZqoKZsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tALD5Q+bTdVJB6zJKCfDM91s0HNALLqp5DjoB4LFSiACDWYENPnTm4UdBhn7P+CJL
	 Fsj6aMiGqZyKdSXOsgppq/qSkNpSZgwdwq51Wesmy7gWcGg/RRi4KvwWVjpTbpcdq3
	 MVk8s3ReuQGwQbx+orkjcyoLQRbzfpPzQqemYb3s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/196] Bluetooth: ISO: dont leak skb in ISO_CONT RX
Date: Mon, 13 Oct 2025 16:45:43 +0200
Message-ID: <20251013144320.809158880@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index be71082d9eafa..69529a3049e74 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2091,7 +2091,7 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
 					  skb->len);
 		conn->rx_len -= skb->len;
-		return;
+		break;
 
 	case ISO_END:
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
-- 
2.51.0



