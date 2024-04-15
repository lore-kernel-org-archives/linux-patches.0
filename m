Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA181D53C;
	Mon, 15 Apr 2024 14:34:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191647; cv=none; b=WVUpwOgprQ2XrAISn0JblD9MWkm85S/2CkffE4M+gZSHYt8xI0PTB/Ka/GfATo63tDvUwPcYdMO6fgAgeVErvJzfdQMqsqyruiECDZXZ1B+eOJYAHxK6fnOncFTufhtcIQKyCyuWzLXGstT5zo1+TkfIJrSDkaECNv3g5AOfizc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191647; c=relaxed/simple;
	bh=ScwUlPNlr3kN+LyoLSTkFE0ZuoJACTQqwA6DQriBgNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kralc6d7b1+FMMQ638/4TubBRMR8l2SVsiDqlUdl6pS1huUGDwilW+bDbY6ZuPBL5aCU0niv/0G568t29SzzFaWfygQXCob8mK6dlxHiW0hES9/bEtdSNZ0N7LYy6QqK5P752MgqDoo5LuDUcixmLusqCTuvCHQrzTX298bcTys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSYCWnKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSYCWnKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A992C113CC;
	Mon, 15 Apr 2024 14:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191646;
	bh=ScwUlPNlr3kN+LyoLSTkFE0ZuoJACTQqwA6DQriBgNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSYCWnKzi5ouNBVe8vR2rVsWeQwzngk6LExHSSipCt6TleveGC6Q2uqa4vV/xeZ05
	 gImqJ0ET7cfJBDiFpge9O73ZHAKiY1FbQx+Du8ZkpBXKpcFJufsp6YLY7Kwv7ibuOV
	 PdDE1tAOsPhCr9OWqcFgu3kMAWVIvjSU+XZLklCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/122] bnxt_en: Fix possible memory leak in bnxt_rdma_aux_device_init()
Date: Mon, 15 Apr 2024 16:20:03 +0200
Message-ID: <20240415141954.512047362@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit 7ac10c7d728d75bc9daaa8fade3c7a3273b9a9ff ]

If ulp = kzalloc() fails, the allocated edev will leak because it is
not properly assigned and the cleanup path will not be able to free it.
Fix it by assigning it properly immediately after allocation.

Fixes: 303432211324 ("bnxt_en: Remove runtime interrupt vector allocation")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
index 6ba2b93986333..7188ea81401de 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ulp.c
@@ -394,12 +394,13 @@ void bnxt_rdma_aux_device_init(struct bnxt *bp)
 	if (!edev)
 		goto aux_dev_uninit;
 
+	aux_priv->edev = edev;
+
 	ulp = kzalloc(sizeof(*ulp), GFP_KERNEL);
 	if (!ulp)
 		goto aux_dev_uninit;
 
 	edev->ulp_tbl = ulp;
-	aux_priv->edev = edev;
 	bp->edev = edev;
 	bnxt_set_edev_info(edev, bp);
 
-- 
2.43.0



