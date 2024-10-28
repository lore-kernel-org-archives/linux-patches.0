Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24853152E1C;
	Mon, 28 Oct 2024 06:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730096948; cv=none; b=uKp5CbJVpt70cg28wZNQ7559pUuPDVKWniz0li/nucIkSO8XzWZf+qZA3/JIW4oMj02QTOLx6z4rNbl6a+eHlLU9WP0KpdZT9EjBJvkh6WThHJ39w/SS9ih/ivCYNn60Q2rINfi3kRkD8obt/PSmd38VyriebDBPbintF9+ll9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730096948; c=relaxed/simple;
	bh=+ljw5/ZzWSh2kRwF/jYIpEx56TgJADJ5r5U0BAxA1Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntRNztqA0FOpdcw4P6j48t3HCR+1G4RXKFpBoKfiVMxSTLr7N2vJa5RWUf/M+u4haM7bJH1wbeMkX/uV1UYd+b85/Yy/ghkcdvZjsbmFPPWLQqu8mGuT2wZi1yuxWrukwl8hGaJQ5G1OF6DRQd/rlhPUq6rfibjPW3N/UQDtGMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dC5Xewf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dC5Xewf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C3BC4CEC3;
	Mon, 28 Oct 2024 06:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730096947;
	bh=+ljw5/ZzWSh2kRwF/jYIpEx56TgJADJ5r5U0BAxA1Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dC5Xewf2ylWv347ZitxStvjoDZ4HWrXnq9RCdyz5Ba6OTQJ2B4bEXHDTzi8isUL0j
	 pweDc1J9Xtu2jjRo5Ab6F2viKJRYqN/RevMBjgLXwkGdWoHqXvmcS0gxLICNEmOQyA
	 zqSwZRTkWmH/2utLv60eVDEYZXF+LaWSYRJPOE7M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Boehm <boehm.jakub@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 56/80] net: plip: fix break; causing plip to never transmit
Date: Mon, 28 Oct 2024 07:25:36 +0100
Message-ID: <20241028062254.173670127@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index b1776116f9f7d..bea741afe78be 100644
--- a/drivers/net/plip/plip.c
+++ b/drivers/net/plip/plip.c
@@ -811,7 +811,7 @@ plip_send_packet(struct net_device *dev, struct net_local *nl,
 				return HS_TIMEOUT;
 			}
 		}
-		break;
+		fallthrough;
 
 	case PLIP_PK_LENGTH_LSB:
 		if (plip_send(nibble_timeout, dev,
-- 
2.43.0



