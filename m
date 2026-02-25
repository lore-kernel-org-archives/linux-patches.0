Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F012C21DF;
	Wed, 25 Feb 2026 06:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002613; cv=none; b=TJPU/3rPA7n+M+8GvAyjFX0vYpwn0IWjCVCpKvIokyM35a4H8qH/Ic2SrxQG07/hZ/2U/+4dzTnQelxboci1QUs8L2qC31wkYDksWG9FsfRVcyOUxlyMBQ2apOmAlasjmq4fjhZmD0vf5dBga5xbzifax8bDRHfv97l1R+XyTTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002613; c=relaxed/simple;
	bh=lsNNwrvqUHEtZ3u0sm0jz+/glGqKWJV+leFTqVqhUS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1zACqrHEh3/CTHTFTqRo2sBIVyte3fp+aUPG4xySAcY3tNRIzMhYNj49YWRyJ+W3R6grlTkVN2BMY7Di1oBOPYP8FpvfWKmrV0GK/uPo5k3PnumN/sNJx3UdMkUmeKiigxap/LDPApHItzjYkawBoqck3ttMmOIYcWqCMoze6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8tPhesb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8tPhesb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE9BC116D0;
	Wed, 25 Feb 2026 06:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002612;
	bh=lsNNwrvqUHEtZ3u0sm0jz+/glGqKWJV+leFTqVqhUS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8tPhesbmh24FJXc+ncCAA9PZORS5jNADVSyMuOE7mUWLxOBIVgPRWpkVu5IiQBr3
	 8DqjqzFdjGbCEwlAYJto+0vhmopTT8bGC3ePiNRprKaLj9EDW+mvnXhd1MEgDIu4Ux
	 Wwe5bDXsHe+VtoPiGyg0GsSp3mIFdSXcmUvqAveg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 364/641] mtd: rawnand: cadence: Fix return type of CDMA send-and-wait helper
Date: Tue, 24 Feb 2026 17:21:30 -0800
Message-ID: <20260225012357.433461398@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 32ed38b893947..21eabedc2ed1c 100644
--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -1015,7 +1015,7 @@ static int cadence_nand_cdma_send(struct cdns_nand_ctrl *cdns_ctrl,
 }
 
 /* Send SDMA command and wait for finish. */
-static u32
+static int
 cadence_nand_cdma_send_and_wait(struct cdns_nand_ctrl *cdns_ctrl,
 				u8 thread)
 {
-- 
2.51.0



