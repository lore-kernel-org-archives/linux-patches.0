Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB753ED5C8;
	Wed, 20 May 2026 17:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297755; cv=none; b=F8tCAnPGJTEG9xkVVHPoUsD+8cfj3cD/GozztPhBghtnamW7cD/3n60cZa2fqPDwmP9PMeV/bc/kFSck05cVdFklePRwHIa/75sSNC7VONiKb+4WyRbr1/pRO2DqVG2pay6vws6d6p6/36NngbWLqC8g+rgH8kDTuDoHvQl9hZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297755; c=relaxed/simple;
	bh=NYB1RE0pSGSzuX/A6riF1Ey3g3+5BXSm3D3nT8X/Px0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkYiIClHqiQyrAE1hv7KRakgnjoxmSmFRveuFRSVpAm23A3xBKjH7O4nRrLWud0HYWxPWfaHaPKBcEzY4gGbCd//2ostsZjx2hEG3Xp3GFJVNU6nEMf4kvzO8ox9e5aDiUGTKdDmykLnvwWQDbqXYkTr/S2ydX3EXHq9pTiAtoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/N0SYo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/N0SYo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940451F00894;
	Wed, 20 May 2026 17:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297754;
	bh=Hh0OesrHxYUvZD1oeNjoM7GEqQ4yjLP4e4WxGu/iJOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/N0SYo8HpbDJpg24pGLn0NE1zjqtAeCv6sjEKLSzlCh3P9wl2jYpa3ldF1A0CmZu
	 +f2XoEcxkt20Be5sJiDbOsf3TvUfNzTdWLuAsxmqO/UQYu5Dh37K9rGrzsu87VNPgE
	 Giv3H0tiYf2d7JN00lgY6XRmFOl+p363EHHCzybY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuegang Lu <xuegang.lu@airoha.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 151/957] net: airoha: Fix FE_PSE_BUF_SET configuration if PPE2 is available
Date: Wed, 20 May 2026 18:10:34 +0200
Message-ID: <20260520162137.827987122@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 02f72964395911e7a09bb2ea2fe6f79eda4ea2c2 ]

airoha_fe_set routine is used to set specified bits to 1 in the selected
register. In the FE_PSE_BUF_SET case this can due to a overestimation of
the required buffers for I/O queues since we can miss to set some bits
of PSE_ALLRSV_MASK subfield to 0. Fix the issue relying on airoha_fe_rmw
routine instead.

Fixes: 8e38e08f2c560 ("net: airoha: fix PSE memory configuration in airoha_fe_pse_ports_init()")
Tested-by: Xuegang Lu <xuegang.lu@airoha.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260408-airoha-reg_fe_pse_buf_set-v1-1-0c4fa8f4d1d9@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 677e40001f9f2..132a32e9e633a 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -293,16 +293,18 @@ static void airoha_fe_pse_ports_init(struct airoha_eth *eth)
 		[FE_PSE_PORT_GDM4] = 2,
 		[FE_PSE_PORT_CDM5] = 2,
 	};
-	u32 all_rsv;
 	int q;
 
-	all_rsv = airoha_fe_get_pse_all_rsv(eth);
 	if (airoha_ppe_is_enabled(eth, 1)) {
+		u32 all_rsv;
+
 		/* hw misses PPE2 oq rsv */
+		all_rsv = airoha_fe_get_pse_all_rsv(eth);
 		all_rsv += PSE_RSV_PAGES *
 			   pse_port_num_queues[FE_PSE_PORT_PPE2];
+		airoha_fe_rmw(eth, REG_FE_PSE_BUF_SET, PSE_ALLRSV_MASK,
+			      FIELD_PREP(PSE_ALLRSV_MASK, all_rsv));
 	}
-	airoha_fe_set(eth, REG_FE_PSE_BUF_SET, all_rsv);
 
 	/* CMD1 */
 	for (q = 0; q < pse_port_num_queues[FE_PSE_PORT_CDM1]; q++)
-- 
2.53.0



