Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B431318A6AE;
	Tue, 17 Jun 2025 16:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176209; cv=none; b=df+3UHKH+mGQsYCuC/GA2vSRGlmwQtr550fFdWEfLgpp1uAp9HIP3TTE553N6wT2jQ0FmErxL+Wo4Pulvn9B8jXj581VKCrx5QfFdpw37Ne+9nOzJu+h1EZh8T7Z4CnetsxioiPaKcrFArWeXO+FBk9uDx+sdlb0n2EYOi62+L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176209; c=relaxed/simple;
	bh=Pbd/rG0/6Cokg5KKCHaQQqUE5ubpYvWb+2sOuwImAGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AwBWp3WRUDufIdv+Lh6m1OASrOiVOYa5aj2+Y9xLLoax+tZbxLIcKS/E95EQgzuMWpktDSiOAbyYzVkWIp8YzEXgeThpL2eUDAmtAbSBfz1BqAdfiDz0hvfM+lX6iTPijsnJhocslZm2uPze8xpdr2dOKjfJcDDaFWeei5n+3P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yqmud+zb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yqmud+zb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 250C1C4CEE3;
	Tue, 17 Jun 2025 16:03:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176209;
	bh=Pbd/rG0/6Cokg5KKCHaQQqUE5ubpYvWb+2sOuwImAGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yqmud+zbdO7HdrCdcANa+xgetKLTnqlIGH/oC/3IAW5ioWAtQ5I59ucLY0MO5nhpm
	 dbpHz76SirdKn9Jvzikd2goXGeq/VU8yrX8sxOs76OHNTo9inYcNU9uOHx0Pn57pVn
	 YE6M5yYYvUJBy056WX2LTuFP7jI/SxxDlaNp+k5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/356] net: dsa: tag_brcm: legacy: fix pskb_may_pull length
Date: Tue, 17 Jun 2025 17:26:10 +0200
Message-ID: <20250617152348.474549118@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit efdddc4484859082da6c7877ed144c8121c8ea55 ]

BRCM_LEG_PORT_ID was incorrectly used for pskb_may_pull length.
The correct check is BRCM_LEG_TAG_LEN + VLAN_HLEN, or 10 bytes.

Fixes: 964dbf186eaa ("net: dsa: tag_brcm: add support for legacy tags")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250529124406.2513779-1-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/dsa/tag_brcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/dsa/tag_brcm.c b/net/dsa/tag_brcm.c
index cacdafb41200e..146c1dbd15a93 100644
--- a/net/dsa/tag_brcm.c
+++ b/net/dsa/tag_brcm.c
@@ -257,7 +257,7 @@ static struct sk_buff *brcm_leg_tag_rcv(struct sk_buff *skb,
 	int source_port;
 	u8 *brcm_tag;
 
-	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_PORT_ID)))
+	if (unlikely(!pskb_may_pull(skb, BRCM_LEG_TAG_LEN + VLAN_HLEN)))
 		return NULL;
 
 	brcm_tag = dsa_etype_header_pos_rx(skb);
-- 
2.39.5



