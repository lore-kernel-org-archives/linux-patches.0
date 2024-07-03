Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1C945945;
	Wed,  3 Jul 2024 11:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004980; cv=none; b=IN1FqU2Oe7NGCDQVPVH46p+b8kyb3Sk43eZXKTpJlE6M6ksMkVXTjuwSW6pkC/mnhOAKPgXEhzk2qkhPpi0d0S/HSgUuKQxvUWYhDkaPjVYcLGD4jDPPiO22+4sj+4eQmNEcRfo3k8VvAKlrsZhtqTFhhPCOQN0GTrCcAla+Qjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004980; c=relaxed/simple;
	bh=T2aEW1oO9aThSe8Q+lt5Y9lxyqRtEOFh0aXifJ9Y+s4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWGj3G8WfUtRQzaz0d7xoE9PZ2JbjUD4Tz6LnyRZjzdqGQzWLjqlYzk4UbA4e8cztMhoL58yDc5fmvX/qjA3R3TJJ6qv7jBmeYyu57vDTB5WGC1XFKYHZlF5UHwYCmn2JVX/Uw9y2rbUlkMpRGAPm2LPfLGy9I45Gm3XfhYED0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xcmzoLZn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xcmzoLZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FDF4C2BD10;
	Wed,  3 Jul 2024 11:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004980;
	bh=T2aEW1oO9aThSe8Q+lt5Y9lxyqRtEOFh0aXifJ9Y+s4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xcmzoLZnzvRgcEMxPUxJHm1cPEnNi8h0hj2qHt0V+SBGtaY1bJjklmp+gRDBZw5Vg
	 tLrIbTfKfSRizmCHnvk7WQD/2c7TZccKkb+GMtdqVBcYlE52WLFTLRn0JEwJ8DQl9+
	 eRNnHE5Evu1OeVa4VfVuNM/GAMxD2wYTwrVjUlkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristram Ha <tristram.ha@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/290] net: dsa: microchip: fix initial port flush problem
Date: Wed,  3 Jul 2024 12:40:00 +0200
Message-ID: <20240703102912.429344542@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/net/dsa/microchip/ksz9477.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
index f42f2f4e4b60e..535b64155320a 100644
--- a/drivers/net/dsa/microchip/ksz9477.c
+++ b/drivers/net/dsa/microchip/ksz9477.c
@@ -206,10 +206,8 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
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
-- 
2.43.0



