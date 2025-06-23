Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B43248F40;
	Mon, 23 Jun 2025 13:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686155; cv=none; b=R+h7l1pjwtRzS/O/rICIjMSOfcW99GVg0G1nqd6/HgPl0vvlTpeAI6LuUXS5EJ74Z22mKdaMQ/pRRD0V9QSJK8vrY3QvHhj6mEuIciRMfN6tIdt2TnH5oV0Y5pAdTGN6v3t2iuEwgM8wRRLbOS6TU5q7LpX+59bRMl/ULBVicG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686155; c=relaxed/simple;
	bh=bE421E9p8uE9/4iYh0PKV5GoZIfvuAXiz7JVuWGZvSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Duls7srZW/LhJuJlFcrH9yY8kIY9nfhhDJT1s+fOjMgGGNZ+SnxhdiyOH2kWXUT+TbwSzt2PJ+el6PBgdVqxFMOQwQl/5cAZpGaaceXAKYK7bLo+HIq0N1B0dy8qg4JE2Zf5T0jXOhwNnZLUu+7JXdy/WrdagYCM+YykTlIhEBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KOHMPx2c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KOHMPx2c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0B6C4CEEA;
	Mon, 23 Jun 2025 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750686154;
	bh=bE421E9p8uE9/4iYh0PKV5GoZIfvuAXiz7JVuWGZvSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KOHMPx2cBdfEfCWbk2+x+UuEFBV2dls5954/FWja4JyAiwWfW8EiDaoccq7FHS5tu
	 Jn4xHA5VoHtN+cUihs/4rygz/aPrMLIocqyjwqRhax53YZrpjOsr6fXNAlqVdDXYUj
	 CNbhwCESxgJ+mFNKR7+NtnyypBlcDZ/yj0OI90I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/222] emulex/benet: correct command version selection in be_cmd_get_stats()
Date: Mon, 23 Jun 2025 15:08:16 +0200
Message-ID: <20250623130616.924002979@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit edb888d29748cee674006a52e544925dacc7728e ]

Logic here always sets hdr->version to 2 if it is not a BE3 or Lancer chip,
even if it is BE2. Use 'else if' to prevent multiple assignments, setting
version 0 for BE2, version 1 for BE3 and Lancer, and version 2 for others.
Fixes potential incorrect version setting when BE2_chip and
BE3_chip/lancer_chip checks could both be true.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20250519141731.691136-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index 9812a9a5d033b..d9bceb26f4e5b 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -1608,7 +1608,7 @@ int be_cmd_get_stats(struct be_adapter *adapter, struct be_dma_mem *nonemb_cmd)
 	/* version 1 of the cmd is not supported only by BE2 */
 	if (BE2_chip(adapter))
 		hdr->version = 0;
-	if (BE3_chip(adapter) || lancer_chip(adapter))
+	else if (BE3_chip(adapter) || lancer_chip(adapter))
 		hdr->version = 1;
 	else
 		hdr->version = 2;
-- 
2.39.5



