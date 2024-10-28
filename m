Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13E28837;
	Mon, 28 Oct 2024 06:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098258; cv=none; b=KbYzSaDQC/MBKAP6ZOKAps+PwWfBuIpSXoD2veQytXdQEy2eMudKpjEG5DarJ5XhFFKtnII8/4SnFbZRCoVtM+vKUbLB+qpINimWy3OeRWSDpLmAg1gN4JRooEgvdH5Vh4u7Jba8JpjcHwFlvE5ymsK0v1YtJePX+klU6iy3NlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098258; c=relaxed/simple;
	bh=6z7GeidsxwY5FQ0kCkBrUIsNWzLkWZ8Wt9gnFA07Q7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ND+I1GTjd1DDnnONhHdSyoB8/lSkIonJcnIJaCZB+oPt4ssb4h4B6UwctSkBprvy8FB6nRhRr4y1IFmxZBJAloqcu8tZz7gkjHwI1iDWdlfoIBj5DxaQEiiWN+nl244eLgPpJBI6ReaNhtRGVAKFaRyWxSHLDPVVLUWF23e7duk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUB3ijF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUB3ijF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22084C4CEC3;
	Mon, 28 Oct 2024 06:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098258;
	bh=6z7GeidsxwY5FQ0kCkBrUIsNWzLkWZ8Wt9gnFA07Q7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MUB3ijF3FADiPNRzDEDqKKuZ4YLkZt95QbsD2NYreZoL+/kdI0bhHzmMs+yBaKhAx
	 k1bgkcWSLlPHB9qbERE38DSYy+cGwRtbPk/el+Bni/bZRj4U6uhsf4ILLJm/xXiLqU
	 ozn0EC1BityKc71CVBDhISfaD6Uldr5PDlIGYSBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Boehm <boehm.jakub@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 148/261] net: plip: fix break; causing plip to never transmit
Date: Mon, 28 Oct 2024 07:24:50 +0100
Message-ID: <20241028062315.749768266@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Boehm <boehm.jakub@gmail.com>

[ Upstream commit f99cf996ba5a315f8b9f13cc21dff0604a0eb749 ]

Since commit
  71ae2cb30531 ("net: plip: Fix fall-through warnings for Clang")

plip was not able to send any packets, this patch replaces one
unintended break; with fallthrough; which was originally missed by
commit 9525d69a3667 ("net: plip: mark expected switch fall-throughs").

I have verified with a real hardware PLIP connection that everything
works once again after applying this patch.

Fixes: 71ae2cb30531 ("net: plip: Fix fall-through warnings for Clang")
Signed-off-by: Jakub Boehm <boehm.jakub@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Message-ID: <20241015-net-plip-tx-fix-v1-1-32d8be1c7e0b@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/plip/plip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/plip/plip.c b/drivers/net/plip/plip.c
index e39bfaefe8c50..d81163bc910a3 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -815,7 +815,7 @@ plip_send_packet(struct net_device *dev, struct net_local *nl,
 				return HS_TIMEOUT;
 			}
 		}
-		break;
+		fallthrough;
 
 	case PLIP_PK_LENGTH_LSB:
 		if (plip_send(nibble_timeout, dev,
-- 
2.43.0



