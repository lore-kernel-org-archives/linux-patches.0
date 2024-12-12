Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0605C217664;
	Thu, 12 Dec 2024 17:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024688; cv=none; b=H7Pds6HUqGMeJryXjsuob3CgR9jLp2xHAnmW2vIwtYYQowrnDUNW8dKvrUfBT3GgtAqihyojE78UAQ6xB+mI+D64YT23qLrGaw2u43kDDqdD/gM4U76vI7Q3trAUQnvCzM7hnS8Zgyg2pDFY1d80jxO3bkd8kjRHMabRWGY1TA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024688; c=relaxed/simple;
	bh=CTjnrbyz84RmXC82LUPoGQzAZUEMn7lGuIwRmX2J6XI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cezvHCvmE59a9wNcHjgbx3u2pnI/2GMmvZMDITVyoNU51YIHrEkl2hmeIfS6pNO4Az9CO/JRimlI0Hk3V3/BXlFLUYGOVDldkIyz9Ex9O7h7TEYCgqhDsFv7geW+hz4QOkYW/VRxglnuIiaRSr6BYqdI5ySHgg9xrV6tQeFKeTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uqkfvMWv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uqkfvMWv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481FEC4CECE;
	Thu, 12 Dec 2024 17:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024687;
	bh=CTjnrbyz84RmXC82LUPoGQzAZUEMn7lGuIwRmX2J6XI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uqkfvMWvqdtR5ALPmVeIqH4arteAYFJd+SMYUaZkclvlXoQVgEM5x0fTEMlwHL6qQ
	 Ta/2z6h21WDQzKSoxFjLS+ctlznEquQsy2MoXjTPvOzI/i81+3z7r+Jxm8laapUW7L
	 9gqi5uxiG9bpNvo1l2EMbZMCyp6pSfDhp4rphs8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <bbrezillon@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Jamie Iles <quic_jiles@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 349/459] i3c: fix incorrect address slot lookup on 64-bit
Date: Thu, 12 Dec 2024 16:01:27 +0100
Message-ID: <20241212144307.447239047@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

From: Jamie Iles <quic_jiles@quicinc.com>

[ Upstream commit f18f98110f2b179792cb70d85cba697320a3790f ]

The address slot bitmap is an array of unsigned long's which are the
same size as an int on 32-bit platforms but not 64-bit.  Loading the
bitmap into an int could result in the incorrect status being returned
for a slot and slots being reported as the wrong status.

Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Cc: Boris Brezillon <bbrezillon@kernel.org>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Jamie Iles <quic_jiles@quicinc.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210922165600.179394-1-quic_jiles@quicinc.com
Stable-dep-of: 851bd21cdb55 ("i3c: master: Fix dynamic address leak when 'assigned-address' is present")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 2527965a6f24d..63c79b3cd7d4f 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -347,7 +347,8 @@ struct bus_type i3c_bus_type = {
 static enum i3c_addr_slot_status
 i3c_bus_get_addr_slot_status(struct i3c_bus *bus, u16 addr)
 {
-	int status, bitpos = addr * 2;
+	unsigned long status;
+	int bitpos = addr * 2;
 
 	if (addr > I2C_MAX_ADDR)
 		return I3C_ADDR_SLOT_RSVD;
-- 
2.43.0



