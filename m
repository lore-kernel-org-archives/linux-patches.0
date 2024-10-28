Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B469015B10D;
	Mon, 28 Oct 2024 06:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097770; cv=none; b=rVHeTkn05Kwn1CnK58rbtc23i3XqDBABzVhB+lxpM47tpCTAXFSjjS6k2NK/O9DHk5LuW5AHW0u74o4kODKbZ/lMuaGq6Up3CpnPa2LtiXdVQExULgUraNlhxdSWY/U4wM9miyMbHQy0qVPwiyz5RHNGK6W/3SmDWMwromp0rnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097770; c=relaxed/simple;
	bh=wPQNTrJuav//DM/MvaYXRCQJsMrqpsfpL7GFE/iiZ2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncGpoLH0QDwdsWg4q//b86dBPLQJdjUUGrVDv+evIfnzCiC93xftCoASfm4ofQ1Jf5P56DioEEanNmq801zcTz0yYvwpvSJ0qxOhqZLvwAwhdvm4UJxM8jMua3R1SwUUTU2GITLZwf58R4sv/5jw7Su6t8vDYEEklUcuIs8yibM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SffDKKVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SffDKKVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04058C4CEC3;
	Mon, 28 Oct 2024 06:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097770;
	bh=wPQNTrJuav//DM/MvaYXRCQJsMrqpsfpL7GFE/iiZ2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SffDKKVSHRnWA0dhwuMxZdV07UWPKNIq77BWh3tBLvWWl1geYvyeBWByMUBpnajC4
	 5yFPjWTjZt5VIuU8lWo66eTsKX+BvcTd26tpDTUkA/Xv2EvlZTX1Ppffm4brCjKtl5
	 PmYYgY7rSQuW8MizQTyChD1/nHHNDhtuseYBGqgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Boehm <boehm.jakub@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 138/208] net: plip: fix break; causing plip to never transmit
Date: Mon, 28 Oct 2024 07:25:18 +0100
Message-ID: <20241028062310.034506747@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 40ce8abe69995..6019811920a44 100644
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



