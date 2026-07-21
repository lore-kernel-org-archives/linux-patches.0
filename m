Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD24395D8E;
	Tue, 21 Jul 2026 19:06:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660807; cv=none; b=onrJ+vIT7HnTpIzV4t2xIOCyBu8jkgVUgZy+x2xydWSZ6phUC7R/l+kjau6NDq6EM6yEmuZuPacFye2/aBrgjNjQxTCRn09s/nPzLTKCEVVoe7JcyP13PqXGHrbtZaIUmF+n4YJU4guV1+S5axQ+thHqcstRlSxp0rntYl5BsDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660807; c=relaxed/simple;
	bh=w9TvQvRu6f24dzXnw9b5YqFZYYhWgCB+Ib49XQA9vF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nFokhMhMP/Qxj2lOScWk5tCHy5JPGcbW6S6GgJ3Y4RNxRumX0pask4DO8JaeOFtmdDxGQPh7c4l9ccYgqYIKXh3R0K1Pd7ToryBdeXdW+2HbNrZ3hlxfWciAUHRhlSzw6/ICh0vW9xpYlLk5Lvj2BBUmgTOmdjHcFtx0yxGYWcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8MdYvr/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8MdYvr/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93CA1F000E9;
	Tue, 21 Jul 2026 19:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660806;
	bh=ECjpYua76CbHL2Ndg10KHS/y3XT3dERpYGp9EsbJnl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8MdYvr/N0WnpNZbY1Twnf8iBZz9W4zcCFj8nzKLHe7xG3j+YzAi7demgLEIearFq
	 wkWbD2h4pVxN2mj34s9RyEx/qIu73QKtl8mpmZZblAb5CW1HEqaaJvBTI1tV3UTysu
	 neM50qLQ7RGHW9D44zlmJtnOVAa0DNEAxy59zT84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1120/2077] dpaa2-switch: fix VLAN upper check not rejecting bridge join
Date: Tue, 21 Jul 2026 17:13:13 +0200
Message-ID: <20260721152619.235635821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 52c1cb9cb7e02a..46ae81c2fa013a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2177,7 +2177,7 @@ dpaa2_switch_prechangeupper_sanity_checks(struct net_device *netdev,
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Cannot join a bridge while VLAN uppers are present");
-		return 0;
+		return err;
 	}
 
 	netdev_for_each_lower_dev(upper_dev, other_dev, iter) {
-- 
2.53.0



