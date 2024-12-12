Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F79B223336;
	Thu, 12 Dec 2024 15:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018307; cv=none; b=VGh1CcaosVOniFQI6u7TZCEZPaojQ8XkfN67qeLwweotK5IMBtCZ4twEFcm0o4+AAgmg0qy/is5TOIQmL4ReSZWeNghIxlD3MnUyylkTHEitW4xyvAH0D468oJxjqqjGKAXJgqhH3/8/imYPm6D0MLPtT58tpYmaOghO7gF/fUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018307; c=relaxed/simple;
	bh=ROwjmKNZ8C+gQ90amxw6WHQHM0cLFfcCNiZXfHmRsOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQH1IQyxj2DEqp0DF3zYQpOqwnnn7uRKUmHwWCR0E2qUaRTgE3ePLYSVvO7RRYn7deZfhQllhI5dYRMpyhTaF/c1/NhiIXCbtQd1wNwWiYwljwHzs3hwHZRimdH1a91Uxbu9PcnQRyu1Hc7m0S7YYz3baGekVAJr2A54k+gZ9dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18LaKTq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18LaKTq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC89EC4CECE;
	Thu, 12 Dec 2024 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018307;
	bh=ROwjmKNZ8C+gQ90amxw6WHQHM0cLFfcCNiZXfHmRsOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18LaKTq2996TFoJ7RS0s1WL0g7Wx1YblPlAoeqEQNMc9Kk+L4y9idv8ClrL4DKAIz
	 QL5fLVttV/3iKy14oKhX4W1FbLUDOdpTLGROqRPtfQsQ2xJEWxOxi1BQseBuThlPkD
	 8YaASiQtz59YPePhq36AIQpWhYEe/F2P+M78G3dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/356] dsa: qca8k: Use nested lock to avoid splat
Date: Thu, 12 Dec 2024 15:59:34 +0100
Message-ID: <20241212144254.679795184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 078e0d596f7b5952dad8662ace8f20ed2165e2ce ]

qca8k_phy_eth_command() is used to probe the child MDIO bus while the
parent MDIO is locked. This causes lockdep splat, reporting a possible
deadlock. It is not an actually deadlock, because different locks are
used. By making use of mutex_lock_nested() we can avoid this false
positive.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241110175955.3053664-1-andrew@lunn.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 17c28fe2d7433..384ae32c05b1c 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -673,7 +673,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	 * We therefore need to lock the MDIO bus onto which the switch is
 	 * connected.
 	 */
-	mutex_lock(&priv->bus->mdio_lock);
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	/* Actually start the request:
 	 * 1. Send mdio master packet
-- 
2.43.0



