Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966272C11DB;
	Tue,  6 Jan 2026 17:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720726; cv=none; b=SNRYadBrWS1BE5fK7EwIemFmpr9OtkGNBhu1VgkkOediMCmT1vSGuflX21WAiY9CbDbLakfyhxjfGbMMeW09vYBNu5C9XqNupbJ9cJEJEXNWFzPPa87FMh0i6QHredU1am1kn65HI25gF7JTdJSog9Mz+/UtSTOa+sVyeKZ/D9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720726; c=relaxed/simple;
	bh=sbaV0KszweiVghWly93uShqjJRFEuJsR3JS0ZgQ3utk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gk7kd0ncZBoecUt4Nrj1rshwH2gimc9dTcyHmCp+sR+e9be96B/PEr66D5csYw+BuZB0yQKQOE6krTl6+6khKqqCPqmItEDo2IM7lhR9YeRshGhsy5ubUBpzVSj0N3V3A6ePzc6ujaqrYDVnb5AfA6RaICmvNxh07oX8A52Yhtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXpaRiAi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXpaRiAi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C279CC16AAE;
	Tue,  6 Jan 2026 17:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720726;
	bh=sbaV0KszweiVghWly93uShqjJRFEuJsR3JS0ZgQ3utk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXpaRiAixLRS4SJx9yLxZcmrTxINy+nxIG/XMy1h540DR2f2B7PLbMFMpylu8yOyh
	 bNtivsTBlldCPPed88N/o6N63r4ij0pPplSPuhkW+PLoGPJKkUtqCZttLCvqPJI5jZ
	 qKq3F9f6+86w9XSRsV4lwsNOndKDyzbFVxeZBHmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshumali Gaur <agaur@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 324/567] octeontx2-pf: fix "UBSAN: shift-out-of-bounds error"
Date: Tue,  6 Jan 2026 18:01:46 +0100
Message-ID: <20260106170503.309320296@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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
index 5197ce816581..cc6a63e2573f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -432,6 +432,14 @@ static int otx2_set_ringparam(struct net_device *netdev,
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



