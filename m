Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C503C10B5;
	Tue, 21 Jul 2026 22:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671966; cv=none; b=WK5B5q7I6c3T3CNYcE5+EC2W+t+06kUImtBqU+gBTmT+P114cVhG1PBSpIPXtvKJdlFyZz0pI6EMcMPSnMW7eMd6iB2p/oulR3iqdpqrNRIAW9BkHxuFbWMfOBV8oXYo5lMwaYYMd3lCo/shWLEt3MuIx21oS/8iF0LgtMisYx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671966; c=relaxed/simple;
	bh=DY7WR9LgaElAZnSBkVWHM/wx151N95nkuM0ikE0f01s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4sGCARGKhz6gEmhg4DE4gsP5Z77kUyfs7cRvkSFohtOE0Lecp9guRBC7msmH5HHGuNHtoiKi7J1+2jHCSNFJzqGU9HeItZGP2YXmOwRyBajTUP5hlm4r1NH2tVWASvR0mKBZRKe4SarZIfd4Mc3JXpUuNGU+PQZt0D51n/psnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdFjqc5u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdFjqc5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 144BA1F000E9;
	Tue, 21 Jul 2026 22:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671965;
	bh=dTnQVT8Hkk7V7Kc9W5X+dS+ERQvVp+630izub/4KVts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rdFjqc5uQLNpf2npjtpMR8pO7xsg0EQeZcrlb3zG6WMi8vSW5cBKbe5cAUuoztVJl
	 Nt/dYBPr2vbTRqE8pWgdnF7WIxsWJHg18A/Z51Fr8QV89uyh0Y/PcJQzp8SRwEK5u8
	 Iz+ft0DD1XNfm2jlAIekwvHexG7cuBHIHH2hTKa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 444/843] dpaa2-switch: fix VLAN upper check not rejecting bridge join
Date: Tue, 21 Jul 2026 17:21:19 +0200
Message-ID: <20260721152416.014710027@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3cc844a61cb882..ea93144d24931b 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2188,7 +2188,7 @@ dpaa2_switch_prechangeupper_sanity_checks(struct net_device *netdev,
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Cannot join a bridge while VLAN uppers are present");
-		return 0;
+		return err;
 	}
 
 	return 0;
-- 
2.53.0



