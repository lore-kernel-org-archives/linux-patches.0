Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC442AF0E;
	Thu, 12 Dec 2024 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016933; cv=none; b=mm8EQMXGh7QMWNHsQK/FuNwaqfoOfRrHcOwaUena163DKphccAQbMWLLU2qXQ7BDtx9pCc9/XQzlhHMLKPpoUKkfqtk9XR4uE21wxv30U6eRUT7IaDa5xaHuFljbNyScAQKB1QmYOlCz/Zd2CYAH4mEuHKfaA9Y5Imrc8wgY3iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016933; c=relaxed/simple;
	bh=/MVwksO2mLQnqSCrzJskPMsUk4AJnETT2Of1oFwxMOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyYwAGP8TcNy96ZsJjaT14c3/i65o86xYTrQ2JqluTotfs/CtLVyheAcSUj8jtjPWPe890RgK9xEOQi84GgkSo7lKUfSfyBf9vOEQp4sBWb/sMD7w1SvnEOVyghi5F28X002mCuZmex6cUqRh/jX3sYKktx9Kvgp17JFwVjxqu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KEaJsuh+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KEaJsuh+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE704C4CED4;
	Thu, 12 Dec 2024 15:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016933;
	bh=/MVwksO2mLQnqSCrzJskPMsUk4AJnETT2Of1oFwxMOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KEaJsuh+Lvlf96TlGPAiOGmv16N3UWBb05MazfLv7XpcvZ/JtFn7unuJQ3xolA9ka
	 f9UsdHAIfHqzZMTs1JJYRjx92G9gvzLwH2/dodIyuDeoZaLB99UHNHkLZerqG1wtYe
	 SXqeYoQYfccO9r+O9CYRbGqXKlL9JLo/Vzr5GVAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/466] dsa: qca8k: Use nested lock to avoid splat
Date: Thu, 12 Dec 2024 15:58:26 +0100
Message-ID: <20241212144320.099878442@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f8d8c70642c4f..59b4a7240b583 100644
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



