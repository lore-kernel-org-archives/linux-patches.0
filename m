Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5988F335BCD;
	Fri,  9 Jan 2026 12:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962640; cv=none; b=FTQaAZW3sE89oIbxMQCCRW+sBmX0ge8UFZW7B0XKvNpYBGkv3uLt++2FLjLfxFZMgi5XO/b/oim2mafJ+OJavc7R9K4J6jxKicI38z5a0pqtqMSOb0/Yru79ZIl30gi89Z59w2Nk4wnkjJuzu1vY1SwYJVmFE1nCr5+5pn/baJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962640; c=relaxed/simple;
	bh=OlNz8YxJ4WQGSBmi7Ra/DlpqDyPtkAqbMbyYIIxOoCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=suVfDV1FypdCx/SmuOgMxfnj5jNKqxrVYKUdrHvDGqqbz+9b5IP/OtgPGjnJvf+u2nzockyOhxmiDgdZV6u28SttZRjDX6dxD6suZgjOEDZgw7RDt3eEaEJqHsEpaW0LSl8/wG4Ekg6iGvgxqdNYGw5hkGkag+ejF6i6TW2c64M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBgtsLJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBgtsLJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA8EC4CEF1;
	Fri,  9 Jan 2026 12:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962640;
	bh=OlNz8YxJ4WQGSBmi7Ra/DlpqDyPtkAqbMbyYIIxOoCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBgtsLJkmTVcaRIDvfXbMvuIF/er1SqTmTQ/jL/GPriYJymTZgR3NQB7zVYOxhna2
	 IPFkAYApfH1g6tMlNJW33gsrrDcapbbtIoBW1TOKrLAGWkUJ6+e8RbiZi+LlgDi4Ye
	 7bVuuZZFw6e4lMmctxqPsmeGzZ5p+nkWe+zPi5Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anshumali Gaur <agaur@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 419/634] octeontx2-pf: fix "UBSAN: shift-out-of-bounds error"
Date: Fri,  9 Jan 2026 12:41:37 +0100
Message-ID: <20260109112133.304057585@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index 2d6f6edb1510..835e85f0667a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -422,6 +422,14 @@ static int otx2_set_ringparam(struct net_device *netdev,
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



