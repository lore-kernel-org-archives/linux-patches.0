Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA111DF246;
	Sun,  7 Sep 2025 20:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277562; cv=none; b=vECv7bTsbzGmyZcFKKzyd+KM/Nro1ov9lyMR/9Q9PiNMOrT9f8S514bqLKNTxboodqwGdMME2BVUE5LfmuLsuiiM0ip+viEuhM7fnCN/NE+I/aYkLII32Q1tOv6a1SXBPVfO3JyQ/vjHK6uRjGVsOudcZ5x7sBFKVEw9QS7ZGmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277562; c=relaxed/simple;
	bh=67s/MIhbJmwY/DasMQt43jblnCTHASuZeqRJSt/7eOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qey0XaHSWFVhf/yck1vFgoSYY8FzfIZPi5HVABF+aojAcPNv3XzXtsumdx8pS3HcDknU/s9HMEeE7FEftuhWVkx2cHLeA6k5kWClztiP2W7HulNHKb2Xf/dCS8+G/0lco4FDPYgf4uw6TUj4yb4bMtZr7+87GTjAqZip7DJFJdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOli2OM9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOli2OM9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482AEC4CEF0;
	Sun,  7 Sep 2025 20:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277561;
	bh=67s/MIhbJmwY/DasMQt43jblnCTHASuZeqRJSt/7eOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOli2OM91/Lwd2PGGHyIgqAO06dEsmm1wpIbYi7Cj5tN9keCtrNL3ii98iwAeKfW7
	 oOX9oYtZXD8PTTd8dJYVaBDizyu8mODQGus1BMFIyfuCYjiSB9XDq0W7U+tn9G/SqU
	 1GSpRYkc/NQyqpayhenq0M/gTED9QxUsON76ElTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 052/183] xirc2ps_cs: fix register access when enabling FullDuplex
Date: Sun,  7 Sep 2025 21:57:59 +0200
Message-ID: <20250907195617.017280153@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index a31d5d5e65936..97e88886253f5 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -1576,7 +1576,7 @@ do_reset(struct net_device *dev, int full)
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



