Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B112EAE5;
	Thu, 11 Apr 2024 10:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832726; cv=none; b=I+ySbXDE7pSWx5UEmVjvXv7vaf+Ym89lDIIQ3LYPfxPy1DOqWNfOjE1F2WKCcJywoczVwRbY6VgSfpnPBc7uVr2wD6zagkpq3Ot6RNve2BO4E8Q9JAmfbkG9PmbRVbh6tEbSctEOCERc/9766UWY73d//PIuRr3Gm6OEiSjC2dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832726; c=relaxed/simple;
	bh=uAkr0ySvkRYzKebrUmc3r6nFL0irOF6SAkYks9Y+6EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AF90XdK8lt72tIWylAwr4op2v9O/EdlSRt+XQebyPVHxiay4BES8HejQmw1y7P72wmPZ0VdVdfK4sSaTBmSJmjNpCDcOQVq7Q0XWUKHXoXUSwdPLc3VD0gTLhGjcMlda79R9diT3f3KIOnM4Hnj8y4tigFwBLHx+MucmQV/H0M4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vr8GfMXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vr8GfMXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01FBEC433C7;
	Thu, 11 Apr 2024 10:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832726;
	bh=uAkr0ySvkRYzKebrUmc3r6nFL0irOF6SAkYks9Y+6EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vr8GfMXUXFMWhMswv7mxSBlLTE+re/2VmpaNvNTeAWCzpEWJXNPAnPyW0HWMgRXyw
	 /2RNM+fnve9EmcuGwA8dFbtip2h1nmz+Fn32ZzEeFQ2+CD2t2KmjKI2Ab3bvD7jDHm
	 7Kneqi3rmsjKE+Mi45mRFf+G6ysBdF7ZDQ6a5WRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 13/57] net: pcs: xpcs: Return EINVAL in the internal methods
Date: Thu, 11 Apr 2024 11:57:21 +0200
Message-ID: <20240411095408.394354303@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit f5151005d379d9ce42e327fd3b2d2aaef61cda81 ]

In particular the xpcs_soft_reset() and xpcs_do_config() functions
currently return -1 if invalid auto-negotiation mode is specified. That
value might be then passed to the generic kernel subsystems which require
a standard kernel errno value. Even though the erroneous conditions are
very specific (memory corruption or buggy driver implementation) using a
hard-coded -1 literal doesn't seem correct anyway especially when it comes
to passing it higher to the network subsystem or printing to the system
log.  Convert the hard-coded error values to -EINVAL then.

Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Tested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 556ca98843565..ab382496c3a83 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -242,7 +242,7 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 		dev = MDIO_MMD_VEND2;
 		break;
 	default:
-		return -1;
+		return -EINVAL;
 	}
 
 	ret = xpcs_write(xpcs, dev, MDIO_CTRL1, MDIO_CTRL1_RESET);
@@ -808,7 +808,7 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 			return ret;
 		break;
 	default:
-		return -1;
+		return -EINVAL;
 	}
 
 	if (compat->pma_config) {
-- 
2.43.0



