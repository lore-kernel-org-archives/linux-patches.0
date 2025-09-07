Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A927714BFA2;
	Sun,  7 Sep 2025 20:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276322; cv=none; b=W7IYf4Xd5USgrpGQqyYjxb50RemHjla8u1vs63DZWo/ow7jhYbpOxTPocg61c520bOIdT1ZIq3mmcYVKicwRBVsaBt++FH3CFEDsDR1Qafrs38RRyIGp7+CnNuOG12F007XMHdPVhtI+j8gvyWTStLndxuuDhyI9N7vv1Ync/Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276322; c=relaxed/simple;
	bh=GivGVMDZnjXYIB6JRR72xM9rq9tFNXlraCjxqvTqpMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhaEudgC4eW4efsqh5PdhF1pfT9WYxnru1x9CD0DXWJJBSoVEucvBhRW7B4mVJ9h668iWJ8YO3uG/C6uQ/BL5nl3Mgx3NJw8OxGtLGPEadpyr1refW2BKVW+ZUCEiJNZtIWRLniQ6BiCclkO4VpJl/0KcWQG2BmDPrthIaqZEhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbML5ssY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbML5ssY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 320C9C4CEF0;
	Sun,  7 Sep 2025 20:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276322;
	bh=GivGVMDZnjXYIB6JRR72xM9rq9tFNXlraCjxqvTqpMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbML5ssYREXt+CAhVz4HP+PcwuICFoc06h8n+fbOlNjstAFUB7+UgmCAm0gGyhvvL
	 2/UThDuKoxOWLOugli8jybFeoG0Vovepgmb1qW5967boZ0r+wEmj5MIxlbE3Y4Is4N
	 /dm7IXwFUEvoOGUEX5xkJu75D6nJGmC8d14DQuF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/104] xirc2ps_cs: fix register access when enabling FullDuplex
Date: Sun,  7 Sep 2025 21:57:37 +0200
Message-ID: <20250907195608.211985034@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9f505cf02d965..2dc1cfcd7ce99 100644
--- a/drivers/net/ethernet/xircom/xirc2ps_cs.c
+++ b/drivers/net/ethernet/xircom/xirc2ps_cs.c
@@ -1578,7 +1578,7 @@ do_reset(struct net_device *dev, int full)
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



