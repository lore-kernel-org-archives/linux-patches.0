Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D198F384;
	Thu, 13 Jun 2024 12:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282539; cv=none; b=FrhlKmqGCB5HVAaXSHTaCMDuJLBFUzz+beh71SwEF0lJfoQf4nS9yGnkfSZ3laLLTzEd838mW3KAz5R2TuKe80XHSLOlQHekK4KCYWMtDjhAocou9GTp8jwg4YeOZi5yu5WugjwQxFSXDT18UbmZaEIdxWFRgQpeSA2/RmE48Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282539; c=relaxed/simple;
	bh=3zfNU6JgC+eZ3UiHwd5nG4FCpGUc60IMzv88WBeZpYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGGRFHyrBkByC1gQrvmZwjf9zBxAPDY7YKksinBDijFhHncC9i9ezzrs7htntx2Nlpab7o0MHWgRlOxgl7pnl0pv3Yn7dj4xbsuTY9MTsdiTuRfYHtvS4snKmbg/yafTncQhjv/ONmRCTVE0CsY58/WpHuuPp7Zt75fQis9YmLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qnpl2CGb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qnpl2CGb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3966C32786;
	Thu, 13 Jun 2024 12:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282539;
	bh=3zfNU6JgC+eZ3UiHwd5nG4FCpGUc60IMzv88WBeZpYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qnpl2CGbPwYVVO0e0hPFKidnuSsmj+jB+ZaGbU0TIhcjAKhcYhKnwbdoKHLCJUmel
	 UPXNdBLUCrx05VKcSSp02ODGGk5MszNGPqSM3cLZUf8XBnvynTcJL3rIgACC86uf4N
	 KbC8fZtAoO6ye/aJIlW6wM+PoudSFRyI8mg9EkY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Langstaff <stephenlangstaff1@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 284/402] net: Always descend into dsa/ folder with CONFIG_NET_DSA enabled
Date: Thu, 13 Jun 2024 13:34:01 +0200
Message-ID: <20240613113313.232394305@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit b1fa60ec252fba39130107074becd12d0b3f83ec ]

Stephen reported that he was unable to get the dsa_loop driver to get
probed, and the reason ended up being because he had CONFIG_FIXED_PHY=y
in his kernel configuration. As Masahiro explained it:

  "obj-m += dsa/" means everything under dsa/ must be modular.

  If there is a built-in object under dsa/ with CONFIG_NET_DSA=m,
  you cannot do  "obj-$(CONFIG_NET_DSA) += dsa/".

  You need to change it back to "obj-y += dsa/".

This was the case here whereby CONFIG_NET_DSA=m, and so the
obj-$(CONFIG_FIXED_PHY) += dsa_loop_bdinfo.o rule is not executed and
the DSA loop mdio_board info structure is not registered with the
kernel, and eventually the device is simply not found.

To preserve the intention of the original commit of limiting the amount
of folder descending, conditionally descend into drivers/net/dsa when
CONFIG_NET_DSA is enabled.

Fixes: 227d72063fcc ("dsa: simplify Kconfig symbols and dependencies")
Reported-by: Stephen Langstaff <stephenlangstaff1@gmail.com>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 50e60852f1286..e5ed9dff10a24 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -46,7 +46,9 @@ obj-$(CONFIG_ARCNET) += arcnet/
 obj-$(CONFIG_DEV_APPLETALK) += appletalk/
 obj-$(CONFIG_CAIF) += caif/
 obj-$(CONFIG_CAN) += can/
-obj-$(CONFIG_NET_DSA) += dsa/
+ifdef CONFIG_NET_DSA
+obj-y += dsa/
+endif
 obj-$(CONFIG_ETHERNET) += ethernet/
 obj-$(CONFIG_FDDI) += fddi/
 obj-$(CONFIG_HIPPI) += hippi/
-- 
2.43.0



