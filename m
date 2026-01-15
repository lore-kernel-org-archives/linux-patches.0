Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8D434216C;
	Thu, 15 Jan 2026 17:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498317; cv=none; b=r89Dh9TqbkG+4PJnetL5FVv9C2BdnQZwHfHbN/qOP0H6R0mk2wTA+vCf39wMVJhCMNBDtM73fgCu/xYVa3HBIysYNkxaz3KXfIEbga+m868QomqivmQYFuJm+Q1cx70iklYqZZ1B+Ov2QKlg92bmRRoYVJWpTG7jglbZxdrmr58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498317; c=relaxed/simple;
	bh=09JFyfYBelWqGW9OlkacI+ZvxU9pG/fZUnFybMJXiSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HH1TkbFsEoflvA0/FNKkooSc3WRIVIJBXCBz1jL7jVVI/VEiry91+e/EW+XlRAjz80AYFpnOA1FXEoil4t9BsxSkx/4L/5dj1ogMbtJe9dYfSLLr78jtRZseLraRCg8d5SN847WRkhZp0qkQxK3fVFzMfFFh8GkAyTgY+kefIYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WTfnfJdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WTfnfJdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5442DC116D0;
	Thu, 15 Jan 2026 17:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498317;
	bh=09JFyfYBelWqGW9OlkacI+ZvxU9pG/fZUnFybMJXiSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WTfnfJdFIRvTC1e91NXNBDvede9PenIAkW/9NkI+TKdUao0tIkBZH+4Dmcweu2lZK
	 qoLjlBYcbljIOa8LuH3hy+N0QQaFr9q/z2IcU3cP31hARPFQdG//tJxZMcrPk5en+j
	 dnigjuRhFezw9JS4Pcn/KoAwOLwjpSd4jgxtYAk0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshumali Gaur <agaur@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 356/554] octeontx2-pf: fix "UBSAN: shift-out-of-bounds error"
Date: Thu, 15 Jan 2026 17:47:02 +0100
Message-ID: <20260115164259.113674202@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

From: Anshumali Gaur <agaur@marvell.com>

[ Upstream commit 85f4b0c650d9f9db10bda8d3acfa1af83bf78cf7 ]

This patch ensures that the RX ring size (rx_pending) is not
set below the permitted length. This avoids UBSAN
shift-out-of-bounds errors when users passes small or zero
ring sizes via ethtool -G.

Fixes: d45d8979840d ("octeontx2-pf: Add basic ethtool support")
Signed-off-by: Anshumali Gaur <agaur@marvell.com>
Link: https://patch.msgid.link/20251219062226.524844-1-agaur@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index db4a9fc399f3..e0c108d48d2e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -391,6 +391,14 @@ static int otx2_set_ringparam(struct net_device *netdev,
 	 */
 	if (rx_count < pfvf->hw.rq_skid)
 		rx_count =  pfvf->hw.rq_skid;
+
+	if (ring->rx_pending < 16) {
+		netdev_err(netdev,
+			   "rx ring size %u invalid, min is 16\n",
+			   ring->rx_pending);
+		return -EINVAL;
+	}
+
 	rx_count = Q_COUNT(Q_SIZE(rx_count, 3));
 
 	/* Due pipelining impact minimum 2000 unused SQ CQE's
-- 
2.51.0



