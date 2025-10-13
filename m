Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C40D2BEC34;
	Mon, 13 Oct 2025 15:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368570; cv=none; b=Jdz7e7/YWqxcskTmx8OUJibalJoNa2bQ05xytHQZKMyYzrM5TfKbSzDKVrw14AhokwHDl20k+7JT7qQV0uFjY6fzDyK1nOftWZtNzWzyJRupnQi6gmXD1rkJpSvp1UJNYzpvqH0iuhRsO0ND/uceotfVu34RQf0OyUcOKTthMeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368570; c=relaxed/simple;
	bh=sbKwKH41tuopmMchn5Jq4WPnqMNu16Lx4wop7FNRQS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PfjLdcFeb3Ta1vq9roBITk0SYQ8EWqJ8bGwkJ2c81sZXsnYrnSTlqukw16e/jebHhMV7hqj3WZjK4kHovCr8hTBB6TmKjwtuC+ALYU+X5I7D4Y4Zw4m5pLYjnh5KKinOQGg4YE/V5FjUN2YnK17P4m8MyNKMiSA8jfm0UuEoEks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CFCeAjEu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CFCeAjEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4E2FC4CEE7;
	Mon, 13 Oct 2025 15:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368570;
	bh=sbKwKH41tuopmMchn5Jq4WPnqMNu16Lx4wop7FNRQS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CFCeAjEuSKYumgJ5Il/QKpjzDiJUm8eWz1QsCJuK90dDYnbwNhsV1AozsqPMnMd1b
	 tUJzJ6z349Ru7bF1l6pDO/Vc/fuH6wzXRmbvc5MSNmX9ugRLYHCYoEl6vuc0cMu61I
	 9Bsmsg8/yk6C/VMMedZ3ge6fNcSpY+MZxTk6ps2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/262] Bluetooth: ISO: dont leak skb in ISO_CONT RX
Date: Mon, 13 Oct 2025 16:45:47 +0200
Message-ID: <20251013144333.626877802@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e38f52638627d..2cd0b963c96bd 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -2304,7 +2304,7 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
 					  skb->len);
 		conn->rx_len -= skb->len;
-		return;
+		break;
 
 	case ISO_END:
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
-- 
2.51.0



