Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706B24756B3;
	Fri,  7 Aug 2026 15:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115074; cv=none; b=F+Eyq5zqf8raVBCiGtiRKEGqcnEMfc7JNt7yX0r6ysL3aHARwEQ4zttU9RGNqu0HIk22fpFmEF9NbPeqRprpNM2PIPtcrrI+rTQUt5fzvIc/q/HPfliobTU/FV3odB5XUjZU0HWvF539tzEwfdu9Ir8Mk6sIwuFC0RfwYpOjoVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115074; c=relaxed/simple;
	bh=eA60QuSFxeH0tR24jKaveiPRDcOAuYZB5z659SfTXbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sk+uffHXOCa3F6Gty3KexB46i8XCSZ6efX0qSiQGamAZmT8wo1wvYAfF+o5lcswY1L5UbJEY4J0k5/MiSj/fr/IpfZdmm7A0ltyY24bSiTPGjSa50mSGbs6nbj2Rz+BH2v2tW7/lDDusninSUvscqP/LNKblx+tXMV3zp2722kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0+biRmI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0+biRmI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 296D31F000E9;
	Fri,  7 Aug 2026 15:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115067;
	bh=MlniHY0aVTxZ14H4nRu7654GXPet/nQa64eVw2bWsCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y0+biRmIjbrH8Wbt622nJ6luwKbIK9YJKsbiMuWvKleCuxx9r1mYhmjs6VvItTaXc
	 miVEwm0P3+NtqSY7Y//UyumFWbeNCum/I0X8A1coXLZ/LrBUEjzLCd3zd6RUlkIuR8
	 PxykbVOXTQ0BlKhBWj/me0R60IltXVxLxoLHIcyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Lu <luyun@kylinos.cn>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Justin Lai <justinlai0215@realtek.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 092/396] rtase: fix double free of multi-frag skb on DMA map failure
Date: Fri,  7 Aug 2026 16:34:12 +0200
Message-ID: <20260807143426.264916292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yun Lu <luyun@kylinos.cn>

[ Upstream commit 6fb7b769d6ed6d1d2e02af4a80e57a2477f35086 ]

In rtase_start_xmit(), when the head buffer DMA mapping fails after
rtase_xmit_frags() has mapped all fragments, the error path clears
the fragment descriptors with rtase_tx_clear_range(), which frees
the skb through the last-frag slot and accounts tx_dropped. Control
then falls through to the common error label, which frees the same
skb a second time and counts it again.

Return right after clearing the fragments when the skb owns frags;
the no-frag case still drops through and frees the head skb once.

Fixes: d6e882b89fdf ("rtase: Implement .ndo_start_xmit function")
Signed-off-by: Yun Lu <luyun@kylinos.cn>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Reviewed-by: Justin Lai <justinlai0215@realtek.com>
Link: https://patch.msgid.link/20260721023836.6691-1-luyun_611@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/rtase/rtase_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/realtek/rtase/rtase_main.c b/drivers/net/ethernet/realtek/rtase/rtase_main.c
index a57a525327a3b..bc9b14614f7a7 100644
--- a/drivers/net/ethernet/realtek/rtase/rtase_main.c
+++ b/drivers/net/ethernet/realtek/rtase/rtase_main.c
@@ -1620,6 +1620,9 @@ static netdev_tx_t rtase_start_xmit(struct sk_buff *skb,
 err_dma_1:
 	ring->skbuff[entry] = NULL;
 	rtase_tx_clear_range(ring, ring->cur_idx + 1, frags);
+	if (frags)
+		/* the frags were cleared above, along with the skb */
+		return NETDEV_TX_OK;
 
 err_dma_0:
 	tp->stats.tx_dropped++;
-- 
2.53.0



