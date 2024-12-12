Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CCB2EAE5;
	Thu, 12 Dec 2024 15:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016736; cv=none; b=M1o2SWMNAo0ivB8OjecJgqc7oqbEIVbtVX4X9Kt9dbH3GteFTjv70oOJMEJ6KdGXvW6u0swE45TxJ6Xocu89T9EKFpXIXyu51drk8z7nGs2Z8peKzAJXH9DNwbesmnM1BYaKLdeFW73ekXYHUltm5yDEr3p9v/vNQaCHJPXmT0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016736; c=relaxed/simple;
	bh=zOV4mMBXn0XITHfbVrdvPT78G4u7MwcO6amyrF3bWUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azj7+HLIDUId8hc+FLX7F0TV5UFhsxslTi3hfF1ZB333mZP7wGVxtglehx2jdQfFuJoavcGPTKTUsaUfdJ3isRRelAwSW+ChHNm3Aa4OKYtmTf4cMJjPTqkDkOzI95jf8SPVH5G19GfdqXbXpf/xdLKuES7+BuclPagqxOWOX2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FKp6ltg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FKp6ltg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9ED0C4CECE;
	Thu, 12 Dec 2024 15:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016736;
	bh=zOV4mMBXn0XITHfbVrdvPT78G4u7MwcO6amyrF3bWUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FKp6ltg/U+AmjR/2sTj7tBHB+xmgC7WCeaZHeoQP6kDi1SAW1H0jCeK/sk7JpyAzx
	 18BM8Ma9ppWRHTvO8bUwkSV6xfzFaLiS2dveYOR4F9C4rnV/vCupbQHncQYYVytjFg
	 GqGe7X4ek3U6ycKE0LEdXZSVijhngBGNH1FOu7Pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Simon Horman <horms@kernel.org>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/466] net: fec_mpc52xx_phy: Use %pa to format resource_size_t
Date: Thu, 12 Dec 2024 15:57:33 +0100
Message-ID: <20241212144318.011097094@linuxfoundation.org>
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

From: Simon Horman <horms@kernel.org>

[ Upstream commit 020bfdc4ed94be472138c891bde4d14241cf00fd ]

The correct format string for resource_size_t is %pa which
acts on the address of the variable to be formatted [1].

[1] https://elixir.bootlin.com/linux/v6.11.3/source/Documentation/core-api/printk-formats.rst#L229

Introduced by commit 9d9326d3bc0e ("phy: Change mii_bus id field to a string")

Flagged by gcc-14 as:

drivers/net/ethernet/freescale/fec_mpc52xx_phy.c: In function 'mpc52xx_fec_mdio_probe':
drivers/net/ethernet/freescale/fec_mpc52xx_phy.c:97:46: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' {aka 'long long unsigned int'} [-Wformat=]
   97 |         snprintf(bus->id, MII_BUS_ID_SIZE, "%x", res.start);
      |                                             ~^   ~~~~~~~~~
      |                                              |      |
      |                                              |      resource_size_t {aka long long unsigned int}
      |                                              unsigned int
      |                                             %llx

No functional change intended.
Compile tested only.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Closes: https://lore.kernel.org/netdev/711d7f6d-b785-7560-f4dc-c6aad2cce99@linux-m68k.org/
Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20241014-net-pa-fmt-v1-1-dcc9afb8858b@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_mpc52xx_phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
index 39689826cc8ff..ce253aac5344c 100644
--- a/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
+++ b/drivers/net/ethernet/freescale/fec_mpc52xx_phy.c
@@ -94,7 +94,7 @@ static int mpc52xx_fec_mdio_probe(struct platform_device *of)
 		goto out_free;
 	}
 
-	snprintf(bus->id, MII_BUS_ID_SIZE, "%x", res.start);
+	snprintf(bus->id, MII_BUS_ID_SIZE, "%pa", &res.start);
 	bus->priv = priv;
 
 	bus->parent = dev;
-- 
2.43.0



