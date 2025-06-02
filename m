Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043B6221299;
	Mon,  2 Jun 2025 14:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874796; cv=none; b=onVxIIPj4vUARxGYssHTLELZzyJNBH9Dz56lFJYckXbGKNIVbsB9boExgnKBMqSyFcIXyaRHLaKkk5a7w+6K0wSt0RwJx+z8IrNmzwS2kDluXXSd/adBJo0WlxS+Xf43H3IQ0BVTCwoZLuKO9iTC1kLS+ZkzyVPjA8RxLOeNCHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874796; c=relaxed/simple;
	bh=Yj+QXhGCmEq3GXcgw3BEC8ES08OUr1iTxDeqbVVpFSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KPNky4lXnqUeA2pjlxpH8eOMdsJl73EoIecIyrRveXXa4Sd+7RkhzwGYM++AnTUbImiCJAu3/OO0lTUJ0mOuNLiW2nOncpB15rBFBtRMyxDSNE5XIM8d7Kcb4LG4HBqyM84MfpT/I4nwBopUBRAdNg7sEQd4dRwMq5o5FoX2L3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v1Lnup4i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v1Lnup4i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DFFC4CEEB;
	Mon,  2 Jun 2025 14:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874795;
	bh=Yj+QXhGCmEq3GXcgw3BEC8ES08OUr1iTxDeqbVVpFSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v1Lnup4iL/71Si1yBDbZCu3DRj2/rkvNJYQGGY3WU7TpxDdfL0z78pSWxGaKxFbZA
	 l5i9BjcZyRDcZiGu8c9QrXzdkaqxQ0QzKJ6VY2jXa8DfjpbQx/A1uyIbHqMlNzfyrK
	 2yePFYNYibRsrX+2CH8U/esSz3MB+GGutTgX/jkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/204] scsi: st: ERASE does not change tape location
Date: Mon,  2 Jun 2025 15:47:20 +0200
Message-ID: <20250602134259.867165772@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit ad77cebf97bd42c93ab4e3bffd09f2b905c1959a ]

The SCSI ERASE command erases from the current position onwards.  Don't
clear the position variables.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250311112516.5548-3-Kai.Makisara@kolumbus.fi
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 8f927851ccf86..3f798f87e8d98 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2889,7 +2889,6 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 			timeout = STp->long_timeout * 8;
 
 		DEBC_printk(STp, "Erasing tape.\n");
-		fileno = blkno = at_sm = 0;
 		break;
 	case MTSETBLK:		/* Set block length */
 	case MTSETDENSITY:	/* Set tape density */
-- 
2.39.5



