Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC1444AB6D;
	Tue, 21 Jul 2026 21:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669522; cv=none; b=HQAZmu0HO91zqJlEke/n9exLdAf15qOlJji77iKAZ6GIQ7c+7jMVQ3sEi3L5lWLzFwmkh3gjquDY4Mc4vuNAtgIvJcZewERdbfXBD6kC5dI0tKOscxJZUxUax9oNZjmIrAmZ3ZFhXIILmcyjxA8hRhpPn76aIgHY7Z53CAe14c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669522; c=relaxed/simple;
	bh=nHMRYLuWkS20ySTvlQSd0KxCm7Cec3lJlCAy9LeyccI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvDPoKcXN4x4obuNaSKAByGFry5gnhPHtKAjtoFfunU/fK3sY5visB7QZyjurNFeQA6ZlULM2LImXzhKZNLTOxXL1EplJArxqP526U8IDvYXjpJ8zBslx9X+fLx6Qqy357JoMJgYD4JLcQk43PATTD88pvDMjs7uV0hjPD6PwC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lWI9iAAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lWI9iAAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E9B1F000E9;
	Tue, 21 Jul 2026 21:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669520;
	bh=IWkrP4clSREmiDMwH9j40CWBivF1A+1clbvb4v/F/7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lWI9iAAu49bkl+n67nWqA/3rkYhpacoochtPOb40bM5QOo2/Il1OM8GwIyyqvwZ/X
	 ITVOXXjFD7iNbhiyg7Nu6xJ86rizvkjmihZQv74F1KjgsF2QS8TyWazoYpDRJ7gFj2
	 pP37WwnrlNwOyL0YvH6cTkjvXV+MMV1SZPzGe0pI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0586/1067] dpaa2-switch: fix VLAN upper check not rejecting bridge join
Date: Tue, 21 Jul 2026 17:19:47 +0200
Message-ID: <20260721152437.714566398@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit ed2294f94e34e97342850c40b320833d881c3819 ]

The blamed commit refactored the prechangeupper event handling but
failed to actually return an error in case
dpaa2_switch_prevent_bridging_with_8021q_upper() detected a 802.1q upper
on a port which tries to join a bridge. Fix this by returning err
instead of 0.

Fixes: 45035febc495 ("net: dpaa2-switch: refactor prechangeupper sanity checks")
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://patch.msgid.link/20260616105430.3725910-1-ioana.ciornei@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 510a018978d9ac..c8478fdcb3aa5f 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2186,7 +2186,7 @@ dpaa2_switch_prechangeupper_sanity_checks(struct net_device *netdev,
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Cannot join a bridge while VLAN uppers are present");
-		return 0;
+		return err;
 	}
 
 	return 0;
-- 
2.53.0



