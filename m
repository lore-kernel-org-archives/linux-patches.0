Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E2113B280;
	Wed,  3 Jul 2024 11:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006013; cv=none; b=AeYwJDTtLznZbsfaQXlTpYAygESb82TogK4jvHfxD7TsERys3lXLACQpS++yLUDdhKhgin4gxb5aeYby2hhQEuhR9bLacxptNGVxE8fKAa4J3Ny9STqsgkT+CoQD29MtVtrN63H6o907M0rDCP5+tMdSsO3kHMpyJ93a4G4kAQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006013; c=relaxed/simple;
	bh=uZrcq+Ch/nbcI2raLdCPMMouU4fEH6qNxJnrBDNPoHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=foQERtu7k01633j8E90Ww7kh4QDaas01l3B26zO5MuoBFyl5JXlhcbj33gcuu0ti4arB8G2/n+QfNFhPJ2ePK+7iJB0O4scBG66rYMvoOxmoNcyZ7Mz1aHvV4YMwiwLC1dhyzcEeuUq5tRYOalq0wUNwcwAzKSGgZ9rOr6X9SxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zAfP6tqH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zAfP6tqH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A03C2BD10;
	Wed,  3 Jul 2024 11:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006013;
	bh=uZrcq+Ch/nbcI2raLdCPMMouU4fEH6qNxJnrBDNPoHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zAfP6tqHLmMTKoRJaAR80+7LSr0jPsjpemxS0GeyicqChhXpm2WWYCQgKWbrURt65
	 LaFC8ols/ry0lBHGV8EZN7ls2CgV/lLx71oZ4BTUViw7T6rvgndD7z3pzXVEO04LHw
	 PndK7ZM4fQDAHQaFGQTORtNzCOaQNzo9qTZdSGMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 271/356] net: dsa: microchip: fix initial port flush problem
Date: Wed,  3 Jul 2024 12:40:07 +0200
Message-ID: <20240703102923.368095040@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Tristram Ha <tristram.ha@microchip.com>

[ Upstream commit ad53f5f54f351e967128edbc431f0f26427172cf ]

The very first flush in any port will flush all learned addresses in all
ports.  This can be observed by unplugging the cable from one port while
additional ports are connected and dumping the fdb entries.

This problem is caused by the initially wrong value programmed to the
REG_SW_LUE_CTRL_1 register.  Setting SW_FLUSH_STP_TABLE and
SW_FLUSH_MSTP_TABLE bits does not have an immediate effect.  It is when
ksz9477_flush_dyn_mac_table() is called then the SW_FLUSH_STP_TABLE bit
takes effect and flushes all learned entries.  After that call both bits
are reset and so the next port flush will not cause such problem again.

Fixes: b987e98e50ab ("dsa: add DSA switch driver for Microchip KSZ9477")
Signed-off-by: Tristram Ha <tristram.ha@microchip.com>
Link: https://patch.msgid.link/1718756202-2731-1-git-send-email-Tristram.Ha@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz9477.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -195,7 +195,6 @@ static int ksz9477_wait_alu_sta_ready(st
 
 static int ksz9477_reset_switch(struct ksz_device *dev)
 {
-	u8 data8;
 	u32 data32;
 
 	/* reset switch */
@@ -206,10 +205,8 @@ static int ksz9477_reset_switch(struct k
 			   SPI_AUTO_EDGE_DETECTION, 0);
 
 	/* default configuration */
-	ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
-	data8 = SW_AGING_ENABLE | SW_LINK_AUTO_AGING |
-	      SW_SRC_ADDR_FILTER | SW_FLUSH_STP_TABLE | SW_FLUSH_MSTP_TABLE;
-	ksz_write8(dev, REG_SW_LUE_CTRL_1, data8);
+	ksz_write8(dev, REG_SW_LUE_CTRL_1,
+		   SW_AGING_ENABLE | SW_LINK_AUTO_AGING | SW_SRC_ADDR_FILTER);
 
 	/* disable interrupts */
 	ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);


