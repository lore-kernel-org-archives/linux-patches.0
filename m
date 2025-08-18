Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8F827F758;
	Mon, 18 Aug 2025 13:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524988; cv=none; b=PTwZzz0E84LtVyBqjV78fWXCAEaaHOtX+QXKE9hN+UGGEnLrXkXyo09Oz06WcU6QOtVSe9GkfCMsu/w3ChJc4dIL3jU++XNi73gL+gfQCv0St8/QDqzxLmuPY3IqFNEOrs06R3TKCwI/70xP/TlpmVI8/DhmZ5hsKNoGf4cKoCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524988; c=relaxed/simple;
	bh=Dh8ISqBbezMKg3H4s0/mbhZL2Ir4r1M62xB0gtmL1a4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+/K4jqdquM23mGf9PdCC92Mr2ouayqu+OnUHWRcLajDIW3znv7VyjPGezvQGfXngghjuT2EqiFnouvt282IGjnwA6YDU/qqRxsmikcTismrJv/a3AjwOS3a0wkeLG9uD2NtuUwSRMIV4DEpY5yMW8oyGgIVU3knkgiqBEeM92k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXg8Dd43; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXg8Dd43"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03E9C4CEEB;
	Mon, 18 Aug 2025 13:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524988;
	bh=Dh8ISqBbezMKg3H4s0/mbhZL2Ir4r1M62xB0gtmL1a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXg8Dd43xuS4T6aP0sxuqxjztZkiYvFUZ4RSaUi/JyCgWDWowfHAgnAcDD9BhuHkc
	 dpXKJ8Xu8qULuqT6jiXe82yjdZ+hVRRvVwh9B2gV5kB8iq9fV7ism9CXnBLZYIMQTa
	 pzeSy1uIm2x+foq9mCzCt4+5+BoV4kcyH3KnIsfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 124/570] usb: xhci: print xhci->xhc_state when queue_command failed
Date: Mon, 18 Aug 2025 14:41:51 +0200
Message-ID: <20250818124510.597720391@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit 7919407eca2ef562fa6c98c41cfdf6f6cdd69d92 ]

When encounters some errors like these:
xhci_hcd 0000:4a:00.2: xHCI dying or halted, can't queue_command
xhci_hcd 0000:4a:00.2: FIXME: allocate a command ring segment
usb usb5-port6: couldn't allocate usb_device

It's hard to know whether xhc_state is dying or halted. So it's better
to print xhc_state's value which can help locate the resaon of the bug.

Signed-off-by: Su Hui <suhui@nfschina.com>
Link: https://lore.kernel.org/r/20250725060117.1773770-1-suhui@nfschina.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-ring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index 94c9c9271658..131e7530ec4a 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -4372,7 +4372,8 @@ static int queue_command(struct xhci_hcd *xhci, struct xhci_command *cmd,
 
 	if ((xhci->xhc_state & XHCI_STATE_DYING) ||
 		(xhci->xhc_state & XHCI_STATE_HALTED)) {
-		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command\n");
+		xhci_dbg(xhci, "xHCI dying or halted, can't queue_command. state: 0x%x\n",
+			 xhci->xhc_state);
 		return -ESHUTDOWN;
 	}
 
-- 
2.39.5



