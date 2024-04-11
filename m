Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BCFA6BB29;
	Thu, 11 Apr 2024 10:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832345; cv=none; b=qv5pUzI5Mz/1mrnn7ofima4CxprFhTL3sNDvmDSWjBt8WTHKqGxvJB+49kuVfghfBHQhO69jodQZ+R9ap0Go8GnlGwGIcFCjlZqFCNmb5sosgNQLuY7AxNUeNvAEcrUhyeEzvWS96/NFh0qldof5VenpoRQavWiiqK3Mcq7YOtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832345; c=relaxed/simple;
	bh=3WNVBvW1TOneoNHKr++5vI5AUPLjuKjBQTbzShp1oU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhQ/UDUgZa/I5+DOhkuQOI9xy0Sg2H7AVkEzTE+wwLDCIm0SxZpU8jRidT21raUTaXt/pumz9zp7fG3aRmiDjv5qhd04vFoMzJHzHDIYrG44zUgmZ4gwJSEQ6zxW4nyn8Dog2PhEfxWzpgyhWJvAgJWcVdOk1ww5gmYXFKIftRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/yPjaAo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/yPjaAo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DE75C433F1;
	Thu, 11 Apr 2024 10:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832345;
	bh=3WNVBvW1TOneoNHKr++5vI5AUPLjuKjBQTbzShp1oU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C/yPjaAoheKxdc+vDdtST4UeVw66ygywmQzCWTbBEiQn+n6vwIC3n9Ux+fl7zMwQz
	 pFHIXd1/onYCg1pNMnO8Anx6JnV6J+kpe3DQyB9K12hMQwS76TE1YwIfcHlwAhut3e
	 zJcVDYXIPPIU0kgCuLBfL13C7L3EqfodpqQbdR60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 18/83] net: pcs: xpcs: Return EINVAL in the internal methods
Date: Thu, 11 Apr 2024 11:56:50 +0200
Message-ID: <20240411095413.226623709@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3f882bce37f42..d126273daab4f 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -262,7 +262,7 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 		dev = MDIO_MMD_VEND2;
 		break;
 	default:
-		return -1;
+		return -EINVAL;
 	}
 
 	ret = xpcs_write(xpcs, dev, MDIO_CTRL1, MDIO_CTRL1_RESET);
@@ -904,7 +904,7 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 			return ret;
 		break;
 	default:
-		return -1;
+		return -EINVAL;
 	}
 
 	if (compat->pma_config) {
-- 
2.43.0



