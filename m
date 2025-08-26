Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C333093BA;
	Tue, 26 Aug 2025 13:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214498; cv=none; b=MwLhdjKabsu254yF3mavu1zEbqd9Yw6spBwDUy7/pIOn5aeKP3RnXEFT7cqgLobCB1leAlmMBcHxa2bx+OY+NBsM4imp5zzrDB1+FzPB517H5Nrvux4P55dLTp6ZtzCZMdA5gVZaZoVUCYD7NTmn4R7w/MJ8nKWKBHpgxcH8AZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214498; c=relaxed/simple;
	bh=f3O/qtmUwZ2BgAbxyITsAtmtw96xzcfVaZ1+3mdoDb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y6OCZaI/UGCVzkQXUbop2FDsaQyCqbWnbClnGzu1DgD7oyC3nD3aI7zgq3LPdmZ6L7//fx74Tfbsvrq+gBuBFW4vs5wsKFfZXecBfMYHgFrO3MIycPVs992bZWvQNTbO8k2K63WFBTfJJjDsivLSjDGUGOqTPH5axh16hXQfmQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZOIj5D3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZOIj5D3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25584C4CEF1;
	Tue, 26 Aug 2025 13:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214498;
	bh=f3O/qtmUwZ2BgAbxyITsAtmtw96xzcfVaZ1+3mdoDb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RZOIj5D3qFhb1itb/K2OwMTKI0TaxzS3XemMQsDpfC8PADsFlqmoVBX8Se5ODizCb
	 cnNessjg3lcJnphrOO2OBExwKL3PhDV2W9B+fH1VtTCuxYA8LlhGDEOwnxZLawWFwE
	 Vzs3OEZzlJCxDq8J2sG2RPeqDCds9mg305SSoyaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 161/482] net: dsa: b53: prevent SWITCH_CTRL access on BCM5325
Date: Tue, 26 Aug 2025 13:06:54 +0200
Message-ID: <20250826110934.788308642@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 22ccaaca43440e90a3b68d2183045b42247dc4be ]

BCM5325 doesn't implement SWITCH_CTRL register so we should avoid reading
or writing it.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://patch.msgid.link/20250614080000.1884236-8-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 5bf390707505..3a1266f535e2 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -339,11 +339,12 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 
 	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_MODE, mgmt);
 
-	/* Include IMP port in dumb forwarding mode
-	 */
-	b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, &mgmt);
-	mgmt |= B53_MII_DUMB_FWDG_EN;
-	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, mgmt);
+	if (!is5325(dev)) {
+		/* Include IMP port in dumb forwarding mode */
+		b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, &mgmt);
+		mgmt |= B53_MII_DUMB_FWDG_EN;
+		b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, mgmt);
+	}
 
 	/* Look at B53_UC_FWD_EN and B53_MC_FWD_EN to decide whether
 	 * frames should be flooded or not.
-- 
2.39.5



