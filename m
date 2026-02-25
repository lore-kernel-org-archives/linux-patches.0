Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B95618B0A;
	Wed, 25 Feb 2026 01:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983339; cv=none; b=kB6rT+PspiXA3oVcIMhNX8bLQi3H9cG/ecGeiTHtdlN/3rIbdmymCwlxxkqfTSdgqA4l8COg0yFVhCMCUfaEsNPoxNBvJCVawQqt2X2QHVrmStus7hldS0JZ4ofc2IiwdiT1vwv/rEuU17KYSMuJ21Jh4Isiz60w7KHCmfoMUQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983339; c=relaxed/simple;
	bh=kjuyAUh4hHBaih7SsMXNsgbeSkRCEEQkSA6G8Vla1EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZ4WS6IKHvztKFQGJ1smZWz4rJ82nIzY/4jx39B3MTZDuX6Q9E94YlCMDX55WUvokb1d6025mpPZhJROyINUpylf/p6471TH4M/h+WN1lHDZNkcPLSomxs5LqGth1NHBZaLkN6AsfXjQ/Zkl8M1u1nhHz1TsjViiET9s/N/wv+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MT3e8uD7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MT3e8uD7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA18FC116D0;
	Wed, 25 Feb 2026 01:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983339;
	bh=kjuyAUh4hHBaih7SsMXNsgbeSkRCEEQkSA6G8Vla1EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MT3e8uD7OMefDE5OOm+IFceAytSr3fOlaGl7cMhNvvK2OTcGt6D2nBuc7h64xxZsg
	 tBeNtblKrRDD317Vw+LBA2ouGdHaAfM2KSlqG1KlFY7S/H9VezZ5ipumiYrUGeCo7y
	 qZQZPAogi88ojmlGF6pZoi8SBkcvDZMnzj2mI72A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 468/781] mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper
Date: Tue, 24 Feb 2026 17:19:37 -0800
Message-ID: <20260225012411.299167273@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 6d8226cbbf124bb5613b532216b74c886a4361b7 ]

cadence_nand_cdma_send_and_wait() propagates negative errno values
from cadence_nand_cdma_send(), returns -ETIMEDOUT on failure and -EIO
when the CDMA engine reports a command failure.

However, it is declared as u32, causing error codes to wrap.
Change the return type to int to correctly propagate errors.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/cadence-nand-controller.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/cadence-nand-controller.c b/drivers/mtd/nand/raw/cadence-nand-controller.c
index 5f037753f78c8..99135ec230105 100644
--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -1066,7 +1066,7 @@ static int cadence_nand_cdma_send(struct cdns_nand_ctrl *cdns_ctrl,
 }
 
 /* Send SDMA command and wait for finish. */
-static u32
+static int
 cadence_nand_cdma_send_and_wait(struct cdns_nand_ctrl *cdns_ctrl,
 				u8 thread)
 {
-- 
2.51.0



