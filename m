Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F80A386450;
	Tue, 21 Jul 2026 18:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656882; cv=none; b=c/QqgF1/JciZn472kt7sSg0O06/WUvtsgBwuv0cpToCabQDu0k5qeWbHH2mt1jnleiIfqntiaUAGIHa6DCsgyf34kGd7yE6+/87yjxl5uPdbI9z3ea9z502S9NE+fQcfwt4P+NrngjmUIdT3tAe86lVHFqcfdb7hVwkHNh3JXQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656882; c=relaxed/simple;
	bh=03qNFIlN/FAumT9eHDnEC7cbXjNog7L7XUmVgCo6hE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JwanDrrNAiEb2h1n1Ybvs20NO6uQlWsCCJmAF9PwK1NckXlmWomCSEsw7Z90MBo9NIeokSww6/5mijzGBOMcvylhxsBKrOE0j3gWikNEUTMo2GhgKmbgTzNv2Loe5bNXxya5oS/A+66M2Hl01VOwPQjVD+h+cCG5k6HCTN4WTNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sY9RT8rp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sY9RT8rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298051F000E9;
	Tue, 21 Jul 2026 18:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656880;
	bh=yIP3v1SqpFbBtuDUuhiCnBy8v9tn45tc813IsSEhkho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sY9RT8rp4WYWGk2TwQI/KKSpAe2JOBOz4hENgUinFiXyd/qHQcOkl57ZL8KSVC3wK
	 pCuysPZ38IjB9uvmh+1Ikl3iEAJo0/opccT6viro29/+mfJu1gAbo8rUFGzUUt8mv2
	 j25wWKVDHOgSxQ/qPFinbU8SBh9JUUdcATfrtqaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wayen.Yan" <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0552/1611] net: airoha: Fix always-true condition in PPE1 queue reservation loop
Date: Tue, 21 Jul 2026 17:11:08 +0200
Message-ID: <20260721152527.795412118@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Wayen.Yan <win847@gmail.com>

[ Upstream commit c66f8511a8109fa50767941b26d3623e316fde02 ]

In airoha_fe_pse_ports_init(), the inner condition for PPE1 queue
reservation is identical to the for-loop bound, making it always true
and the else branch dead code:

  for (q = 0; q < pse_port_num_queues[FE_PSE_PORT_PPE1]; q++) {
      if (q < pse_port_num_queues[FE_PSE_PORT_PPE1])  /* always true */
          set RSV_PAGES;
      else
          set 0;  /* unreachable */
  }

The intended behavior is to reserve pages only for the first half of
the queues, matching the PPE2 implementation on line 334 which
correctly uses the /2 divisor. Fix the PPE1 condition accordingly.

Fixes: 23020f049327 ("net: airoha: Introduce ethernet support for EN7581 SoC")
Signed-off-by: Wayen.Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/6a2ca3de.ad59c0a6.147df9.2ac1@mx.google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 7e7256d92fdb0b..5e7939c4f3e6fe 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -311,7 +311,7 @@ static void airoha_fe_pse_ports_init(struct airoha_eth *eth)
 					 PSE_QUEUE_RSV_PAGES);
 	/* PPE1 */
 	for (q = 0; q < pse_port_num_queues[FE_PSE_PORT_PPE1]; q++) {
-		if (q < pse_port_num_queues[FE_PSE_PORT_PPE1])
+		if (q < pse_port_num_queues[FE_PSE_PORT_PPE1] / 2)
 			airoha_fe_set_pse_oq_rsv(eth, FE_PSE_PORT_PPE1, q,
 						 PSE_QUEUE_RSV_PAGES);
 		else
-- 
2.53.0



