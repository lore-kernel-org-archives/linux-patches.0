Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD851CDFAC;
	Sun,  7 Sep 2025 20:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757275924; cv=none; b=QuIs6o0vdwkVE4gzfpBc35ZJrWXFQ8ZonhYQwu8N2cwbBArjDiERRVusNVYfQuzFUtrXV5xnA/WkeSbM1RJMOpx4Ak1pg3bPugu0RV+/NkW+xVjxa8d333OvV8w5uBbW2hOpaXGfw0x1ZIgb1qp3cOfnlUYXwHLSiKyhnC8dpSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757275924; c=relaxed/simple;
	bh=NFmI68oZUN4OrXpg7YMe8uCocV+515/qeICAl+Z8A5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKArK31uU690wkuMgnjxzJDHpuDMLF3xTngSBsVPabQjUxxg7P8peQscFPbyg0X2pQFU0xMMX50fD9qV8fQDWgDt+Rg+ZxxaRNgfzBlzDk8FJHZ17vOCfNI/3EJC+7AlUHUeNPhhgB4HB03Ud2JSPnGW+GBJjmbBrw7HwFrurUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCrBlbDb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCrBlbDb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C6EC4CEF0;
	Sun,  7 Sep 2025 20:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757275924;
	bh=NFmI68oZUN4OrXpg7YMe8uCocV+515/qeICAl+Z8A5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCrBlbDbyN8pz1jm+fKZIOUgRr3RDN/eXTofFniO+fdso4EVdprNItE9JTYxzsV3e
	 GvBrSpAb0yx03h2f8I8/B1bAKabT3LYBDxo4gscf0H1Lag8U+oBrGlfEOuIhFdlAiy
	 OwL6k/TVVMZzpYvT7yu66H3bMLwFQ70SY6wn8Di0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/45] xirc2ps_cs: fix register access when enabling FullDuplex
Date: Sun,  7 Sep 2025 21:57:51 +0200
Message-ID: <20250907195601.119286089@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
References: <20250907195600.953058118@linuxfoundation.org>
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

[ Upstream commit b79e498080b170fd94fc83bca2471f450811549b ]

The current code incorrectly passes (XIRCREG1_ECR | FullDuplex) as
the register address to GetByte(), instead of fetching the register
value and OR-ing it with FullDuplex. This results in an invalid
register access.

Fix it by reading XIRCREG1_ECR first, then or-ing with FullDuplex
before writing it back.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20250827192645.658496-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xircom/xirc2ps_cs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xircom/xirc2ps_cs.c b/drivers/net/ethernet/xircom/xirc2ps_cs.c
index e3438cef5f9c6..4d8a1728e8ed6 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -1584,7 +1584,7 @@ do_reset(struct net_device *dev, int full)
 	    msleep(40);			/* wait 40 msec to let it complete */
 	}
 	if (full_duplex)
-	    PutByte(XIRCREG1_ECR, GetByte(XIRCREG1_ECR | FullDuplex));
+	    PutByte(XIRCREG1_ECR, GetByte(XIRCREG1_ECR) | FullDuplex);
     } else {  /* No MII */
 	SelectPage(0);
 	value = GetByte(XIRCREG_ESR);	 /* read the ESR */
-- 
2.50.1



