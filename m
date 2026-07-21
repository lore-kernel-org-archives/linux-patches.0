Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980452EBB8D;
	Tue, 21 Jul 2026 20:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666568; cv=none; b=nsDJn1jpxP+XEu4O+ODiTiZ1/+MTbT3ox5yyFWaE1UtE7V4bbhlyjcwFeIr7L5W95TF0gfwSnYLrqSu3OmUXkPaRYzg1grQZbHI2RqMnYQEM8ejgAB9qn/R0YMd1X6xWPdq/xwHwo4kAPNA42gxgnann8pYfUlhg4NlOJgO70oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666568; c=relaxed/simple;
	bh=XTeNmQkD2H+ZV5G5o5HAC5DcO3r3S+hh1qnZgoAoGDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkriEsmFfwlWStV6m4oWataJeTVWCzM5lffL3nwymW+4BxzWpmde09Ysvh7pajPYoFffmbPjAQwW9f/cs5EjLpRlsZYkZoOo2iGhi7veQX83h7EB2WlUvYQ0xG6Jf6649orFEySIyt1u87EZbkbxcuPesaDynJjBQedJV5XICw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yLbLGjcp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yLbLGjcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005871F000E9;
	Tue, 21 Jul 2026 20:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666567;
	bh=VpLOx3X5zmL7tq1nE0BNa1a/eTAb0MSpMSSSz9Zp8mg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yLbLGjcpXbKal6hJgX95KzUZXrwoVTxeUIhcCNKvWH8A8adk3LnMTQ9ebwvKZNPcZ
	 wf8xUWyGbbllZg9ulK3RbCUOnRAnVv7kiQ31ZqK+1A0qBThcEh9drZue1sLhEqYyhn
	 lwv5LTQQ6wMQCzHrSHzf2/Wrklk5+rMhgxJtKSSg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ioana Ciornei <ioana.ciornei@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0730/1266] dpaa2-switch: fix VLAN upper check not rejecting bridge join
Date: Tue, 21 Jul 2026 17:19:27 +0200
Message-ID: <20260721152458.206871773@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 176f7072338b27..0f8b46dccc0971 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -2180,7 +2180,7 @@ dpaa2_switch_prechangeupper_sanity_checks(struct net_device *netdev,
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "Cannot join a bridge while VLAN uppers are present");
-		return 0;
+		return err;
 	}
 
 	return 0;
-- 
2.53.0



