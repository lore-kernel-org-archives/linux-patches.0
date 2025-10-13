Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A7D30CDB9;
	Mon, 13 Oct 2025 14:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367344; cv=none; b=tCxzuvo8j4m2UvgDn1EXXLnv4yKmut2Mv/BJ2ulxRTqbZK8tMbcFoLFqs9jDWH6BYnc0q8b32akOdRBYxgHiHXFBdNkOvZjMAYoZkLCIXtK5gQmmKkWd3YRmmAEJ25ThBPuGEh/KEvcQI0UGCijbEiVkRHezvA/F+5nRHkWELFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367344; c=relaxed/simple;
	bh=CXl+XaegYARTfqaVnhfg2yWH662CfmnDGW5vuSzPumg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQnuV38x+6i9OKJ0ByTppbTJF9THjUEhiwCT9/lUqEhghAYxzL+V+7J94vYlBjJVqdycwQgDypunUL7wqU0ygKHMEaxZ6HjomgV7bzes2SLZ49DZlC87wnYtD0jZiHMRperoQeeSzJWz2Bw2l95luRKIoIGF3QkGe+66FCht+Fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n390vnhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n390vnhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A717C4CEE7;
	Mon, 13 Oct 2025 14:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367343;
	bh=CXl+XaegYARTfqaVnhfg2yWH662CfmnDGW5vuSzPumg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n390vnhsyw5AiJxzPH+1yhvSDRc0B9PeJ6t4aGbIK/hyO8XOz/+au/JN4EEsIUfhS
	 o5q5vm2Nug9q3V58QYWHCB5mwSty7KhpHzfOetCNvRuzDO4hSFZO26rhdj0TIpaLR4
	 e0pbYZtGxF9Lr0i+5RuTP2GRwithzfqqzXarY9Mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pauli Virtanen <pav@iki.fi>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/196] Bluetooth: ISO: dont leak skb in ISO_CONT RX
Date: Mon, 13 Oct 2025 16:45:32 +0200
Message-ID: <20251013144320.451318592@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5f6e4c79e190b..c542497f040cc 100644
--- a/net/bluetooth/iso.c
+++ b/net/bluetooth/iso.c
@@ -1729,7 +1729,7 @@ void iso_recv(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
 					  skb->len);
 		conn->rx_len -= skb->len;
-		return;
+		break;
 
 	case ISO_END:
 		skb_copy_from_linear_data(skb, skb_put(conn->rx_skb, skb->len),
-- 
2.51.0



