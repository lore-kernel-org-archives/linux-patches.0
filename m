Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D38098837;
	Mon, 28 Oct 2024 06:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098011; cv=none; b=ohrkCCQMgKeXTR+8moWZPvFRgaQsg1qpC3BUzbTBBtoOi28NXR77kSUGtRaJ+F3XTIzr+TmevaaP73BFPvdIvO80IqRAGsCGwKIOWOkxVqeeyN/RDtMoxGqmMM0smQX3YtszW/j7bF2fyL8Xx6O69wOVfzr7MMULbej/ySvbtwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098011; c=relaxed/simple;
	bh=Wu8BTip+5SawOtJE/PexleDtdTlKCNil4sYIzIJ7IT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ak7ATSHL7ebitCf4uwgsoA8qHQKn9HrW04sw0TrEK9J9ITDi71uupvdAbmjKmF+xRizBX4xeGmFigg8YfHF/yBccbHDAwA1cJ6BioPZ2CbCrEDkoy/rS5OYlzY1aLhPdMMTyxOBMec8UHgon482RnfHvOlsQGWwYgdP0Ro7u/FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZstMUj7J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZstMUj7J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A656C4CEC3;
	Mon, 28 Oct 2024 06:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098011;
	bh=Wu8BTip+5SawOtJE/PexleDtdTlKCNil4sYIzIJ7IT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZstMUj7JWkcacaGf1uJQ7wLS5CRtw5rDX8Hcn6bH+nHSG4MS+WH7odEUbteV/hGMy
	 J9Jmfg4UkAJKptM/WEtTRgZko8epGOJ0shQBQoXlG6585Ixp1CgUvJiTytBG+4o1IS
	 VYq6tBgIiMzRhY8UeuJwtId2hz78P7gA4TMdORlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 038/261] net: sparx5: fix source port register when mirroring
Date: Mon, 28 Oct 2024 07:23:00 +0100
Message-ID: <20241028062312.964462593@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 8a6be4bd6fb319cee63d228e37c8dda5fd1eb74a ]

When port mirroring is added to a port, the bit position of the source
port, needs to be written to the register ANA_AC_PROBE_PORT_CFG.  This
register is replicated for n_ports > 32, and therefore we need to derive
the correct register from the port number.

Before this patch, we wrongly calculate the register from portno /
BITS_PER_BYTE, where the divisor ought to be 32, causing any port >=8 to
be written to the wrong register. We fix this, by using do_div(), where
the dividend is the register, the remainder is the bit position and the
divisor is now 32.

Fixes: 4e50d72b3b95 ("net: sparx5: add port mirroring implementation")
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241009-mirroring-fix-v1-1-9ec962301989@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/sparx5/sparx5_mirror.c    | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_mirror.c b/drivers/net/ethernet/microchip/sparx5/sparx5_mirror.c
index 15db423be4aa6..459a53676ae96 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_mirror.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_mirror.c
@@ -31,10 +31,10 @@ static u64 sparx5_mirror_port_get(struct sparx5 *sparx5, u32 idx)
 /* Add port to mirror (only front ports) */
 static void sparx5_mirror_port_add(struct sparx5 *sparx5, u32 idx, u32 portno)
 {
-	u32 val, reg = portno;
+	u64 reg = portno;
+	u32 val;
 
-	reg = portno / BITS_PER_BYTE;
-	val = BIT(portno % BITS_PER_BYTE);
+	val = BIT(do_div(reg, 32));
 
 	if (reg == 0)
 		return spx5_rmw(val, val, sparx5, ANA_AC_PROBE_PORT_CFG(idx));
@@ -45,10 +45,10 @@ static void sparx5_mirror_port_add(struct sparx5 *sparx5, u32 idx, u32 portno)
 /* Delete port from mirror (only front ports) */
 static void sparx5_mirror_port_del(struct sparx5 *sparx5, u32 idx, u32 portno)
 {
-	u32 val, reg = portno;
+	u64 reg = portno;
+	u32 val;
 
-	reg = portno / BITS_PER_BYTE;
-	val = BIT(portno % BITS_PER_BYTE);
+	val = BIT(do_div(reg, 32));
 
 	if (reg == 0)
 		return spx5_rmw(0, val, sparx5, ANA_AC_PROBE_PORT_CFG(idx));
-- 
2.43.0



