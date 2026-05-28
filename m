Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9AA1DE4E0;
	Thu, 28 May 2026 20:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001065; cv=none; b=e3BrSEnivHhgi3e0OKFuTAjV074pFxEjamP4D5Pcj28kG5rQY8hLh3XR+8QxSlVDK8+83YJtVEZDAk/XSfkP5rlMok3h6QKOQ84VopQkjeOJ24edJmX6EOx9aBjrJibR1jyJe2nj2+6ckeK3Be4rr9Usjc+pUzzNmDhM/+ULiWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001065; c=relaxed/simple;
	bh=xX2c/XqcmCYN+sIlNesdYb2SjaBv53A4jQhwOPMYunI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pki5ehX65Sh9d9XmwQsUZW+EOd8YK+atdPrVe9F+ePSyawW82pvkhmDQ231cgyqkk9Cc4oxWyo+3Pabg5nwAgDvLmkIGha8OSTv3u11gbd1iqbeWyNfOls6oplNkTPuTYygA1tz43a9VftSxntrsQCisXydcjBpIwMS5aGBclis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVyXPWSM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVyXPWSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2D431F000E9;
	Thu, 28 May 2026 20:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001064;
	bh=L/FRYdUEFgmEZYvc6a5TR7sddMaBXIZr8Q6lp+UyyII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iVyXPWSMjOA07yjOBNq1xY3soQMsfb/4vcenjRKfxfcJF+36UzHk69RGWhLVyI6Y7
	 cRumJUe90OP9Mq2IHBa/6y2j87GrHlh66rNdw07Cn5eDR2ftrwHYzgjv8ITbKBL1Cm
	 jsJ7VBKqFy4qeVf4kG5VErEEM2xAYpDKAs6l+hEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 267/272] octeontx2-af: npc: Fix allmulticast skip logic for LBK and SDP VFs
Date: Thu, 28 May 2026 21:50:41 +0200
Message-ID: <20260528194636.556429439@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit 9eddc819f00b5b74bb4ac91396f80bd35f5f3561 ]

When installing the allmulticast NPC rule, rvu_npc_install_allmulti_entry()
should skip LBK and SDP VFs (only CGX PF/VF may add the entry).  The
code combined is_lbk_vf() and is_sdp_vf() with logical AND, which is
never true for a single pcifunc, so the intended early return never ran.

Use logical OR instead.

Cc: Geetha sowjanya <gakula@marvell.com>
Fixes: ae703539f49d2 ("octeontx2-af: Cleanup loopback device checks")
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260520043036.1523798-1-rkannoth@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index a78923d7811dc..e3038a912a580 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -853,7 +853,7 @@ void rvu_npc_install_allmulti_entry(struct rvu *rvu, u16 pcifunc, int nixlf,
 	u16 vf_func;
 
 	/* Only CGX PF/VF can add allmulticast entry */
-	if (is_lbk_vf(rvu, pcifunc) && is_sdp_vf(rvu, pcifunc))
+	if (is_lbk_vf(rvu, pcifunc) || is_sdp_vf(rvu, pcifunc))
 		return;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
-- 
2.53.0



