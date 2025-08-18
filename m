Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA8231B11A;
	Mon, 18 Aug 2025 13:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522016; cv=none; b=UUCT/D+FI3CncMUl7KOakc9fzo0B/F3GMU73rDcWJi0vALiH9T4L5sJxoprXESaoZBJvk8Pr7GPfoHTQvqC02vIidyPrUeVYcdp2HiGFjqk9wDoyoXMnPIzrJRjVmtuuC0On8yKDNSReqk5eL0UKu4G1zFd1/thKIPlOdqk83zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522016; c=relaxed/simple;
	bh=zhlAspqD7v/gmaEy21QKF4vina0D4R/CRfazTnXZ9hM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVDi9Zs+2RfkzTANVdgnFUg/XeGBZ/AGH66dmlGmf0CF22hnDcOd1buO3aQ1NHYaWgL9lbn5bHWaPAMnANsE+4pCiJ0J4fR2Lk0rYfJdaYrlEw/JxZB8siUfKnCqQDaGG8xjh3Qp+WjZjy76EkTAcR9A4zo1PLikA6rS7cRxYcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T+PefIO3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T+PefIO3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFED3C4CEEB;
	Mon, 18 Aug 2025 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522016;
	bh=zhlAspqD7v/gmaEy21QKF4vina0D4R/CRfazTnXZ9hM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T+PefIO3Begvh1eEyivfHvKtYJrD1xDkAFkzDrMX9usO8ntdTIqLWHVYgQTw6q3gb
	 NqXeVeEF9psfgiXDDzEao2FoRLglwwMG3HZtxO3RS357DdjOyd6zn5NXHGn23/tiF1
	 FScuSfmqTe+9aMJ5RHWEiLvUtQSgpjj2Qw2fgVU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Ping CHNG <jchng@maxlinear.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 182/444] net: pcs: xpcs: mask readl() return value to 16 bits
Date: Mon, 18 Aug 2025 14:43:28 +0200
Message-ID: <20250818124455.696882745@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jack Ping CHNG <jchng@maxlinear.com>

[ Upstream commit 2b0ba7b5b010455c4e43ab557860f8b1089e7424 ]

readl() returns 32-bit value but Clause 22/45 registers are 16-bit wide.
Masking with 0xFFFF avoids using garbage upper bits.

Signed-off-by: Jack Ping CHNG <jchng@maxlinear.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20250716030349.3796806-1-jchng@maxlinear.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/pcs/pcs-xpcs-plat.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs-plat.c b/drivers/net/pcs/pcs-xpcs-plat.c
index 629315f1e57c..9dcaf7a66113 100644
--- a/drivers/net/pcs/pcs-xpcs-plat.c
+++ b/drivers/net/pcs/pcs-xpcs-plat.c
@@ -66,7 +66,7 @@ static int xpcs_mmio_read_reg_indirect(struct dw_xpcs_plat *pxpcs,
 	switch (pxpcs->reg_width) {
 	case 4:
 		writel(page, pxpcs->reg_base + (DW_VR_CSR_VIEWPORT << 2));
-		ret = readl(pxpcs->reg_base + (ofs << 2));
+		ret = readl(pxpcs->reg_base + (ofs << 2)) & 0xffff;
 		break;
 	default:
 		writew(page, pxpcs->reg_base + (DW_VR_CSR_VIEWPORT << 1));
@@ -124,7 +124,7 @@ static int xpcs_mmio_read_reg_direct(struct dw_xpcs_plat *pxpcs,
 
 	switch (pxpcs->reg_width) {
 	case 4:
-		ret = readl(pxpcs->reg_base + (csr << 2));
+		ret = readl(pxpcs->reg_base + (csr << 2)) & 0xffff;
 		break;
 	default:
 		ret = readw(pxpcs->reg_base + (csr << 1));
-- 
2.39.5



