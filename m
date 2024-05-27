Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C60E17E90E;
	Mon, 27 May 2024 19:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836812; cv=none; b=oWpphjOnmGBBiy7kb3NspgpFFDoZE0KereUamL1n6ahPCnzgfMPjTdvCdGb6LKg2UO/L3WveI+ET34CbyfQssUQ4AR5gkpMjr84OtMX+Zpty9Ec4rxvXRSsrG9cW/pkEXAJl0QFdlG9rd5h0mNfL95UVloO/VO1TIoFSRZ9SlzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836812; c=relaxed/simple;
	bh=ybaDnizHIu2aLTYS+opCpEPbUNLKlSXO4dJlDAI6QzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WGC0mW7Cz08bUKUtZh8IhdiFKr2BL0ixTPw0JCQ0xTVHTVY7vr6pfWLJgEC+wf/M+awVC9D3X4A4YJTunnxlQj8VDs/Wh9lJ4RZmd3dakmRN/8ewlreubIWLAKLAfu9OOe3z63oEAYAB4qVZ5rQMltI4iJ8QPAbwY1nwn0pAdFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mwhvs6st; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mwhvs6st"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3205C2BBFC;
	Mon, 27 May 2024 19:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836812;
	bh=ybaDnizHIu2aLTYS+opCpEPbUNLKlSXO4dJlDAI6QzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mwhvs6stQDq3diQz0SDOSqbkGTJRTyitPEp+DltzhgPOjqubcE+QX+MqnSoVolr87
	 55p6osZT2EnI7ymGkObB6oPgSmv439sJ3D8+th0hH+uQdMZRyp9DV+VrIZOoLM3d5G
	 ci/VlT0f9VSnIk+C6LpxFvvhvKF/lvvpu4bZY25M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 198/427] wifi: mt76: mt7603: add wpdma tx eof flag for PSE client reset
Date: Mon, 27 May 2024 20:54:05 +0200
Message-ID: <20240527185620.722003520@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 21de5f72260b4246e2415bc900c18139bc52ea80 ]

This flag is needed for the PSE client reset. Fixes watchdog reset issues.

Fixes: c677dda16523 ("wifi: mt76: mt7603: improve watchdog reset reliablity")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
index cf21d06257e53..dc8a77f0a1cc4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/mac.c
@@ -1393,6 +1393,7 @@ void mt7603_pse_client_reset(struct mt7603_dev *dev)
 		   MT_CLIENT_RESET_TX_R_E_2_S);
 
 	/* Start PSE client TX abort */
+	mt76_set(dev, MT_WPDMA_GLO_CFG, MT_WPDMA_GLO_CFG_FORCE_TX_EOF);
 	mt76_set(dev, addr, MT_CLIENT_RESET_TX_R_E_1);
 	mt76_poll_msec(dev, addr, MT_CLIENT_RESET_TX_R_E_1_S,
 		       MT_CLIENT_RESET_TX_R_E_1_S, 500);
-- 
2.43.0



