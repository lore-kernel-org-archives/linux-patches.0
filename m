Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C4E145B06;
	Thu, 11 Apr 2024 10:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830120; cv=none; b=l/Yv5oFAAjcfyC5ItRjnhg3GnZemYcjcNMh8NPBq5Y4M47LrCjDqYONNlLUTvYgU9PA5/wfyBVjE9dy8trR/EnPoeraA2rAuX9R9C6vah6zle85EYbdbgCVDDNt6ruFthNPMGk+mXtxo4I5ynyVzyUMp1MPuixpDCNhzkGfgsEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830120; c=relaxed/simple;
	bh=pz2E+wVgAhgjhMYyzuX+h/Gvr6aXl4FbcQxTV97O/10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLUzLRZTeuWcB6s/cBkZFMuU4HBZtnap7fLQVVhQwcR7brRe8qyxZ8p35pgIVh2D7EsDNNU41QxVyRb8OVIaiEoT5uqaihLKVzGf4TNZSN/TcY7iy1jUsLsbMKkI2eV/Q4m7bVc3ZwGQZ3hgIK830Oyo1Lz639TqfhV7oVWzLoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t41xolph; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t41xolph"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5460BC433F1;
	Thu, 11 Apr 2024 10:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830119;
	bh=pz2E+wVgAhgjhMYyzuX+h/Gvr6aXl4FbcQxTV97O/10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t41xolphhV35mgRC6J5HFjcDjmM2C45vKt9KXzGdH9m69DYFpG5wAp5YHOrjFDWQ/
	 mWdENMM/vM7ZaWsC5kU4lhTZJE7t9UeNoBGxtj7XYK4ujeUAef1WHZ3FL3NN7W7Bfg
	 Fts+LguIIN79EdtPInY/ROtrnLxYcxNe+EwMWKro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 040/143] net: pcs: xpcs: Return EINVAL in the internal methods
Date: Thu, 11 Apr 2024 11:55:08 +0200
Message-ID: <20240411095422.120588469@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 31f0beba638a2..03d6a6aef77cd 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -293,7 +293,7 @@ static int xpcs_soft_reset(struct dw_xpcs *xpcs,
 		dev = MDIO_MMD_VEND2;
 		break;
 	default:
-		return -1;
+		return -EINVAL;
 	}
 
 	ret = xpcs_write(xpcs, dev, MDIO_CTRL1, MDIO_CTRL1_RESET);
@@ -891,7 +891,7 @@ int xpcs_do_config(struct dw_xpcs *xpcs, phy_interface_t interface,
 			return ret;
 		break;
 	default:
-		return -1;
+		return -EINVAL;
 	}
 
 	if (compat->pma_config) {
-- 
2.43.0



